import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/homepage.dart';

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
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
                title: const Text('Verify Email'),
                backgroundColor: Colors.redAccent),
            backgroundColor: Colors.black45,
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'A verification mail has been sent to your email.',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          icon: const Icon(Icons.mail, size: 32),
                          label: const Text('Resent Email',
                              style: TextStyle(fontSize: 24)),
                          onPressed:
                              canResendEmail ? sendVerificationEmail : null),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          icon: const Icon(Icons.mail, size: 32),
                          label: const Text('Cancel',
                              style: TextStyle(fontSize: 24)),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          })
                    ])));
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
