// ignore_for_file: no_logic_in_create_state, avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(
              carModel.vehicle.toString() + '-' + carModel.model.toString(),
              style: TextStyle(fontSize: screenWidth * 0.07),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: screenHeight * 0.04),
                onPressed: () async {
                  Navigator.pop(context, await _fetchInfoCar());
                })),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(
                  height: screenHeight * 0.25,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              SizedBox(height: screenHeight * 0.03),
              Container(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.9,
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
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Seats: ' + carModel.seats.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Fuel: ' + carModel.fuel.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text(
                            'Position: ' +
                                _positionString(carModel.position.toString()),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text('Price for day: ' + carModel.price.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w500,
                                backgroundColor: Colors.white)),
                        Text(
                            'Status: ' +
                                _activeString(carModel.activeOrNot.toString()),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.065,
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
              SizedBox(height: screenHeight * 0.04),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.4,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () async {
                          PassMarker.carModel = carModel;
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
                        child: Text("Change Info",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05))),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurple,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ])),
                SizedBox(width: screenWidth * 0.08),
                Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.4,
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
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.065))),
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
              SizedBox(height: screenHeight * 0.04),
              Row(children: [
                SizedBox(width: screenWidth * 0.26),
                Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.4,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () async {
                          if (await _fetchCarRes(carModel.cid!) == 0) {
                            User? user = _auth.currentUser;
                            _deleteCar(user!.uid, carModel.cid!);
                            Navigator.pop(context, _fetchInfoCar());
                            Fluttertoast.showToast(
                                msg: 'Car deleted!', fontSize: 20);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    InactiveSingleCar(car: carModel));
                          }
                        },
                        child: Text("Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.065))),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.deepPurple,
                              spreadRadius: 6,
                              blurRadius: 3)
                        ])),
                SizedBox(width: screenWidth * 0.08),
                FloatingActionButton(
                    onPressed: () async {
                      List<String> files =
                          await urlFile(carModel.uid!, carModel.cid!);
                      final List<ImageProvider> _imageProviders = [];
                      for (int i = 0; i < files.length; i++) {
                        _imageProviders.insert(
                            i, Image.network(files[i]).image);
                      }
                      MultiImageProvider multiImageProvider =
                          MultiImageProvider(_imageProviders);
                      await showImageViewerPager(context, multiImageProvider);
                    },
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.photo_album, size: screenHeight * 0.04))
              ])
            ])));
  }

  void _deleteCar(String uid, String cid) async {
    /* await FirebaseStorage.instance.ref("$uid/$cid/").listAll().then((value) {
      for (int i = 0; value.items.isEmpty; i++) {
        String path = value.items[i].fullPath;
        FirebaseStorage.instance.ref(path).delete();
      }
    });*/

    await firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('cars')
        .doc(carModel.cid)
        .delete();
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

  Future<int> _fetchCarRes(String cid) async {
    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    int i = 0;
    if (user != null) {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .doc(cid)
          .collection('booking-in')
          .get()
          .then((ds) async {
        if (ds.docs.isEmpty) {
          return i;
        } else {
          for (var book in ds.docs) {
            if (book.data()['status'] == 'c') {
              i++;
            }
          }
        }
      });
    }
    return i;
  }

  Future<List<String>> urlFile(String uid, String cid) async {
    final Storage storage = Storage();
    final firebase_storage.FirebaseStorage storage2 =
        firebase_storage.FirebaseStorage.instance;
    List<String> urlList = [];
    firebase_storage.ListResult results =
        await storage2.ref('$uid/$cid/').listAll();
    for (int i = 0; i < results.items.length; i++) {
      String url = await storage.downloadURL(uid, cid, 'imageCar$i');
      urlList.insert(i, url);
    }
    return urlList;
  }
}

class InactiveSingleCar extends StatelessWidget {
  CarModel car;
  InactiveSingleCar({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
            'You have active reservation! For the moment, click below to switch your cars disabled and then complete or cancel your reservations',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center),
        actions: <Widget>[
          Row(children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close', style: TextStyle(fontSize: 24))),
            const SizedBox(width: 110),
            TextButton(
                onPressed: () async {
                  final _auth = FirebaseAuth.instance;
                  User? user = _auth.currentUser;
                  _suspendOrActiveCar(car, user!);
                  Fluttertoast.showToast(
                      msg: 'Your car has been disabled!', fontSize: 20);
                  Navigator.of(context).pop();
                },
                child: const Text('Disable', style: TextStyle(fontSize: 24))),
          ])
        ]);
  }

  void _suspendOrActiveCar(CarModel car, User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .doc(car.cid)
          .update({'activeOrNot': 'f'});
    } on FirebaseAuthException catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
