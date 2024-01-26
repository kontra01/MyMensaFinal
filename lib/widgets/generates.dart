import 'package:flutter/material.dart';

const double border = 30;

Widget generateText(String text) {
  return Center(
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );
}
