import "package:isar/isar.dart";

part 'meal.g.dart';

@collection
class Meal {
  Id id = Isar.autoIncrement;
  final String name;
  int? rating;
  double? price;
  String description;
  int type;

  // -> add features and information.

  Meal(this.name, this.rating, this.price, this.description, this.type);

  Meal emptyMeal(String name) {
    return Meal(name, -1, -1, "");
  }

  String getSubtitle() {
    return "Preis: ${price}0 € \t Bewertung: $rating/10"; // rating.toString()
  }
}
