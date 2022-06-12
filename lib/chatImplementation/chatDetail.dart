// ignore_for_file: no_logic_in_create_state, file_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

class ChatDetail extends StatefulWidget {
  final String friendUid;
  final String friendName;
  final bool hp;
  const ChatDetail(
      {Key? key,
      required this.friendUid,
      required this.friendName,
      required this.hp})
      : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName, hp);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final String friendUid;
  final String friendName;
  final bool hp;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;
  var textController = TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName, this.hp);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });
            } else {
              await chats.add({
                'users': {currentUserId: null, friendUid: null},
                'names': {
                  currentUserId: FirebaseAuth.instance.currentUser?.displayName,
                  friendUid: friendName
                }
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': friendName,
      'friendId': friendUid,
      'msg': msg
    }).then((value) {
      textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: Text(friendName,
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: hp
                        ? Icon(Icons.cancel, size: screenText * 25)
                        : Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            data = document.data()!;
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02),
                                child: ChatBubble(
                                    clipper: ChatBubbleClipper6(
                                      nipSize: 0,
                                      radius: 0,
                                      type: isSender(data['uid'].toString())
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble,
                                    ),
                                    alignment:
                                        getAlignment(data['uid'].toString()),
                                    margin: EdgeInsets.only(
                                        top: screenHeight * 0.02),
                                    backGroundColor:
                                        isSender(data['uid'].toString())
                                            ? Colors.redAccent
                                            : Colors.grey.shade200,
                                    child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                        ),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  child: Text(data['msg'],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: isSender(data[
                                                                      'uid']
                                                                  .toString())
                                                              ? Colors.white
                                                              : Colors.black),
                                                      maxLines: 100,
                                                      overflow:
                                                          TextOverflow.fade))
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    data['createdOn'] == null
                                                        ? DateTime.now()
                                                            .toString()
                                                            .substring(0, 16)
                                                        : data['createdOn']
                                                            .toDate()
                                                            .toString()
                                                            .substring(0, 16),
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenText * 14,
                                                        color: isSender(
                                                                data['uid']
                                                                    .toString())
                                                            ? Colors.white
                                                            : Colors.black))
                                              ])
                                        ]))));
                          }).toList())),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.08),
                          child: CupertinoTextField(
                            controller: textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                          child: Icon(Icons.send_sharp, size: screenText * 25),
                          onPressed: () => sendMessage(textController.text))
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
