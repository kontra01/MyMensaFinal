import "package:isar/isar.dart";

part 'meal.g.dart';

@collection
class Meal {
  Id id = Isar.autoIncrement;
  final String name;
  int? rating;
  double? price;
  String? description;
  bool? vegetarian;
  bool? vegan;
  bool? glutenfree;
  bool? nutfree;
  bool? dairyfree;
  // -> add features and information.

  Meal(this.name, this.price,
      {this.rating,
      this.description,
      this.vegetarian,
      this.vegan,
      this.glutenfree,
      this.nutfree,
      this.dairyfree});

  Meal emptyMeal(String name) {
    return Meal(name, null);
  }

  String getSubtitle() {
    return "Preis: ${price}0 € \t Bewertung: $rating/10"; // rating.toString()
  }
}
