// ignore_for_file: must_be_immutable, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/carModel.dart';

class InfoCar extends StatelessWidget {
  CarModel carModel;

  InfoCar(this.carModel, {Key? key}) : super(key: key);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Info Car',
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
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                carModel.model.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30.8,
                    fontWeight: FontWeight.normal),
              ),
              Text(
                carModel.seats.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17.8,
                    fontWeight: FontWeight.normal),
              ),
              Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF0069FE),
                    onPressed: () async {},
                    child: const Text("Change Info",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                  )),
              /*Container(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: const Color(0xFF0069FE),
                      onPressed: () async {},
                      child: const Text("Sospend",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                    )),*/
              Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF0069FE),
                    onPressed: () async {
                      _deleteCar();
                      Navigator.pop(context, _fetchInfoCar());
                    },
                    child: const Text("Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                  ))
            ],
          ),
        ));
  }

  void _deleteCar() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          //quando non ci sono macchine da errore
          .collection('cars')
          .doc(carModel.cid)
          .delete();
    }
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
            //quando non ci sono macchine da errore
            .collection('cars')
            .get()
            .then((ds) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "cars not found") {
          print("No Cars found");
        }
      }
    }
    return cars;
  }
}
