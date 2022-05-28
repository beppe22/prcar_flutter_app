import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/auth/signUp.dart';
import 'package:prcarpolimi/forgot_password.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/static_user.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Login function
  UserModel userModel = UserModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool from = true;
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
      return null;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 80),
              const Text("Welcome to PrCar!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50.8,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              SizedBox(
                  height: 175,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(height: 25.0),
              TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "User Email",
                      prefixIcon: const Icon(Icons.mail, color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 26.0),
              TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 25),
              Row(children: [
                GestureDetector(
                    child: const Text('Forgot password?',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.redAccent,
                            fontSize: 20)),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ))),
                const Text(' or ', style: TextStyle(fontSize: 16)),
                GestureDetector(
                    child: const Text("Don't have an account?",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.redAccent,
                            fontSize: 20)),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp())))
              ]),
              const SizedBox(height: 35),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    height: 50,
                    width: 250,
                    child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          PassMarker.driveInserted = await listFiles();
                          if (user != null) {
                            await firebaseFirestore
                                .collection('users')
                                .doc(user.uid)
                                .get()
                                .then((ds) {
                              userModel = UserModel.fromMap(ds);
                              StaticUser.email = userModel.email!;
                              StaticUser.uid = userModel.uid!;
                              StaticUser.firstName = userModel.firstName!;
                              StaticUser.secondName = userModel.secondName!;
                              PassMarker.from = true;
                              _finishReservation(user);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No user found :(', fontSize: 20);
                          }
                        },
                        child: const Text("Login",
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
                        ]))
              ])
            ])));
  }

  Future<bool> listFiles() async {
    int count = 0;
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    firebase_storage.ListResult results =
        await storage.ref('drivingLicenseData/').listAll();
    for (int i = 0; i < results.items.length; i++) {
      String temp = results.items[i].name;
      final splitted = temp.split('.');
      if (splitted[0] == user!.uid) {
        count++;
      }
    }
    if (count == 4) {
      return true;
    } else {
      return false;
    }
  }

  _finishReservation(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var data = await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('booking-out')
        .get();

    if (data.docs.isNotEmpty) {
      for (var bookOut in data.docs) {
        String data = bookOut.data()['date'];
        final splitted = data.split('-');
        String finalDate = splitted[1];
        DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(finalDate);
        if (dayEnd.compareTo(DateTime.now()) < 0) {
          await firebaseFirestore
              .collection('users')
              .doc(user.uid)
              .collection('booking-out')
              .doc(bookOut.data()['bookingId'])
              .update({'status': 'f'});
        }
      }
    }

    var data2 = await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('cars')
        .get();

    if (data2.docs.isNotEmpty) {
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
              String data = book.data()['date'];
              final splitted = data.split('-');
              String finalDate = splitted[1];
              DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(finalDate);
              if (dayEnd.compareTo(DateTime.now()) < 0) {
                await firebaseFirestore
                    .collection('users')
                    .doc(user.uid)
                    .collection('cars')
                    .doc(book.data()['cid'])
                    .collection('booking-in')
                    .doc(book.data()['bookingId'])
                    .update({'status': 'f'});
              }
            }
          }
        });
      }
    }
  }
}
