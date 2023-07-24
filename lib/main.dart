import 'package:consolelog/consolelog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
      setState(() {
        String title = message.notification?.title ?? "Cannot get title";
        String body = message.notification?.body ?? "Cannot get body";
        messageText = "Push Messaging message:\n$title\n$body\n";
      });
      console.log("onMessage: $message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      setState(() {
        String title = message.notification?.title ?? "Cannot get title";
        String body = message.notification?.body ?? "Cannot get body";
        messageText = "Push Messaging message:\n$title\n$body\n";
      });
      console.log("onMessageOpenedApp: $message");
    });

    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true)
        .then((value) => console.log("Settings registered: $value"));

    FirebaseMessaging.instance.getToken().then((token) {
      assert(token != null);
      setState(() {
        homeScreenText = "Push Messaging token: $token";
      });
      console.log('Token: $token');
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
