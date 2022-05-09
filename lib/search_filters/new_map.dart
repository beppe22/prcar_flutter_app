// ignore_for_file: no_logic_in_create_state, must_be_immutable, unused_local_variable

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'package:prcarpolimi/models/marker_to_search.dart';
import 'package:prcarpolimi/models/search_model.dart';

const double pinVisiblePosition = 10;
const double pinInvisiblePosition = -220;

class NewMap extends StatefulWidget {
  SearchModel search;
  List<CarModel> cars;
  NewMap(this.search, this.cars, {Key? key}) : super(key: key);

  @override
  _NewMapState createState() => _NewMapState(search, cars);
}

class _NewMapState extends State<NewMap> {
  SearchModel search;
  List<CarModel> cars;

  _NewMapState(this.search, this.cars);
  double pinPillPosition = pinInvisiblePosition;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;
    String? user = _auth.currentUser!.uid.toString();
    return Scaffold(
        appBar: AppBar(
            title: const Text("PrCar"),
            backgroundColor: Colors.redAccent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  SearchMarker.markerToSearch = {};
                  SearchMarker.countMarker = 0;
                  Navigator.pop(context);
                }),
            actions: [
              Row(children: [
                const Text('Reload!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      List<CarModel> carsFiltered =
                          await _searchCar(cars, search, user);
                      for (int i = 0; i < carsFiltered.length; i++) {
                        String? carLatLng = carsFiltered[i].position;
                        final splitted = carLatLng!.split('-');
                        double lat = double.parse(splitted[0]);
                        double lng = double.parse(splitted[1]);
                        setState(() {
                          SearchMarker.markerToSearch.add(Marker(
                              markerId: MarkerId('marker$i'),
                              infoWindow:
                                  const InfoWindow(title: 'Searched car'),
                              position: LatLng(lat, lng),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                              onTap: () {
                                setState(() {
                                  pinPillPosition = pinVisiblePosition;
                                });
                              }));
                          SearchMarker.countMarker =
                              SearchMarker.countMarker + 1;
                        });
                      }
                    },
                    icon: const Icon(Icons.autorenew_rounded))
              ])
            ]),
        backgroundColor: Colors.white,
        body: Stack(children: [
          GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(45.47811155714095, 9.227444681728846),
                  zoom: 16),
              markers: SearchMarker.markerToSearch,
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

  Future<List<CarModel>> _searchCar(
      List<CarModel> cars, SearchModel search, String user) async {
    List<CarModel> filteredCar = [];
    for (int i = 0; i < cars.length; i++) {
      bool j = true;
      String owner = cars[i].uid.toString();
      if (user == owner) {
        j = false;
      }
      if (j &&
          (search.seats.toString() != '') &&
          (int.parse(search.seats.toString()) >
              int.parse(cars[i].seats.toString()))) {
        j = false;
      }
      if (j &&
          (search.fuel.toString() != '') &&
          (search.fuel != cars[i].fuel)) {
        j = false;
      }
      String modelSearch = '';
      if (search.vehicle.toString() != '') {
        String toSplit = search.vehicle.toString();
        final splitted = toSplit.split('-');
        modelSearch = splitted[1];
      }
      if (j &&
          (search.vehicle.toString() != '') &&
          (modelSearch != cars[i].model)) {
        j = false;
      }
      if (j &&
          (search.price.toString() != '') &&
          (int.parse(search.price.toString()) <
              int.parse(cars[i].price.toString()))) {
        j = false;
      }
      if (j &&
          (SearchCar.latSearch.toString() != '') &&
          (_nearbyPosition(SearchCar.latSearch, SearchCar.lngSearch,
              cars[i].position.toString()))) {
        j = false;
      }
      if (j) {
        filteredCar.add(cars[i]);
      }
    }
    return filteredCar;
  }

  bool _nearbyPosition(String lat, String lng, String carsPos) {
    double lat1 = double.parse(lat) / 57.29577951;
    double lng1 = double.parse(lng) / 57.29577951;
    final splitted = carsPos.split('-');
    double lat2 = double.parse(splitted[0]) / 57.29577951;
    double lng2 = double.parse(splitted[1]) / 57.29577951;
    double distance = 3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(lng2 - lng1)) *
        1.609344;
    return distance > 3;
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
