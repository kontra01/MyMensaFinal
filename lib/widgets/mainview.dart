import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/generates.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'storage/mealtype.dart';
import 'storage/mensaday.dart';
import 'storage/plan.dart';
import 'storage/meal.dart';

List<String> weekdays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

// styles

List<List<dynamic>> styles = [];

DateTime today = DateTime.now();
String dateToString(DateTime d, int focus) {
  return '${focus == 0 ? '${weekdays[d.weekday - 1]}, ${d.day.toString()}' : ''}. ${focus < 2 ? DateFormat('MMMM').format(DateTime(0, d.month)) : ''}${today.year == d.year ? '' : ' ${d.year}'}';
}

// ignore: must_be_immutable
class MainView extends StatefulWidget {
  AllSchemata allSchemata;
  Id planId; // plan schema
  Function dateFocusGetter;
  Function dateFocusSetter;
  MainViewState createdState = MainViewState();

  MainView(
      this.allSchemata, this.planId, this.dateFocusGetter, this.dateFocusSetter,
      {super.key});

  @override
  State<MainView> createState() => createdState;

  void jumpToDate(DateTime newDate, {int newFocus = 0}) {
    createdState.jumpToDate(newDate, newFocus: newFocus);
  }
}

class MainViewState extends State<MainView> {
  late Plan plan; // plan
  late Directory dir;
  late Id planId;
  bool isInitialized = false;
  late Function appBarStateSetter;
  List<Function> pageViewFocus = const [];

  late int selection; // variable that determines which slide the user is on
  late int change;

  late DateTime date; // current date. this is just helpful

  // day = 0; week = 1; month = 2; year = 3;

  late PageController controller; // for the sliding effect

  MainViewState() {
    pageViewFocus = [
      generateViewFocusDay,
      generateViewFocusWeek,
      generateViewFocusMonth,
      generateViewFocusYear
    ];
  }

  @override
  void initState() {
    super.initState();
    planId = widget.planId;
    change = 0;
    if (!isInitialized) {
      initialize().then((r) {
        if (r) {
          int futureIndex = plan.getClosestFutureDay(today);
          date = plan.getAccountedDate(futureIndex);
          selection = futureIndex;
          controller = PageController(initialPage: selection);
        } else {
          // error
        }
        setState(() {
          isInitialized = true;
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> initialize() async {
    await widget.allSchemata.mealSchema.writeTxn(() async {
      await widget.allSchemata.mealSchema.meals.clear();
      await widget.allSchemata.mealSchema.meals.putAll([
        Meal("Gebratener Reis", 3.5),
        Meal("Bohnensuppe", 4),
        Meal("Spinat-Quiche", 4.5),
        Meal("Tomatensalat", 2.5),
        Meal("Kirschkuchen", 3),
        Meal("Pasta Alio Olio", 4.5)
      ]);
    });
    // MT(name, mealId, typus, hours, minutes)
    // -> typus is yet to be defined and so on.
    MealType mt1 = MealType("Prima Klima", [1], 0, 13, 0);
    MealType mt2 = MealType("Sattmacher", [2], 0, 13, 0);
    MealType mt3 = MealType("Topf + Pfanne", [6], 0, 13, 0);
    MealType mt4 = MealType("Beilagen", [4], 0, 13, 0);
    MealType mt5 = MealType("Desserts", [5], 0, 13, 30);
    MealType mt6 = MealType("Prima Klima", [3], 0, 13, 0);
    await widget.allSchemata.mealtypeSchema.writeTxn(() async {
      await widget.allSchemata.mealtypeSchema.mealTypes.clear();
      await widget.allSchemata.mealtypeSchema.mealTypes
          .putAll([mt1, mt2, mt3, mt4, mt5, mt6]);
    });

    // the following is mostly for default data generating
    await widget.allSchemata.planSchema.writeTxn(() async {
      await widget.allSchemata.planSchema.plans.clear();
    });
    Plan? planT = await widget.allSchemata.planSchema.plans.get(planId);
    if (planT == null) {
      MensaDay md1 = MensaDay(DateTime.utc(2024, 1, 14), mealTypes: [mt1.id]);
      MensaDay md2 =
          MensaDay(DateTime.utc(2024, 1, 15), mealTypes: [mt1.id, mt4.id]);
      MensaDay md3 = MensaDay(DateTime.utc(2024, 1, 18), mealTypes: [mt2.id]);
      MensaDay md4 =
          MensaDay(DateTime.utc(2024, 1, 19), mealTypes: [mt3.id, mt5.id]);
      MensaDay md5 =
          MensaDay(DateTime.utc(2024, 1, 20), mealTypes: [mt6.id, mt4.id]);

      await widget.allSchemata.mensadaySchema.writeTxn(() async {
        await widget.allSchemata.mensadaySchema.mensaDays.clear();
        await widget.allSchemata.mensadaySchema.mensaDays
            .putAll([md1, md2, md3, md4, md5]);
      });
      plan = Plan();
      plan.addAll([md1, md2, md3, md4, md5]);
      await widget.allSchemata.planSchema.writeTxn(() async {
        await widget.allSchemata.planSchema.plans.put(plan);
      });
    } else {
      plan = planT;
    }
    return true;
  }

  void jumpToDate(DateTime newDate, {int newFocus = 0}) {
    selection = plan.getAccountedIndex(newDate);
    controller
        .animateToPage(selection,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastEaseInToSlowEaseOut)
        .then((r) {
      appBarStateSetter(() {
        date = newDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialized) {
      return buildLoaded(context);
    } else {
      return generateText('Loading...');
    }
  }

  DateTime scrollDate(int change, int dateFocus) {
    return DateTime(
      dateFocus == 3 ? date.year + change : date.year,
      dateFocus == 2 ? date.month + change : date.month,
      dateFocus <= 1 ? date.day + change * (dateFocus == 1 ? 7 : 1) : date.day,
    );
  }

  Widget buildLoaded(context) {
    return Scaffold(
        appBar: AppBar(
          title: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              appBarStateSetter = setState;
              return Text(dateToString(date, widget.dateFocusGetter()));
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    change = index - selection;
                    selection = index;
                    appBarStateSetter(() {
                      date = scrollDate(change, widget.dateFocusGetter());
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    return FutureBuilder<Widget>(
                        future:
                            pageViewFocus[widget.dateFocusGetter()](pageIndex),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          }
                          return generateText("loading...");
                        });
                  }),
            )
          ],
        ));
  }

  Future<Widget> generateViewFocusDay(pageIndex) async {
    MensaDay? currentMensaDay = plan[pageIndex] == null
        ? null
        : (await widget.allSchemata.mensadaySchema.mensaDays
            .get(plan[pageIndex]!));
    if (currentMensaDay == null) {
      return generateText("No meals entered for this date.");
    }
    List<Id>? currentTypes = currentMensaDay.mealTypes;
    if (currentTypes.isEmpty) {
      return generateText("No meals entered for this date.");
    }
    // THIS PART IS THE ACTUAL BOXES
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: joinWidgetList(
              currentTypes
                  .map((currentType) => generateTypeBox(currentType))
                  .toList(),
              const SizedBox(height: 20.0)),
        ));
  }

  Widget generateViewFocusWeek(pageIndex) {
    return Column();
  }

  Widget generateViewFocusMonth(pageIndex) {
    return Column();
  }

  Widget generateViewFocusYear(pageIndex) {
    return Column();
  }

  List<Widget> joinWidgetList(List<Widget> widgetList, Widget joinment) {
    if (widgetList.isEmpty) return widgetList;
    List<Widget> newWidgetList = [widgetList.removeAt(0)];

    for (Widget widget in widgetList) {
      newWidgetList.add(joinment);
      newWidgetList.add(widget);
    }
    return newWidgetList;
  }

  Widget generateTypeBox(Id mealTypeId) {
    return FutureBuilder<MealType?>(
      future: widget.allSchemata.mealtypeSchema.mealTypes.get(mealTypeId),
      builder: (BuildContext context, AsyncSnapshot<MealType?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            children: [
              Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(14.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  snapshot.data!.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...generateMealRows(snapshot.data!.mealIds),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  List<Widget> generateMealRows(List<Id> mealIds) {
    return mealIds.map((mealId) {
      return FutureBuilder<Meal?>(
        future: getMeal(mealId),
        builder: (BuildContext context, AsyncSnapshot<Meal?> snapshot) {
          if (snapshot.hasData) {
            Meal? meal = snapshot.data;
            if (meal == null) {
              return generateText("No meals entered for this date.");
            }
            return ListTile(
              title: Text(meal.name),
              subtitle: Text(meal.getSubtitle()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    // Rate button
                    icon: const Icon(Icons.star),
                    onPressed: () {
                      // TODO: rate from 1 to ten.
                    },
                  )
                ],
              ),
            );
          } else {
            return generateText('No meal details available');
          }
        },
      );
    }).toList();
  }

  Future<Meal?> getMeal(Id mealId) async {
    try {
      return await widget.allSchemata.mealSchema.meals.get(mealId);
    } catch (e) {
      return null;
    }
  }
}
