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

class Login extends StatefulWidget {
  final Service loginService;

  const Login({Key? key, required this.loginService}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserModel userModel = UserModel();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
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
      return 25.0;
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
        key: const ValueKey(1),
        autofocus: false,
        style: TextStyle(fontSize: sizeHintText()),
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail, size: sizeHintText()),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Email",
            hintStyle: TextStyle(fontSize: sizeHintText()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final passwordField = TextFormField(
        key: const ValueKey(2),
        autofocus: false,
        style: TextStyle(fontSize: sizeHintText()),
        controller: _passwordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key, size: sizeHintText()),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Password",
            hintStyle: TextStyle(fontSize: sizeHintText()),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    return PassMarker.useMobileLayout!
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(height: screenHeight * 0.1),
                  Text("Welcome to PrCar!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenText * 45,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                      height: screenHeight * 0.2,
                      child: Image.asset("assets/prcarlogo.png",
                          fit: BoxFit.contain)),
                  SizedBox(height: screenHeight * 0.05),
                  emailField,
                  SizedBox(height: screenHeight * 0.02),
                  passwordField,
                  SizedBox(height: screenHeight * 0.05),
                  Row(children: [
                    SizedBox(width: screenWidth * 0.06),
                    GestureDetector(
                        child: Text('Forgot password?',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.redAccent,
                                fontSize: screenText * 16)),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ))),
                    Text(' or ', style: TextStyle(fontSize: screenText * 12)),
                    GestureDetector(
                        key: Key("New Account"),
                        child: Text("Don't have an account?",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.redAccent,
                                fontSize: screenText * 16)),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp())))
                  ]),
                  SizedBox(height: screenHeight * 0.06),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        key: const Key("clickButtom"),
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.85,
                        child: MaterialButton(
                            color: Colors.redAccent,
                            onPressed: () async {
                              if (await NetworkCheck().check()) {
                                User? user = await loginUsingEmailPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
                                if (user != null) {
                                  await widget.loginService
                                      .firebasefirestore()
                                      .collection('users')
                                      .doc(user.uid)
                                      .get()
                                      .then((ds) {
                                    userModel = UserModel.fromMap(ds);
                                    StaticUser.email = userModel.email!;
                                    StaticUser.uid = userModel.uid!;
                                    StaticUser.firstName = userModel.firstName!;
                                    StaticUser.secondName =
                                        userModel.secondName!;
                                    PassMarker.from = true;
                                    _finishReservation(user);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                homePageService: Service())));
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
                                    fontSize: screenText * 25))),
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
                ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                      child: Container(
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.05),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    SizedBox(height: screenHeight * 0.1),
                                    Text("Welcome to PrCar!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenText * 55,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: screenHeight * 0.05),
                                    SizedBox(
                                        height: screenHeight * 0.3,
                                        child: Image.asset(
                                            "assets/prcarlogo.png",
                                            fit: BoxFit.contain)),
                                    SizedBox(height: screenHeight * 0.05),
                                    emailField,
                                    SizedBox(height: screenHeight * 0.02),
                                    passwordField,
                                    SizedBox(height: screenHeight * 0.05),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              child: Text('Forgot password?',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.green,
                                                      fontSize:
                                                          screenText * 30)),
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ForgotPasswordPage()))),
                                          Text(' or ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenText * 22)),
                                          GestureDetector(
                                              child: Text(
                                                  "Don't have an account?",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.green,
                                                      fontSize:
                                                          screenText * 30)),
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignUp())))
                                        ]),
                                    SizedBox(height: screenHeight * 0.06),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: screenHeight * 0.07,
                                              width: screenWidth * 0.85,
                                              child: MaterialButton(
                                                  color: Colors.green,
                                                  onPressed: () async {
                                                    if (await NetworkCheck()
                                                        .check()) {
                                                      User? user =
                                                          await loginUsingEmailPassword(
                                                              email:
                                                                  _emailController
                                                                      .text,
                                                              password:
                                                                  _passwordController
                                                                      .text,
                                                              context: context);
                                                      if (user != null) {
                                                        await widget
                                                            .loginService
                                                            .firebasefirestore()
                                                            .collection('users')
                                                            .doc(user.uid)
                                                            .get()
                                                            .then((ds) {
                                                          userModel =
                                                              UserModel.fromMap(
                                                                  ds);
                                                          StaticUser.email =
                                                              userModel.email!;
                                                          StaticUser.uid =
                                                              userModel.uid!;
                                                          StaticUser.firstName =
                                                              userModel
                                                                  .firstName!;
                                                          StaticUser
                                                                  .secondName =
                                                              userModel
                                                                  .secondName!;
                                                          PassMarker.from =
                                                              true;
                                                          _finishReservation(
                                                              user);
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
                                                          msg:
                                                              'No internet connection',
                                                          fontSize: 20);
                                                    }
                                                  },
                                                  child: Text("Login",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: screenText *
                                                              25))),
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color:
                                                            Colors.deepPurple,
                                                        spreadRadius: 6,
                                                        blurRadius: 3)
                                                  ]))
                                        ])
                                  ]))))));
            } else {
              return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white,
                  body: Form(
                      key: _formKey,
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
                                        color: Colors.green,
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
                                        color: Colors.green,
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
                                        color: Colors.green,
                                        onPressed: () async {
                                          if (await NetworkCheck().check()) {
                                            User? user =
                                                await loginUsingEmailPassword(
                                                    email:
                                                        _emailController.text,
                                                    password:
                                                        _passwordController
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
                      ])));
            }
          });
  }
}
