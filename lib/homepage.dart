// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/booking_page.dart';
import 'package:prcarpolimi/infoAccount.dart';
import 'package:prcarpolimi/cars_user.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'hamburger/filters.dart';

const double pinVisiblePosition = 10;
const double pinInvisiblePosition = -220;

class HomePage extends StatefulWidget {
  UserModel userModel;

  HomePage(this.userModel, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(userModel);
}

class _HomePageState extends State<HomePage> {
  UserModel userModel;

  _HomePageState(this.userModel);
  double pinPillPosition = pinInvisiblePosition;

  @override
  void initState() {
    super.initState();
    PassMarker.markerToPass = {};
    PassMarker.countMarker = 0;
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
                const Text('Reload!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      final _auth = FirebaseAuth.instance;
                      String? userAuth = _auth.currentUser!.uid.toString();
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
                              icon:
                                  _iconColor(cars[i].uid.toString(), userAuth),
                              onTap: () {
                                if (userAuth != cars[i].uid.toString()) {
                                  PassMarker.carModel = cars[i];
                                  setState(() {
                                    pinPillPosition = pinVisiblePosition;
                                  });
                                }
                              }));
                          PassMarker.countMarker = PassMarker.countMarker + 1;
                        });
                      }
                    },
                    icon: const Icon(Icons.autorenew_rounded))
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
                        builder: (context) => InfoAccount(userModel)));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cars_user(cars)));
                }
              }),
          ListTile(title: const Text("Help"), onTap: () {}),
          ListTile(title: const Text("Configuration"), onTap: () {})
        ])),
        body: Stack(children: [
          GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(45.47811155714095, 9.227444681728846),
                  zoom: 16),
              markers: PassMarker.markerToPass,
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
                                                  Navigator.pop(
                                                      context,
                                                      await BookingOut(
                                                              PassMarker
                                                                  .carModel.cid,
                                                              PassMarker
                                                                  .carModel.uid)
                                                          .book());
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
