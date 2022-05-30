// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/filters/fuel/fuel.dart';
import 'package:prcarpolimi/filters/position/position.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/filters/vehicle/vehicle.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';

class ChangeInfoCar extends StatefulWidget {
  CarModel carModel;
  ChangeInfoCar(this.carModel, {Key? key}) : super(key: key);
  @override
  State<ChangeInfoCar> createState() => _ChangeInfoCarState(carModel);
}

class _ChangeInfoCarState extends State<ChangeInfoCar> {
  CarModel carModel;
  CarModel modify = CarModel();
  _ChangeInfoCarState(this.carModel);

  @override
  void initState() {
    super.initState();
    modify = carModel;
  }

  @override
  Widget build(BuildContext context) {
    String positionString = modify.position.toString();
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
                  modify.position = SearchCar.latSearch.toString() +
                      '-' +
                      SearchCar.lngSearch.toString();
                  positionString = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Position: " + _printPosition(positionString),
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
                  modify.vehicle = SearchCar.vehicle;
                  modify.model = SearchCar.model;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text(
                "Vehicle: " +
                    modify.vehicle.toString() +
                    '-' +
                    modify.model.toString(),
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
                  modify.seats = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + modify.seats.toString(),
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
                  modify.fuel = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + modify.fuel.toString(),
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
                  modify.price = data;
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + modify.price.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                  CarModel valueNull = carModel;
                  Navigator.pop(context, valueNull);
                }),
            actions: [
              Row(children: [
                const Text('Change!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      if (modify != carModel) {
                        _changeFirebase(modify);
                        Fluttertoast.showToast(
                            msg: 'New car\'s update :)', fontSize: 20);
                        Navigator.pop(context, modify);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'You change nothing :(', fontSize: 20);
                      }
                    },
                    icon: const Icon(Icons.add_task))
              ])
            ]),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const SizedBox(
              height: 40,
              child: Text("Change your car's",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 35))),
          const SizedBox(height: 15),
          const SizedBox(
              height: 40,
              child: Text("information",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 35))),
          const SizedBox(height: 35),
          vehicleButton,
          const SizedBox(height: 15),
          positionButton,
          const SizedBox(height: 15),
          seatsButton,
          const SizedBox(height: 15),
          fuelButton,
          const SizedBox(height: 15),
          priceButton,
          const SizedBox(height: 15)
        ])));
  }

  String _printPosition(String position) {
    String newPos = '';
    List<String> splitted = position.split('-');
    newPos = splitted[0].substring(0, 7) + '-' + splitted[1].substring(0, 7);
    return newPos;
  }

  void _changeFirebase(CarModel car) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(car.uid)
        .collection('cars')
        .doc(car.cid)
        .update({
      'fuel': modify.fuel,
      'price': modify.price,
      'position': modify.position,
      'seats': modify.seats,
      'veicol': modify.vehicle,
      'model': modify.model
    });
  }
}
