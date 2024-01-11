import 'package:flutter/material.dart';
import 'widgets/footer.dart';
import 'widgets/mainview.dart';
import 'widgets/variables.dart';
import 'widgets/containerTest.dart';

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
  _MyMensaState createState() => _MyMensaState();
}

class _MyMensaState extends State<MyMensa> {
  late PageController pageController;
  int currentContainer = 0;

  void changeContainer(int index) {
    setState(() {
      currentContainer = index;
    });
    pageController.jumpToPage(index);
  }

  int getContainer() {
    return currentContainer;
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentContainer);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
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
      ),
      body: PageStorage(
          bucket: PageStorageBucket(),
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentContainer = index;
              });
            },
            children: const [ContainerT1(), Container1()],
          )),
      bottomNavigationBar: FooterWidget(changeContainer, getContainer),
    ));
  }
}
