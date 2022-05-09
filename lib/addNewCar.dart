// ignore_for_file: file_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/filters/fuel/fuel.dart';
import 'package:prcarpolimi/filters/position/position.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/filters/vehicle/vehicle.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'dart:math';

class AddNewCar extends StatefulWidget {
  const AddNewCar({Key? key}) : super(key: key);
  @override
  _AddNewCarState createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  static late CarModel car;
  String vehicleString = '';
  String positionString = '';

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
                      '-' +
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
                      car.vehicle.toString() + '-' + car.model.toString();
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('PrCar'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(
              height: 30,
              child: Text("Insert your own car.",
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
          clearButton,
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF0069FE),
                onPressed: () async {
                  List<CarModel> cars = await _addCar(car);
                  if (cars != []) {
                    Navigator.pop(context, cars);
                  }
                },
                child: const Text("Add new car",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
              ))
        ])));
  }

  Future<List<CarModel>> _addCar(CarModel carModel) async {
    final _auth = FirebaseAuth.instance;
    var rng = Random();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

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
    return cars;
  }
}
