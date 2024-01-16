import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "datemap.dart";

part "plan.g.dart";

@collection
class Plan {
  Id id = Isar.autoIncrement;
  // -> List<Id> with Id being a Isar object id for the meals.
  DateTime? date0;

  final List<MensaDay?> _indices = [];

  void add(MensaDay day) {
    day.toUtc();
    int thrIndex = getAccountedIndex(day.date);

    if (thrIndex < 0) {
      expand(-thrIndex + 1);
      thrIndex = 0;
    }

    if (thrIndex == 0) {
      _indices.insert(0, day);
      date0 = day.date;
      return;
    } else if (thrIndex >= _indices.length) {
      expand(thrIndex - 1);
      _indices.add(day);
    } else {
      _indices[thrIndex] = day;
    }
  }

  /// Returns [MensaDay] for provided [index]. If [DateTime] is not added for [index] yet, null is returned.

  MensaDay? operator [](int index) {
    return index < 0 || index > _indices.length ? null : _indices[index];
  }

  /// Returns [DateTime] for provided [DateTime]. If [DateTime] is not added for [DateTime] yet, null is returned.

  MensaDay? getDay(DateTime date) {
    date = date.toUtc();
    for (int i = 0; i < _indices.length; i++) {
      if (DateUtils.isSameDay(_indices[i]!.date, date)) return _indices[i];
    }
    return null;
  }

  DateTime getAccountedDate(int index) {
    if (this[index] != null) {
      return this[index]!.date;
    }

    return date0 == null
        ? DateTime.now().toUtc()
        : DateTime(date0!.year, date0!.month, date0!.day + index);
  }

  int? getIndex(DateTime date) {
    date = date.toUtc();
    for (int i = 0; i < _indices.length; i++) {
      if (DateUtils.isSameDay(_indices[i]!.date, date)) return i;
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
        List<MensaDay?>.generate(expansion.abs(), (i) => null));
  }

  void addDay(DateTime date, [List<MealType> mealTypes = const []]) {
    add(MensaDay(date, mealTypes: mealTypes));
  }

  void addDays([List<MensaDay> mensaDays = const []]) {
    for (MensaDay md in mensaDays) {
      add(md);
    }
  }

  int getClosestFutureDay(DateTime date) {
    int iD = getAccountedIndex(date);
    if (iD < 0) {
      expand(iD);
      iD = 0;
    }
    return getUpperNonNull(iD) ?? iD;
  }
}
