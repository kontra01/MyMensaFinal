import "dart:collection";
import "meal.dart";

class DateMap<EntryType> {
  Map<DateTime, EntryType> map = HashMap();
  List<DateTime?> indices = [];

  void add(DateTime date, EntryType entry) {
    date = date.toUtc();
    map[date] = entry;
    if (indices.isEmpty) {
      indices.add(date);
      return;
    }

    // TODO: convert all to insert for shorter algorithm
    int gapToBase = date.difference(indices[0]!).inDays;
    if (indices[0]!.isBefore(date)) {
      indices.insertAll(
          0, List<DateTime?>.generate(gapToBase - 1, (i) => null));
      indices.insert(0, date);
    } else if (indices[indices.length - 1]!.isAfter(date)) {
      indices.addAll(List<DateTime?>.generate(
          gapToBase - indices.length - 2, (i) => null));
      indices.add(date);
    } else {
      indices[gapToBase] = date;
      return;
    }
  }

  /// Returns [EntryType] for provided [DateTime]. If [EntryType] is not added for [DateTime] yet, null is returned.
  EntryType? operator [](DateTime date) {
    return map[date];
  }

  /// Returns [DateTime] for provided [index]. If [DateTime] is not added for [index] yet, null is returned.
  DateTime? getDate(int index) {
    return indices[index];
  }

  /// Returns [EntryType] through redirection for provided [index]. If [DateTime] or [EntryType] for that is not added for [index] yet, null is returned.
  EntryType? getEntry(int index) {
    return map[indices[index]!];
  }

  /// Returns tuple of [DateTime] and [EntryType] for provided [index]. Either parts can be null, if not added yet.
  (DateTime?, EntryType?) of(int index) {
    DateTime? date = getDate(index);
    return (date, map[date]);
  }

  /// Gets first item for
  int? getUpperNonNull(int index) {
    if (index <= 0 || indices.length < index) return null;
    for (int j = index + 1; j < indices.length; j++) {
      if (indices[j] != null) return j;
    }
    return null;
  }

  int? getLowerNonNull(int index) {
    if (index <= 0 || indices.isEmpty) return null;
    for (int j = index - 1; j >= 0; j--) {
      if (indices[j] != null) return j;
    }
    return null;
  }

  void expand(int index) {
    int expansion = index - indices.length - 1;
    if (expansion == 0 || expansion.abs() < indices.length) return;
    indices.insertAll(index < 0 ? 0 : indices.length,
        List<DateTime?>.generate(expansion.abs(), (i) => null));
  }
}

class Plan {
  DateMap<List<Meal>> dateMap = DateMap();

  void addDay(DateTime date, [List<Meal> meals = const []]) {
    dateMap.add(date, meals);
  }

  void addMeals(DateTime date, [List<Meal> meals = const []]) {
    List<Meal>? oldMeals = dateMap[date];
    if (oldMeals == null) {
      addDay(date, meals);
    } else {
      oldMeals.addAll(meals);
    }
  }

  ///
  int getClosestFutureDay() {
    DateTime now = DateTime.now().toUtc();
    DateTime? base = dateMap.getDate(0);
    if (base == null) return 0;
    int baseDiff = base.difference(now).inDays;
    int? upperNonNull = dateMap.getUpperNonNull(baseDiff);
    if (now.isBefore(base)) baseDiff *= -1;
    return now.isBefore(base) ? 0 : (upperNonNull ?? baseDiff);
  }
}
