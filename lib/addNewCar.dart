// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'dart:math';

class AddNewCar extends StatelessWidget {
  AddNewCar({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController model = TextEditingController();
    TextEditingController seats = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController fuel = TextEditingController();
    TextEditingController vehicle = TextEditingController();

    return MaterialApp(
        home: Scaffold(
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
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add car informations",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50.8,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: vehicle,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Car Vehicle",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: model,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Car Model")),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: seats,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Number of seats",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: fuel,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Type of fuel",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: price,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Price for day",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: const Color(0xFF0069FE),
                        onPressed: () async {
                          List<CarModel> cars = await _addCar(model.text,
                              seats.text, fuel.text, vehicle.text, price.text);
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

  Future<List<CarModel>> _addCar(String model, String seats, String fuel,
      String vehicle, String price) async {
    var rng = Random();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    CarModel carModel = CarModel();
    List<CarModel> cars = [];

    carModel.model = model;
    carModel.fuel = fuel;
    carModel.price = price;
    carModel.vehicle = vehicle;
    carModel.seats = seats;
    carModel.active_or_not = 't';

    if (user != null) {
      carModel.cid = user.uid + vehicle + rng.nextInt(1000000).toString();
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
