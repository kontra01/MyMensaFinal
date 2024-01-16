import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContainerT1 extends StatefulWidget {
  const ContainerT1({super.key});

  @override
  State<ContainerT1> createState() => _ContainerT1State();
}

class _ContainerT1State extends State<ContainerT1> {
  @override
  void initState() {
    print("inited");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nothing"),
      ),
      body: const Text("container text"),
    );
  }
}
