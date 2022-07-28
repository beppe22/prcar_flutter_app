// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:prcarpolimi/services/services.dart';

class InfoCar extends StatefulWidget {
  CarModel carModel;
  String supOrActive;
  bool homepage;
  Service service;

  InfoCar(this.carModel, this.supOrActive, this.homepage,
      {required this.service, Key? key})
      : super(key: key);
  @override
  State<InfoCar> createState() =>
      _InfoCarState(carModel, supOrActive, homepage);
}

class _InfoCarState extends State<InfoCar> {
  CarModel carModel;
  String supOrActive;
  bool homepage;

  _InfoCarState(this.carModel, this.supOrActive, this.homepage);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: Text(
                    carModel.vehicle.toString() +
                        '-' +
                        carModel.model.toString(),
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: homepage
                        ? Icon(Icons.cancel, size: screenText * 25)
                        : Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () async {
                      Navigator.pop(context, await _fetchInfoCar());
                    })),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                      height: screenHeight * 0.21,
                      child: Image.asset("assets/prcarlogo.png",
                          fit: BoxFit.contain)),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.95,
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
                                    fontSize: screenText * 22,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.white)),
                            Text('Seats: ' + carModel.seats.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenText * 22,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.white)),
                            Text('Fuel: ' + carModel.fuel.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenText * 22,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.white)),
                            Text(
                                'Position: ' +
                                    _positionString(
                                        carModel.position.toString()),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenText * 22,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.white)),
                            Text('Price for day: ' + carModel.price.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenText * 22,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: Colors.white)),
                            Text(
                                'Status: ' +
                                    _activeString(
                                        carModel.activeOrNot.toString()),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: screenText * 22,
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
                            key: Key("change info button"),
                            color: Colors.grey,
                            onPressed: () async {
                              PassMarker.carModel = carModel;
                              CarModel newCar = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangeInfoCar(
                                          carModel: carModel,
                                          changeInfoCarService: Service())));
                              if (newCar != CarModel()) {
                                setState(() {
                                  carModel = newCar;
                                });
                              }
                            },
                            child: Text("Change Info",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenText * 20))),
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
                      key: Key("active/suspend button"),
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.4,
                        child: MaterialButton(
                            color: Colors.grey,
                            onPressed: () async {
                              if (await NetworkCheck().check()) {
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
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'No internet connection',
                                    fontSize: 20);
                              }
                            },
                            child: Text(supOrActive,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenText * 23))),
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
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text(
                                                'Are you sure to delete this car?',
                                                style: TextStyle(
                                                    fontSize: screenText * 26,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center),
                                            actions: <Widget>[
                                              Row(children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Close',
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText *
                                                                    22))),
                                                SizedBox(
                                                    width: screenWidth * 0.35),
                                                TextButton(
                                                    onPressed: () async {
                                                      if (await NetworkCheck()
                                                          .check()) {
                                                        User? user = widget
                                                            .service
                                                            .currentUser();
                                                        await _deleteCar(
                                                            user!.uid,
                                                            carModel.cid!);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context,
                                                            _fetchInfoCar());
                                                        Fluttertoast.showToast(
                                                            msg: 'Car deleted!',
                                                            fontSize: 20);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No internet connection',
                                                            fontSize: 20);
                                                      }
                                                    },
                                                    child: Text('Yes!',
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText *
                                                                    22)))
                                              ])
                                            ]));
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
                          if (await NetworkCheck().check()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );
                            List<String> files =
                                await urlFile(carModel.uid!, carModel.cid!);
                            final List<ImageProvider> _imageProviders = [];
                            for (int i = 0; i < files.length; i++) {
                              _imageProviders.insert(
                                  i, Image.network(files[i]).image);
                            }
                            MultiImageProvider multiImageProvider =
                                MultiImageProvider(_imageProviders);
                            await showImageViewerPager(
                                context, multiImageProvider);
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No internet connection', fontSize: 20);
                          }
                        },
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.photo_album, size: screenText * 25))
                  ])
                ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text(
                          carModel.vehicle.toString() +
                              '-' +
                              carModel.model.toString(),
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: homepage
                              ? Icon(Icons.cancel, size: screenText * 35)
                              : Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () async {
                            Navigator.pop(context, await _fetchInfoCar());
                          })),
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        SizedBox(height: screenHeight * 0.03),
                        SizedBox(
                            height: screenHeight * 0.32,
                            child: Image.asset("assets/prcarlogo.png",
                                fit: BoxFit.contain)),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.8,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                      'Model: ' +
                                          carModel.vehicle.toString() +
                                          '-' +
                                          carModel.model.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white)),
                                  Text('Seats: ' + carModel.seats.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white)),
                                  Text('Fuel: ' + carModel.fuel.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white)),
                                  Text(
                                      'Position: ' +
                                          _positionString(
                                              carModel.position.toString()),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white)),
                                  Text(
                                      'Price for day: ' +
                                          carModel.price.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: Colors.white)),
                                  Text(
                                      'Status: ' +
                                          _activeString(
                                              carModel.activeOrNot.toString()),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: screenText * 40,
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: screenHeight * 0.07,
                                  width: screenWidth * 0.4,
                                  child: MaterialButton(
                                      key: Key("change info button tablet"),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        PassMarker.carModel = carModel;
                                        CarModel newCar = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangeInfoCar(
                                                        carModel: carModel,
                                                        changeInfoCarService:
                                                            Service())));
                                        if (newCar != CarModel()) {
                                          setState(() {
                                            carModel = newCar;
                                          });
                                        }
                                      },
                                      child: Text("Change Info",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenText * 40))),
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
                                        if (await NetworkCheck().check()) {
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
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'No internet connection',
                                              fontSize: 20);
                                        }
                                      },
                                      child: Text(supOrActive,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenText * 40))),
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
                                    if (await _fetchCarRes(carModel.cid!) ==
                                        0) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: Text(
                                                      'Are you sure to delete this car?',
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenText * 36,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                  actions: <Widget>[
                                                    Row(children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Close',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      screenText *
                                                                          32))),
                                                      SizedBox(
                                                          width: screenWidth *
                                                              0.38),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (await NetworkCheck()
                                                                .check()) {
                                                              User? user = widget
                                                                  .service
                                                                  .currentUser();
                                                              await _deleteCar(
                                                                  user!.uid,
                                                                  carModel
                                                                      .cid!);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context,
                                                                  _fetchInfoCar());
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Car deleted!',
                                                                      fontSize:
                                                                          20);
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'No internet connection',
                                                                      fontSize:
                                                                          20);
                                                            }
                                                          },
                                                          child: Text('Yes!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      screenText *
                                                                          32)))
                                                    ])
                                                  ]));
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
                                          fontSize: screenText * 40))),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.deepPurple,
                                        spreadRadius: 6,
                                        blurRadius: 3)
                                  ])),
                          Container(
                              height: screenHeight * 0.07,
                              width: screenWidth * 0.3,
                              child: FloatingActionButton(
                                  onPressed: () async {
                                    if (await NetworkCheck().check()) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                      List<String> files = await urlFile(
                                          carModel.uid!, carModel.cid!);
                                      final List<ImageProvider>
                                          _imageProviders = [];
                                      for (int i = 0; i < files.length; i++) {
                                        _imageProviders.insert(
                                            i, Image.network(files[i]).image);
                                      }
                                      MultiImageProvider multiImageProvider =
                                          MultiImageProvider(_imageProviders);
                                      await showImageViewerPager(
                                          context, multiImageProvider);
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'No internet connection',
                                          fontSize: 20);
                                    }
                                  },
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.photo_album,
                                      size: screenText * 35)))
                        ])
                      ])));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text(
                          carModel.vehicle.toString() +
                              '-' +
                              carModel.model.toString(),
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: homepage
                              ? Icon(Icons.cancel, size: screenText * 35)
                              : Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () async {
                            Navigator.pop(context, await _fetchInfoCar());
                          })),
                  body: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Column(children: [
                          SizedBox(height: screenHeight * 0.1),
                          SizedBox(
                              height: screenHeight * 0.35,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                              height: screenHeight * 0.38,
                              width: screenWidth * 0.43,
                              child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        'Model: ' +
                                            carModel.vehicle.toString() +
                                            '-' +
                                            carModel.model.toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white)),
                                    Text('Seats: ' + carModel.seats.toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white)),
                                    Text('Fuel: ' + carModel.fuel.toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white)),
                                    Text(
                                        'Position: ' +
                                            _positionString(
                                                carModel.position.toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white)),
                                    Text(
                                        'Price for day: ' +
                                            carModel.price.toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
                                            fontWeight: FontWeight.w500,
                                            backgroundColor: Colors.white)),
                                    Text(
                                        'Status: ' +
                                            _activeString(carModel.activeOrNot
                                                .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: screenText * 35,
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
                                  ]))
                        ]),
                        SizedBox(width: screenWidth * 0.1),
                        Column(children: [
                          SizedBox(height: screenHeight * 0.15),
                          Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.4,
                              child: MaterialButton(
                                  key: Key("change info button tablet2"),
                                  color: Colors.grey,
                                  onPressed: () async {
                                    PassMarker.carModel = carModel;
                                    CarModel newCar = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChangeInfoCar(
                                                carModel: carModel,
                                                changeInfoCarService:
                                                    Service())));
                                    if (newCar != CarModel()) {
                                      setState(() {
                                        carModel = newCar;
                                      });
                                    }
                                  },
                                  child: Text("Change Info",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenText * 40))),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.deepPurple,
                                        spreadRadius: 6,
                                        blurRadius: 3)
                                  ])),
                          SizedBox(height: screenHeight * 0.1),
                          Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.4,
                              child: MaterialButton(
                                  color: Colors.grey,
                                  onPressed: () async {
                                    if (await NetworkCheck().check()) {
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
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'No internet connection',
                                          fontSize: 20);
                                    }
                                  },
                                  child: Text(supOrActive,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenText * 40))),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.deepPurple,
                                        spreadRadius: 6,
                                        blurRadius: 3)
                                  ])),
                          SizedBox(height: screenHeight * 0.1),
                          Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.4,
                              child: MaterialButton(
                                  color: Colors.grey,
                                  onPressed: () async {
                                    if (await _fetchCarRes(carModel.cid!) ==
                                        0) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: Text(
                                                      'Are you sure to delete this car?',
                                                      style: TextStyle(
                                                          fontSize:
                                                              screenText * 36,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center),
                                                  actions: <Widget>[
                                                    Row(children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Close',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      screenText *
                                                                          32))),
                                                      SizedBox(
                                                          width: screenWidth *
                                                              0.38),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (await NetworkCheck()
                                                                .check()) {
                                                              User? user = widget
                                                                  .service
                                                                  .currentUser();
                                                              await _deleteCar(
                                                                  user!.uid,
                                                                  carModel
                                                                      .cid!);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context,
                                                                  _fetchInfoCar());
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Car deleted!',
                                                                      fontSize:
                                                                          20);
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'No internet connection',
                                                                      fontSize:
                                                                          20);
                                                            }
                                                          },
                                                          child: Text('Yes!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      screenText *
                                                                          32)))
                                                    ])
                                                  ]));
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
                                          fontSize: screenText * 40))),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.deepPurple,
                                        spreadRadius: 6,
                                        blurRadius: 3)
                                  ])),
                          SizedBox(height: screenHeight * 0.05),
                          Container(
                              height: screenHeight * 0.13,
                              width: screenWidth * 0.30,
                              child: FloatingActionButton(
                                  onPressed: () async {
                                    if (await NetworkCheck().check()) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                      List<String> files = await urlFile(
                                          carModel.uid!, carModel.cid!);
                                      final List<ImageProvider>
                                          _imageProviders = [];
                                      for (int i = 0; i < files.length; i++) {
                                        _imageProviders.insert(
                                            i, Image.network(files[i]).image);
                                      }
                                      MultiImageProvider multiImageProvider =
                                          MultiImageProvider(_imageProviders);
                                      await showImageViewerPager(
                                          context, multiImageProvider);
                                      Navigator.pop(context);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'No internet connection',
                                          fontSize: 20);
                                    }
                                  },
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.photo_album,
                                      size: screenText * 40)))
                        ])
                      ])));
            }
          });
  }

  Future<void> _deleteCar(String uid, String cid) async {
    await widget.service
        .firebasefirestore()
        .collection('users')
        .doc(uid)
        .collection('cars')
        .doc(carModel.cid)
        .delete();
  }

  void _suspendOrActiveCar() async {
    User? user = widget.service.currentUser();

    if (user != null) {
      try {
        await widget.service
            .firebasefirestore()
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

  Future<List<CarModel>> _fetchInfoCar() async {
    User? user = widget.service.currentUser();
    List<CarModel> cars = [];
    if (user != null) {
      try {
        await widget.service
            .firebasefirestore()
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
    List<String> splitted = position.split(',');
    newPos = splitted[0].substring(0, 7) + ',' + splitted[1].substring(0, 7);
    return newPos;
  }

  Future<int> _fetchCarRes(String cid) async {
    User? user = widget.service.currentUser();
    int i = 0;
    if (user != null) {
      await widget.service
          .firebasefirestore()
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
    final screenWidth = MediaQuery.of(context).size.width;
    return PassMarker.useMobileLayout!
        ? AlertDialog(
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
                      child:
                          const Text('Close', style: TextStyle(fontSize: 24))),
                  const SizedBox(width: 90),
                  TextButton(
                      onPressed: () async {
                        final _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        _suspendOrActiveCar(car, user!);
                        Fluttertoast.showToast(
                            msg: 'Your car has been disabled!', fontSize: 20);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Disable',
                          style: TextStyle(fontSize: 24))),
                ])
              ])
        : AlertDialog(
            title: const Text(
                'You have active reservation! For the moment, click below to switch your cars disabled and then complete or cancel your reservations',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center),
            actions: <Widget>[
                Row(children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                          const Text('Close', style: TextStyle(fontSize: 34))),
                  SizedBox(width: screenWidth * 0.57),
                  TextButton(
                      onPressed: () async {
                        final _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        _suspendOrActiveCar(car, user!);
                        Fluttertoast.showToast(
                            msg: 'Your car has been disabled!', fontSize: 20);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Disable',
                          style: TextStyle(fontSize: 34))),
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
