// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/booking_page.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/infoAccount.dart';
import 'package:prcarpolimi/cars_user.dart';
import 'package:prcarpolimi/message_page.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/static_user.dart';
import 'hamburger/configuration2.dart';
import 'hamburger/filters.dart';

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
    _listen();
    //checkForInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;
    return Scaffold(
        appBar: AppBar(
            title: const Text("PrCar"),
            backgroundColor: Colors.redAccent,
            actions: [
              Row(children: [
                const Text('Clear filter!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      if (PassMarker.from) {
                        Fluttertoast.showToast(
                            msg: 'Map arleady clean!', fontSize: 20);
                      } else {
                        PassMarker.from = true;
                        _updateMarkers();
                      }
                    },
                    icon: const Icon(Icons.autorenew_rounded))
              ]),
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
              title: const Text("Mess"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagePage(messages)));
              }),
          ListTile(
              title: const Text("Filters"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Filters()));
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
              onTap: () {
                if (!PassMarker.driveInserted2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Configuration()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Configuration2()));
                }
              }),
          ListTile(title: const Text("Help"), onTap: () {})
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

  _saveToken() async {
    messaging = FirebaseMessaging.instance;
    await messaging.getToken().then((value) async {
      await db.collection('tokens').doc(StaticUser.uid).set({
        'token': value,
      });
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
        setState(() {
          messages.add(event.notification!.body.toString());
        });
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message clicked!');
        print(message.notification!.body);
        setState(() {
          messages.add(message.notification!.body.toString());
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /*checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('Message ripreso!');
      print(initialMessage.notification!.body);
      showDialog(
          barrierDismissible:
              true, //tapping outside dialog will close the dialog if set 'true'
          context: context,
          builder: (context) {
            return const Dialog(
              child: Text('ciao'),
            );
          });
      /*setState(() {
        setState(() {
          messages.add(initialMessage.notification!.body.toString());
        });
      });*/
    } 
    }
  }*/

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
            await firebaseFirestore
                .collection('users')
                .doc(user_1.data()['uid'])
                .collection('cars')
                .get()
                .then((ds_1) {
              for (var car in ds_1.docs) {
                //print(car.data());
                cars.add(CarModel.fromMap(car.data()));
              }
            });
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "impossible to insert new car") {}
      }
    }
    return cars;
  }

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
}

class MapBottomPill extends StatelessWidget {
  const MapBottomPill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 80,
                  offset: Offset.zero)
            ]),
        child: Column(children: [
          Container(
              color: Colors.redAccent,
              child: Row(children: [
                ClipOval(
                    child: Image.asset('assets/prcarlogo.png',
                        width: 100,
                        height: 85,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter)),
                Column(children: [
                  const Text('Selected car, click below for',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  const Text('more details: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Container(
                      width: 140,
                      margin: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          onPressed: () async {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 6,
                                      child: Column(children: <Widget>[
                                        const SizedBox(height: 20),
                                        const Center(
                                            child: Text('Car Information',
                                                style: TextStyle(
                                                    fontSize: 38,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        const SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.vehicle
                                                .toString(),
                                            'VEHICLE'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.model
                                                .toString(),
                                            'MODEL'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.fuel.toString(),
                                            'FUEL'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.seats
                                                .toString(),
                                            'SEATS'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.price
                                                .toString(),
                                            'PRICE FOR DAY'),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                            height: 175,
                                            child: Image.asset(
                                                "assets/prcarlogo.png",
                                                fit: BoxFit.contain)),
                                        Container(
                                            child: MaterialButton(
                                                height: 50,
                                                minWidth: 200,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  if (PassMarker
                                                      .driveInserted) {
                                                    PassMarker.hpOrNot = true;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Least()));
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'No driving license info inserted. Go to configuration for more details',
                                                        fontSize: 18);
                                                  }
                                                },
                                                child: const Text("Reserve",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0))),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.deepPurple,
                                                      spreadRadius: 6,
                                                      blurRadius: 3)
                                                ])),
                                        const SizedBox(height: 30),
                                        Container(
                                            child: MaterialButton(
                                                height: 50,
                                                minWidth: 200,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  Navigator.pop(context, '');
                                                },
                                                child: const Text("Return",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0))),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.deepPurple,
                                                      spreadRadius: 6,
                                                      blurRadius: 3)
                                                ]))
                                      ]));
                                });
                            if (result == '1') {
                              /*showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Congra'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Your Booked your car'),
                                          
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Navigator.pop(context, '1')
                                    ],
                                  );
                                },
                              );*/
                            }
                            //fare spuntare un label per comunicare se la reservation ha avuto buon fine
                          },
                          child: const Text('Reserve'))),
                ], mainAxisAlignment: MainAxisAlignment.center)
              ]))
        ]));
  }

  Widget _buildRow(String imageAsset, String value, String type) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          const SizedBox(height: 12),
          //Container(height: 2, color: Colors.redAccent),
          Row(children: <Widget>[
            //CircleAvatar(backgroundImage: AssetImage(imageAsset)),
            const SizedBox(width: 12),
            Text(
              type.toUpperCase(),
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[900],
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ))
          ])
        ]));
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
