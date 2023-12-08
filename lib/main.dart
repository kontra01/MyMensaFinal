import 'package:flutter/material.dart';
import 'widgets/footer.dart';
import 'widgets/containerTest.dart';

void main() {
  runApp(const MyMensa());
}

final ButtonStyle headerButton =
    ElevatedButton.styleFrom(minimumSize: const Size.fromWidth(60.0));

class MyMensa extends StatelessWidget {
  const MyMensa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              FlutterLogo(),
              SizedBox(width: 10.0),
              Text('MyMensa'),
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
