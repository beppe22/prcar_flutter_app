// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/booking.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'calendar.dart';

class Least extends StatefulWidget {
  Service service;
  Least({Key? key, required this.service}) : super(key: key);

  @override
  _LeastState createState() => _LeastState();
}

class _LeastState extends State<Least> {
  String dateStart = '';
  String dateEnd = '';
  double? pinPillPosition;
  NetworkCheck networkCheck = NetworkCheck();
  @override
  void initState() {
    super.initState();
    dateStart = '';
    dateEnd = '';
    pinPillPosition = -220;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;

    return PassMarker.useMobileLayout!
        ? Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text("Least", style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () async {
                      if (PassMarker.hpOrNot) {
                        Navigator.pop(context, 'start');
                      } else {
                        Navigator.pop(context, '');
                      }
                    })),
            backgroundColor: Colors.white,
            body: Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.03,
                    screenHeight * 0.005,
                    screenWidth * 0.03,
                    screenHeight * 0.005),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      SizedBox(
                          height: screenHeight * 0.3,
                          child: Image.asset("assets/prcarlogo.png",
                              fit: BoxFit.contain)),
                      SizedBox(
                          height: screenHeight * 0.07,
                          child: Text("Choose for how long are you in need",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: screenText * 20))),
                      SizedBox(height: screenHeight * 0.04),
                      Row(children: [
                        Container(
                            width: screenWidth * 0.35,
                            height: screenHeight * 0.07,
                            margin: EdgeInsets.only(
                                top: screenHeight * 0.02,
                                left: screenWidth * 0.06,
                                right: screenWidth * 0.06,
                                bottom: screenHeight * 0.02),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                                onPressed: () async {
                                  if (await NetworkCheck().check()) {
                                    List<String> blackout = await _fetchDates();
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Calendar(
                                                    blackout: blackout)))
                                        .then((data) {
                                      setState(() {
                                        dateStart = data[0];
                                        dateEnd = data[1];
                                      });
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No internet connection',
                                        fontSize: 20);
                                  }
                                },
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(fromString(dateStart),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: screenText * 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))),
                        Container(
                            width: screenWidth * 0.35,
                            height: screenHeight * 0.07,
                            margin: EdgeInsets.only(
                                top: screenHeight * 0.02,
                                left: screenWidth * 0.06,
                                right: screenWidth * 0.06,
                                bottom: screenHeight * 0.02),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                                onPressed: () async {
                                  if (await NetworkCheck().check()) {
                                    final List<String> blackout =
                                        await _fetchDates();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Calendar(blackout: blackout)));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No internet connection',
                                        fontSize: 20);
                                  }
                                },
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(untilString(dateEnd),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: screenText * 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))))
                      ]),
                      SizedBox(height: screenHeight * 0.035),
                      Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.1,
                          margin: EdgeInsets.only(
                              top: screenHeight * 0.01,
                              left: screenWidth * 0.03,
                              right: screenWidth * 0.03,
                              bottom: screenHeight * 0.01),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: screenWidth * 0.017,
                                  color: Colors.grey)),
                          child: MaterialButton(
                              onPressed: () async {
                                if (await networkCheck.check()) {
                                  if (PassMarker.hpOrNot) {
                                    if (dateStart == '' && dateEnd == '') {
                                      Fluttertoast.showToast(
                                          msg: "No date choosen :(",
                                          fontSize: 20);
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
                                          msg: "No date choosen :(",
                                          fontSize: 20);
                                    } else {
                                      Navigator.pop(
                                          context, [dateStart, dateEnd]);
                                    }
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No internet connection',
                                      fontSize: 20);
                                }
                              },
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(_textReserveSave(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenText * 25,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold))))
                    ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Least",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () async {
                            if (PassMarker.hpOrNot) {
                              Navigator.pop(context, 'start');
                            } else {
                              Navigator.pop(context, '');
                            }
                          })),
                  backgroundColor: Colors.white,
                  body: Padding(
                      padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.03,
                          screenHeight * 0.005,
                          screenWidth * 0.03,
                          screenHeight * 0.005),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.1),
                            SizedBox(
                                height: screenHeight * 0.35,
                                child: Image.asset("assets/prcarlogo.png",
                                    fit: BoxFit.contain)),
                            SizedBox(
                                height: screenHeight * 0.07,
                                child: Text(
                                    "Choose for how long are you in need",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: screenText * 30))),
                            SizedBox(height: screenHeight * 0.04),
                            Row(children: [
                              Container(
                                  width: screenWidth * 0.35,
                                  height: screenHeight * 0.07,
                                  margin: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.06,
                                      right: screenWidth * 0.06,
                                      bottom: screenHeight * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: MaterialButton(
                                      onPressed: () async {
                                        if (await NetworkCheck().check()) {
                                          List<String> blackout =
                                              await _fetchDates();
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Calendar(
                                                              blackout:
                                                                  blackout)))
                                              .then((data) {
                                            setState(() {
                                              dateStart = data[0];
                                              dateEnd = data[1];
                                            });
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(fromString(dateStart),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenText * 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))),
                              Container(
                                  width: screenWidth * 0.35,
                                  height: screenHeight * 0.07,
                                  margin: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.06,
                                      right: screenWidth * 0.06,
                                      bottom: screenHeight * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: MaterialButton(
                                      onPressed: () async {
                                        if (await NetworkCheck().check()) {
                                          final List<String> blackout =
                                              await _fetchDates();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Calendar(
                                                          blackout: blackout)));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(untilString(dateEnd),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenText * 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))))
                            ]),
                            SizedBox(height: screenHeight * 0.035),
                            Container(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.1,
                                margin: EdgeInsets.only(
                                    top: screenHeight * 0.01,
                                    left: screenWidth * 0.03,
                                    right: screenWidth * 0.03,
                                    bottom: screenHeight * 0.01),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: screenWidth * 0.017,
                                        color: Colors.grey)),
                                child: MaterialButton(
                                    onPressed: () async {
                                      if (await networkCheck.check()) {
                                        if (PassMarker.hpOrNot) {
                                          if (dateStart == '' &&
                                              dateEnd == '') {
                                            Fluttertoast.showToast(
                                                msg: "No date choosen :(",
                                                fontSize: 20);
                                          } else {
                                            Navigator.pop(
                                                context,
                                                await BookingOut(
                                                        PassMarker.carModel.cid,
                                                        PassMarker.carModel.uid,
                                                        dateStart +
                                                            '-' +
                                                            dateEnd)
                                                    .book());
                                          }
                                        } else {
                                          if (dateStart == '' &&
                                              dateEnd == '') {
                                            Fluttertoast.showToast(
                                                msg: "No date choosen :(",
                                                fontSize: 20);
                                          } else {
                                            Navigator.pop(
                                                context, [dateStart, dateEnd]);
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'No internet connection',
                                            fontSize: 20);
                                      }
                                    },
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(_textReserveSave(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenText * 35,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold))))
                          ])));
            } else {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Least",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () async {
                            if (PassMarker.hpOrNot) {
                              Navigator.pop(context, 'start');
                            } else {
                              Navigator.pop(context, '');
                            }
                          })),
                  backgroundColor: Colors.white,
                  body: Padding(
                      padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.03,
                          screenHeight * 0.005,
                          screenWidth * 0.03,
                          screenHeight * 0.005),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.1),
                            SizedBox(
                                height: screenHeight * 0.35,
                                child: Image.asset("assets/prcarlogo.png",
                                    fit: BoxFit.contain)),
                            SizedBox(
                                height: screenHeight * 0.07,
                                child: Text(
                                    "Choose for how long are you in need",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: screenText * 30))),
                            SizedBox(height: screenHeight * 0.04),
                            Row(children: [
                              Container(
                                  width: screenWidth * 0.35,
                                  height: screenHeight * 0.1,
                                  margin: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.06,
                                      right: screenWidth * 0.06,
                                      bottom: screenHeight * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: MaterialButton(
                                      onPressed: () async {
                                        if (await NetworkCheck().check()) {
                                          List<String> blackout =
                                              await _fetchDates();
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Calendar(
                                                              blackout:
                                                                  blackout)))
                                              .then((data) {
                                            setState(() {
                                              dateStart = data[0];
                                              dateEnd = data[1];
                                            });
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(fromString(dateStart),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenText * 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))),
                              Container(
                                  width: screenWidth * 0.35,
                                  height: screenHeight * 0.1,
                                  margin: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.06,
                                      right: screenWidth * 0.06,
                                      bottom: screenHeight * 0.02),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: MaterialButton(
                                      onPressed: () async {
                                        if (await NetworkCheck().check()) {
                                          final List<String> blackout =
                                              await _fetchDates();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Calendar(
                                                          blackout: blackout)));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text(untilString(dateEnd),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenText * 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))))
                            ]),
                            SizedBox(height: screenHeight * 0.035),
                            Container(
                                width: screenWidth * 0.6,
                                height: screenHeight * 0.12,
                                margin: EdgeInsets.only(
                                    top: screenHeight * 0.01,
                                    left: screenWidth * 0.03,
                                    right: screenWidth * 0.03,
                                    bottom: screenHeight * 0.01),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: screenWidth * 0.01,
                                        color: Colors.grey)),
                                child: MaterialButton(
                                    onPressed: () async {
                                      if (await networkCheck.check()) {
                                        if (PassMarker.hpOrNot) {
                                          if (dateStart == '' &&
                                              dateEnd == '') {
                                            Fluttertoast.showToast(
                                                msg: "No date choosen :(",
                                                fontSize: 20);
                                          } else {
                                            Navigator.pop(
                                                context,
                                                await BookingOut(
                                                        PassMarker.carModel.cid,
                                                        PassMarker.carModel.uid,
                                                        dateStart +
                                                            '-' +
                                                            dateEnd)
                                                    .book());
                                          }
                                        } else {
                                          if (dateStart == '' &&
                                              dateEnd == '') {
                                            Fluttertoast.showToast(
                                                msg: "No date choosen :(",
                                                fontSize: 20);
                                          } else {
                                            Navigator.pop(
                                                context, [dateStart, dateEnd]);
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'No internet connection',
                                            fontSize: 20);
                                      }
                                    },
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(_textReserveSave(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenText * 35,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold))))
                          ])));
            }
          });
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
