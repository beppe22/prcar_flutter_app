// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/about_your_car/image_car.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/filters/fuel/fuel.dart';
import 'package:prcarpolimi/filters/position/position.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/filters/vehicle/vehicle.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

class ChangeInfoCarService {
  firebasefirestore() {
    return FirebaseFirestore.instance;
  }
}

class ChangeInfoCar extends StatefulWidget {
  final CarModel carModel;
  Service changeInfoCarService;

  ChangeInfoCar(
      {Key? key, required this.carModel, required this.changeInfoCarService})
      : super(key: key);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    List<File?> images = [];
    String nameString = vehicleString.toString() + '-' + modelString.toString();

    color() {
      if (PassMarker.useMobileLayout!) {
        return Colors.redAccent;
      } else {
        return Colors.green;
      }
    }

    height() {
      if (PassMarker.useMobileLayout!) {
        return screenHeight * 0.07;
      } else {
        return screenHeight * 0.09;
      }
    }

    text() {
      if (PassMarker.useMobileLayout!) {
        return screenText * 20;
      } else {
        return screenText * 30;
      }
    }

    width() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return screenWidth * 0.8;
      } else {
        return screenWidth * 0.5;
      }
    }

    final positionButton = Container(
        width: width(),
        height: height(),
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: color(), borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Position(service: Service())))
                  .then((data) {
                setState(() {
                  if (data != '' && data != null) {
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
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text("Position: " + _printPosition(positionString!),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: text(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))));

//vehicle button field
    final vehicleButton = Container(
        width: width(),
        height: height(),
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: color(), borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Vehicle(service: Service())))
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
            padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text("Vehicle: " + nameString,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: text(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))));

    //seats button field
    final seatsButton = Container(
        width: width(),
        height: height(),
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: color(), borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Seats(filter: false, service: Service())))
                  .then((data) {
                setState(() {
                  if (data != '' && data != null) {
                    seatsString = data;
                  }
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + seatsString.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: text(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //fuel button field
    final fuelButton = Container(
        width: width(),
        height: height(),
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: color(), borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Fuel(service: Service())))
                  .then((data) {
                setState(() {
                  if (data != '' && data != null) {
                    fuelString = data;
                  }
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + fuelString.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: text(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //price button field
    final priceButton = Container(
        width: width(),
        height: height(),
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: color(), borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Price(filter: false, service: Service())))
                  .then((data) {
                setState(() {
                  if (data != '' && data != null) {
                    priceString = data;
                  }
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + priceString.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: text(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
    return PassMarker.useMobileLayout!
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: Text('Change Car',
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: screenText * 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context, carModel);
                    }),
                actions: [
                  Row(children: [
                    Text('Change!',
                        style: TextStyle(
                            fontSize: screenText * 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          if (await NetworkCheck().check()) {
                            if (carModel.fuel == fuelString &&
                                carModel.model == modelString &&
                                carModel.position == positionString &&
                                carModel.price == priceString &&
                                carModel.seats == seatsString &&
                                carModel.vehicle == vehicleString &&
                                images.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'You change nothing :(', fontSize: 20);
                            } else {
                              _changeFirebase(
                                  carModel,
                                  seatsString!,
                                  fuelString!,
                                  modelString!,
                                  vehicleString!,
                                  priceString!,
                                  positionString!);
                              if (images.isNotEmpty) {
                                _updateImages(
                                    images, carModel.uid!, carModel.cid!);
                              }
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
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No internet connection', fontSize: 20);
                          }
                        },
                        icon: Icon(Icons.add_task, size: screenText * 25))
                  ])
                ]),
            body: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                  height: screenHeight * 0.1,
                  child: Text("Change your car's \n information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: screenText * 26))),
              SizedBox(height: screenHeight * 0.02),
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
              FloatingActionButton(
                  onPressed: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageCar(add: false)))
                        .then((data) {
                      images = data;
                    });
                  },
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.photo_album, size: screenText * 25))
            ])))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.green,
                title: Text('Change Car',
                    style: TextStyle(fontSize: screenText * 30)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: screenText * 35,
                    ),
                    onPressed: () {
                      Navigator.pop(context, carModel);
                    }),
                actions: [
                  Row(children: [
                    Text('Change!',
                        style: TextStyle(
                            fontSize: screenText * 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          if (await NetworkCheck().check()) {
                            if (carModel.fuel == fuelString &&
                                carModel.model == modelString &&
                                carModel.position == positionString &&
                                carModel.price == priceString &&
                                carModel.seats == seatsString &&
                                carModel.vehicle == vehicleString &&
                                images.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'You change nothing :(', fontSize: 20);
                            } else {
                              _changeFirebase(
                                  carModel,
                                  seatsString!,
                                  fuelString!,
                                  modelString!,
                                  vehicleString!,
                                  priceString!,
                                  positionString!);
                              if (images.isNotEmpty) {
                                _updateImages(
                                    images, carModel.uid!, carModel.cid!);
                              }
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
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No internet connection', fontSize: 20);
                          }
                        },
                        icon: Icon(Icons.add_task, size: screenText * 35))
                  ])
                ]),
            body: OrientationBuilder(builder: (_, orientation) {
              if (orientation == Orientation.portrait) {
                return Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                      SizedBox(height: screenHeight * 0.04),
                      SizedBox(
                          height: screenHeight * 0.1,
                          child: Text("Change your car's \n information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: screenText * 46))),
                      SizedBox(height: screenHeight * 0.02),
                      vehicleButton,
                      SizedBox(height: screenHeight * 0.015),
                      positionButton,
                      SizedBox(height: screenHeight * 0.015),
                      seatsButton,
                      SizedBox(height: screenHeight * 0.015),
                      fuelButton,
                      SizedBox(height: screenHeight * 0.015),
                      priceButton,
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.2,
                          child: FloatingActionButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ImageCar(add: false))).then((data) {
                                  images = data;
                                });
                              },
                              backgroundColor: Colors.green,
                              child: Icon(Icons.photo_album,
                                  size: screenText * 35)))
                    ]));
              } else {
                return Center(
                    child: Row(children: <Widget>[
                  Column(children: [
                    SizedBox(height: screenHeight * 0.1),
                    SizedBox(
                        height: screenHeight * 0.1,
                        child: Text("Change your car's \n information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: screenText * 40))),
                    SizedBox(height: screenHeight * 0.08),
                    SizedBox(
                        height: screenHeight * 0.55,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                  ]),
                  Column(children: [
                    SizedBox(height: screenHeight * 0.1),
                    vehicleButton,
                    SizedBox(height: screenHeight * 0.015),
                    positionButton,
                    SizedBox(height: screenHeight * 0.015),
                    seatsButton,
                    SizedBox(height: screenHeight * 0.015),
                    fuelButton,
                    SizedBox(height: screenHeight * 0.015),
                    priceButton,
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                        height: screenHeight * 0.13,
                        width: screenWidth * 0.2,
                        child: FloatingActionButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageCar(add: false))).then((data) {
                                images = data;
                              });
                            },
                            backgroundColor: Colors.green,
                            child:
                                Icon(Icons.photo_album, size: screenText * 35)))
                  ])
                ]));
              }
            }));
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
    FirebaseFirestore firebaseFirestore =
        widget.changeInfoCarService.firebasefirestore();
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

  void _updateImages(List<File?> images, String uid, String cid) {
    final Storage storage = Storage();
    FirebaseStorage.instance.ref("$uid/$cid/").listAll().then((value) {
      for (int i = 0; value.items.isEmpty; i++) {
        String path = value.items[i].fullPath;
        FirebaseStorage.instance.ref(path).delete();
      }
    });
    for (int i = 0; images[i] != null && i < 6; i++) {
      final tempPath = images[i]!.path;
      storage.uploadCarPic(tempPath, 'imageCar$i', uid, cid);
    }
  }
}
