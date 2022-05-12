// ignore_for_file: file_names, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/models/userModel.dart';

class InfoAccount extends StatelessWidget {
  UserModel usermodel;
  InfoAccount(this.usermodel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('PrCar'),
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
                  height: 250,
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
                        Text('Email: ' + usermodel.email.toString(),
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
                        Text('First Name: ' + usermodel.firstName.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
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
                        Text('Second Name: ' + usermodel.secondName.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
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
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    height: 50,
                    width: 175,
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
                                TextStyle(color: Colors.white, fontSize: 34))),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.blueGrey,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ]))
              ])
            ])));
  }
}
