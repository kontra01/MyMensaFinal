import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'package:mymensa/widgets/storage/meal.dart';
import 'package:mymensa/widgets/storage/mealtype.dart';
import 'package:mymensa/widgets/storage/mensaday.dart';
import 'package:mymensa/widgets/storage/plan.dart';

const double border = 30;

const List<String> months = [
  "january",
  "february",
  "march",
  "april",
  "may",
  "juny",
  "juli",
  "august",
  "september",
  "october",
  "november",
  "december"
];

// ignore: must_be_immutable
class CustomPopUp extends StatefulWidget {
  AllSchemata allSchemata;
  Id planId;
  CustomPopUp(this.allSchemata, this.planId, {super.key});

  @override
  State<CustomPopUp> createState() => _CustomPopUpState();
}

class _CustomPopUpState extends State<CustomPopUp> {
  bool showFilterOptions = false;
  Map<String, bool> filterOptions = {
    'Meals': true,
    'Meal Types': true,
    'Dates': true,
    'Categories': true,
  };

  TextEditingController searchController = TextEditingController();
  Widget searchResults = Text("");

  late double wid;
  late double hei;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wid = MediaQuery.of(context).size.width;
    hei = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          left: -wid,
          right: -wid,
          top: border + 40,
          bottom: border,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: wid - 2 * border,
              height: hei,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<Plan?>(
                        future: widget.allSchemata.planSchema.plans
                            .get(widget.planId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: searchController,
                                        onChanged: (query) {
                                          updateSearchItems(
                                              query, snapshot.data);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Enter search...',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.filter_list),
                                      onPressed: () {
                                        setState(() {
                                          showFilterOptions =
                                              !showFilterOptions;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                if (showFilterOptions) ...[
                                  const SizedBox(height: 12.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      for (var entry in filterOptions.entries)
                                        FilterButton(
                                          label: entry.key,
                                          selected: entry.value,
                                          onSelected: (selected) {
                                            setState(() {
                                              filterOptions[entry.key] =
                                                  selected;
                                            });
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8.0),
                                searchResults,
                              ],
                            );
                          }
                          return const Text("loading...");
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: border,
          top: border,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  bool reciMatch(String a, String b) {
    return a.toLowerCase().contains(b.toLowerCase()) ||
        b.toLowerCase().contains(a.toLowerCase());
  }

  bool recimatchAll(List querys, String str) =>
      querys.map((i) => reciMatch(i, str)).contains(true);

  bool queryMatchesDate(String query, DateTime date) {
    List<String> querys = query.toLowerCase().split(" ");
    DateTime today = DateTime.now().toUtc();
    if (recimatchAll(querys, "today")) {
      if (DateUtils.isSameDay(today, date)) return true;
    }
    if (recimatchAll(querys, "tomorrow")) {
      DateTime morrow =
          DateTime(today.year, today.month, today.day + 1).toUtc();
      if (DateUtils.isSameDay(morrow, date)) return true;
    }
    if (recimatchAll(querys, "yesterday")) {
      DateTime yester =
          DateTime(today.year, today.month, today.day - 1).toUtc();
      if (DateUtils.isSameDay(yester, date)) return true;
    }
    if (recimatchAll(querys, months[date.month - 1])) {
      return true;
    }

    if (querys.map((i) => date.toString().contains(i)).contains(true)) {
      return true;
    }

    return false;
  }

  void updateSearchItems(String query, Plan? plan) {
    setState(() {
      searchResults = plan == null
          ? Text("Plan not found.")
          : FutureBuilder<List<Widget>>(future: (() async {
              query = query.toLowerCase();
              List<String> querys = query.toLowerCase().split(" ");
              List<Widget> resultItems = [];
              if (query == "") return resultItems;
              List<Id> possibleMealIds = [];
              if (filterOptions['Meals']!) {
                List<Meal> allMeals =
                    await widget.allSchemata.mealSchema.meals.where().findAll();
                for (Meal m in allMeals) {
                  if (recimatchAll(querys, m.name.toLowerCase())) {
                    possibleMealIds.add(m.id);
                  }
                }
                print(possibleMealIds);
              }
              if (filterOptions['Categories']!) {
                // To be worked on
              }
              for (Id mdId in plan.getAllNonNulls()) {
                print("checking one");
                MensaDay? md =
                    await widget.allSchemata.mensadaySchema.mensaDays.get(mdId);
                if (md == null) {
                  print("isNull");
                  continue;
                }
                print(md.date);
                bool? matchesDate;

                if (filterOptions['Dates']!) {
                  matchesDate = queryMatchesDate(query, md.date);
                }
                if (filterOptions['Meal Types']! || filterOptions['Meals']!) {
                  for (int i = 0; i < md.mealTypes.length; i++) {
                    MealType? mt = await widget
                        .allSchemata.mealtypeSchema.mealTypes
                        .get(md.mealTypes[i]);
                    if (mt == null) {
                      continue;
                    }
                    Iterable mealTypeMatches =
                        querys.map((q) => reciMatch(q, mt.name));
                    if (filterOptions['Meal Types']! &&
                        mealTypeMatches.contains(true)) {
                      for (int match = 0;
                          match < mealTypeMatches.length;
                          match++) {
                        if (!mealTypeMatches.elementAt(match)) continue;
                        resultItems.add(ResultItemWidget(md.date,
                            markup("", mt.name.toUpperCase(), querys[match])));
                      }
                    }
                    if (filterOptions['Meals']!) {
                      for (int m = 0; m < mt.mealIds.length; m++) {
                        Id mId = mt.mealIds[m];
                        if (!possibleMealIds.contains(mId)) continue;
                        Meal? therebyMeal =
                            await widget.allSchemata.mealSchema.meals.get(mId);
                        if (therebyMeal == null) continue;
                        Iterable mealMatches =
                            querys.map((q) => reciMatch(q, therebyMeal.name));

                        for (int match = 0;
                            match < mealMatches.length;
                            match++) {
                          print("match");
                          if (!mealMatches.elementAt(match)) continue;
                          resultItems.add(ResultItemWidget(md.date,
                              markup("", therebyMeal.name, querys[match])));
                        }
                      }
                    }
                  }
                } else if (matchesDate != null && matchesDate) {
                  resultItems.add(ResultItemWidget(md.date, Text("")));
                }
              }
              print("done");
              return resultItems;
            })(), builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> resultItems = snapshot.data!;
                if (resultItems.isNotEmpty) {
                  return Container(
                    constraints: BoxConstraints(maxHeight: hei - 400),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: resultItems.length,
                            itemBuilder: (context, index) {
                              return resultItems[index];
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Text("No results.");
              }
              return Text("Loading...");
            });
    });
  }
}

class ResultItemWidget extends StatelessWidget {
  final DateTime date;
  final Widget text;

  const ResultItemWidget(
    this.date,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_formatDate(date)),
      subtitle: text,
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () {},
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}. ${months[date.month - 1]} ${date.year}';
  }
}

RichText markup(String pretext, String text, String marker) {
  String lowercasedText = text.toLowerCase();
  String lowercasedMarker = marker.toLowerCase();

  List<TextSpan> textSpans = [];
  int index = lowercasedText.indexOf(lowercasedMarker);

  while (index != -1) {
    textSpans.add(
      TextSpan(
        text: text.substring(0, index),
        style: TextStyle(color: Colors.black),
      ),
    );
    textSpans.add(
      TextSpan(
        text: text.substring(index, index + marker.length),
        style: TextStyle(
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    text = text.substring(index + marker.length);
    lowercasedText = lowercasedText.substring(index + marker.length);
    index = lowercasedText.indexOf(lowercasedMarker);
  }

  textSpans.add(
    TextSpan(
      text: text,
      style: TextStyle(color: Colors.black),
    ),
  );

  return RichText(
    text: TextSpan(children: [
      TextSpan(text: pretext),
      ...textSpans,
    ]),
  );
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(!selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: selected ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
