// ignore_for_file: no_logic_in_create_state, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/change_info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';

class InfoCar extends StatefulWidget {
  CarModel carModel;
  String supOrActive;

  InfoCar(this.carModel, this.supOrActive, {Key? key}) : super(key: key);
  @override
  State<InfoCar> createState() => _InfoCarState(carModel, supOrActive);
}

class _InfoCarState extends State<InfoCar> {
  CarModel carModel;
  String supOrActive;

  _InfoCarState(
    this.carModel,
    this.supOrActive,
  );

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('PrCar'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context, await _fetchInfoCar());
                })),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(
                  height: 200,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(height: 30),
              Container(
                  height: 175,
                  width: 350,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                            'Model: ' +
                                carModel.vehicle.toString() +
                                '-' +
                                carModel.model.toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Seats: ' + carModel.seats.toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Fuel: ' + carModel.fuel.toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text(
                            'Position: ' +
                                _positionString(carModel.position.toString()),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Price for day: ' + carModel.price.toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text(
                            'Status: ' +
                                _activeString(carModel.activeOrNot.toString()),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white))
                      ])),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.redAccent,
                            spreadRadius: 4,
                            blurRadius: 2)
                      ])),
              const SizedBox(height: 35),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    height: 60,
                    width: 150,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () async {
                          CarModel newCar = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeInfoCar(carModel)));
                          if (newCar != CarModel()) {
                            setState(() {
                              carModel = newCar;
                            });
                          }
                        },
                        child: const Text("Change Info",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20))),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurple,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ])),
                const SizedBox(width: 30),
                Container(
                    height: 60,
                    width: 150,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () async {
                          if (supOrActive == 'Active') {
                            setState(() {
                              carModel.activeOrNot = 't';
                              supOrActive = 'Suspend';
                            });
                          } else {
                            setState(() {
                              carModel.activeOrNot = 'f';
                              supOrActive = 'Active';
                            });
                          }
                          _suspendOrActiveCar();
                          Fluttertoast.showToast(
                              msg:
                                  'Car\'s status changed! Pay attention to its reservations because those are still available!',
                              fontSize: 20);
                        },
                        child: Text(supOrActive,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20))),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurple,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ]))
              ]),
              const SizedBox(height: 30),
              Container(
                  height: 60,
                  width: 150,
                  child: MaterialButton(
                      color: Colors.grey,
                      onPressed: () async {
                        _deleteCar();
                        Navigator.pop(context, _fetchInfoCar());
                      },
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.deepPurple,
                            spreadRadius: 6,
                            blurRadius: 3)
                      ]))
            ])));
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

  void _suspendOrActiveCar() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .collection('cars')
            .doc(carModel.cid)
            .set(carModel.toMap());
      } on FirebaseAuthException catch (e) {
        print(
          e.toString(),
        );
      }
    }
  }

  static Future<List<CarModel>> _fetchInfoCar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    List<CarModel> cars = [];
    if (user != null) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .collection('cars')
            .get()
            .then((ds) {
          if (ds.docs.isNotEmpty) {
            for (var car in ds.docs) {
              cars.add(CarModel.fromMap(car.data()));
            }
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "cars not found") {}
      }
    }
    return cars;
  }

  String _activeString(String active) {
    if (active == 't') {
      return 'Active';
    } else {
      return 'Inactive';
    }
  }

  String _positionString(String position) {
    String newPos = '';
    List<String> splitted = position.split('-');
    newPos = splitted[0].substring(0, 7) + '-' + splitted[1].substring(0, 7);
    return newPos;
  }
}
