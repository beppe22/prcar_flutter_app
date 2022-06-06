// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

import '../chatImplementation/chatDetail.dart';

class BookingOutPage extends StatefulWidget {
  List<String> res;
  BookingOutPage({Key? key, required this.res}) : super(key: key);

  @override
  State<BookingOutPage> createState() => BookingOutPageState(res);
}

class BookingOutPageState extends State<BookingOutPage> {
  List<String> res;
  BookingOutPageState(this.res);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Booking-Out',
                style: TextStyle(fontSize: screenWidth * 0.06)),
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
              SizedBox(height: screenHeight * 0.05),
              (res.isEmpty)
                  ? Container(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.9,
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
                  : Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: res == [] ? 0 : res.length,
                          itemBuilder: (context, index) {
                            if (PassMarker.status[index] != 'e') {
                              return Container(
                                  padding: EdgeInsets.all(screenHeight * 0.008),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: screenHeight * 0.01),
                                        Container(
                                            height: screenHeight * 0.16,
                                            width: screenWidth * 0.9,
                                            padding: EdgeInsets.fromLTRB(
                                                screenWidth * 0.008,
                                                screenHeight * 0.008,
                                                screenWidth * 0.008,
                                                screenHeight * 0.008),
                                            child: (MaterialButton(
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                  title: Text(
                                                                      'What do you want to do?',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          fontSize: screenWidth *
                                                                              0.08,
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                  content: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                screenHeight * 0.03),
                                                                        Container(
                                                                            height: screenHeight *
                                                                                0.09,
                                                                            width: screenWidth *
                                                                                0.7,
                                                                            decoration:
                                                                                BoxDecoration(color: _colorAnulment(index), border: Border.all(width: 5.0, color: Colors.grey)),
                                                                            child: MaterialButton(
                                                                              onPressed: () async {
                                                                                if (PassMarker.status[index] != 'a') {
                                                                                  Navigator.pop(context);
                                                                                  final splitted = res[index].split('.');
                                                                                  String date = splitted[0];
                                                                                  DateTime dayStart = DateFormat("dd/MM/yyyy").parse(date.substring(0, 10));
                                                                                  DateTime day = DateTime.now();
                                                                                  DateTime day3 = DateTime(day.year, day.month, day.day + 3);
                                                                                  if (dayStart.compareTo(day3) > 0) {
                                                                                    setState(() {
                                                                                      _annulmentMessage(index);
                                                                                      PassMarker.status[index] = 'a';
                                                                                    });

                                                                                    Fluttertoast.showToast(msg: 'Reservation annulated!', fontSize: 20);
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: 'Impossible operation: you can\'t cancel the reservation 3 days before it :(', fontSize: 20);
                                                                                  }
                                                                                } else {
                                                                                  Fluttertoast.showToast(msg: 'Impossible operation: reservation already abolished :(', fontSize: 20);
                                                                                }
                                                                              },
                                                                              child: Text('Annulment', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.065, color: Colors.black)),
                                                                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                            )),
                                                                        SizedBox(
                                                                            height:
                                                                                screenHeight * 0.03),
                                                                        Container(
                                                                            height: screenHeight *
                                                                                0.09,
                                                                            width: screenWidth *
                                                                                0.7,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                            child: MaterialButton(
                                                                              onPressed: () async {
                                                                                Navigator.pop(context);
                                                                                final splitted = res[index].split('.');
                                                                                String date = splitted[0];
                                                                                DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(date.substring(11));
                                                                                if (dayEnd.compareTo(DateTime.now()) < 0 || PassMarker.status[index] == 'a') {
                                                                                  setState(() {
                                                                                    _eliminationMessage(index);
                                                                                    PassMarker.status[index] = 'e';
                                                                                  });
                                                                                  Fluttertoast.showToast(msg: 'This message has been eliminated!', fontSize: 20);
                                                                                } else {
                                                                                  Fluttertoast.showToast(msg: 'Impossible operation: you can\'t eliminate this message while the reservation isn\'t finished :(', fontSize: 20);
                                                                                }
                                                                              },
                                                                              child: Text('Elimination', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.065, color: Colors.black)),
                                                                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                            )),
                                                                        SizedBox(
                                                                            height:
                                                                                screenHeight * 0.03),
                                                                        Container(
                                                                            height: screenHeight *
                                                                                0.09,
                                                                            width: screenWidth *
                                                                                0.7,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                            child: MaterialButton(
                                                                              onPressed: () async {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text('Return', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.065, color: Colors.black)),
                                                                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                            )),
                                                                        Container(
                                                                            height: screenHeight *
                                                                                0.09,
                                                                            width: screenWidth *
                                                                                0.7,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                            child: MaterialButton(
                                                                              onPressed: () async {
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(friendName: 'ciao', friendUid: PassMarker.uidFriend[index])));
                                                                              },
                                                                              child: Text('Chat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.065, color: Colors.black)),
                                                                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                            ))
                                                                      ])));
                                                },
                                                child: Text(
                                                    _seeReservation(
                                                        index, res[index]),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenWidth * 0.05,
                                                        color: Colors
                                                            .redAccent)))),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 5.0,
                                                    color: Colors.grey),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 6,
                                                      blurRadius: 2)
                                                ]))
                                      ]));
                            }
                            return const SizedBox(height: 1);
                          }))
            ])));
  }

  String _seeReservation(int i, String message) {
    final splitted = message.split('.');
    String date = splitted[0];
    String car = splitted[1];
    DateTime dayStart = DateFormat("dd/MM/yyyy").parse(date.substring(0, 10));
    DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(date.substring(11));
    if (PassMarker.status[i] == 'a') {
      return i.toString() +
          '. Date: ' +
          date +
          '\n Model: ' +
          car +
          '\n Status: Declined';
    }
    if (PassMarker.status[i] == 'c' && dayStart.compareTo(DateTime.now()) > 0) {
      return i.toString() +
          '. Date: ' +
          date +
          '\n Model: ' +
          car +
          '\n Status: Soon';
    }
    if (PassMarker.status[i] == 'c' &&
        dayStart.compareTo(DateTime.now()) <= 0 &&
        dayEnd.compareTo(DateTime.now()) > 0) {
      return i.toString() +
          '. Date: ' +
          date +
          '\n Model: ' +
          car +
          '\n Status: Active';
    }
    return i.toString() +
        '. Date: ' +
        date +
        '\n Model: ' +
        car +
        '\n Status: Complete';
  }

  _eliminationMessage(int i) async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('booking-out')
        .doc(PassMarker.bookId[i])
        .update({'status': 'e'});
  }

  _annulmentMessage(int i) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .collection('booking-out')
        .doc(PassMarker.bookId[i])
        .update({'status': 'a'});
  }

  _colorAnulment(int i) {
    if (PassMarker.status[i] == 'a') {
      return Colors.black;
    } else {
      return Colors.redAccent;
    }
  }
}
