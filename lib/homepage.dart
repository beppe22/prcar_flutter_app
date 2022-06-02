// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/booking/booking_in.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/hamburger/infoAccount.dart';
import 'package:prcarpolimi/hamburger/booking_page.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/static_user.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'bottom_pill.dart';
import 'hamburger/cars_user.dart';
import 'hamburger/filters.dart';
import 'dart:io' show Platform;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

const double pinVisiblePosition = 10;
const double pinInvisiblePosition = -220;

class HomePage extends StatefulWidget {
  List<CarModel>? searchCar;
  List<String>? positionString;

  HomePage({Key? key, this.searchCar, this.positionString}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(searchCar, positionString);
}

class _HomePageState extends State<HomePage> {
  List<CarModel>? searchCar;
  List<String>? positionString;
  _HomePageState(this.searchCar, this.positionString);
  double? pinPillPosition;
  Set<Marker> _markers = {};
  late FirebaseMessaging messaging;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();

    pinPillPosition = -220;
    _updateMarkers();

    _saveToken();
    if (Platform.isAndroid) {
      _listen();
      _checkForInitialMessage();

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        print('Message clicked!');
        print(message.notification!.body);
        setState(() {
          messages.add(message.notification!.body.toString());
        });
        List<String> bookIn = await _fetchOtherRes();
        //bookingId in input
        String bookingId = message.data["bookId"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookingInPage(bookingId: bookingId, res: bookIn)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;
    return Scaffold(
        appBar: AppBar(
            title: const Text("PrCar"),
            backgroundColor: Colors.redAccent,
            actions: [
              !PassMarker.from
                  ? Row(children: [
                      const Text('Clear filter!',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {
                            PassMarker.from = true;
                            _updateMarkers();
                          },
                          icon: const Icon(Icons.autorenew_rounded))
                    ])
                  : Row(children: [
                      const Text('Filters',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Filters()));
                          },
                          icon: const Icon(Icons.search))
                    ])
            ]),
        backgroundColor: Colors.white,
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          const SizedBox(height: 20.0),
          ListTile(
              title: const Text("Home",
                  style: TextStyle(fontSize: 30, color: Colors.redAccent)),
              onTap: () {}),
          ListTile(
              title: const Text("Account"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InfoAccount()));
              }),
          ListTile(
              title: const Text("Booking"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MessagePage()));
              }),
          ListTile(
              title: const Text("About your car"),
              onTap: () async {
                List<CarModel> cars = await _fetchInfoCar();
                if (cars != []) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Cars_user(cars))).then((data) {
                    setState(() {
                      _updateMarkers();
                    });
                  });
                }
              }),
          ListTile(
              title: const Text("Configuration"),
              onTap: () async {
                PassMarker.driveInserted = await listFiles();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Configuration()));
              }),
          ListTile(title: const Text("Help"), onTap: () async {})
        ])),
        body: Stack(children: [
          GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(45.47811155714095, 9.227444681728846),
                  zoom: 16),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onTap: (LatLng loc) {
                setState(() {
                  pinPillPosition = pinInvisiblePosition;
                });
              }),
          AnimatedPositioned(
              left: 0,
              curve: Curves.easeInOut,
              right: 0,
              bottom: pinPillPosition,
              child: const MapBottomPill(),
              duration: const Duration(milliseconds: 500))
        ]));
  }

  _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      UserModel userModel = UserModel.fromMap(await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .get());

      StaticUser.email = userModel.email!;
      StaticUser.uid = userModel.uid!;
      StaticUser.firstName = userModel.firstName!;
      StaticUser.secondName = userModel.secondName!;
    }
  }

  _saveToken() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) async {
      //popoliamo la variabile staticUser
      await _fetchUserInfo();
      PassMarker.driveInserted = await listFiles();
      if (value != null) {
        await db.collection('tokens').doc(StaticUser.uid).set({
          'token': value,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem
        });
      }
    });
  }

  _listen() async {
    messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        print("message recieved");
        print(event.notification!.body);
        print(event.data["bookId"]);
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text(event.notification!.body.toString(),
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    actions: <Widget>[
                      Row(children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close',
                                style: TextStyle(fontSize: 24))),
                        const SizedBox(width: 110),
                        TextButton(
                            onPressed: () async {
                              List<String> bookIn = await _fetchOtherRes();
                              //bookingId in input
                              String bookingId = event.data["bookId"];
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingInPage(
                                          bookingId: bookingId, res: bookIn)));
                              Navigator.of(context).pop();
                            },
                            child: const Text('Go!',
                                style: TextStyle(fontSize: 24))),
                      ])
                    ]));
        setState(() {
          messages.add(event.notification!.body.toString());
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<List<String>> _fetchOtherRes() async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    List<String> otherRes = [];
    PassMarker.uid = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get();
      if (data.docs.isNotEmpty) {
        for (var car in data.docs) {
          await firebaseFirestore
              .collection('users')
              .doc(car.data()['uid'])
              .collection('cars')
              .doc(car.data()['cid'])
              .collection('booking-in')
              .get()
              .then((ds) async {
            if (ds.docs.isNotEmpty) {
              for (var book in ds.docs) {
                String insert = book.data()['date'];
                var data1 = await firebaseFirestore
                    .collection('users')
                    .doc(book.data()['uidOwner'])
                    .collection('cars')
                    .doc(book.data()['cid'])
                    .get();
                if (book.data()['status'] != 'e') {
                  PassMarker.uid.add(user.uid);
                  PassMarker.cid.add(book.data()['cid']);
                  PassMarker.bookId.add(book.data()['bookingId']);
                  PassMarker.status.add(book.data()['status']);
                  insert = insert +
                      '.' +
                      data1.data()!['veicol'] +
                      '-' +
                      data1.data()!['model'];

                  otherRes.add(insert);
                }
              }
            }
          });
        }
      }
    }
    return otherRes;
  }

  _checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('Message ripreso!');
      print(initialMessage.notification!.body);
      List<String> bookIn = await _fetchOtherRes();
      //bookingId in input
      String bookingId = initialMessage.data["bookId"];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BookingInPage(bookingId: bookingId, res: bookIn)));
    }
  }

//Function that fecth all the cars in the database
  Future<List<CarModel>> _fetchCar() async {
    final _auth = FirebaseAuth.instance;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    List<CarModel> cars = [];

    if (user != null) {
      try {
        await firebaseFirestore.collection('users').get()
            //quando non ci sono macchine da errore
            .then((ds) async {
          for (var user_1 in ds.docs) {
            //print(user_1.data());
            try {
              await firebaseFirestore
                  .collection('users')
                  .doc(user_1.data()['uid'])
                  .collection('cars')
                  .get()
                  .then((ds_1) {
                for (var car in ds_1.docs) {
                  //print(car.data());
                  if (car.data()['activeOrNot'] == 't') {
                    cars.add(CarModel.fromMap(car.data()));
                  }
                }
              });
            } on FirebaseAuthException catch (e) {
              print(e.code);
            }
          }
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);
        //if (e.code == "impossible to insert new car") {}
      }
    }
    return cars;
  }

//Function that fecth only user's car
  static Future<List<CarModel>> _fetchInfoCar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    List<CarModel> cars = [];

    if (user != null) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .collection('cars')
            .get()
            .then((ds) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "cars not found") {}
      }
    }
    return cars;
  }

  BitmapDescriptor _iconColor(String owner, String user) {
    if (owner == user) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  String _printInfoWindow(String owner, String user, String carOwner) {
    if (owner == user) {
      return 'My car';
    } else {
      return carOwner;
    }
  }

  void _updateMarkers() async {
    final _auth = FirebaseAuth.instance;
    String? userAuth = _auth.currentUser!.uid.toString();
    if (PassMarker.from) {
      PassMarker.markerToPass = {};
      List<CarModel> cars = await _fetchCar();
      for (int i = 0; i < cars.length; i++) {
        String? carLatLng = cars[i].position;
        final splitted = carLatLng!.split('-');
        double lat = double.parse(splitted[0]);
        double lng = double.parse(splitted[1]);
        setState(() {
          PassMarker.markerToPass.add(Marker(
              markerId: MarkerId('marker$i'),
              infoWindow: InfoWindow(
                  title: _printInfoWindow(
                      cars[i].uid.toString(),
                      userAuth,
                      cars[i].vehicle.toString() +
                          '-' +
                          cars[i].model.toString())),
              position: LatLng(lat, lng),
              icon: _iconColor(cars[i].uid.toString(), userAuth),
              onTap: () {
                if (userAuth != cars[i].uid.toString()) {
                  PassMarker.carModel = cars[i];
                  setState(() {
                    pinPillPosition = pinVisiblePosition;
                  });
                } else {
                  setState(() {
                    pinPillPosition = pinInvisiblePosition;
                  });
                }
              }));
          PassMarker.markerId = PassMarker.markerId + 1;
        });
      }
    } else {
      PassMarker.markerToPass = {};
      for (int i = 0; i < searchCar!.length; i++) {
        String? carLatLng = searchCar![i].position;
        final splitted = carLatLng!.split('-');
        double lat = double.parse(splitted[0]);
        double lng = double.parse(splitted[1]);
        setState(() {
          PassMarker.markerToPass.add(Marker(
              markerId: MarkerId('marker$i'),
              infoWindow: InfoWindow(
                  title: _printInfoWindow(
                      searchCar![i].uid.toString(),
                      userAuth,
                      searchCar![i].vehicle.toString() +
                          '-' +
                          searchCar![i].model.toString())),
              position: LatLng(lat, lng),
              icon: _iconColor(searchCar![i].uid.toString(), userAuth),
              onTap: () {
                setState(() {
                  pinPillPosition = pinVisiblePosition;
                });
              }));
        });
      }
    }
    _markers = PassMarker.markerToPass;
  }

  Future<bool> listFiles() async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    firebase_storage.ListResult results =
        await storage.ref('${user!.uid}/drivingLicenseData/').listAll();
    if (results.items.length == 4) {
      return true;
    } else {
      return false;
    }
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
