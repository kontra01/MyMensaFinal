import 'package:flutter/material.dart';
import 'variables.dart';

final ButtonStyle footerButton = ElevatedButton.styleFrom(
    backgroundColor: MyMensaStyle.main,
    foregroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    minimumSize: const Size.fromHeight(double.infinity));

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: footerButton,
              child: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: footerButton,
              child: const Icon(Icons.today),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: footerButton,
              child: const Icon(Icons.checklist),
            ),
          )
        ],
      ),
    );
  }
}
