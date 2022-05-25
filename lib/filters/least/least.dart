import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/booking_page.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'calendar.dart';

class Least extends StatefulWidget {
  const Least({Key? key}) : super(key: key);

  @override
  _LeastState createState() => _LeastState();
}

class _LeastState extends State<Least> {
  String dateStart = '';
  String dateEnd = '';
  double? pinPillPosition;
  @override
  void initState() {
    super.initState();
    dateStart = '';
    dateEnd = '';
    pinPillPosition = -220;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Least"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  if (PassMarker.hpOrNot) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context, '');
                  }
                })),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(6),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 250,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(
                  height: 50,
                  child: Text("Choose for how long are you in need.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 20))),
              const SizedBox(height: 40),
              Row(children: [
                Container(
                    width: 110,
                    height: 50,
                    margin: const EdgeInsets.only(
                        top: 10, left: 40, right: 40, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                        onPressed: () async {
                          List<String> blackout = await _fetchDates();
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Calendar(blackout: blackout)))
                              .then((data) {
                            setState(() {
                              dateStart = data[0];
                              dateEnd = data[1];
                            });
                          });
                        },
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(fromString(dateStart),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                Container(
                    width: 110,
                    height: 50,
                    margin: const EdgeInsets.only(
                        top: 10, left: 40, right: 40, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                        onPressed: () async {
                          final List<String> blackout = await _fetchDates();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Calendar(blackout: blackout)));
                        },
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(untilString(dateEnd),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))
              ]),
              const SizedBox(height: 20),
              Container(
                  width: 400,
                  height: 70,
                  margin: const EdgeInsets.only(
                      top: 10, left: 40, right: 40, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 5.0, color: Colors.grey)),
                  child: MaterialButton(
                      onPressed: () async {
                        if (PassMarker.hpOrNot) {
                          if (dateStart == '' && dateEnd == '') {
                            Fluttertoast.showToast(
                                msg: "No date choosen :(", fontSize: 20);
                          } else {
                            Navigator.pop(
                                context,
                                await BookingOut(
                                        PassMarker.carModel.cid,
                                        PassMarker.carModel.uid,
                                        dateStart + '-' + dateEnd)
                                    .book());
                          }
                        } else {
                          if (dateStart == '' && dateEnd == '') {
                            Fluttertoast.showToast(
                                msg: "No date choosen :(", fontSize: 20);
                          } else {
                            Navigator.pop(context, [dateStart, dateEnd]);
                          }
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(_textReserveSave(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold))))
            ])));
  }

  String _textReserveSave() {
    if (PassMarker.hpOrNot) {
      return "Reserve!";
    } else {
      return "Save!";
    }
  }

  String fromString(String from) {
    if (from == '') {
      return "From: ";
    } else {
      return from.substring(0, 5);
    }
  }

  String untilString(String until) {
    if (until == '') {
      return "Until: ";
    } else {
      return until.substring(0, 5);
    }
  }

  Future<List<String>> _fetchDates() async {
    final _auth = FirebaseAuth.instance;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    List<String> dates = [];

    if (user != null) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(PassMarker.carModel.uid)
          .collection('cars')
          .doc(PassMarker.carModel.cid)
          .collection('booking-in')
          .get();

      if (data.docs.isNotEmpty) {
        for (var bookIn in data.docs) {
          if (bookIn.data()['status'] != 'a') {
            dates.add(bookIn.data()['date']);
          }
        }
      }
    }
    return dates;
  }
}
