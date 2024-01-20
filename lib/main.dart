import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
import 'package:path_provider/path_provider.dart';
import 'widgets/footer.dart';
import 'widgets/mainview.dart';
import 'widgets/variables.dart';

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
  int dateFocus = 0;
  AllSchemata? allSchemata;
  late Directory dir;
  bool schemataAreInitialized = false;

  void changeContainer(int index) {}

  int dateFocusGetter() {
    return dateFocus;
  }

  void dateFocusSetter(int newFocus) {
    setState(() {
      dateFocus = newFocus;
    });
  }

  Future<bool> initializeSchemata() async {
    print("initialization started.");
    dir = await getApplicationDocumentsDirectory();
    if (allSchemata != null) {
      return true;
      //print("closing all...");
      //await allSchemata!.closeAll();
    }
    allSchemata = AllSchemata(dir);
    return await allSchemata!.initialize();
  }

  @override
  void initState() {
    dateFocus = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "MyMensa",
        theme: ThemeData(
            textTheme:
                GoogleFonts.lexendTextTheme(Theme.of(context).textTheme)),
        home: FutureBuilder<bool>(
            future: initializeSchemata(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    appBar: getAppBar(),
                    body: MainView(
                        allSchemata!, 1, dateFocusGetter, dateFocusSetter),
                    bottomNavigationBar: FooterWidget(
                        allSchemata!, 1, dateFocusGetter, dateFocusSetter));
              } else {
                return const Center(
                  child: Text("loading..."),
                );
              }
            }));
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
          const Text('My Mensa'),
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
