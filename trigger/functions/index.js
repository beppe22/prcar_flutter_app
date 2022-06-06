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
        'status' : 'c',
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
      
      tok = value.data().token;
      //const nameCar= await retrieveCarName(bookOut.cid,bookOut.uidOwner);
      var payload = {
        "data" : {
          "bookId" : bookOut.bookingId,
          "type" : 'booking',
        },
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

  const booking= snap.after.data();
  const preStatus= snap.before.data().status;
  const postStatus= snap.after.data().status;;

  //Retrieve status of the booking-in
  const bookIn = await db.collection('users')
    .doc(booking.uidOwner)
    .collection('cars')
    .doc(booking.cid)
    .collection('booking-in')
    .doc(booking.bookingId)
    .get();
  const statusBookIn= bookIn.data().status;


  if(preStatus == 'c' && postStatus == 'a' && statusBookIn == 'c')
  {
    await db.collection('users')
    .doc(booking.uidOwner)
    .collection('cars')
    .doc(booking.cid)
    .collection('booking-in')
    .doc(booking.bookingId)
    .update({'status' : 'a'});

    //Retrieve car booked info
  
    const car= await db.collection('users').doc(booking.uidOwner).collection('cars').doc(booking.cid).get();
    const model= car.data().model;
    const vehicle= car.data().veicol;

    //Retrieve email from who received the booking
    const userOwner= await db.collection('users').doc(booking.uidOwner).get();
    const email= userOwner.data().email;

    //Retrieve who has canceled the booking
    const userBookingOut= await db.collection('users').doc(booking.uidBooking).get();
    const nameUserBookingOut= userBookingOut.data().firstName;
    
    //Retrieve the date of the booking
    const date= booking.date;


    //send email 
    const SENDGRID_API_KEY = functions.config().sendgrid.key;
    const sgMail= require('@sendgrid/mail');
    sgMail.setApiKey(SENDGRID_API_KEY);
  
    const msg= 
    {
    to: email,
    from: 'tancreditalia@hotmail.it',
    subject: 'Booking-out Canceled',
    templateId: 'd-e3da928169964fe3a9a2723bf720a13f',
    substitutionWrappers: ['{{', '}}'],
    dynamic_template_data: {
      nameCar: vehicle + '-' + model,
      nameUserBookingOut: nameUserBookingOut,
      date: date,
    }


    }
    sgMail.send(msg)

    //send notification
    await db.collection('tokens').doc(booking.uidOwner).get().then(async (value) => {
    
      if (value.empty) {
          console.log('No Device');
    
      }else {
        var tok = '';
        
        tok = value.data().token;
        //const nameCar= await retrieveCarName(bookOut.cid,bookOut.uidOwner);
        var payload = {
          "data" : {
            "bookId" : booking.bookingId,
            "type" : 'booking',
          },
          "notification": {
              "title": "Booking canceled",
              "body": "Someone has canceled a booking of your car ",
              "sound": "default"
          }}
      
        return admin.messaging().sendToDevice(tok,payload).then((response) => {
          console.log('Pushed them all');
      }).catch((err) => {
          console.log(err);
      });
      }
        
        });






  }
})

exports.statusChangingBookingIn = functions.firestore
.document('users/{IdUser}/cars/{IdCars}/booking-in/{IdBookingIn}')
.onUpdate(async (snap, context) => {

  const booking= snap.after.data();
  const preStatus= snap.before.get('status');
  const postStatus= snap.after.get('status');

  //Retrieve status of the booking-out
  const bookOut= await db.collection('users')
  .doc(booking.uidBooking)
  .collection('booking-out')
  .doc(booking.bookingId)
  .get();
  const statusBookOut= bookOut.data().status;

  if(preStatus == 'c' && postStatus == 'a' && statusBookOut=='c')
  {
    await db.collection('users')
    .doc(booking.uidBooking)
    .collection('booking-out')
    .doc(booking.bookingId)
    .update({'status' : 'a'});


    //Retrieve car booked info
  
    const car= await db.collection('users').doc(booking.uidOwner).collection('cars').doc(booking.cid).get();
    const model= car.data().model;
    const vehicle= car.data().veicol;

    //Retrieve email of who has booked
    const userBooking= await db.collection('users').doc(booking.uidBooking).get();
    const email= userBooking.data().email;

    //Retrieve who has canceled the booking - The owner of the car
    const userBookingOut= await db.collection('users').doc(booking.uidOwner).get();
    const nameUserOwner= userBookingOut.data().firstName;
    
    //Retrieve the date of the booking
    const date= booking.date;


    //Send email
    const SENDGRID_API_KEY = functions.config().sendgrid.key;
    const sgMail= require('@sendgrid/mail');
    sgMail.setApiKey(SENDGRID_API_KEY);
  
    const msg= 
    {
    to: email,
    from: 'tancreditalia@hotmail.it',
    subject: 'Booking-in Canceled',
    templateId: 'd-b5337e0888484e92bb375e9e0949e8da',
    substitutionWrappers: ['{{', '}}'],
    dynamic_template_data: {
      nameCar: vehicle + '-' + model,
      nameOwner: nameUserOwner,
      date: date,
    }


    }
    sgMail.send(msg)


    //send notification
    await db.collection('tokens').doc(booking.uidBooking).get().then(async (value) => {
    
      if (value.empty) {
          console.log('No Device');
    
      }else {
        var tok = '';
        
        tok = value.data().token;
        //const nameCar= await retrieveCarName(bookOut.cid,bookOut.uidOwner);
        var payload = {
          "data" : {
            "bookId" : booking.bookingId,
            "type" : 'booking',
          },
          "notification": {
              "title": "Booking canceled",
              "body": "Your booking was canceled by the owner ",
              "sound": "default"
          }}
      
        return admin.messaging().sendToDevice(tok,payload).then((response) => {
          console.log('Pushed them all');
      }).catch((err) => {
          console.log(err);
      });
      }
        
        });
  }
})

exports.chatMessage = functions.firestore
.document('chats/{Idchat}/messages/{IdMessage}')
.onCreate(async (snap, context) => {

  //Retreive Id and name of the one who received a message
  const friendId= snap.data().friendId;
  const friendName= snap.data().friendName;

  //Retreive the name of who sent the message
  await db.collection('users').doc(snap.data().uid).get().then(async (value1) =>{

    const name = value1.data().firstName;

    await db.collection('tokens').doc(friendId).get().then(async (value) => {
    
      if (value.empty) {
          console.log('No Device');
    
      }else {
        var tok = '';
        
        tok = value.data().token;
        
        var payload = {
          "data" : {
            "type" : 'message',
            "friendId" : snap.data().uid,
            "friendName" : name,
          },
          "notification": {
              "title": "Message arrived",
              "body": "You received a message from" + name,
              "sound": "default"
          }}
      
        return admin.messaging().sendToDevice(tok,payload).then((response) => {
          console.log('Pushed them all');
      }).catch((err) => {
          console.log(err);
      });
      }
        
        });



  } )

  


})


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });