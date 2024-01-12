import "dart:collection";

import "package:isar/isar.dart";

class MensaDay extends DateTime {
  late Id mealId;
  MensaDay(super.year, super.month, super.day);
}

class DateMap<DateType> {
  List<DateType?> indices = [];

  void add(DateTime date, DateType entry) {
    date = date.toUtc();
    DateTime? d0 = getDate0();
    if (d0 == null) {
      indices.add(date);
      return;
    }

    int gapToBase = date.difference(d0).inDays;

    if (d0.isAfter(date)) {
      this.expand(-gapToBase + 1);
      indices.insert(0, date);
    } else if (gapToBase >= indices.length) {
      this.expand(gapToBase - 1);
      indices.add(date);
    } else {
      indices[gapToBase] = date;
      return;
    }
  }

  DateTime? getDate0([int? index]) {
    if (indices.isEmpty) return null;
    if (index != null && indices[index] != null) {
      return indices[index];
    } else if (index == null && indices[0] != null) {
      return indices[0];
    }
    int? iX = this.getUpperNonNull(-1);
    if (iX == null) return null;
    DateTime dX = indices[iX]!;
    return DateTime(dX.year, dX.month, dX.day - iX + (index ?? 0)).toUtc();
  }

  /// Returns [EntryType] for provided [DateTime]. If [EntryType] is not added for [DateTime] yet, null is returned.
  EntryType? operator [](DateTime date) {
    return map[date];
  }

  /// Returns [DateTime] for provided [index]. If [DateTime] is not added for [index] yet, null is returned.
  DateTime? getDate(int index) {
    try {
      return indices[index];
    } on IndexError {
      return null;
    }
  }

  DateTime getAccountedDate(int index) {
    DateTime? d = getDate(index);
    if (d != null) {
      return d;
    }
    DateTime? d0 = getDate0();
    if (d0 == null) {
      return DateTime.now();
    }
    return DateTime(d0.year, d0.month, d0.day + index);
  }

  int getIndex(DateTime date) {
    DateTime? d0 = getDate0();
    if (d0 == null) {
      return 0;
    }
    return date.toUtc().difference(d0).inDays;
  }

  /// Returns [EntryType] through redirection for provided [index]. If [DateTime] or [EntryType] for that is not added for [index] yet, null is returned.
  EntryType? getEntry(int index) {
    try {
      return map[indices[index]];
    } on IndexError {
      return null;
    }
  }

  /// Returns tuple of [DateTime] and [EntryType] for provided [index]. Either parts can be null, if not added yet.
  (DateTime?, EntryType?) of(int index) {
    DateTime? date = getDate(index);
    return (date, map[date]);
  }

  int? getUpperNonNull(int index) {
    if (indices.isEmpty || indices.length < index + 1) return null;
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
    int expansion = index - indices.length + 1;
    if (expansion == 0 || expansion.abs() < indices.length) return;
    indices.insertAll(index < 0 ? 0 : indices.length,
        List<DateTime?>.generate(expansion.abs(), (i) => null));
  }
}
