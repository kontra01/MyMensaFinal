import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "storage/plan.dart";
import "storage/meal.dart";

Plan mymp = Plan();
List<Meal> meals = [
  Meal("Gyros", 7, 3.2),
  Meal("Reis", 2, 2.8),
  Meal("Fisch", 2, 4.5),
  Meal("Bohnensuppe", 8, 3.2)
];

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
class Container1 extends StatefulWidget {
  const Container1({super.key});

  @override
  _Container1State createState() => _Container1State();
}

DateTime today = DateTime.now();
String dateToString(DateTime d, int focus) {
  return '${focus == 0 ? '${weekdays[d.weekday - 1]}, ${d.day.toString()}' : ''}. ${focus < 2 ? DateFormat('MMMM').format(DateTime(0, d.month)) : ''}${today.year == d.year ? '' : ' ${d.year}'}';
}

class _Container1State extends State<Container1> {
  late int selection; // variable that determines which slide the user is on
  late int change;

  late DateTime date; // current date. this is just helpful

  int dateFocus = 0; // day = 0; month = 1; year = 2;

  late PageController controller; // for the sliding effect

  @override
  void initState() {
    super.initState();
    mymp.addDay(DateTime.utc(2023, 12, 14), [meals[0]]);
    mymp.addDay(DateTime.utc(2023, 12, 15), [meals[3]]);
    mymp.addDay(DateTime.utc(2023, 12, 18), [meals[1]]);
    mymp.addDay(DateTime.utc(2023, 12, 19), [meals[2]]);
    mymp.addDay(DateTime.utc(2023, 12, 20), [meals[3], meals[2]]);
    int futureIndex = mymp.getClosestFutureDay(DateTime.now());
    date = mymp.getAccountedDate(futureIndex);
    selection = futureIndex;

    controller = PageController(initialPage: selection);
    Future.delayed(Duration(milliseconds: 200 * selection), () {
      controller.animateToPage(selection,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    change = 0;
  }

  @override
  Widget build(BuildContext context) {
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
                    date = DateTime(
                        dateFocus == 2 ? date.year + change : date.year,
                        dateFocus == 1 ? date.month + change : date.month,
                        dateFocus == 0 ? date.day + change : date.day);
                    selection = index;
                  });
                },
                itemBuilder: (context, index) {
                  List<Meal>? currentMeals = mymp.getEntry(index);
                  if (currentMeals == null) {
                    return Text("No meals entered for this date.");
                  }
                  // THIS PART IS THE ACTUAL BOXES
                  return ListView.builder(
                    itemCount: currentMeals.length,
                    itemBuilder: (context, jndex) {
                      Meal meal = currentMeals[jndex];
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
                          ));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
