import "package:isar/isar.dart";

// MAHLZEIT!
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

// a day with different types of MAHLZEITEN
class MensaDay {
  Id id = Isar.autoIncrement;
  List<MealType> mealTypes = [];
  DateTime date;
  MensaDay(this.date, {this.mealTypes = const []});
  void add(MealType mt) {
    for (int i = 0; i < mealTypes.length; i++) {
      if (mt.isBefore(mealTypes[i])) {
        mealTypes.insert(i, mt);
        return;
      }
    }
    mealTypes.add(mt);
  }

  void toUtc() {
    date = date.toUtc();
  }
}
/*
class DateMap {
  DateTime? date0;

  final List<DateTime?> _indices = [];

  void add(DateTime date) {
    date = date.toUtc();

    int thrIndex = getAccountedIndex(date);

    if (thrIndex < 0) {
      expand(-thrIndex + 1);

      thrIndex = 0;
    }

    if (thrIndex == 0) {
      _indices.insert(0, date);

      date0 = date;

      return;
    } else if (thrIndex >= _indices.length) {
      expand(thrIndex - 1);

      _indices.add(date);
    } else {
      _indices[thrIndex] = date;

      return;
    }
  }

  /*
  DateTime? getDate0([int? index]) {
    if (_indices.isEmpty) return null;

    if (index != null && _indices[index] != null) {
      return _indices[index];
    } else if (index == null && _indices[0] != null) {
      return _indices[0];
    }

    int? iX = this.getUpperNonNull(-1);

    if (iX == null) return null;

    DateTime dX = _indices[iX]!;

    return DateTime(dX.year, dX.month, dX.day - iX + (index ?? 0)).toUtc();
  }
  */

  /// Returns [DateTime] for provided [index]. If [DateTime] is not added for [index] yet, null is returned.

  DateTime? operator [](int index) {
    return index < 0 || index > _indices.length ? null : _indices[index];
  }

  /// Returns [DateTime] for provided [DateTime]. If [DateTime] is not added for [DateTime] yet, null is returned.

  DateTime? getDate(DateTime date) {
    date = date.toUtc();
    for (int i = 0; i < _indices.length; i++) {
      if (DateUtils.isSameDay(_indices[i], date)) return _indices[i];
    }
    return null;
  }

  DateTime getAccountedDate(int index) {
    if (this[index] != null) {
      return this[index]!;
    }

    return date0 == null
        ? DateTime.now().toUtc()
        : DateTime(date0!.year, date0!.month, date0!.day + index);
  }

  int? getIndex(DateTime date) {
    date = date.toUtc();
    for (int i = 0; i < _indices.length; i++) {
      if (DateUtils.isSameDay(_indices[i], date)) return i;
    }
    return null;
  }

  int getAccountedIndex(DateTime date) {
    if (date0 == null) return 0;

    return date.toUtc().difference(date0!).inDays;
  }

  int? getUpperNonNull(int index) {
    if (_indices.isEmpty || _indices.length < index + 1) return null;

    for (int j = index + 1; j < _indices.length; j++) {
      if (_indices[j] != null) return j;
    }

    return null;
  }

  int? getLowerNonNull(int index) {
    if (index <= 0 || _indices.isEmpty) return null;

    for (int j = index - 1; j >= 0; j--) {
      if (_indices[j] != null) return j;
    }

    return null;
  }

  void expand(int index) {
    int expansion = index - _indices.length + 1;

    if (expansion >= 0 && expansion < _indices.length) return;

    if (index < 0 && date0 != null) {
      date0 = DateTime(date0!.year, date0!.month, date0!.day + index);
    }

    _indices.insertAll(index < 0 ? 0 : _indices.length,
        List<DateTime?>.generate(expansion.abs(), (i) => null));
  }
}
*/
