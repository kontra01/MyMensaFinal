import 'dart:io';

import 'package:isar/isar.dart';
import 'package:mymensa/widgets/storage/mealtype.dart';
import 'package:mymensa/widgets/storage/mensaday.dart';

import 'meal.dart';
import 'plan.dart';

class AllSchemata {
  late Isar mealSchema;
  late Isar planSchema;
  late Isar mensadaySchema;
  late Isar mealtypeSchema;
  Directory dir;
  bool schemataAreInitialized = false;

  AllSchemata(this.dir);

  Future<Isar?> openSchema(List<CollectionSchema<dynamic>> schema,
      {String name = "default"}) async {
    try {
      return await Isar.open(schema, directory: dir.path, name: name);
    } catch (e) {
      print("Schema might be already opened.");
      print(e);
    }
    return null;
  }

  Future<bool> initialize() async {
    mealSchema =
        await openSchema([MealSchema], name: "mealSchema") ?? mealSchema;
    print("mealSchema initialized");
    planSchema =
        await openSchema([PlanSchema], name: "planSchema") ?? planSchema;
    print("planSchema initialized");
    mensadaySchema =
        await openSchema([MensaDaySchema], name: "mensadaySchema") ??
            mensadaySchema;
    print("mensadaySchema initialized");
    mealtypeSchema =
        await openSchema([MealTypeSchema], name: "mealtypeSchema") ??
            mealtypeSchema;
    print("mealtypeSchema initialized");
    schemataAreInitialized = true;
    return true;
  }
}
