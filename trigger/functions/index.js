const functions = require("firebase-functions");
const admin = require('firebase-admin');
auth = FirebaseAuth.instance;
const user = auth.currentUser.uid;









exports.makeUppercase= functions.firestore
.document('m/Mxw2M8wMQn0rWuLSky8j/n/{bookId}')
.onCreate((snap, context) => {



    const original = snap.data().original;

      // Access the parameter `{documentId}` with `context.params`
    functions.logger.log('Uppercasing', context.params.bookId, original);
      
    const uppercase = user.toString();
      
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to Firestore.
      // Setting an 'uppercase' field in Firestore document returns a Promise.
    return snap.ref.set({uppercase}, {merge: true});
    
    
    /*const uidOwner= snap.data().uidOwner;
    const cid=snap.data().cid
    //print(cid);
    
    var object1 = {
        'uidOwner': uidOwner,
        'cid': cid,
        'date': snap.data().date,
        'uidBooking': snap.data().uidBooking,
      }

    
    await db.collection('users')
    .document(uidOwner)
    .collection('cars')
    .document(cid)
    .collection('booking-in')
    .document('ciao')
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
