// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:prcarpolimi/models/search_model.dart';

const double pinPillPosition = -220;

class NewMap extends StatefulWidget {
  SearchModel search;
  NewMap({Key? key, required this.search}) : super(key: key);

  @override
  _NewMapState createState() => _NewMapState(search);
}

class _NewMapState extends State<NewMap> {
  SearchModel search;

  _NewMapState(this.search);
  @override
  Widget build(BuildContext context) {
    SearchModel carSearch;
    return Scaffold(
        appBar: AppBar(
          title: const Text("PrCar"),
          backgroundColor: Colors.redAccent,
        ),
        backgroundColor: Colors.white,
        body: Stack(children: [
          const GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
                target: LatLng(45.47811155714095, 9.227444681728846), zoom: 16),
            /*markers: PassMarker.markerToPass,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onTap: (LatLng loc) {
                setState(() {
                  pinPillPosition = pinInvisiblePosition;
                });
              }*/
          ),
          AnimatedPositioned(
              left: 0,
              curve: Curves.easeInOut,
              right: 0,
              bottom: pinPillPosition,
              child: MapBottomPill(),
              duration: const Duration(milliseconds: 500))
        ]));
  }

  /*Future<List<CarModel>> _fetchCar() async {
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
  }*/

  BitmapDescriptor _iconColor(String owner, String user) {
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
