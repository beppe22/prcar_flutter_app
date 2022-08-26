import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/auth/signUp.dart';
import 'package:prcarpolimi/auth/forgot_password.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:prcarpolimi/services/services.dart';
import '../models/static_user.dart';
import 'package:intl/intl.dart';

class Login2 extends StatefulWidget {
  final Service loginService;

  const Login2({Key? key, required this.loginService}) : super(key: key);

  @override
  State<Login2> createState() => _LoginState2();
}

class _LoginState2 extends State<Login2> {
  UserModel userModel = UserModel();
  static final _emailController2 = TextEditingController();
  static final _passwordController2 = TextEditingController();
  static final _newKey = GlobalKey<FormState>();
  static final _newKey2 = GlobalKey<FormState>();
  bool from = true;

  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;

    try {
      user = await widget.loginService.signInWithemailandpass(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
      Fluttertoast.showToast(
          msg: 'Login failed :( wrong email or password', fontSize: 20);
      return null;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    return user;
  }

  sizeHintText() {
    if (PassMarker.useMobileLayout!) {
      return 20.0;
    } else {
      return 30.0;
    }
  }

  _finishReservation(User user) async {
    var data = await widget.loginService
        .firebasefirestore()
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
          await widget.loginService
              .firebasefirestore()
              .collection('users')
              .doc(user.uid)
              .collection('booking-out')
              .doc(bookOut.data()['bookingId'])
              .update({'status': 'f'});
        }
      }
    }

    var data2 = await widget.loginService
        .firebasefirestore()
        .collection('users')
        .doc(user.uid)
        .collection('cars')
        .get();

    if (data2.docs.isNotEmpty) {
      for (var car in data.docs) {
        await widget.loginService
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
              String data = book.data()['date'];
              final splitted = data.split('-');
              String finalDate = splitted[1];
              DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(finalDate);
              if (dayEnd.compareTo(DateTime.now()) < 0) {
                await widget.loginService
                    .firebasefirestore()
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;

    final emailField = TextFormField(
        key: const ValueKey(3),
        autofocus: false,
        style: TextStyle(fontSize: sizeHintText()),
        controller: _emailController2,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail, size: sizeHintText()),
            hintText: "Email",
            hintStyle: TextStyle(fontSize: sizeHintText()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final passwordField = TextFormField(
        key: const ValueKey(4),
        autofocus: false,
        style: TextStyle(fontSize: sizeHintText()),
        controller: _passwordController2,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key, size: sizeHintText()),
            hintText: "Password",
            hintStyle: TextStyle(fontSize: sizeHintText()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    return OrientationBuilder(builder: (_, orientation) {
      if (orientation == Orientation.portrait) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Form(
                    key: _newKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.1),
                          Text("Welcome to PrCar!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenText * 55,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: screenHeight * 0.05),
                          SizedBox(
                              height: screenHeight * 0.35,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.05),
                          emailField,
                          SizedBox(height: screenHeight * 0.02),
                          passwordField,
                          SizedBox(height: screenHeight * 0.05),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    child: Text('Forgot password?',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.redAccent,
                                            fontSize: screenText * 30)),
                                    onTap: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordPage(),
                                        ))),
                                Text(' or ',
                                    style: TextStyle(
                                        fontSize: screenText * 25,
                                        fontWeight: FontWeight.bold)),
                                GestureDetector(
                                    key: Key("New Account2"),
                                    child: Text("Don't have an account?",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.redAccent,
                                            fontSize: screenText * 30)),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp())))
                              ]),
                          SizedBox(height: screenHeight * 0.06),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    key: const Key("clickButtom2"),
                                    height: screenHeight * 0.07,
                                    width: screenWidth * 0.85,
                                    child: MaterialButton(
                                        color: Colors.redAccent,
                                        onPressed: () async {
                                          if (await NetworkCheck().check()) {
                                            User? user =
                                                await loginUsingEmailPassword(
                                                    email:
                                                        _emailController2.text,
                                                    password:
                                                        _passwordController2
                                                            .text,
                                                    context: context);

                                            if (user != null) {
                                              await widget.loginService
                                                  .firebasefirestore()
                                                  .collection('users')
                                                  .doc(user.uid)
                                                  .get()
                                                  .then((ds) {
                                                userModel =
                                                    UserModel.fromMap(ds);
                                                StaticUser.email =
                                                    userModel.email!;
                                                StaticUser.uid = userModel.uid!;
                                                StaticUser.firstName =
                                                    userModel.firstName!;
                                                StaticUser.secondName =
                                                    userModel.secondName!;
                                                PassMarker.from = true;
                                                _finishReservation(user);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage(
                                                                homePageService:
                                                                    Service())));
                                              });
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: 'No internet connection',
                                                fontSize: 20);
                                          }
                                        },
                                        child: Text("Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: screenText * 35))),
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
                        ]))));
      } else {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Form(
                    key: _newKey2,
                    child: Row(children: [
                      SizedBox(width: screenWidth * 0.06),
                      Column(children: [
                        SizedBox(height: screenHeight * 0.1),
                        Text("Welcome to \n PrCar!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenText * 65,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                            height: screenHeight * 0.5,
                            child: Image.asset("assets/prcarlogo.png",
                                fit: BoxFit.contain)),
                        SizedBox(height: screenHeight * 0.05),
                      ]),
                      SizedBox(width: screenWidth * 0.08),
                      Column(children: [
                        SizedBox(height: screenHeight * 0.2),
                        Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.5,
                            child: emailField),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.5,
                            child: passwordField),
                        SizedBox(height: screenHeight * 0.05),
                        Row(children: [
                          GestureDetector(
                              child: Text('Forgot password?',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.redAccent,
                                      fontSize: screenText * 32)),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage()))),
                          Text(' or ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenText * 26)),
                          GestureDetector(
                              child: Text("Don't have an account?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.redAccent,
                                      fontSize: screenText * 32)),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp())))
                        ]),
                        SizedBox(height: screenHeight * 0.06),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth * 0.4,
                                  child: MaterialButton(
                                      color: Colors.redAccent,
                                      onPressed: () async {
                                        if (await NetworkCheck().check()) {
                                          User? user =
                                              await loginUsingEmailPassword(
                                                  email: _emailController2.text,
                                                  password:
                                                      _passwordController2.text,
                                                  context: context);
                                          /* User? user =
                                              await loginUsingEmailPassword(
                                                  email:
                                                      'marinvargasf@gmail.com',
                                                  password: 'vargas22',
                                                  context: context);*/
                                          if (user != null) {
                                            await widget.loginService
                                                .firebasefirestore()
                                                .collection('users')
                                                .doc(user.uid)
                                                .get()
                                                .then((ds) {
                                              userModel = UserModel.fromMap(ds);
                                              StaticUser.email =
                                                  userModel.email!;
                                              StaticUser.uid = userModel.uid!;
                                              StaticUser.firstName =
                                                  userModel.firstName!;
                                              StaticUser.secondName =
                                                  userModel.secondName!;
                                              PassMarker.from = true;
                                              _finishReservation(user);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                              homePageService:
                                                                  Service())));
                                            });
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      child: Text("Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenText * 40))),
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
                      ])
                    ]))));
      }
    });
  }
}
