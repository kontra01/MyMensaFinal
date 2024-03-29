import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'package:mymensa/widgets/storage/meal.dart';
import 'package:mymensa/widgets/storage/mealtype.dart';
import 'package:mymensa/widgets/storage/mensaday.dart';
import 'package:mymensa/widgets/storage/plan.dart';

Future<Map> readJson() async {
  final String response = await rootBundle.loadString('assets/mensa.json');
  final data = await json.decode(response);
  return data;
}

Future<Id> loadJSON(AllSchemata allSchemata, Id planId) async {
  // https://github.com/isar/isar/discussions/256
  Plan plan = await allSchemata.planSchema.plans.get(planId) ?? Plan();
  Map data = await readJson();
  DateTime date;
  int typus = 0;
  int hours = 13;
  int minutes = 0;

  final days = data["Days"];
  for (var day in days) {
    date = dateHelper(day["date"]);
    List<Id> mealTypeIds = [];

    for (var mealType in day["mealTypes"]) {
      String mealTypeName = mealType["name"];
      List<Id> mealIdList = [];

      for (var meal in mealType["meals"]) {
        Meal m = Meal(meal["name"], meal["price"]);
        await allSchemata.mealSchema.writeTxn(() async {
          await allSchemata.mealSchema.meals.put(m);
        });
        mealIdList.add(m.getId());
      }

      MealType mt = MealType(mealTypeName, mealIdList, typus, hours, minutes);
      await allSchemata.mealtypeSchema.writeTxn(() async {
        await allSchemata.mealtypeSchema.mealTypes.put(mt);
      });
      mealTypeIds.add(mt.id);
    }

    MensaDay md = MensaDay(date, mealTypes: mealTypeIds);
    await allSchemata.mensadaySchema.writeTxn(() async {
      await allSchemata.mensadaySchema.mensaDays.put(md);
    });
    plan.add(md);
  }
  await allSchemata.planSchema.writeTxn(() async {
    await allSchemata.planSchema.plans.put(plan);
  });

  return plan.id;
}

DateTime dateHelper(String dateStr) {
  List split = dateStr.split('-');
  int year = int.parse(split[0]);
  int month = int.parse(split[1]);
  int day = int.parse(split[2]);
  return DateTime(year, month, day);
}
