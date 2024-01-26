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

  Id getId() {
    return id;
  }

  void setRating(int? rating) {
    rating ??= 0;
    this.rating = (rating % 11);
  }

  int? getRating() {
    return rating;
  }

  void setDesription(String? txt) {
    // if it should have a max length ...
    description = txt;
  }

  String? getDescription() {
    if (description != null) {
      return description;
    } else {
      return "";
    }
  }

  double? getPrice() {
    return price;
  }

  void setPrice(double? price) {
    this.price = price;
  }

  String getSubtitle() {
    String pr = price.toString();
    if (pr.length == 3) {
      pr = "${pr}0";
    }
    return "Price: ${pr} € \t ${rating == null ? "" : "Rating: $rating/10"}"; // rating.toString()
  }
}
