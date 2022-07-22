import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  VerifyEmailPageState createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    try {
      if (!isEmailVerified) {
        sendVerificationEmail();
        timer = Timer.periodic(
            const Duration(seconds: 3), (_) => checkEmailVerified());
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      if (isEmailVerified) timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? isEmailVerified
            ? HomePage(homePageService: Service())
            : Scaffold(
                appBar: AppBar(
                    title: Text('Verify Email',
                        style: TextStyle(fontSize: screenText * 20)),
                    backgroundColor: Colors.redAccent,
                    automaticallyImplyLeading: false),
                backgroundColor: Colors.white,
                body: Padding(
                    padding: EdgeInsets.all(screenHeight * 0.03),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.08),
                          Text(
                              'A verification mail has been sent to your email.',
                              style: TextStyle(
                                  fontSize: screenText * 18,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: screenHeight * 0.05),
                          SizedBox(
                              height: screenHeight * 0.3,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.05),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size.fromHeight(screenText * 45)),
                              icon: Icon(Icons.mail, size: screenText * 28),
                              label: Text('Resent Email',
                                  style: TextStyle(fontSize: screenText * 24)),
                              onPressed: canResendEmail
                                  ? sendVerificationEmail
                                  : null),
                          SizedBox(height: screenHeight * 0.06),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size.fromHeight(screenText * 45)),
                              icon: Icon(Icons.cancel, size: screenText * 28),
                              label: Text('Cancel',
                                  style: TextStyle(fontSize: screenText * 24)),
                              onPressed: () async {
                                if (await NetworkCheck().check()) {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user?.uid)
                                      .delete();
                                  await user?.delete();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login(
                                                loginService: Service(),
                                              )),
                                      (Route<dynamic> route) => false);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No internet connection',
                                      fontSize: 20);
                                }
                              })
                        ])))
        : Container();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        canResendEmail = true;
      });
      Fluttertoast.showToast(
          msg:
              'A email has been sent. (If you don\' see it, check also your spam!)',
          fontSize: 20);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
