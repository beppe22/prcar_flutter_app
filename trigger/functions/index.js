const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { auth } = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();


exports.eii= functions.firestore
.document('users/{IdUser}/booking-out/{IdBookingOut}')
.onCreate(async (snap, context) => {

   const bookOut= snap.data();
    
    
    /*const uidOwner= snap.data().uidOwner;
    const cid=snap.data().cid
    //print(cid);*/
    
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


    await db.collection('tokens').doc(bookOut.uidOwner).get().then(async (value) => {
    
    if (value.empty) {
        console.log('No Device');
  
    }else {
      var tok = '';
      //console.log('Device');
      tok = value.data().token;
      
      //debugPrint('ciao = $tok');
      //const nameCar= await retrieveCarName(bookOut.cid,bookOut.uidOwner);
      var payload = {
        "notification": {
            "title": "Car booked",
            "body": "Someone has booked your car ",
            "sound": "default"
        }}
    
      return admin.messaging().sendToDevice(tok,payload).then((response) => {
        console.log('Pushed them all');
    }).catch((err) => {
        console.log(err);
    });
    }
      
      });
    
    
    
  
    
    //admin.database().ref('users/' + uidOwner + '/cars/' + cid + '/booking-in/' + '1').set(BookingInModel(uidOwner, cid, snap.data().date,snap.data().uidBooking).toMap());
    //admin.database().ref('/users/vZElXSMJupWCIumLLSpdHD5ntvi1/cars/vZElXSMJupWCIumLLSpdHD5ntvi1BMW353100/booking-in/aaa').set(BookingOutModel(uidOwner, cid, snap.data().date,snap.data().uidBooking).toMap());
    //return getDatabase().ref('/users/vZElXSMJupWCIumLLSpdHD5ntvi1/cars/vZElXSMJupWCIumLLSpdHD5ntvi1BMW353100/booking-in/aaa').push(object1);
})

async function retrieveCarName(idCar,idUser){
   
  await db.collection('users').doc(idUser).collection('cars').doc(idCar).get().then(async (car) => {
  const nameVehicle= car.data().veicol;
  const nameModel= car.data().model;
  const stringa= nameVehicle + '-'+ nameModel;

  return (stringa);
  });

  
}


/*exports.endToDevice= functions.firestore
.document('b/{id}')
.onCreate((snap, context) => {

  
  db.collection('a').doc('a').get().then((value) => {
    
    if (value.empty) {
      console.log('No Device');

  }else {
    var tok = '';
    console.log('Device');
    tok = value.data().token;
    
    //debugPrint('ciao = $tok');

    var payload = {
      "notification": {
          "title": "From",
          "body": "motive" + tok,
          "sound": "default"
      }}
  
    return admin.messaging().sendToDevice(tok,payload).then((response) => {
      console.log('Pushed them all');
  }).catch((err) => {
      console.log(err);
  });
  }
    
    });
  
  
})*/


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });