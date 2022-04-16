import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/auth/signUp.dart';
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
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return MaterialApp(
        home: Scaffold(
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          const Text("PrCar",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 50.8,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 44.0),
          TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "User Email",
                  prefixIcon: Icon(Icons.mail, color: Colors.black))),
          const SizedBox(height: 26.0),
          TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.black))),
          const SizedBox(height: 12.0),
          const Text("Don't remember your password?",
              style: TextStyle(color: Colors.blue)),
          const SizedBox(height: 88.0),
          SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                  fillColor: const Color(0xFF0069FE),
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
                                builder: (context) => HomePage(userModel)));
                      });
                    }
                  },
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 18.0)))),
          const SizedBox(height: 88.0),
          InkWell(
              child: const Text("Don't have an account?",
                  style: TextStyle(color: Colors.blue, fontSize: 15.0)),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUp())))
        ])));
  }
}
