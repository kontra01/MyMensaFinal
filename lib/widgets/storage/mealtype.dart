import "package:isar/isar.dart";

part "mealtype.g.dart";

// MAHLZEIT!
@collection
class MealType {
  Id id = Isar.autoIncrement;
  String name;
  int hours;
  int minutes;
  List<Id> mealIds;
  int typus;
  MealType(this.name, this.mealIds, this.typus, this.hours, this.minutes);
  int totalMinutes() => hours * 60 + minutes;
  double totalHours() => hours + minutes / 60;
  bool isBefore(MealType mt) => totalMinutes() < mt.totalMinutes();
  bool isAtSameTime(MealType mt) => totalMinutes() == mt.totalMinutes();
  bool isAfter(MealType mt) => totalMinutes() > mt.totalMinutes();
}
