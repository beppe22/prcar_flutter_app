// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            elevation: 0,
            title: const Text('Reset Password'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                })),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Receive an email to reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 40),
                      SizedBox(
                          height: 250,
                          child: Image.asset("assets/prcarlogo.png",
                              fit: BoxFit.contain)),
                      const SizedBox(height: 30),
                      TextFormField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon:
                                  const Icon(Icons.mail, color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          icon: const Icon(Icons.email_outlined),
                          label: const Text("Reset Password",
                              style: TextStyle(fontSize: 24)),
                          onPressed: () {
                            resetPassword();
                          })
                    ]))));
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      //showSnackBar('Password Reset Email Sent');

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      //Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
