import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mymensa/widgets/generates.dart';

class NotificationsWindow extends StatefulWidget {
  NotificationsWindow({super.key});

  @override
  State<NotificationsWindow> createState() => _NotificationsWindowState();
}

class _NotificationsWindowState extends State<NotificationsWindow> {
  late double wid;
  late double hei;
  late FlutterLocalNotificationsPlugin flnp;
  bool initialized = false;
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    init().then((r) {
      if (r) {
        setState(() {
          initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    wid = MediaQuery.of(context).size.width;
    hei = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          left: -wid,
          right: -wid,
          top: border + 40,
          bottom: border,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: wid - 2 * border,
              height: hei,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      "Notifications",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (initialized)
                    Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(notifications[index]),
                          );
                        },
                      ),
                    )
                  else
                    generateText("Loading Notifications..."),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: border,
          top: border,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Future<bool> init() async {
    flnp = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings notificationsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings notificationsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: notificationsAndroid, iOS: notificationsIOS);
    flnp.initialize(initializationSettings);

    return true;
  }
}
