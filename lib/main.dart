import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'widgets/footer.dart';
import 'widgets/mainview.dart';
import 'widgets/variables.dart';

late Isar mealSchema;
late Isar planSchema;
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
  Widget _body = MainView(mealSchema, planSchema, 1);

  void changeContainer(int index) {}

  void getContainer() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: getAppBar(),
      body: _body,
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
          style: headerButton,
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        IconButton(
          style: headerButton,
          icon: const Icon(Icons.person),
          onPressed: () {},
        ),
      ],
    );
  }
}
