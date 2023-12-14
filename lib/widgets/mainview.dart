import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "storage/plan.dart";
import "storage/meal.dart";

Plan myMensaPlan = Plan();
List<Meal> meals = [
  Meal("Gyros", 7, 3.2),
  Meal("Reis", 2, 2.8),
  Meal("Fisch", 2, 4.5),
  Meal("Bohnensuppe", 8, 3.2)
];

// ignore: must_be_immutable
class Container1 extends StatefulWidget {
  const Container1({super.key});

  @override
  _Container1State createState() => _Container1State();
}

DateTime today = DateTime.now();
String dateToString(DateTime d, int focus) {
  return '${focus == 0 ? d.day.toString() : ''}. ${focus < 2 ? DateFormat('MMMM').format(DateTime(0, d.month)) : ''}${today.year == d.year ? '' : ' ${d.year}'}';
}

class _Container1State extends State<Container1> {
  late int selectedDay = 0;
  late DateTime date;
  int dateFocus = 0; // day = 0; month = 1; year = 2;
  late PageController controller = PageController(initialPage: selectedDay);

  @override
  void initState() {
    myMensaPlan.addDay(Day(DateTime.utc(2023, 12, 14), [meals[0]]));
    myMensaPlan.addDay(Day(DateTime.utc(2023, 12, 15), [meals[3]]));
    myMensaPlan.addDay(Day(DateTime.utc(2023, 12, 18), [meals[1]]));
    myMensaPlan.addDay(Day(DateTime.utc(2023, 12, 19), [meals[2]]));
    myMensaPlan.addDay(Day(DateTime.utc(2023, 12, 20), [meals[3], meals[2]]));
    super.initState();
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
                  int change = index - selectedDay;
                  date = DateTime(
                      dateFocus == 2 ? date.year + change : date.year,
                      dateFocus == 1 ? date.month + change : date.month,
                      dateFocus == 0 ? date.day + change : date.day);
                  selectedDay = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Content for Day $index',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
