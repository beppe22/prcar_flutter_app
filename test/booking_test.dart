import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/booking.dart';
import 'package:prcarpolimi/main.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  test('Counter value should be incremented', () async {
    var myapp = const MyApp();
    runApp(myapp);
    final booking = BookingOut('ElLKXX1ddNgfwtMThtRmq7pw8l42Audi449605',
        'ElLKXX1ddNgfwtMThtRmq7pw8l42', '15/06/2023-16/06/2023');

    var a = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection('booking-out')
        .get();
    var number = a.docs.length;

    booking.book();

    var b = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection('booking-out')
        .get();
    var number2 = b.docs.length;
    expect(number, number2 - 1);
  });
}
