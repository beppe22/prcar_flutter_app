// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              IconButton(
                  onPressed: () async {
                    List<CarModel> cars = await _fetchInfoCar();
                    for (int i = 0; i < cars.length; i++) {
                      String? carLatLng = cars[i].position;
                      final splitted = carLatLng!.split('-');
                      double lat = double.parse(splitted[0]);
                      double lng = double.parse(splitted[1]);
                      setState(() {
                        PassMarker.markerToPass.add(Marker(
                            markerId: MarkerId('marker$i'),
                            infoWindow: InfoWindow(
                              title: 'Car$i',
                              //snippet: 'Car of ${cars[i].cid}'
                            ),
                            position: LatLng(lat, lng),
                            icon: _iconColor(cars[i].cid.toString()),
                            onTap: () {
                              setState(() {
                                pinPillPosition = pinVisiblePosition;
                              });
                            }));
                        PassMarker.countMarker = PassMarker.countMarker + 1;
                      });
                    }
                  },
                  icon: const Icon(Icons.approval)),
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
              child: MapBottomPill(),
              duration: const Duration(milliseconds: 500))
        ]));
  }

  static Future<List<CarModel>> _fetchInfoCar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    CarModel carModel = CarModel();
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

  BitmapDescriptor _iconColor(String owner) {
    final _auth = FirebaseAuth.instance;
    String? user = _auth.currentUser.toString();
    if (owner == user) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}

class MapBottomPill extends StatelessWidget {
  MapBottomPill({Key? key}) : super(key: key);

  final carButton = Container(
      width: 140,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('Reserve'),
      ));

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
                    child: Image.asset(
                  'assets/prcarlogo.png',
                  width: 100,
                  height: 85,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                )),
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
                  carButton
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
              ])),
        ]));
  }
}
