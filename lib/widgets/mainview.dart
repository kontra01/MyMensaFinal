import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'storage/plan.dart';
import 'storage/meal.dart';
import 'storage/datemap.dart';
import 'package:path_provider/path_provider.dart';

List<String> weekdays = [
  "Montag",
  "Dienstag",
  "Mittwoch",
  "Donnerstag",
  "Freitag",
  "Samstag",
  "Sonntag"
];

// ignore: must_be_immutable
class MainView extends StatefulWidget {
  Isar mealSchema; // meal schema
  Isar planSchema;
  Id planId; // plan schema

  MainView(this.mealSchema, this.planSchema, this.planId, {super.key});

  @override
  State<MainView> createState() {
    return _MainView();
  }
}

DateTime today = DateTime.now();
String dateToString(DateTime d, int focus) {
  return '${focus == 0 ? '${weekdays[d.weekday - 1]}, ${d.day.toString()}' : ''}. ${focus < 2 ? DateFormat('MMMM').format(DateTime(0, d.month)) : ''}${today.year == d.year ? '' : ' ${d.year}'}';
}

class _MainView extends State<MainView> {
  late Isar mealSchema; // meal schema
  late Isar planSchema;
  late Plan plan; // plan
  late Directory dir;
  late Id planId;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    mealSchema = widget.mealSchema;
    planSchema = widget.planSchema;
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
    dir = await getApplicationDocumentsDirectory();
    final plans = planSchema.plans;
    // the following is mostly for default data generating
    Plan? planT = await plans.get(planId);
    if (planT == null) {
      plan = Plan();
      await planSchema.writeTxn(() async {
        await plans.put(plan);
      });
    } else {
      plan = planT;
    }
    await mealSchema.writeTxn(() async {
      await mealSchema.meals.clear();
      await mealSchema.meals.putAll([
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
    plan.addDays([
      MensaDay(DateTime.utc(2024, 1, 14), mealTypes: [mt1]),
      MensaDay(DateTime.utc(2024, 1, 15), mealTypes: [mt1, mt4]),
      MensaDay(DateTime.utc(2024, 1, 18), mealTypes: [mt2]),
      MensaDay(DateTime.utc(2024, 1, 19), mealTypes: [mt3, mt5]),
      MensaDay(DateTime.utc(2024, 1, 20), mealTypes: [mt6, mt4])
    ]);
    return true;
  }

  late int selection; // variable that determines which slide the user is on
  late int change;

  late DateTime date; // current date. this is just helpful

  int dateFocus = 0; // day = 0; month = 1; year = 2;

  late PageController controller; // for the sliding effect

  @override
  Widget build(BuildContext context) {
    print("checking...");
    if (isInitialized) {
      print("Starting loaded build");
      return buildLoaded(context);
    } else {
      return const Text('Loading...');
    }
  }

  DateTime scrollDate(int change) {
    return DateTime(
      dateFocus == 2 ? date.year + change : date.year,
      dateFocus == 1 ? date.month + change : date.month,
      dateFocus == 0 ? date.day + change : date.day,
    );
  }

  Widget buildLoaded(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(dateToString(date, dateFocus)),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      change = index - selection;
                      date = scrollDate(change);
                      selection = index;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    MensaDay? currentMensaDay = plan[pageIndex];
                    if (currentMensaDay == null) {
                      return const Text("No meals entered for this date.");
                    }
                    List<MealType>? currentTypes = currentMensaDay.mealTypes;
                    if (currentTypes.isEmpty) {
                      return const Text("No meals entered for this date.");
                    }

                    // THIS PART IS THE ACTUAL BOXES
                    return Column(
                      children: currentTypes.map((currentType) {
                        return generateTypeBox(currentType);
                      }).toList(),
                    );
                  }),
            )
          ],
        ));
  }

  Widget generateTypeBox(MealType mealType) {
    if (mealType.mealIds.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(children: generateMealRows(mealType.mealIds));
  }

  List<Widget> generateMealRows(List<Id> mealIds) {
    return mealIds.map((mealId) {
      return FutureBuilder<Meal?>(
        future: getMeal(mealId),
        builder: (BuildContext context, AsyncSnapshot<Meal?> snapshot) {
          if (snapshot.hasData) {
            Meal? meal = snapshot.data;
            if (meal == null) {
              return const Text("No meals entered for this date.");
            }
            return ListTile(
              title: Text(meal.name),
              subtitle: Text(meal.getSubtitle()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    // Edit button
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: create plan and interface for editing.
                    },
                  ),
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
            return const Text('No meal details available');
          }
        },
      );
    }).toList();
  }

  Future<Meal?> getMeal(Id mealId) async {
    try {
      return await mealSchema.meals.get(mealId);
    } catch (e) {
      return null;
    }
  }
}
