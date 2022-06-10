// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/about_your_car/image_car.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
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
    SearchCar.vehicle = '';
    SearchCar.model = '';
    PassMarker.photoCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    //position button field
    final positionButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
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
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text("Position: " + positionString.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenText * 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))))));

//vehicle button field
    final vehicleButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
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
                  if (car.vehicle != '' && car.model != '') {
                    vehicleString =
                        car.vehicle.toString() + '-' + car.model.toString();
                  } else {
                    vehicleString = '';
                  }
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text("Vehicle: " + vehicleString,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenText * 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))))));

    //seats button field
    final seatsButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Seats(filter: false))).then((data) {
                setState(() {
                  car.seats = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + car.seats.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //fuel button field
    final fuelButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
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
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + car.fuel.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //price button field
    final priceButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Price(filter: false))).then((data) {
                setState(() {
                  car.price = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + car.price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

//photo button field
    final photoButton = FloatingActionButton(
      onPressed: () async {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => ImageCar(add: true)))
            .then((data) {
          images = data;
        });
      },
      backgroundColor: Colors.redAccent,
      child: Icon(Icons.photo_camera, size: screenText * 25),
    );

//clear button field
    final clearButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
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
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Clear All",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    final Storage storage = Storage();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Add Car', style: TextStyle(fontSize: screenText * 20)),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: screenText * 25),
                onPressed: () {
                  List<CarModel> valueNull = [];
                  Navigator.pop(context, valueNull);
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
                }),
            actions: [
              Row(children: [
                Text('Done!',
                    style: TextStyle(
                        fontSize: screenText * 20,
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
                              infoWindow: InfoWindow(
                                  title: 'My car: click for details',
                                  onTap: () {
                                    String suspOrAct = 'Active';

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InfoCar(car, suspOrAct, true)));
                                  }),
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: screenHeight * 0.07,
              child: Text("Insert a new car",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: screenText * 25))),
          SizedBox(height: screenHeight * 0.015),
          vehicleButton,
          SizedBox(height: screenHeight * 0.015),
          positionButton,
          SizedBox(height: screenHeight * 0.015),
          seatsButton,
          SizedBox(height: screenHeight * 0.015),
          fuelButton,
          SizedBox(height: screenHeight * 0.015),
          priceButton,
          SizedBox(height: screenHeight * 0.015),
          photoButton,
          SizedBox(height: screenHeight * 0.015),
          clearButton,
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
