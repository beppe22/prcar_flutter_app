// ignore_for_file: must_be_immutable, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/addNewCar.dart';
import 'package:prcarpolimi/models/carModel.dart';

class InfoCar extends StatelessWidget {
  List<CarModel> cars;
  InfoCar(this.cars, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'About your car',
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
                  Text(cars[0].model.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30.8,
                          fontWeight: FontWeight.normal)),
                  Text(cars[0].color.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.8,
                          fontWeight: FontWeight.normal)),
                  Text(cars[0].seats.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.8,
                          fontWeight: FontWeight.normal))
                ]),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNewCar()));
                },
                tooltip: 'Add new car',
                child: const Icon(Icons.add))));
  }
}
