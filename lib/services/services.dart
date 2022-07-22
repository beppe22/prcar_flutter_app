import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:prcarpolimi/auth/storage_service.dart';

class Service {
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  firebasefirestore() {
    return FirebaseFirestore.instance;
  }

  firebaseMessaging() {
    return FirebaseMessaging.instance;
  }

  storage() {
    return Storage();
  }

  Future<User?> signInWithemailandpass(String email, String password) async {
    return (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
  }
}

class FakeService implements Service {
  @override
  firebasefirestore() {
    return null;
  }

  @override
  User? currentUser() {
    return null;
  }

  @override
  storage() {
    return null;
  }

  @override
  firebaseMessaging() {
    return null;
  }

  @override
  Future<User?> signInWithemailandpass(String email, String password) async {
    return null;
  }
}
