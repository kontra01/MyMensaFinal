import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/generates.dart';
import 'package:mymensa/widgets/mainview.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'package:mymensa/widgets/storage/meal.dart';
import 'package:mymensa/widgets/storage/mealtype.dart';
import 'package:mymensa/widgets/storage/mensaday.dart';
import 'package:mymensa/widgets/storage/plan.dart';

const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "Juny",
  "Juli",
  "August",
  "September",
  "October",
  "November",
  "December"
];

// ignore: must_be_immutable
class SearchPopUp extends StatefulWidget {
  AllSchemata allSchemata;
  Id planId;
  MainView mv;
  SearchPopUp(this.allSchemata, this.planId, this.mv, {super.key});

  @override
  State<SearchPopUp> createState() => _SearchPopUp();
}

// used the following for keyboard handling: https://stackoverflow.com/questions/48750361/flutter-detect-keyboard-open-and-close
class _SearchPopUp extends State<SearchPopUp> {
  bool showFilterOptions = false;
  Map<String, bool> filterOptions = {
    'Meals': true,
    'Meal Types': true,
    'Dates': true,
    'Categories': true,
  };

  TextEditingController searchController = TextEditingController();
  Widget searchResults = const Text("");

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
                                          isSelected: (selected) {
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
                                Flexible(child: searchResults)
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
    if (recimatchAll(querys, months[date.month - 1].toLowerCase())) {
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
          ? generateText("Plan either not selected or found.")
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
              }
              if (filterOptions['Categories']!) {
                // To be worked on
              }
              for (Id mdId in plan.getAllNonNulls()) {
                MensaDay? md =
                    await widget.allSchemata.mensadaySchema.mensaDays.get(mdId);
                if (md == null) {
                  continue;
                }
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
                        resultItems.add(ResultItemWidget(
                            md.date,
                            markup("", mt.name.toUpperCase(), querys[match]),
                            widget.mv.jumpToDate));
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
                          if (!mealMatches.elementAt(match)) continue;
                          resultItems.add(ResultItemWidget(
                              md.date,
                              markup("", therebyMeal.name, querys[match]),
                              widget.mv.jumpToDate));
                        }
                      }
                    }
                  }
                } else if (matchesDate != null && matchesDate) {
                  resultItems.add(ResultItemWidget(
                      md.date, const Text(""), widget.mv.jumpToDate));
                }
              }
              return resultItems;
            })(), builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> resultItems = snapshot.data!;
                if (resultItems.isNotEmpty) {
                  return SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: resultItems,
                  ));
                }
                return generateText("No results.");
              }
              return generateText("Loading...");
            });
    });
  }
}

// ignore: must_be_immutable
class ResultItemWidget extends StatelessWidget {
  final DateTime date;
  final Widget text;
  Function jumpToDate;
  ResultItemWidget(this.date, this.text, this.jumpToDate, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_formatDate(date)),
      subtitle: text,
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.of(context).pop();

          jumpToDate(date);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}. ${months[date.month - 1]} ${date.year}';
  }
}

RichText markup(String pretext, String text, String marker) {
  String textlower = text.toLowerCase();
  String marklower = marker.toLowerCase();

  List<TextSpan> textSpans = [];
  int index = textlower.indexOf(marklower);

  while (index != -1) {
    textSpans.add(
      TextSpan(
        text: text.substring(0, index),
        style: const TextStyle(color: Colors.black),
      ),
    );
    textSpans.add(
      TextSpan(
        text: text.substring(index, index + marker.length),
        style: const TextStyle(
          backgroundColor: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    text = text.substring(index + marker.length);
    textlower = textlower.substring(index + marker.length);
    index = textlower.indexOf(marklower);
  }

  textSpans.add(
    TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black),
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
  final ValueChanged<bool> isSelected;

  const FilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected(!selected);
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
