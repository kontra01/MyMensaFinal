import 'package:isar/isar.dart';

import 'mealtype.dart';

part "mensaday.g.dart";

@collection
class MensaDay {
  Id id = Isar.autoIncrement;
  List<Id> mealTypes = [];
  DateTime date;
  MensaDay(this.date, {this.mealTypes = const []});
  void add(Isar mealTypeSchema, MealType mt) async {
    await mealTypeSchema.writeTxn(() async {
      await mealTypeSchema.mealTypes.put(mt);
    });
    for (int i = 0; i < mealTypes.length; i++) {
      if (mt.isBefore((await mealTypeSchema.mealTypes.get(mealTypes[i]))!)) {
        mealTypes.insert(i, mt.id);
        return;
      }
    }
    mealTypes.add(mt.id);
  }

  void toUtc() {
    date = date.toUtc();
  }
}
