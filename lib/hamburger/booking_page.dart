// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import '../booking/booking_in.dart';
import 'package:intl/intl.dart';
import '../booking/booking_out.dart';

class MessagePage extends StatefulWidget {
  Service service;
  MessagePage({Key? key, required this.service}) : super(key: key);

  @override
  State<MessagePage> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  MessagePageState({Key? key});

  String messaggio = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
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
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              Container(
                  key: Key("Other reservation button"),
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      border: Border.all(width: 5.0, color: Colors.grey)),
                  child: (MaterialButton(
                      onPressed: () async {
                        if (await NetworkCheck().check()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );
                          List<String> res = await _fetchOtherRes();
                          String bookingId = '';
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingInPage(
                                      bookingId: bookingId,
                                      res: res,
                                      fromHp: false,
                                      service: Service())));
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'No internet connection', fontSize: 20);
                        }
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
                  key: Key("here for your reservation"),
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      border: Border.all(width: 5.0, color: Colors.grey)),
                  child: (MaterialButton(
                      onPressed: () async {
                        if (await NetworkCheck().check()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );

                          List<String> res = await _fetchMyRes();

                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingOutPage(
                                      res: res, service: Service())));
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'No internet connection', fontSize: 20);
                        }
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
            ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('All Booking',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: Center(
                      child: Column(children: [
                    SizedBox(height: screenHeight * 0.1),
                    SizedBox(
                        height: screenHeight * 0.35,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                    Container(
                        key: Key("Other reservation button tablet"),
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.85,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            border: Border.all(width: 5.0, color: Colors.grey)),
                        child: (MaterialButton(
                            onPressed: () async {
                              if (await NetworkCheck().check()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                );
                                List<String> res = await _fetchOtherRes();
                                String bookingId = '';
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingInPage(
                                            bookingId: bookingId,
                                            res: res,
                                            fromHp: false,
                                            service: Service())));
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'No internet connection',
                                    fontSize: 20);
                              }
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
                                    fontSize: screenText * 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))))),
                    SizedBox(height: screenHeight * 0.06),
                    Container(
                        key: Key("here for your reservation tablet"),
                        height: screenHeight * 0.12,
                        width: screenWidth * 0.85,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            border: Border.all(width: 5.0, color: Colors.grey)),
                        child: (MaterialButton(
                            onPressed: () async {
                              if (await NetworkCheck().check()) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                );
                                List<String> res = await _fetchMyRes();
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingOutPage(
                                            res: res, service: Service())));
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'No internet connection',
                                    fontSize: 20);
                              }
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
                                    fontSize: screenText * 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))))
                  ])));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('All Booking',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: Center(
                      child: Row(children: [
                    SizedBox(
                        height: screenHeight * 0.5,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                    Column(children: [
                      SizedBox(height: screenHeight * 0.25),
                      Container(
                          key: Key("Other reservation button tablet2"),
                          height: screenHeight * 0.18,
                          width: screenWidth * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              border:
                                  Border.all(width: 5.0, color: Colors.grey)),
                          child: (MaterialButton(
                              onPressed: () async {
                                if (await NetworkCheck().check()) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                  List<String> res = await _fetchOtherRes();
                                  String bookingId = '';
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingInPage(
                                              bookingId: bookingId,
                                              res: res,
                                              fromHp: false,
                                              service: Service())));
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No internet connection',
                                      fontSize: 20);
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text("Here for others reservations!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenText * 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))))),
                      SizedBox(height: screenHeight * 0.06),
                      Container(
                          key: Key("here for your reservation tablet2"),
                          height: screenHeight * 0.18,
                          width: screenWidth * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              border:
                                  Border.all(width: 5.0, color: Colors.grey)),
                          child: (MaterialButton(
                              onPressed: () async {
                                if (await NetworkCheck().check()) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                  List<String> res = await _fetchMyRes();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingOutPage(
                                              res: res, service: Service())));
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No internet connection',
                                      fontSize: 20);
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text("Here for your reservations!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenText * 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))))
                    ])
                  ])));
            }
          });
  }

//Function that retrieves all booking-out
  Future<List<String>> _fetchMyRes() async {
    User? user = widget.service.currentUser();
    List<String> myRes = [];
    PassMarker.uidFriend = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await widget.service
          .firebasefirestore()
          .collection('users')
          .doc(user.uid)
          .collection('booking-out')
          .get();

      if (data.docs.isNotEmpty) {
        for (var bookOut in data.docs) {
          String insert = bookOut.data()['date'];
          final splitted = insert.split('-');
          DateTime dayEnd =
              DateFormat("dd/MM/yyyy").parse(splitted[1].substring(0, 10));
          if (dayEnd.compareTo(DateTime.now()) < 0) {
            await widget.service
                .firebasefirestore()
                .collection('users')
                .doc(user.uid)
                .collection('booking-out')
                .doc(bookOut.id)
                .update({'status': 'f'});
          }
          var data1 = await widget.service
              .firebasefirestore()
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

//Function that retrieves all booking-in
  Future<List<String>> _fetchOtherRes() async {
    User? user = widget.service.currentUser();
    List<String> otherRes = [];
    PassMarker.uidFriend = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await widget.service
          .firebasefirestore()
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get();
      if (data.docs.isNotEmpty) {
        for (var car in data.docs) {
          await widget.service
              .firebasefirestore()
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
                final splitted = insert.split('-');
                DateTime dayEnd = DateFormat("dd/MM/yyyy")
                    .parse(splitted[1].substring(0, 10));
                if (dayEnd.compareTo(DateTime.now()) < 0) {
                  await widget.service
                      .firebasefirestore()
                      .collection('users')
                      .doc(user.uid)
                      .collection('cars')
                      .doc(car.data()['cid'])
                      .collection('booking-in')
                      .doc(book.id)
                      .update({'status': 'f'});
                }
                var data1 = await widget.service
                    .firebasefirestore()
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
