import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import '../booking/booking_in.dart';
import '../booking/booking_out.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  MessagePageState({Key? key});

  late FirebaseMessaging messaging;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String messaggio = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('All Booking',
                style: TextStyle(fontSize: screenText * 20)),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: screenText * 25),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Center(
            child: Column(children: [
          SizedBox(height: screenHeight * 0.05),
          SizedBox(
              height: screenHeight * 0.35,
              child: Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          Container(
              height: screenHeight * 0.12,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () async {
                    List<String> res = await _fetchOtherRes();
                    String bookingId = '';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingInPage(
                                bookingId: bookingId,
                                res: res,
                                fromHp: false)));
                  },
                  padding: EdgeInsets.fromLTRB(
                      screenHeight * 0.01,
                      screenWidth * 0.03,
                      screenWidth * 0.03,
                      screenHeight * 0.01),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Here for others reservations!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))))),
          SizedBox(height: screenHeight * 0.06),
          Container(
              height: screenHeight * 0.12,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () async {
                    List<String> res = await _fetchMyRes();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingOutPage(res: res)));
                  },
                  padding: EdgeInsets.fromLTRB(
                      screenHeight * 0.01,
                      screenWidth * 0.03,
                      screenWidth * 0.03,
                      screenHeight * 0.01),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Here for your reservations!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))))
        ])));
  }

  Future<List<String>> _fetchMyRes() async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    List<String> myRes = [];
    PassMarker.uidFriend = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('booking-out')
          .get();

      if (data.docs.isNotEmpty) {
        for (var bookOut in data.docs) {
          String insert = bookOut.data()['date'];

          var data1 = await firebaseFirestore
              .collection('users')
              .doc(bookOut.data()['uidOwner'])
              .collection('cars')
              .doc(bookOut.data()['cid'])
              .get();
          if (bookOut.data()['status'] != 'e') {
            PassMarker.uidFriend.add(bookOut.data()['uidOwner']);
            PassMarker.cid.add(bookOut.data()['cid']);
            PassMarker.bookId.add(bookOut.data()['bookingId']);
            PassMarker.status.add(bookOut.data()['status']);
            insert = insert +
                '.' +
                data1.data()!['veicol'] +
                '-' +
                data1.data()!['model'];
            myRes.add(insert);
          }
        }
      }
    }
    return myRes;
  }

  Future<List<String>> _fetchOtherRes() async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    List<String> otherRes = [];
    PassMarker.uidFriend = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get();
      if (data.docs.isNotEmpty) {
        for (var car in data.docs) {
          await firebaseFirestore
              .collection('users')
              .doc(car.data()['uid'])
              .collection('cars')
              .doc(car.data()['cid'])
              .collection('booking-in')
              .get()
              .then((ds) async {
            if (ds.docs.isNotEmpty) {
              for (var book in ds.docs) {
                String insert = book.data()['date'];
                var data1 = await firebaseFirestore
                    .collection('users')
                    .doc(book.data()['uidOwner'])
                    .collection('cars')
                    .doc(book.data()['cid'])
                    .get();
                if (book.data()['status'] != 'e') {
                  PassMarker.uidFriend.add(book.data()['uidBooking']);
                  PassMarker.cid.add(book.data()['cid']);
                  PassMarker.bookId.add(book.data()['bookingId']);
                  PassMarker.status.add(book.data()['status']);
                  insert = insert +
                      '.' +
                      data1.data()!['veicol'] +
                      '-' +
                      data1.data()!['model'];

                  otherRes.add(insert);
                }
              }
            }
          });
        }
      }
    }
    return otherRes;
  }
}
