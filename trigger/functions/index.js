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
        'bookingId': bookOut.bookingId,
        'cid': bookOut.cid,
        'date': bookOut.date,
        'status' : 'a',
        'uidBooking': bookOut.uidBooking,
        'uidOwner': bookOut.uidOwner,
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

exports.emailForBooking = functions.firestore
.document('users/{IdUser}/booking-out/{IdBookingOut}')
.onCreate(async (snap, context) => {

  const bookOut= snap.data();
  

  //Retrieve car booked info
  
  const car= await db.collection('users').doc(bookOut.uidOwner).collection('cars').doc(bookOut.cid).get();
  const model= car.data().model;
  const vehicle= car.data().veicol;

  //Retrieve email from who received the booking
  const user= await db.collection('users').doc(bookOut.uidOwner).get();
  const email= user.data().email;


  const SENDGRID_API_KEY = functions.config().sendgrid.key;
  const sgMail= require('@sendgrid/mail');
  sgMail.setApiKey(SENDGRID_API_KEY);
  
  const msg= 
  {
    to: email,
    from: 'tancreditalia@hotmail.it',
    subject: 'Booking',
    templateId: 'd-61b9f62cf1d74688aaee77abcb0dc1fc',
    substitutionWrappers: ['{{', '}}'],
    dynamic_template_data: {
      nameCar: vehicle + '-' + model,
    }


  }
  return sgMail.send(msg)
  
});

exports.statusChangingBookingOut = functions.firestore
.document('users/{IdUser}/booking-out/{IdBookingOut}')
.onUpdate(async (snap, context) => {

  const booking= snap.data();
  const preStatus= snap.before.get('status');
  const postStatus= snap.after.get('status');

  if(preStatus == 'c' && postStatus == 'a')
  {
    await db.collection('users')
    .doc(booking.uidOwner)
    .collection('cars')
    .doc(bookOut.cid)
    .collection('booking-in')
    .doc(bookOut.bookingId)
    .update({'status' : 'a'});
  }
})

exports.statusChangingBookingIn = functions.firestore
.document('users/{IdUser}/cars/{IdCars}/booking-in/{IdBookingIn}')
.onUpdate(async (snap, context) => {

  const booking= snap.data();
  const preStatus= snap.before.get('status');
  const postStatus= snap.after.get('status');

  if(preStatus == 'c' && postStatus == 'a')
  {
    await db.collection('users')
    .doc(booking.uidBooking)
    .collection('booking-out')
    .doc(bookOut.bookingId)
    .update({'status' : 'a'});
  }
})



/*exports.emailForNewAcceptedUser = functions.firestore
.document('users/{IdUser}')
.onUpdate(async (snap, context) => {

  const user= snap.data();
  const preStatus = snap.before.get('isConfirmed');
  const postStatus = snap.after.get('isConfirmed');

  if(preStatus == 'false' && postStatus == 'true'){
  
  

  const email= user.data().email;


  const SENDGRID_API_KEY = functions.config().sendgrid.key;
  const sgMail= require('@sendgrid/mail');
  sgMail.setApiKey(SENDGRID_API_KEY);
  
  const msg= 
  {
    to: email,
    from: 'tancreditalia@hotmail.it',
    subject: 'Confirmation',
    templateId: 'd-7a00fd84017c425b99f0805f4de5c528',
    substitutionWrappers: ['{{', '}}'],
    dynamic_template_data: {
      name: user.data().firstName,
    }


  }
  return sgMail.send(msg)
}
});*/

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