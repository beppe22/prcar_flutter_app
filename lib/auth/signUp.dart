// ignore_for_file: file_names, body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/auth/verify_email.dart';
import 'package:prcarpolimi/models/static_user.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/services/services.dart';

import '../models/marker_to_pass.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  bool from = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name can't be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Name(Min. 3 Character");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "First Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name can't be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Second Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email.");
          }
          //reg expression for email validator
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password(Min. 6 Character");
          }
          return null;
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't Match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //signup button
    final signUpButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.redAccent,
        child: MaterialButton(
            onPressed: () async {
              if (await NetworkCheck().check()) {
                signUp(emailEditingController.text,
                    passwordEditingController.text);
              } else {
                Fluttertoast.showToast(
                    msg: 'No internet connection', fontSize: 20);
              }
            },
            padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            minWidth: MediaQuery.of(context).size.width,
            child: Text("Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    return PassMarker.useMobileLayout!
        ? MaterialApp(
            //padding: const EdgeInsets.all(16.0),
            home: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                    backgroundColor: Colors.redAccent,
                    title: Text("Sign Up",
                        style: TextStyle(fontSize: screenText * 20)),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: screenText * 25),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                body: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(screenHeight * 0.05),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                          height: screenHeight * 0.2,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain)),
                                      SizedBox(height: screenHeight * 0.05),
                                      firstNameField,
                                      SizedBox(height: screenHeight * 0.02),
                                      secondNameField,
                                      SizedBox(height: screenHeight * 0.02),
                                      emailField,
                                      SizedBox(height: screenHeight * 0.02),
                                      passwordField,
                                      SizedBox(height: screenHeight * 0.02),
                                      confirmPasswordField,
                                      SizedBox(height: screenHeight * 0.02),
                                      signUpButton,
                                      SizedBox(height: screenHeight * 0.02),
                                    ])))))))
        : Container();
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()});
    }
  }

  postDetailsToFirestore() async {
    //Calling our Firestore and User Model

    //Sending these Values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.isConfirmed = 'negative';

    StaticUser.email = userModel.email!;
    StaticUser.uid = userModel.uid!;
    StaticUser.firstName = userModel.firstName!;
    StaticUser.secondName = userModel.secondName!;
    PassMarker.from = true;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VerifyEmailPage(
                service: Service(),
              )),
    );
  }
}
