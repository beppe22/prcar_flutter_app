import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prcarpolimi/models/booking_model_out.dart';

class BookingOut {
  late String? uid;
  late String? cid;

  BookingOut(this.cid, this.uid);

  Future<String> book() async {
    final _auth = FirebaseAuth.instance;
    var rng = Random();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            //quando non ci sono macchine da errore
            .collection('booking-out')
            .doc(user.uid.toString() + cid.toString() + rng.toString())
            .set(BookingOutModel(
                    cid: cid, uidOwner: uid, date: '1', uidBooking: user.uid)
                .toMap())
            .then((ds) {
          return '1';
        });
        return '1';
      } on FirebaseAuthException catch (e) {
        if (e.code == "impossible to insert new car") {}
        return '0';
      }
    }
    return '0';
  }
}
