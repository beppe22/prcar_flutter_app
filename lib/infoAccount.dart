// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/auth/login.dart';

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
                                                await deleteAccount();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()),
                                                    (Route<dynamic> route) =>
                                                        false);
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
}
