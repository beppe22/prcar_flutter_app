// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                title: Text('Reset Password',
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  SizedBox(height: screenHeight * 0.08),
                  Text('Receive an email to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                      height: screenHeight * 0.32,
                      child: Image.asset("assets/prcarlogo.png",
                          fit: BoxFit.contain)),
                  SizedBox(height: screenHeight * 0.05),
                  TextFormField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.mail,
                              color: Colors.black, size: screenText * 25),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null),
                  SizedBox(height: screenHeight * 0.05),
                  Container(
                      child: MaterialButton(
                          height: screenHeight * 0.08,
                          minWidth: screenWidth * 0.85,
                          elevation: 6,
                          color: Colors.grey.shade200,
                          child: Text("Reset Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: screenText * 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            if (await NetworkCheck().check()) {
                              resetPassword();
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'No internet connection', fontSize: 20);
                            }
                          }),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 6,
                                blurRadius: 3)
                          ]))
                ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('Reset Password',
                          style: TextStyle(fontSize: screenText * 28)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 30),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: screenHeight * 0.08),
                            Text('Receive an email to reset \n your password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: screenText * 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            SizedBox(height: screenHeight * 0.05),
                            SizedBox(
                                height: screenHeight * 0.35,
                                child: Image.asset("assets/prcarlogo.png",
                                    fit: BoxFit.contain)),
                            SizedBox(height: screenHeight * 0.05),
                            TextFormField(
                                style: TextStyle(fontSize: screenText * 25),
                                controller: emailController,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    errorStyle: TextStyle(
                                      fontSize: screenText * 25,
                                    ),
                                    hintStyle:
                                        TextStyle(fontSize: screenText * 28),
                                    prefixIcon: Icon(Icons.mail,
                                        color: Colors.black,
                                        size: screenText * 35),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null),
                            SizedBox(height: screenHeight * 0.05),
                            Container(
                                child: MaterialButton(
                                    height: screenHeight * 0.08,
                                    minWidth: screenWidth * 0.85,
                                    elevation: 6,
                                    color: Colors.grey.shade200,
                                    child: Text("Reset Password",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenText * 40,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () async {
                                      if (await NetworkCheck().check()) {
                                        resetPassword();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'No internet connection',
                                            fontSize: 20);
                                      }
                                    }),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 6,
                                          blurRadius: 3)
                                    ]))
                          ])));
            } else {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text('Reset Password',
                          style: TextStyle(fontSize: screenText * 28)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 30),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white,
                  body: Center(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                        Text('Receive an email to reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: screenText * 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                            height: screenHeight * 0.35,
                            child: Image.asset("assets/prcarlogo.png",
                                fit: BoxFit.contain)),
                        Container(
                            width: screenWidth * 0.6,
                            child: TextFormField(
                                style: TextStyle(fontSize: screenText * 25),
                                controller: emailController,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    errorStyle: TextStyle(
                                      fontSize: screenText * 25,
                                    ),
                                    hintStyle:
                                        TextStyle(fontSize: screenText * 28),
                                    prefixIcon: Icon(Icons.mail,
                                        color: Colors.black,
                                        size: screenText * 35),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? 'Enter a valid email'
                                    : null)),
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                            child: MaterialButton(
                                height: screenHeight * 0.12,
                                minWidth: screenWidth * 0.5,
                                elevation: 6,
                                color: Colors.grey.shade200,
                                child: Text("Reset Password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: screenText * 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {
                                  if (await NetworkCheck().check()) {
                                    resetPassword();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No internet connection',
                                        fontSize: 20);
                                  }
                                }),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 6,
                                      blurRadius: 3)
                                ]))
                      ]))));
            }
          });
  }

//Function that eliminates the old password and adds the new one
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg:
            'A email has been sent. (If you don\' see it, check also your spam!)',
        fontSize: 20);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }
}
