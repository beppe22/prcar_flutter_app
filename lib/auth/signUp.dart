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
    textSize() {
      if (PassMarker.useMobileLayout!) {
        return screenText * 14;
      } else {
        return screenText * 25;
      }
    }

    //first name field
    final firstNameField = TextFormField(
        key: Key("first name field"),
        autofocus: false,
        style: TextStyle(fontSize: textSize()),
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
            prefixIcon: Icon(Icons.account_circle, size: 25 * screenText),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "First Name",
            hintStyle: TextStyle(fontSize: textSize()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //second name field
    final secondNameField = TextFormField(
        key: Key("second name field"),
        autofocus: false,
        style: TextStyle(fontSize: textSize()),
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
            prefixIcon: Icon(Icons.account_circle, size: 25 * screenText),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Second Name",
            hintStyle: TextStyle(fontSize: textSize()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //email field
    final emailField = TextFormField(
        key: Key("email field"),
        autofocus: false,
        style: TextStyle(fontSize: textSize()),
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
            prefixIcon: Icon(Icons.mail, size: 25 * screenText),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Email",
            hintStyle: TextStyle(fontSize: textSize()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //password field
    final passwordField = TextFormField(
        key: Key("password field"),
        autofocus: false,
        style: TextStyle(fontSize: textSize()),
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
            prefixIcon: Icon(Icons.vpn_key, size: 25 * screenText),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Password",
            hintStyle: TextStyle(fontSize: textSize()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //confirm password field
    final confirmPasswordField = TextFormField(
        key: Key("confirmed password field"),
        autofocus: false,
        style: TextStyle(fontSize: textSize()),
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
            hintStyle: TextStyle(fontSize: textSize()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    colorSignUp() {
      if (PassMarker.useMobileLayout!) {
        return Colors.redAccent;
      } else {
        return Colors.green;
      }
    }

    //signup button
    final signUpButton = Container(
        color: colorSignUp(),
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
                    fontSize: textSize(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold))),
        key: Key("sign up buttom"));

    return PassMarker.useMobileLayout!
        ? MaterialApp(
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
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return MaterialApp(
                  home: Scaffold(
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                          backgroundColor: Colors.green,
                          title: Text("Sign Up",
                              style: TextStyle(fontSize: screenText * 35)),
                          automaticallyImplyLeading: false,
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Colors.white, size: screenText * 35),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                                height: screenHeight * 0.3,
                                                child: Image.asset(
                                                    "assets/prcarlogo.png",
                                                    fit: BoxFit.contain)),
                                            SizedBox(
                                                height: screenHeight * 0.05),
                                            firstNameField,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            secondNameField,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            emailField,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            passwordField,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            confirmPasswordField,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            signUpButton,
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                          ])))))));
            } else {
              return MaterialApp(
                  home: Scaffold(
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                          backgroundColor: Colors.green,
                          title: Text("Sign Up",
                              style: TextStyle(fontSize: screenText * 30)),
                          automaticallyImplyLeading: false,
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Colors.white, size: screenText * 35),
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                      body: SingleChildScrollView(
                          child: Center(
                              child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.all(screenHeight * 0.05),
                                      child: Form(
                                          key: _formKey,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                    height: screenHeight * 0.5,
                                                    child: Image.asset(
                                                        "assets/prcarlogo.png",
                                                        fit: BoxFit.contain)),
                                                SizedBox(
                                                    height: screenWidth * 0.15),
                                                Column(children: [
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.08),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child: firstNameField),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.03),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child: secondNameField),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.03),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child: emailField),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.03),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child: passwordField),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.03),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child:
                                                          confirmPasswordField),
                                                  SizedBox(
                                                      height:
                                                          screenHeight * 0.03),
                                                  Container(
                                                      height:
                                                          screenHeight * 0.07,
                                                      width: screenWidth * 0.5,
                                                      child: signUpButton)
                                                ])
                                              ]))))))));
            }
          });
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
