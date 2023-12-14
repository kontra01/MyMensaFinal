class Meal {
  final String name;
  int rating;
  double price;

  Meal(this.name, this.rating, this.price);
  Meal mealFromName(String name) {
    return Meal(name, -1, -1);
  }

  @override
  String toString() {
    return name + " (" + "$rating" + "/10)"; // rating.toString()
  }

  double getPrice() {
    return price;
  }

  int getRating() {
    return rating;
  }

  setRating(int rating) {
    this.rating = rating;
  }
}
