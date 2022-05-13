import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/auth/signUp.dart';
import 'package:prcarpolimi/forgot_password.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Login function
  UserModel userModel = UserModel();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                          if (user != null) {
                            await firebaseFirestore
                                .collection('users')
                                .doc(user.uid)
                                .get()
                                .then((ds) {
                              userModel = UserModel.fromMap(ds);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(userModel)));
                            });
                          }
                        },
                        child: const Text("Login",
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
            ]));
  }
}
