import "dart:collection";
import "package:isar/isar.dart";
import "datemap.dart";

part "plan.g.dart";

@collection
class Plan extends DateMap<List<Id>> {
  Id id = Isar.autoIncrement;
  // -> List<Id> with Id being a Isar object id for the meals.

  void addDay(DateTime date, [List<Id> mealIds = const []]) {
    add(date, mealIds);
  }

  void addMeals(DateTime date, [List<Id> mealIds = const []]) {
    List<Id>? oldMeals = this[date];
    if (oldMeals == null) {
      addDay(date, mealIds);
    } else {
      oldMeals.addAll(mealIds);
    }
  }

  int getClosestFutureDay(DateTime date) {
    int iD = getIndex(date);
    if (iD < 0) {
      expand(iD);
      iD = 0;
    }
    return getUpperNonNull(iD) ?? iD;
  }
}
