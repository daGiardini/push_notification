import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String homeScreenText = "Waiting for token...";
  String messageText = "Waiting for message...";

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      String title = message.notification?.title ?? "Cannot get title";
      String body = message.notification?.body ?? "Cannot get body";

      setState(() {
        messageText = "Push Messaging message:\n$title\n$body";
      });

      logger.d("Message body: $body");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      String title = message.notification?.title ?? "Cannot get title";
      String body = message.notification?.body ?? "Cannot get body";

      setState(() {
        messageText = "Push Messaging message:\n$title\n$body";
      });

      logger.d("Message body: $body");
    });

    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true)
        .then((value) => logger.i("Settings registered: $value"));

    FirebaseMessaging.instance.getToken().then((token) {
      assert(token != null);
      setState(() {
        homeScreenText = "Push Messaging token: $token";
      });
      logger.d('Token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Measurify Push Messaging Examp'),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(homeScreenText),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Text(messageText),
                ),
              ])
            ],
          ),
        ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase app
  runApp(
    const MaterialApp(
      home: MyHomePage(),
    ),
  );
}
