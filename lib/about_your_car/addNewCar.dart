// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/about_your_car/image_car.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/filters/fuel/fuel.dart';
import 'package:prcarpolimi/filters/position/position.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/filters/vehicle/vehicle.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'dart:math';
import 'package:prcarpolimi/models/marker_to_pass.dart';

const double pinVisiblePosition = 10;
const double pinInvisiblePosition = -220;

class AddNewCar extends StatefulWidget {
  const AddNewCar({Key? key}) : super(key: key);
  @override
  _AddNewCarState createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  static late CarModel car;
  String vehicleString = '';
  String positionString = '';
  double pinPillPosition = -220;
  List<File?> images = [];

  @override
  void initState() {
    super.initState();
    car = CarModel(
      model: '',
      seats: '',
      fuel: '',
      price: '',
      vehicle: '',
      position: '',
      cid: '',
      activeOrNot: '',
    );
    PassMarker.photoCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    //position button field
    final positionButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Position()))
                  .then((data) {
                setState(() {
                  car.position = SearchCar.latSearch.toString() +
                      ',' +
                      SearchCar.lngSearch.toString();
                  positionString = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Position: " + positionString.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

//vehicle button field
    final vehicleButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Vehicle()))
                  .then((data) {
                setState(() {
                  car.vehicle = SearchCar.vehicle;
                  car.model = SearchCar.model;
                  vehicleString =
                      car.vehicle.toString() + ',' + car.model.toString();
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Vehicle: " + vehicleString,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //seats button field
    final seatsButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Seats()))
                  .then((data) {
                setState(() {
                  car.seats = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + car.seats.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //fuel button field
    final fuelButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Fuel()))
                  .then((data) {
                setState(() {
                  car.fuel = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + car.fuel.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //price button field
    final priceButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Price()))
                  .then((data) {
                setState(() {
                  car.price = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + car.price.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

//photo button field
    final photoButton = FloatingActionButton(
      onPressed: () async {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ImageCar()))
            .then((data) {
          images = data;
        });
      },
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.photo_camera),
    );

//clear button field
    final clearButton = Container(
        width: double.maxFinite,
        height: 50,
        margin: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              setState(() {
                car.fuel = '';
                car.price = '';
                car.vehicle = '';
                car.seats = '';
                car.position = '';
                car.model = '';
                positionString = '';
                vehicleString = '';
                PassMarker.photoCount = 0;
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: const Text("Clear All",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    final Storage storage = Storage();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('PrCar'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  List<CarModel> valueNull = [];
                  Navigator.pop(context, valueNull);
                }),
            actions: [
              Row(children: [
                const Text('Done!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      if (car.fuel != '' &&
                          car.position != '' &&
                          car.model != '' &&
                          car.price != '' &&
                          car.seats != '' &&
                          images.isNotEmpty) {
                        List<CarModel> cars = await _addCar(car);
                        Fluttertoast.showToast(
                            msg: 'Car added succesfully :)', fontSize: 20);
                        PassMarker.from = true;
                        setState(() {
                          int i = PassMarker.markerId;
                          PassMarker.markerId = PassMarker.markerId + 1;
                          String? carLatLng = car.position;
                          final splitted = carLatLng!.split(',');
                          double lat = double.parse(splitted[0]);
                          double lng = double.parse(splitted[1]);
                          PassMarker.markerToPass.add(Marker(
                              markerId: MarkerId('marker$i'),
                              infoWindow: const InfoWindow(title: 'My car'),
                              position: LatLng(lat, lng),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueBlue),
                              onTap: () {
                                setState(() {
                                  pinPillPosition = pinInvisiblePosition;
                                });
                              }));
                        });
                        final _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        for (int i = 0; images[i] != null && i < 6; i++) {
                          final tempPath = images[i]!.path;
                          storage.uploadCarPic(tempPath, 'imageCar$i',
                              user!.uid, PassMarker.cidAdd);
                        }
                        if (cars != []) {
                          Navigator.pop(context, cars);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'Invalid Insert: You can\'t insert a car without all the parameters choosen',
                            fontSize: 20);
                      }
                    },
                    icon: const Icon(Icons.add_task))
              ])
            ]),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(
              height: 30,
              child: Text("Insert a new car",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 25))),
          const SizedBox(height: 15),
          vehicleButton,
          const SizedBox(height: 15),
          positionButton,
          const SizedBox(height: 15),
          seatsButton,
          const SizedBox(height: 15),
          fuelButton,
          const SizedBox(height: 15),
          priceButton,
          const SizedBox(height: 15),
          photoButton,
          const SizedBox(height: 15),
          clearButton,
          const SizedBox(height: 10),
        ])));
  }

  Future<List<CarModel>> _addCar(CarModel carModel) async {
    final _auth = FirebaseAuth.instance;
    var rng = Random();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    PassMarker.cidAdd = '';
    List<CarModel> cars = [];

    carModel.activeOrNot = 't';
    carModel.uid = user!.uid.toString();
    if (user != null) {
      carModel.cid = user.uid +
          carModel.vehicle.toString() +
          rng.nextInt(1000000).toString();
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            //quando non ci sono macchine da errore
            .collection('cars')
            .doc(carModel.cid)
            .set(carModel.toMap());

        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            //quando non ci sono macchine da errore
            .collection('cars')
            .get()
            .then((ds) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "impossible to insert new car") {}
      }
    }
    PassMarker.cidAdd = carModel.cid!;
    return cars;
  }
}
