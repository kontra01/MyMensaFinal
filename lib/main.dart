import 'package:flutter/material.dart';

void main() {
  runApp(const MyMensaHome());
}

class MyMensaHome extends StatelessWidget {
  const MyMensaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
