// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class BookingInPage extends StatefulWidget {
  List<String> res;
  String bookingId;
  BookingInPage({Key? key, required this.res, required this.bookingId})
      : super(key: key);

  @override
  State<BookingInPage> createState() => BookingInPageState(res, bookingId);
}

class BookingInPageState extends State<BookingInPage> {
  List<String> res;
  String bookingId;
  BookingInPageState(this.res, this.bookingId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Booking-In'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              const SizedBox(height: 40),
              (res.isEmpty)
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
                      itemCount: res == [] ? 0 : res.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                      height: 110,
                                      width: 350,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      child: (MaterialButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                            title: const Text(
                                                                'What do you want to do?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Container(
                                                                      height:
                                                                          70,
                                                                      width:
                                                                          250,
                                                                      decoration: BoxDecoration(
                                                                          color: _colorAnulment(
                                                                              index),
                                                                          border: Border.all(
                                                                              width: 5.0,
                                                                              color: Colors.grey)),
                                                                      child: MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (PassMarker.status[index] !=
                                                                              'a') {
                                                                            Navigator.pop(context);
                                                                            final splitted =
                                                                                res[index].split('.');
                                                                            String
                                                                                date =
                                                                                splitted[0];
                                                                            DateTime
                                                                                dayStart =
                                                                                DateFormat("dd/MM/yyyy").parse(date.substring(0, 10));
                                                                            DateTime
                                                                                day =
                                                                                DateTime.now();
                                                                            DateTime
                                                                                day3 =
                                                                                DateTime(day.year, day.month, day.day + 3);
                                                                            if (dayStart.compareTo(day3) >
                                                                                0) {
                                                                              setState(() {
                                                                                _annulmentMessage(index);
                                                                                PassMarker.status[index] = 'a';
                                                                              });

                                                                              Fluttertoast.showToast(msg: 'Operation abolished!', fontSize: 20);
                                                                            } else {
                                                                              Fluttertoast.showToast(msg: 'Impossible operation: you can\'t cancel the reservation 3 days before it :(', fontSize: 20);
                                                                            }
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                msg: 'Impossible operation: reservation already abolished :(',
                                                                                fontSize: 20);
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'Annulment',
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                      )),
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Container(
                                                                      height:
                                                                          70,
                                                                      width:
                                                                          250,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          border: Border.all(
                                                                              width: 5.0,
                                                                              color: Colors.grey)),
                                                                      child: MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          final splitted =
                                                                              res[index].split('.');
                                                                          String
                                                                              date =
                                                                              splitted[0];
                                                                          DateTime
                                                                              dayEnd =
                                                                              DateFormat("dd/MM/yyyy").parse(date.substring(11));
                                                                          if (dayEnd.compareTo(DateTime.now()) < 0 ||
                                                                              PassMarker.status[index] == 'a') {
                                                                            setState(() {
                                                                              _eliminationMessage(index);
                                                                              PassMarker.status[index] = 'e';
                                                                            });
                                                                            Fluttertoast.showToast(
                                                                                msg: 'This message has been eliminated!',
                                                                                fontSize: 20);
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                msg: 'Impossible operation: you can\'t eliminate this message while the reservation isn\'t finished :(',
                                                                                fontSize: 20);
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'Elimination',
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                      )),
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Container(
                                                                      height:
                                                                          70,
                                                                      width:
                                                                          250,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          border: Border.all(
                                                                              width: 5.0,
                                                                              color: Colors.grey)),
                                                                      child: MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Return',
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                      ))
                                                                ])));
                                          },
                                          child: Text(
                                              _seeReservation(
                                                  index, res[index]),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: _colorReservation(
                                                      index, bookingId))))),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5.0, color: Colors.grey),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.white,
                                                spreadRadius: 6,
                                                blurRadius: 2)
                                          ]))
                                ]));
                      })
            ]))));
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
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(PassMarker.uid[i])
        .collection('cars')
        .doc(PassMarker.cid[i])
        .collection('bookingIn')
        .doc(PassMarker.bookId[i])
        .update({'status': 'e'});
  }

  _annulmentMessage(int i) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(PassMarker.uid[i])
        .collection('cars')
        .doc(PassMarker.cid[i])
        .collection('bookingIn')
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

  _colorReservation(int i, String bookingId) {
    if (PassMarker.bookId[i] == bookingId) {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }
}
