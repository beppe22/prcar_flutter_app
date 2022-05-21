import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  List<String> messages = [];
  MessagePage(this.messages, {Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => MessagePageState(messages);
}

class MessagePageState extends State<MessagePage> {
  List<String> messages = [];
  MessagePageState(this.messages, {Key? key});

  late FirebaseMessaging messaging;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String messaggio = '';

  /*@override
  void initState() {
    super.initState();
    /*messaging = FirebaseMessaging.instance;
    _saveToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });*/
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("My first app")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(messages.last),
        ],
      )),
    ));
  }

  /*ciao() async {
    String tok = '';

    await db.collection('a').doc('a').get().then((value) {
      tok = value['token'];
    });
    print(tok);
  }*/

  /*_saveToken() async {
    await messaging.getToken().then((value) async {
      print(value);

      await db.collection('a').doc('a').set({
        'token': value,
      });
    });
  }*/

  setTheState(String newMess) {
    setState(() {
      messaggio = newMess;
    });
  }
}
