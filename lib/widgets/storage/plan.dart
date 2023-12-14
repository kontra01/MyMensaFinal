import "meal.dart";

class Day {
  final DateTime date;
  final List<Meal> meals;
  Day(this.date, this.meals);
}

class Plan {
  final List<Day> days = [];
  void addDay(Day d) {
    int i = 0;
    while (i < days.length && days[i].date.isBefore(d.date)) {
      i++;
    }
    days.insert(i, d);
  }

  int getDayIndex(DateTime date) {
    return [for (Day d in days) d.date].indexOf(date);
  }

  int getClosestFutureDay() {
    DateTime now = DateTime.now();

    for (int i = 0; i < days.length; i++) {
      if (days[i].date.isAfter(now) || days[i].date.isAtSameMomentAs(now)) {
        return i;
      }
    }
    return days.isNotEmpty ? days.length - 1 : -1;
  }
}
