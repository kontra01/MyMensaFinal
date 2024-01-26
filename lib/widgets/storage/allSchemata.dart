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

  Future<bool> closeSchema(Isar? schema) async {
    try {
      await schema?.close();
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> closeAll() async {
    if (!schemataAreInitialized) return false;
    await closeSchema(mealSchema);
    await closeSchema(planSchema);
    await closeSchema(mensadaySchema);
    await closeSchema(mealtypeSchema);
    schemataAreInitialized = false;
    return true;
  }

  Future<void> openSchema(
      Isar? schemaVar, List<CollectionSchema<dynamic>> schema,
      {String name = "default"}) async {
    try {
      schemaVar = await Isar.open(schema, directory: dir.path, name: name);
    } catch (e) {
      return;
    }
  }

  Future<bool> initialize() async {
    if (schemataAreInitialized) return true;
    try {
      mealSchema = await Isar.open([MealSchema],
          directory: dir.path, name: "mealSchema");
    } catch (e) {
      print("Error opening schema: $e");
    }
    try {
      planSchema = await Isar.open([PlanSchema],
          directory: dir.path, name: "planSchema");
    } catch (e) {
      print("Error opening schema: $e");
    }
    try {
      mensadaySchema = await Isar.open([MensaDaySchema],
          directory: dir.path, name: "mensadaySchema");
    } catch (e) {
      print("Error opening schema: $e");
    }
    try {
      mealtypeSchema = await Isar.open([MealTypeSchema],
          directory: dir.path, name: "mealtypeSchema");
    } catch (e) {
      print("Error opening schema: $e");
    }
    schemataAreInitialized = true;
    return true;
  }
}
