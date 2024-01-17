import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/storage/meal.dart';
import 'package:mymensa/widgets/storage/plan.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/footer.dart';
import 'widgets/mainview.dart';
import 'widgets/variables.dart';

late Isar mealSchema;
late Isar planSchema;
late Directory dir;
bool schemataAreInitialized = false;

void main() {
  runApp(const MyMensa());
}

final ButtonStyle headerButton = ElevatedButton.styleFrom(
  minimumSize: const Size.fromWidth(60.0),
);

class MyMensa extends StatefulWidget {
  final StatefulWidget? container;

  const MyMensa({super.key, this.container});

  @override
  State<MyMensa> createState() => _MyMensaState();
}

class _MyMensaState extends State<MyMensa> {
  void changeContainer(int index) {}

  void getContainer() {}

  Future<Isar> openSchema(List<CollectionSchema<dynamic>> schema,
      {String name = "default"}) async {
    return await Isar.open(schema, directory: dir.path, name: name);
  }

  Future<bool> initializeSchemata() async {
    print("initialization started.");
    dir = await getApplicationDocumentsDirectory();
    try {
      mealSchema = await openSchema([MealSchema], name: "mealSchema");
    } catch (e) {
      print("mS might be already opened.");
      print(e);
    }
    print("mealSchema init");
    try {
      planSchema = await openSchema([PlanSchema], name: "planSchema");
    } catch (e) {
      print("pS might be already opened.");
      print(e);
    }
    print("schemata initialized.");
    schemataAreInitialized = true;
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<bool>(
          future: initializeSchemata(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("data received");
              return MainView(mealSchema, planSchema, 1);
            } else {
              return const Center(
                child: Text("loading..."),
              );
            }
          }),
      bottomNavigationBar: FooterWidget(changeContainer, getContainer),
    ));
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: MyMensaStyle.main,
      title: Row(
        children: [
          Image.asset(
            'assets/logo/4xtransparent/mymensa4@4x.png',
            height: 25.0,
          ),
          const SizedBox(width: 10.0),
          const Text('MyMensa'),
        ],
      ),
      actions: [
        IconButton(
          // settings button
          style: headerButton,
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        IconButton(
          // personal button
          style: headerButton,
          icon: const Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }
}
