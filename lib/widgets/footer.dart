import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mymensa/widgets/mainview.dart';
import 'package:mymensa/widgets/notifications.dart';
import 'package:mymensa/widgets/storage/allSchemata.dart';
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
  MainView mv;
  AllSchemata allSchemata;
  Id planId;

  void setJumper(MainView mv) {
    this.mv = mv;
  }

  FooterWidget(this.allSchemata, this.planId, this.dateFocusGetter,
      this.dateFocusSetter, this.mv,
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
                _showPopUpWindow(context, SearchPopUp(allSchemata, planId, mv));
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
              onPressed: () {
                _showPopUpWindow(context, NotificationsWindow());
              },
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
