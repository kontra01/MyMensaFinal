import "package:isar/isar.dart";
import "allSchemata.dart";
import "mensaday.dart";

part "plan.g.dart";

@collection
class Plan {
  Id id = Isar.autoIncrement;
  // -> List<Id> with Id being a Isar object id for the meals.
  DateTime? date0;

  final List<Id?> indices = [];

  void add(AllSchemata schemata, MensaDay day) async {
    day.toUtc();
    await schemata.mensadaySchema.writeTxn(() async {
      await schemata.mensadaySchema.mensaDays.put(day);
    });
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
    return index < 0 || index >= indices.length ? null : indices[index];
  }

  /// Returns [DateTime] for provided [DateTime]. If [DateTime] is not added for [DateTime] yet, null is returned.

  Id? getDay(DateTime date) {
    date = date.toUtc();
    return this[getAccountedIndex(date)];
  }

  DateTime getAccountedDate(int index) {
    return date0 == null
        ? DateTime.now().toUtc()
        : DateTime(date0!.year, date0!.month, date0!.day + index);
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
    if (date0 == null) return 0;
    return date.toUtc().difference(date0!).inDays;
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

    if (expansion >= 0 && expansion < indices.length) return;

    if (index < 0 && date0 != null) {
      date0 = DateTime(date0!.year, date0!.month, date0!.day + index);
    }

    indices.insertAll(index < 0 ? 0 : indices.length,
        List<Id?>.generate(expansion.abs(), (i) => null));
  }

  void addAll(AllSchemata allSchemata, [List<MensaDay> mensaDays = const []]) {
    for (MensaDay md in mensaDays) {
      add(allSchemata, md);
    }
  }

  List<Id> getAllNonNulls() {
    List<Id> nonNulls = [];
    for (Id? d in indices) {
      if (d != null) nonNulls.add(d);
    }
    return nonNulls;
  }

  List<Id?> getAll() => indices;

  int getClosestFutureDay(DateTime date) {
    int iD = getAccountedIndex(date);
    if (iD < 0) {
      expand(iD);
      iD = 0;
    }
    return getUpperNonNull(iD) ?? iD;
  }
}
