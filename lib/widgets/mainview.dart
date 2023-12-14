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
  late int selectedDay;
  late int closestIndex;
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
    closestIndex = myMensaPlan.getClosestFutureDay();
    selectedDay = myMensaPlan.days[0].date
        .difference(myMensaPlan.days[closestIndex].date)
        .inDays;
    date = myMensaPlan.days[closestIndex].date;

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
                return DayContainer(day: myMensaPlan.days[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayContainer extends StatelessWidget {
  final Day day;

  const DayContainer({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dateToString(day.date, 0),
          style: const TextStyle(fontSize: 24),
        ),
        ListView.builder(
          itemCount: day.meals.length,
          itemBuilder: (context, mealIndex) {
            Meal meal = day.meals[mealIndex];
            return ListTile(
              title: Text(meal.name),
              subtitle: Text('Preis: ${meal.price}, Sterne: ${meal.rating}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
