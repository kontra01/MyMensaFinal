import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'search.dart';
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
  Function dateFocusSetter;
  Function dateFocusGetter;
  Isar mealSchema;
  Isar planSchema;
  Id planId;

  FooterWidget(this.mealSchema, this.planSchema, this.planId,
      this.dateFocusGetter, this.dateFocusSetter,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showPopUpWindow(
                    context, CustomPopUp(mealSchema, planSchema, planId));
              },
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

  void _showPopUpWindow(BuildContext context, StatefulWidget widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
