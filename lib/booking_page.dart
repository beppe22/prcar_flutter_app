import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prcarpolimi/models/booking_model.dart';

class BookingOut {
  late String? uid;
  late String? cid;
  late String? date;

  BookingOut(this.cid, this.uid, this.date);

  Future<String> book() async {
    final _auth = FirebaseAuth.instance;
    var rng = Random().nextInt(10000000);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        String bookingId =
            user.uid.toString() + cid.toString() + rng.toString();
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            //quando non ci sono macchine da errore
            .collection('booking-out')
            .doc(bookingId)
            .set(BookingModel(
                    cid: cid,
                    uidOwner: uid,
                    date: date,
                    uidBooking: user.uid,
                    bookingId: bookingId)
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
