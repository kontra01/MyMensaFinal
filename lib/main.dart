import 'package:flutter/material.dart';
import 'widgets/footer.dart';
import 'widgets/containerTest.dart';

// main color: 0xff94c11f

void main() {
  runApp(const MyMensa());
}

final ButtonStyle headerButton = ElevatedButton.styleFrom(
  minimumSize: const Size.fromWidth(60.0),
);

void changeContainer(StatelessWidget newContainer) {
  return;
}

class MyMensa extends StatelessWidget {
  const MyMensa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xaa94c11f),
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
        ),
        body: const Container1(),
        bottomNavigationBar: const FooterWidget(),
      ),
    );
  }
}
