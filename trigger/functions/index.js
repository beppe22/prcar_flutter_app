const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();


exports.eii= functions.firestore
.document('users/{IdUser}/booking-out/{IdBookingOut}')
.onCreate(async (snap, context) => {

   const bookOut= snap.data();
    
    
    /*const uidOwner= snap.data().uidOwner;
    const cid=snap.data().cid
    //print(cid);
    */
    var object1 = {
        'uidOwner': bookOut.uidOwner,
        'cid': bookOut.cid,
        'date': bookOut.date,
        'uidBooking': bookOut.uidBooking,
        'bookingId': bookOut.bookingId,
      }

    
    await db.collection('users')
    .doc(bookOut.uidOwner)
    .collection('cars')
    .doc(bookOut.cid)
    .collection('booking-in')
    .doc(bookOut.bookingId)
    .set(object1);
    
    /*return getFirestore()
    .collection('users')
    .doc(uidOwner)
    .collection('cars')
    .doc(cid)
    .collection('booking-in')
    .doc('ciao')
    .set(object1);*/
    
    //admin.database().ref('users/' + uidOwner + '/cars/' + cid + '/booking-in/' + '1').set(BookingInModel(uidOwner, cid, snap.data().date,snap.data().uidBooking).toMap());
    //admin.database().ref('/users/vZElXSMJupWCIumLLSpdHD5ntvi1/cars/vZElXSMJupWCIumLLSpdHD5ntvi1BMW353100/booking-in/aaa').set(BookingOutModel(uidOwner, cid, snap.data().date,snap.data().uidBooking).toMap());
    //return getDatabase().ref('/users/vZElXSMJupWCIumLLSpdHD5ntvi1/cars/vZElXSMJupWCIumLLSpdHD5ntvi1BMW353100/booking-in/aaa').push(object1);*/
})


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
