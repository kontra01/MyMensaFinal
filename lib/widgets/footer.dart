import 'package:flutter/material.dart';
import 'variables.dart';

final ButtonStyle footerButton = ElevatedButton.styleFrom(
    backgroundColor: MyMensaStyle.main,
    foregroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    minimumSize: const Size.fromHeight(double.infinity));

// ignore: must_be_immutable
class FooterWidget extends StatelessWidget {
  late var changeContainer;
  late var getIndex;

  FooterWidget(this.changeContainer, this.getIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (this.getIndex == 0) return;
                changeContainer(0);
              },
              style: footerButton,
              child: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (this.getIndex == 1) return;
                changeContainer(1);
              },
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
