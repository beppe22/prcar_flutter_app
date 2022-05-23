// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  List<String> messages;
  MessagePage(this.messages, {Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => MessagePageState(messages);
}

class MessagePageState extends State<MessagePage> {
  List<String> messages;
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('PrCar'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 40),
              (messages.isEmpty)
                  ? Container(
                      height: 70,
                      width: 350,
                      child: const Text('No messages yet :(',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 5.0, color: Colors.redAccent),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 6,
                                blurRadius: 2)
                          ]))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages == [] ? 0 : messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                  const SizedBox(height: 20),
                                  Container(
                                      height: 50,
                                      width: 350,
                                      child: Text(messages[index]),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.redAccent,
                                                spreadRadius: 6,
                                                blurRadius: 2)
                                          ]))
                                ])));
                      }),
            ])));
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
