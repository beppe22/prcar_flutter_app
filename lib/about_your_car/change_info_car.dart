// ignore_for_file: no_logic_in_create_state

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
  final CarModel carModel;
  const ChangeInfoCar({Key? key, required this.carModel}) : super(key: key);
  @override
  State<ChangeInfoCar> createState() => _ChangeInfoCarState(carModel);
}

class _ChangeInfoCarState extends State<ChangeInfoCar> {
  final CarModel carModel;
  String? positionString;
  String? vehicleString;
  String? modelString;
  String? priceString;
  String? fuelString;
  String? seatsString;
  _ChangeInfoCarState(this.carModel);

  @override
  void initState() {
    super.initState();
    SearchCar.vehicle = carModel.vehicle!;
    SearchCar.model = carModel.model!;
    positionString = carModel.position;
    vehicleString = carModel.vehicle;
    modelString = carModel.model;
    fuelString = carModel.fuel;
    priceString = carModel.price;
    seatsString = carModel.seats;
  }

  @override
  Widget build(BuildContext context) {
    String nameString = vehicleString.toString() + '-' + modelString.toString();
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
                  if (data != '') {
                    positionString = SearchCar.latSearch.toString() +
                        ',' +
                        SearchCar.lngSearch.toString();
                  }
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Position: " + _printPosition(positionString!),
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
                  if (SearchCar.latSearch != '' && SearchCar.lngSearch != '') {
                    vehicleString = SearchCar.vehicle;
                    modelString = SearchCar.model;
                    nameString =
                        vehicleString.toString() + '-' + modelString.toString();
                  }
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Vehicle: " + nameString,
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
                  if (data != '') {
                    seatsString = data;
                  }
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + seatsString.toString(),
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
                  if (data != '') {
                    fuelString = data;
                  }
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + fuelString.toString(),
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
                  if (data != '') {
                    priceString = data;
                  }
                });
              });
            },
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + priceString.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Change Car'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, carModel);
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
                      //if (modify != PassMarker.carModel) {
                      _changeFirebase(
                          carModel,
                          seatsString!,
                          fuelString!,
                          modelString!,
                          vehicleString!,
                          priceString!,
                          positionString!);
                      Fluttertoast.showToast(
                          msg: 'New car\'s update :)', fontSize: 20);
                      setState(() {
                        carModel.fuel = fuelString.toString();
                        carModel.price = priceString.toString();
                        carModel.model = modelString.toString();
                        carModel.vehicle = vehicleString.toString();
                        carModel.seats = seatsString.toString();
                        carModel.position = positionString.toString();
                      });
                      Navigator.pop(context, carModel);
                      /*} else {
                        Fluttertoast.showToast(
                            msg: 'You change nothing :(', fontSize: 20);
                      }*/
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
    if (position != '') {
      List<String> splitted = position.split(',');
      newPos = splitted[0].substring(0, 7) + ',' + splitted[1].substring(0, 7);
    }
    return newPos;
  }

  void _changeFirebase(CarModel car, String seats, String fuel, String model,
      String vehicle, String price, String position) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(car.uid)
        .collection('cars')
        .doc(car.cid)
        .update({
      'fuel': fuel,
      'price': price,
      'position': position,
      'seats': seats,
      'veicol': vehicle,
      'model': model
    });
  }
}
