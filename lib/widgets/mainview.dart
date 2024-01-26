import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/generates.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'package:mymensa/widgets/storage/json_util.dart';
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

DateTime today = DateUtils.dateOnly(DateTime.now());
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
  late Directory dir;
  late Id planId;
  late AllSchemata allSchemata;
  late Function dateFocusGetter;
  bool isInitialized = false;
  late Function appBarStateSetter;
  List<Function> pageViewFocus = const [];
  late DateTime date;
  late int selected;

  late PageController controller; // for the sliding effect
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

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
    allSchemata = widget.allSchemata;
    dateFocusGetter = widget.dateFocusGetter;
    if (!isInitialized) {
      initialize().then((r) async {
        Plan? plan = await getPlan();
        if (r && plan != null) {
          selected = plan.getClosestFutureDay(today);
          updatePlan(plan);
          date = plan.getAccountedDate(selected);
          controller = PageController(initialPage: selected);
        } else {
          // error... never comes up though.
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

  // this function is mainly constructed for data generating. this would have different logics
  Future<bool> initialize() async {
    if (await allSchemata.planSchema.plans.get(planId) != null) {
      return true;
    }
    await allSchemata.planSchema.writeTxn(() async {
      await allSchemata.planSchema.plans.clear();
    });
    await allSchemata.mealSchema.writeTxn(() async {
      await allSchemata.mealSchema.meals.clear();
    });
    await allSchemata.mealtypeSchema.writeTxn(() async {
      await allSchemata.mealtypeSchema.mealTypes.clear();
    });
    await allSchemata.mensadaySchema.writeTxn(() async {
      await allSchemata.mensadaySchema.mensaDays.clear();
    });

    await loadJSON(allSchemata, planId);
    return true;
  }

  Future<Plan?> getPlan() async {
    return await allSchemata.planSchema.plans.get(planId);
  }

  Future<bool> updatePlan(Plan updatedPlan) async {
    await allSchemata.planSchema.writeTxn(() async {
      await allSchemata.planSchema.plans.put(updatedPlan);
    });
    return true;
  }

  void jumpToDate(DateTime newDate, {int newFocus = 0}) async {
    Plan? plan = await getPlan();
    if (plan == null) return;
    controller
        .animateToPage(plan.getAccountedIndex(newDate),
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
              return Text(dateToString(date, dateFocusGetter()));
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    int change = index - selected;
                    appBarStateSetter(() {
                      date = scrollDate(change, dateFocusGetter());
                    });
                    selected = index;
                  },
                  itemBuilder: (context, pageIndex) {
                    return FutureBuilder<Widget>(
                        future: pageViewFocus[dateFocusGetter()](pageIndex),
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
    Plan? plan = await getPlan();
    if (plan == null) {
      return generateText("No Plan present.");
    }
    MensaDay? currentMensaDay = plan[pageIndex] == null
        ? null
        : (await allSchemata.mensadaySchema.mensaDays.get(plan[pageIndex]!));
    if (currentMensaDay == null) {
      return generateText("No meals entered for this date.");
    }
    List<Id> currentTypes = currentMensaDay.mealTypes;
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
      future: allSchemata.mealtypeSchema.mealTypes.get(mealTypeId),
      builder: (BuildContext context, AsyncSnapshot<MealType?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            children: [
              Container(
                color: Colors.grey,
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

            return StatefulBuilder(builder: (context, subtitleSetter) {
              return ListTile(
                title: Text(meal.name),
                subtitle: Text(meal.getSubtitle()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      // Edit button
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        // partial from https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
                        final _formKey = GlobalKey<FormState>();
                        await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40,
                                        top: -80,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                controller:
                                                    descriptionController,
                                              ), //init value: meal.getDesription()
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Submit'),
                                                onPressed: () async {
                                                  String descr =
                                                      descriptionController
                                                          .text;
                                                  meal.setDesription(descr);
                                                  await widget
                                                      .allSchemata.mealSchema
                                                      .writeTxn(() async {
                                                    await allSchemata
                                                        .mealSchema.meals
                                                        .put(meal);
                                                  }).then((r) {
                                                    Navigator.of(context).pop();
                                                  });
                                                  /* if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                        } */
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    ),
                    IconButton(
                      // Rate button
                      icon: const Icon(Icons.star),
                      onPressed: () async {
                        // partial from https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
                        final _formKey = GlobalKey<FormState>();
                        await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40,
                                        top: -80,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: TextFormField(
                                                  controller: ratingController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ]),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                child: const Text('Submit'),
                                                onPressed: () async {
                                                  int rating = int.parse(
                                                      ratingController.text);
                                                  meal.setRating(rating);
                                                  await widget
                                                      .allSchemata.mealSchema
                                                      .writeTxn(() async {
                                                    await allSchemata
                                                        .mealSchema.meals
                                                        .put(meal);
                                                  }).then((r) {
                                                    subtitleSetter(() {});
                                                    Navigator.of(context).pop();
                                                  });

                                                  /* if (_formKey.currentState!.validate()) {
                                                  _formKey.currentState!.save();
                                                } */
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    )
                  ],
                ),
              );
            });
          } else {
            return generateText('No meal details available');
          }
        },
      );
    }).toList();
  }

  Future<Meal?> getMeal(Id mealId) async {
    try {
      return await allSchemata.mealSchema.meals.get(mealId);
    } catch (e) {
      return null;
    }
  }
}
