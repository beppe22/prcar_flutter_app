// ignore_for_file: must_be_immutable, no_logic_in_create_state
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/services/services.dart';
import '../chatImplementation/chatDetail.dart';

class BookingOutPage extends StatefulWidget {
  List<String> res;
  Service service;
  BookingOutPage({Key? key, required this.res, required this.service})
      : super(key: key);

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
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: Text('Booking-Out',
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  (res.isEmpty)
                      ? Column(children: [
                          SizedBox(height: screenHeight * 0.05),
                          Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.9,
                              child: Text('No booking-out yet :(',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: screenText * 24,
                                      fontWeight: FontWeight.bold)),
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02,
                                  screenHeight * 0.02,
                                  screenWidth * 0.02,
                                  screenHeight * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 5.0, color: Colors.redAccent),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 6,
                                        blurRadius: 2)
                                  ]))
                        ])
                      : Expanded(
                          child: (ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: res == [] ? 0 : res.length,
                              itemBuilder: (context, index) {
                                if (PassMarker.status[index] != 'e') {
                                  return Container(
                                      key: Key("click booking-out"),
                                      padding:
                                          EdgeInsets.all(screenHeight * 0.008),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: screenHeight * 0.01),
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
                                                                              fontSize: screenText *
                                                                                  25,
                                                                              fontWeight: FontWeight
                                                                                  .bold),
                                                                          textAlign: TextAlign
                                                                              .center),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15)),
                                                                      content: Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            SizedBox(height: screenHeight * 0.03),
                                                                            Container(
                                                                                key: (Key("Chat button")),
                                                                                height: screenHeight * 0.09,
                                                                                width: screenWidth * 0.7,
                                                                                decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                                child: MaterialButton(
                                                                                  onPressed: () async {
                                                                                    if (await NetworkCheck().check()) {
                                                                                      String nameFriend = (UserModel.fromMap(await widget.service.firebasefirestore().collection('users').doc(PassMarker.uidFriend[index]).get())).firstName!;
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(friendName: nameFriend, friendUid: PassMarker.uidFriend[index], hp: false)));
                                                                                    } else {
                                                                                      Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                    }
                                                                                  },
                                                                                  child: Text('Chat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 20, color: Colors.black)),
                                                                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                                )),
                                                                            SizedBox(height: screenHeight * 0.03),
                                                                            Container(
                                                                                height: screenHeight * 0.09,
                                                                                width: screenWidth * 0.7,
                                                                                decoration: BoxDecoration(color: _colorAnulment(index), border: Border.all(width: 5.0, color: Colors.grey)),
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
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) => AlertDialog(title: Text('Are you sure?', style: TextStyle(fontSize: screenText * 28, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center), actions: <Widget>[
                                                                                                  Row(children: [
                                                                                                    TextButton(
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                        child: Text('Close', style: TextStyle(fontSize: screenText * 24))),
                                                                                                    SizedBox(width: screenWidth * 0.32),
                                                                                                    TextButton(
                                                                                                        onPressed: () async {
                                                                                                          if (await NetworkCheck().check()) {
                                                                                                            setState(() {
                                                                                                              _annulmentMessage(index);
                                                                                                              PassMarker.status[index] = 'a';
                                                                                                            });
                                                                                                            Navigator.of(context).pop();
                                                                                                            Fluttertoast.showToast(msg: 'Reservation annullated!', fontSize: 20);
                                                                                                          } else {
                                                                                                            Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                                          }
                                                                                                        },
                                                                                                        child: Text('Yes!', style: TextStyle(fontSize: screenText * 24)))
                                                                                                  ])
                                                                                                ]));
                                                                                      } else {
                                                                                        if (PassMarker.status[index] != 'f') {
                                                                                          Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: you can\'t cancel the reservation 3 days before it :(', fontSize: 20);
                                                                                        } else {
                                                                                          Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: reservation already finished', fontSize: 20);
                                                                                        }
                                                                                      }
                                                                                    } else {
                                                                                      {
                                                                                        Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: reservation already abolished :(', fontSize: 20);
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: Text('Annulment', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 20, color: Colors.black)),
                                                                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                                )),
                                                                            SizedBox(height: screenHeight * 0.03),
                                                                            Container(
                                                                                height: screenHeight * 0.09,
                                                                                width: screenWidth * 0.7,
                                                                                decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                                child: MaterialButton(
                                                                                  onPressed: () async {
                                                                                    if (await NetworkCheck().check()) {
                                                                                      Navigator.pop(context);
                                                                                      final splitted = res[index].split('.');
                                                                                      String date = splitted[0];
                                                                                      DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(date.substring(11));
                                                                                      if (dayEnd.compareTo(DateTime.now()) < 0 || PassMarker.status[index] == 'a') {
                                                                                        setState(() {
                                                                                          _eliminationMessage(index);
                                                                                          PassMarker.status[index] = 'e';
                                                                                        });
                                                                                        Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'This message has been eliminated!', fontSize: 20);
                                                                                      } else {
                                                                                        Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: you can\'t eliminate this message while the reservation isn\'t finished :(', fontSize: 20);
                                                                                      }
                                                                                    } else {
                                                                                      Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                    }
                                                                                  },
                                                                                  child: Text('Elimination', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 20, color: Colors.black)),
                                                                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                                ))
                                                                          ])));
                                                    },
                                                    child: Text(
                                                        _seeReservation(
                                                            index, res[index]),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenText * 18,
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
                              })))
                ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('Booking-Out',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        (res.isEmpty)
                            ? Column(children: [
                                SizedBox(height: screenHeight * 0.05),
                                Container(
                                    height: screenHeight * 0.1,
                                    width: screenWidth * 0.9,
                                    child: Text('No booking-out yet :(',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 38,
                                            fontWeight: FontWeight.bold)),
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.02,
                                        screenHeight * 0.032,
                                        screenWidth * 0.02,
                                        screenHeight * 0.02),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            width: 5.0,
                                            color: Colors.redAccent),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              spreadRadius: 6,
                                              blurRadius: 2)
                                        ]))
                              ])
                            : Expanded(
                                child: (ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: res == [] ? 0 : res.length,
                                    itemBuilder: (context, index) {
                                      if (PassMarker.status[index] != 'e') {
                                        return Container(
                                          key: Key("click booking-out tablet"),
                                            padding: EdgeInsets.all(
                                                screenHeight * 0.008),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.01),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.2,
                                                      width: screenWidth * 0.7,
                                                      padding: EdgeInsets.fromLTRB(
                                                          screenWidth * 0.008,
                                                          screenHeight * 0.008,
                                                          screenWidth * 0.008,
                                                          screenHeight * 0.008),
                                                      child: (MaterialButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                        title: Text(
                                                                            'What do you want to do?',
                                                                            style: TextStyle(
                                                                                color: Colors.redAccent,
                                                                                fontSize: screenText * 35,
                                                                                fontWeight: FontWeight.bold),
                                                                            textAlign: TextAlign.center),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                            key: (Key("Chat button tablet")),
                                                                              height: screenHeight * 0.09,
                                                                              width: screenWidth * 0.5,
                                                                              decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                              child: MaterialButton(
                                                                                onPressed: () async {
                                                                                  if (await NetworkCheck().check()) {
                                                                                    String nameFriend = (UserModel.fromMap(await widget.service.firebasefirestore().collection('users').doc(PassMarker.uidFriend[index]).get())).firstName!;
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(friendName: nameFriend, friendUid: PassMarker.uidFriend[index], hp: false)));
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                  }
                                                                                },
                                                                                child: Text('Chat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              )),
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                              height: screenHeight * 0.09,
                                                                              width: screenWidth * 0.5,
                                                                              decoration: BoxDecoration(color: _colorAnulment(index), border: Border.all(width: 5.0, color: Colors.grey)),
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
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) => AlertDialog(title: Text('Are you sure?', style: TextStyle(fontSize: screenText * 38, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center), actions: <Widget>[
                                                                                                Row(children: [
                                                                                                  TextButton(
                                                                                                      onPressed: () {
                                                                                                        Navigator.of(context).pop();
                                                                                                      },
                                                                                                      child: Text('Close', style: TextStyle(color: Colors.redAccent, fontSize: screenText * 34))),
                                                                                                  SizedBox(width: screenWidth * 0.32),
                                                                                                  TextButton(
                                                                                                      onPressed: () async {
                                                                                                        if (await NetworkCheck().check()) {
                                                                                                          setState(() {
                                                                                                            _annulmentMessage(index);
                                                                                                            PassMarker.status[index] = 'a';
                                                                                                          });
                                                                                                          Navigator.of(context).pop();
                                                                                                          Fluttertoast.showToast(msg: 'Reservation annullated!', fontSize: 20);
                                                                                                        } else {
                                                                                                          Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                                        }
                                                                                                      },
                                                                                                      child: Text('Yes!', style: TextStyle(color: Colors.redAccent, fontSize: screenText * 34)))
                                                                                                ])
                                                                                              ]));
                                                                                    } else {
                                                                                      if (PassMarker.status[index] != 'f') {
                                                                                        Fluttertoast.showToast(msg: 'Impossible operation: you can\'t cancel the reservation 3 days before it :(', fontSize: 20);
                                                                                      } else {
                                                                                        Fluttertoast.showToast(msg: 'Impossible operation: reservation already finished', fontSize: 20);
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    {
                                                                                      Fluttertoast.showToast(msg: 'Impossible operation: reservation already abolished :(', fontSize: 20);
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text('Annulment', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              )),
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                              height: screenHeight * 0.09,
                                                                              width: screenWidth * 0.5,
                                                                              decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                              child: MaterialButton(
                                                                                onPressed: () async {
                                                                                  if (await NetworkCheck().check()) {
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
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                  }
                                                                                },
                                                                                child: Text('Elimination', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              ))
                                                                        ])));
                                                          },
                                                          child: Text(_seeReservation(index, res[index]),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenText *
                                                                          32,
                                                                  color: Colors
                                                                      .redAccent)))),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 5.0,
                                                              color: Colors.grey),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .white,
                                                                spreadRadius: 6,
                                                                blurRadius: 2)
                                                          ]))
                                                ]));
                                      }
                                      return const SizedBox(height: 1);
                                    })))
                      ])));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('Booking-Out',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        (res.isEmpty)
                            ? Column(children: [
                                SizedBox(height: screenHeight * 0.1),
                                Container(
                                    height: screenHeight * 0.15,
                                    width: screenWidth * 0.8,
                                    child: Text('No booking-out yet :(',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 38,
                                            fontWeight: FontWeight.bold)),
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.02,
                                        screenHeight * 0.032,
                                        screenWidth * 0.02,
                                        screenHeight * 0.02),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            width: 5.0,
                                            color: Colors.redAccent),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              spreadRadius: 6,
                                              blurRadius: 2)
                                        ]))
                              ])
                            : Expanded(
                                child: (ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: res == [] ? 0 : res.length,
                                    itemBuilder: (context, index) {
                                      if (PassMarker.status[index] != 'e') {
                                        return Container(
                                          key: Key("click booking-out tablet2"),
                                            padding: EdgeInsets.all(
                                                screenHeight * 0.008),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.01),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.2,
                                                      width: screenWidth * 0.6,
                                                      padding: EdgeInsets.fromLTRB(
                                                          screenWidth * 0.008,
                                                          screenHeight * 0.008,
                                                          screenWidth * 0.008,
                                                          screenHeight * 0.008),
                                                      child: (MaterialButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                        title: Text(
                                                                            'What do you want to do?',
                                                                            style: TextStyle(
                                                                                color: Colors.redAccent,
                                                                                fontSize: screenText * 35,
                                                                                fontWeight: FontWeight.bold),
                                                                            textAlign: TextAlign.center),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                            key: (Key("Chat button tablet2")),
                                                                              height: screenHeight * 0.12,
                                                                              width: screenWidth * 0.35,
                                                                              decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                              child: MaterialButton(
                                                                                onPressed: () async {
                                                                                  if (await NetworkCheck().check()) {
                                                                                    String nameFriend = (UserModel.fromMap(await widget.service.firebasefirestore().collection('users').doc(PassMarker.uidFriend[index]).get())).firstName!;
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetail(friendName: nameFriend, friendUid: PassMarker.uidFriend[index], hp: false)));
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                  }
                                                                                },
                                                                                child: Text('Chat', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              )),
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                              height: screenHeight * 0.12,
                                                                              width: screenWidth * 0.35,
                                                                              decoration: BoxDecoration(color: _colorAnulment(index), border: Border.all(width: 5.0, color: Colors.grey)),
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
                                                                                      showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) => AlertDialog(title: Text('Are you sure?', style: TextStyle(fontSize: screenText * 38, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center), actions: <Widget>[
                                                                                                Row(children: [
                                                                                                  TextButton(
                                                                                                      onPressed: () {
                                                                                                        Navigator.of(context).pop();
                                                                                                      },
                                                                                                      child: Text('Close', style: TextStyle(color: Colors.redAccent, fontSize: screenText * 34))),
                                                                                                  SizedBox(width: screenWidth * 0.32),
                                                                                                  TextButton(
                                                                                                      onPressed: () async {
                                                                                                        if (await NetworkCheck().check()) {
                                                                                                          setState(() {
                                                                                                            _annulmentMessage(index);
                                                                                                            PassMarker.status[index] = 'a';
                                                                                                          });
                                                                                                          Navigator.of(context).pop();
                                                                                                          Fluttertoast.showToast(msg: 'Reservation annullated!', fontSize: 20);
                                                                                                        } else {
                                                                                                          Fluttertoast.showToast(msg: 'No internet connection', fontSize: 20);
                                                                                                        }
                                                                                                      },
                                                                                                      child: Text('Yes!', style: TextStyle(color: Colors.redAccent, fontSize: screenText * 34)))
                                                                                                ])
                                                                                              ]));
                                                                                    } else {
                                                                                      if (PassMarker.status[index] != 'f') {
                                                                                        Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: you can\'t cancel the reservation 3 days before it :(', fontSize: 20);
                                                                                      } else {
                                                                                        Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: reservation already finished', fontSize: 20);
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    {
                                                                                      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: reservation already abolished :(', fontSize: 20);
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text('Annulment', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              )),
                                                                          SizedBox(
                                                                              height: screenHeight * 0.03),
                                                                          Container(
                                                                              height: screenHeight * 0.12,
                                                                              width: screenWidth * 0.35,
                                                                              decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(width: 5.0, color: Colors.grey)),
                                                                              child: MaterialButton(
                                                                                onPressed: () async {
                                                                                  if (await NetworkCheck().check()) {
                                                                                    Navigator.pop(context);
                                                                                    final splitted = res[index].split('.');
                                                                                    String date = splitted[0];
                                                                                    DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(date.substring(11));
                                                                                    if (dayEnd.compareTo(DateTime.now()) < 0 || PassMarker.status[index] == 'a') {
                                                                                      setState(() {
                                                                                        _eliminationMessage(index);
                                                                                        PassMarker.status[index] = 'e';
                                                                                      });
                                                                                      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'This message has been eliminated!', fontSize: 20);
                                                                                    } else {
                                                                                      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Impossible operation: you can\'t eliminate this message while the reservation isn\'t finished :(', fontSize: 20);
                                                                                    }
                                                                                  } else {
                                                                                    Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'No internet connection', fontSize: 20);
                                                                                  }
                                                                                },
                                                                                child: Text('Elimination', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenText * 30, color: Colors.black)),
                                                                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                              ))
                                                                        ])));
                                                          },
                                                          child: Text(_seeReservation(index, res[index]),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenText *
                                                                          32,
                                                                  color: Colors
                                                                      .redAccent)))),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 5.0,
                                                              color: Colors.grey),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .white,
                                                                spreadRadius: 6,
                                                                blurRadius: 2)
                                                          ]))
                                                ]));
                                      }
                                      return const SizedBox(height: 1);
                                    })))
                      ])));
            }
          });
  }

//Function that prints all the reservations
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
        dayEnd.compareTo(DateTime.now()) >= 0) {
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

//Function that eliminates a reservation
  _eliminationMessage(int i) async {
    User? user = widget.service.currentUser();
    await widget.service
        .firebasefirestore()
        .collection('users')
        .doc(user!.uid)
        .collection('booking-out')
        .doc(PassMarker.bookId[i])
        .update({'status': 'e'});
  }

//Function that annulates a reservation
  _annulmentMessage(int i) async {
    User? user = widget.service.currentUser();
    await widget.service
        .firebasefirestore()
        .collection('users')
        .doc(user!.uid)
        .collection('booking-out')
        .doc(PassMarker.bookId[i])
        .update({'status': 'a'});
  }

//Function that changes annulment's color
  _colorAnulment(int i) {
    if (PassMarker.status[i] == 'a' || PassMarker.status[i] == 'f') {
      if (PassMarker.useMobileLayout!) {
        return Colors.red.shade100;
      } else {
        return Colors.redAccent.shade100;
      }
    } else {
      if (PassMarker.useMobileLayout!) {
        return Colors.redAccent;
      } else {
        return Colors.redAccent;
      }
    }
  }
}
