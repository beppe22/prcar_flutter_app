// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'models/static_user.dart';

class InfoAccount extends StatelessWidget {
  const InfoAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Account'),
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
              const SizedBox(height: 25),
              SizedBox(
                  height: 200,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(height: 30),
              Container(
                  height: 50,
                  width: 350,
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.mail, color: Colors.grey),
                        const SizedBox(width: 20),
                        Text('Email: ' + StaticUser.email.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white))
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
              const SizedBox(height: 30),
              Container(
                  height: 40,
                  width: 320,
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.account_circle, color: Colors.grey),
                        const SizedBox(width: 20),
                        Text('First Name: ' + StaticUser.firstName.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white))
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
              const SizedBox(height: 30),
              Container(
                  height: 40,
                  width: 320,
                  child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.account_circle, color: Colors.grey),
                        const SizedBox(width: 20),
                        Text('Second Name: ' + StaticUser.secondName.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white))
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
              const SizedBox(height: 30),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    height: 50,
                    width: 250,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () async {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text("Logout",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25))),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurple,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ])),
                const SizedBox(height: 40),
                Container(
                    height: 50,
                    width: 250,
                    child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('!!! Warning !!!',
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const <Widget>[
                                            Text(
                                                'If you press \'Confirm!\' your account will be deleted. Do you want to continue?',
                                                style: TextStyle(fontSize: 20),
                                                textAlign: TextAlign.center)
                                          ]),
                                      actions: <Widget>[
                                        Row(children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close',
                                                  style:
                                                      TextStyle(fontSize: 24))),
                                          const SizedBox(width: 110),
                                          TextButton(
                                              onPressed: () async {
                                                int i = 0;
                                                if (await _fetchAllRes(i) ==
                                                    0) {
                                                  await deleteAccount();
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Login()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          const InactiveCar());
                                                }
                                              },
                                              child: const Text('Confirm!',
                                                  style:
                                                      TextStyle(fontSize: 24)))
                                        ])
                                      ]));
                        },
                        child: const Text("Delete Account",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25))),
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
            ])));
  }

  deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await user?.delete();
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
