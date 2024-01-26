import "package:isar/isar.dart";
import "mensaday.dart";
// STOPP
part "plan.g.dart";

@collection
class Plan {
  Id id = Isar.autoIncrement;
  // -> List<Id> with Id being a Isar object id for the meals.
  DateTime date0 = DateTime(0);

  List<Id> indices = [];

  void add(MensaDay day) async {
    day.toUtc();
    int thrIndex = getAccountedIndex(day.date);
    if (thrIndex < 0) {
      expand(-thrIndex + 1);
      thrIndex = 0;
    }

    if (thrIndex == 0) {
      indices.insert(0, day.id);
      date0 = day.date;
      return;
    } else if (thrIndex >= indices.length) {
      expand(thrIndex - 1);
      indices.add(day.id);
    } else {
      indices[thrIndex] = day.id;
    }
  }

  /// Returns [MensaDay] for provided [index]. If [DateTime] is not added for [index] yet, null is returned.

  Id? operator [](int index) {
    return index < 0 || index >= indices.length
        ? null
        : (indices[index] < 0 ? null : indices[index]);
  }

  /// Returns [DateTime] for provided [DateTime]. If [DateTime] is not added for [DateTime] yet, null is returned.

  Id? getDay(DateTime date) {
    date = date.toUtc();
    return this[getAccountedIndex(date)];
  }

  bool date0isNull() => date0.year == 0;
  void date0toNull() {
    date0 = DateTime(0);
  }

  DateTime getAccountedDate(int index) {
    return date0isNull()
        ? DateTime.now().toUtc()
        : DateTime(date0.year, date0.month, date0.day + index);
  }

  int? getIndex(DateTime date) {
    date = date.toUtc();
    int accountion = getAccountedIndex(date);
    if (this[accountion] == null) {
      return null;
    } else {
      return accountion;
    }
  }

  int getAccountedIndex(DateTime date) {
    if (date0isNull()) return 0;
    return date.toUtc().difference(date0).inDays;
  }

  int? getUpperNonNull(int index) {
    if (indices.isEmpty || indices.length < index + 1) return null;

    for (int j = index + 1; j < indices.length; j++) {
      if (this[j] != null) return j;
    }

    return null;
  }

  int? getLowerNonNull(int index) {
    if (index <= 0 || indices.isEmpty) return null;

    for (int j = index - 1; j >= 0; j--) {
      if (this[j] != null) return j;
    }

    return null;
  }

  void expand(int index) {
    if (index >= 0 && index < indices.length) return;

    if (index < 0 && !date0isNull()) {
      date0 = DateTime(date0.year, date0.month, date0.day + index);
    }

    List<Id> minusList = List<Id>.generate(index.abs(), (i) => -1);
    indices = index < 0 ? (minusList + indices) : (indices + minusList);
  }

  void addAll([List<MensaDay> mensaDays = const []]) {
    for (MensaDay md in mensaDays) {
      add(md);
    }
  }

  List<Id> getAllNonNulls() {
    List<Id> nonNulls = [];
    for (int d = 0; d < indices.length; d++) {
      if (this[d] != null) nonNulls.add(this[d]!);
    }
    return nonNulls;
  }

  List<Id?> getAll() => indices;

  int getClosestFutureDay(DateTime date) {
    int iD = getAccountedIndex(date);
    if (iD < 0) {
      expand(iD);
      iD = 0;
      return getUpperNonNull(iD) ?? iD;
    }
    return getUpperNonNull(iD - 1) ?? iD;
  }
}
