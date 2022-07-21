// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import '../models/static_user.dart';

class InfoAccount extends StatelessWidget {
  const InfoAccount({Key? key}) : super(key: key);

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
                title: Text('Account',
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
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                      height: screenHeight * 0.25,
                      child: Image.asset("assets/prcarlogo.png",
                          fit: BoxFit.contain)),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.9,
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            SizedBox(width: screenWidth * 0.02),
                            Icon(Icons.mail,
                                color: Colors.grey, size: screenText * 25),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        'Email: ' + StaticUser.email.toString(),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: screenText * 22,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white))))
                          ])),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.redAccent,
                                spreadRadius: 4,
                                blurRadius: 2)
                          ])),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.9,
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            SizedBox(width: screenWidth * 0.02),
                            Icon(Icons.account_circle,
                                color: Colors.grey, size: screenText * 25),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        'First Name: ' +
                                            StaticUser.firstName.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: screenText * 22,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white))))
                          ])),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.redAccent,
                                spreadRadius: 4,
                                blurRadius: 2)
                          ])),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.9,
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            SizedBox(width: screenWidth * 0.02),
                            Icon(Icons.account_circle,
                                color: Colors.grey, size: screenText * 25),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        'Second Name: ' +
                                            StaticUser.secondName.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: screenText * 22,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white))))
                          ])),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.redAccent,
                                spreadRadius: 4,
                                blurRadius: 2)
                          ])),
                  SizedBox(height: screenHeight * 0.04),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.7,
                            child: MaterialButton(
                                color: Colors.grey.shade500,
                                onPressed: () async {
                                  if (await NetworkCheck().check()) {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Login(
                                                  loginService: LoginService(),
                                                )),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No internet connection',
                                        fontSize: 20);
                                  }
                                },
                                child: Text("Logout",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenText * 22))),
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.deepPurple,
                                      spreadRadius: 6,
                                      blurRadius: 3)
                                ])),
                        SizedBox(height: screenHeight * 0.04),
                        Container(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.7,
                            child: MaterialButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: Text('!!! Warning !!!',
                                                  style: TextStyle(
                                                      fontSize: screenText * 28,
                                                      color: Colors.redAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                              content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                        'If you press \'Confirm!\' your account will be delete. Do you want to continue?',
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText *
                                                                    20),
                                                        textAlign:
                                                            TextAlign.center)
                                                  ]),
                                              actions: <Widget>[
                                                Row(children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Close',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenText *
                                                                      24))),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.20),
                                                  TextButton(
                                                      onPressed: () async {
                                                        if (await NetworkCheck()
                                                            .check()) {
                                                          int i = 0;
                                                          if (await _fetchAllRes(
                                                                  i) ==
                                                              0) {
                                                            await deleteAccount(
                                                                context);

                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            Login(
                                                                              loginService: LoginService(),
                                                                            )),
                                                                    (Route<dynamic>
                                                                            route) =>
                                                                        false);
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    const InactiveCar());
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'No internet connection',
                                                              fontSize: 20);
                                                        }
                                                      },
                                                      child: Text('Confirm!',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenText *
                                                                      24)))
                                                ])
                                              ]));
                                },
                                child: Text("Delete Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenText * 22))),
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black87,
                                      spreadRadius: 6,
                                      blurRadius: 3)
                                ]))
                      ])
                ])))
        : Container();
  }

  deleteAccount(context) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await user?.delete();
    await firebaseFirestore.collection("tokens").doc(StaticUser.uid).delete();
    await firebaseFirestore
        .collection("users")
        .doc(StaticUser.uid)
        .collection('cars')
        .get()
        .then((snap1) async {
      if (snap1.docs.isNotEmpty) {
        for (var car in snap1.docs) {
          await firebaseFirestore
              .collection('users')
              .doc(StaticUser.uid)
              .collection('cars')
              .doc(car.data()['cid'])
              .collection('booking-in')
              .get()
              .then((snap) async {
            if (snap.docs.isNotEmpty) {
              for (var bookingIn in snap.docs) {
                bookingIn.reference.delete();
              }
            }
          });
          car.reference.delete();
        }
      }
    });

    await firebaseFirestore
        .collection("users")
        .doc(StaticUser.uid)
        .collection('booking-out')
        .get()
        .then((snap) async {
      if (snap.docs.isNotEmpty) {
        for (var bookingOut in snap.docs) {
          bookingOut.reference.delete();
        }
      }
    });
    await firebaseFirestore.collection("users").doc(StaticUser.uid).delete();
  }

  Future<int> _fetchAllRes(int i) async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('booking-out')
          .get();
      if (data.docs.isNotEmpty) {
        for (var bookOut in data.docs) {
          await firebaseFirestore
              .collection('users')
              .doc(bookOut.data()['uidOwner'])
              .collection('cars')
              .doc(bookOut.data()['cid'])
              .get();
          if (bookOut.data()['status'] == 'c') {
            i++;
          }
        }
      }
    }
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
                await firebaseFirestore
                    .collection('users')
                    .doc(book.data()['uidOwner'])
                    .collection('cars')
                    .doc(book.data()['cid'])
                    .get();
                if (book.data()['status'] == 'c') {
                  i++;
                }
              }
            }
          });
        }
      }
    }
    return i;
  }
}

class InactiveCar extends StatelessWidget {
  const InactiveCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
            'You have active reservation! For the moment, click below to switch your cars disabled and then complete or cancel your reservations',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center),
        actions: <Widget>[
          Row(children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close', style: TextStyle(fontSize: 24))),
            const SizedBox(width: 110),
            TextButton(
                onPressed: () async {
                  final _auth = FirebaseAuth.instance;
                  User? user = _auth.currentUser;
                  List<CarModel> cars = await _fetchInfoCar(user!);
                  _suspendOrActiveCar(cars, user);
                  Fluttertoast.showToast(
                      msg: 'All the cars have been disabled!', fontSize: 20);
                  Navigator.of(context).pop();
                },
                child: const Text('Disable', style: TextStyle(fontSize: 24))),
          ])
        ]);
  }

  static Future<List<CarModel>> _fetchInfoCar(User user) async {
    List<CarModel> cars = [];
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get()
          .then((ds) {
        if (ds.docs.isNotEmpty) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "cars not found") {}
    }

    return cars;
  }

  void _suspendOrActiveCar(List<CarModel> cars, User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    for (int i = 0; i < cars.length; i++) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .collection('cars')
            .doc(cars[i].cid)
            .update({'activeOrNot': 'f'});
      } on FirebaseAuthException catch (e) {
        // ignore: avoid_print
        print(
          e.toString(),
        );
      }
    }
  }
}
