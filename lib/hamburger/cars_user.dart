// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import '../about_your_car/addNewCar.dart';

class Cars_user extends StatefulWidget {
  List<CarModel> cars;
  Service service;
  Cars_user(this.cars, {Key? key, required this.service}) : super(key: key);

  @override
  _Cars_userState createState() => _Cars_userState(cars);
}

class _Cars_userState extends State<Cars_user> {
  List<CarModel> cars;
  _Cars_userState(this.cars);

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
                title: Text('Your cars',
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: SingleChildScrollView(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  SizedBox(height: screenHeight * 0.03),
                  (cars.isEmpty)
                      ? Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.9,
                          child: Text('No cars yet :(',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: screenText * 24,
                                  fontWeight: FontWeight.bold)),
                          padding: EdgeInsets.fromLTRB(
                              screenWidth * 0.02,
                              screenHeight * 0.02,
                              screenWidth * 0.02,
                              screenHeight * 0.02),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  width: 5.0, color: Colors.redAccent),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 6,
                                    blurRadius: 2)
                              ]))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cars == [] ? 0 : cars.length,
                          itemBuilder: (context, index) {
                            return Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screenHeight * 0.03),
                                      Container(
                                          key: Key("car"),
                                          height: screenHeight * 0.07,
                                          width: screenWidth * 0.85,
                                          child: MaterialButton(
                                              color: Colors.grey.shade200,
                                              onPressed: () async {
                                                String suspOrAct = '';
                                                if (cars[index].activeOrNot ==
                                                    't') {
                                                  suspOrAct = 'Suspend';
                                                } else {
                                                  suspOrAct = 'Active';
                                                }
                                                final newCars =
                                                    await Navigator.of(context)
                                                        .push(
                                                  MaterialPageRoute(
                                                    settings:
                                                        const RouteSettings(
                                                            name: "/Page1"),
                                                    builder: (context) =>
                                                        InfoCar(cars[index],
                                                            suspOrAct, false,
                                                            service: Service()),
                                                  ),
                                                );

                                                if (newCars != []) {
                                                  setState(() {
                                                    cars = newCars;
                                                  });
                                                }
                                              },
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                      cars[index]
                                                              .vehicle
                                                              .toString() +
                                                          '-' +
                                                          cars[index]
                                                              .model
                                                              .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize:
                                                              screenText * 35,
                                                          fontWeight: FontWeight
                                                              .w500)))),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.redAccent,
                                                    spreadRadius: 6,
                                                    blurRadius: 2)
                                              ]))
                                    ]));
                          })
                ]))),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final newCars = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewCar(
                                addNewCarService: Service(),
                              )));
                  if (newCars.isNotEmpty) {
                    setState(() {
                      cars = newCars;
                    });
                  }
                },
                backgroundColor: Colors.grey,
                tooltip: 'Add new car',
                child: Icon(
                  Icons.add,
                  size: screenText * 25,
                )))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text('Your cars',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: SingleChildScrollView(
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                        SizedBox(height: screenHeight * 0.03),
                        (cars.isEmpty)
                            ? Container(
                                height: screenHeight * 0.1,
                                width: screenWidth * 0.9,
                                child: Text('No cars yet :(',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: screenText * 34,
                                        fontWeight: FontWeight.bold)),
                                padding: EdgeInsets.fromLTRB(
                                    screenWidth * 0.02,
                                    screenHeight * 0.032,
                                    screenWidth * 0.02,
                                    screenHeight * 0.02),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 5.0, color: Colors.green),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          spreadRadius: 6,
                                          blurRadius: 2)
                                    ]))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cars == [] ? 0 : cars.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            Container(
                                                height: screenHeight * 0.07,
                                                width: screenWidth * 0.85,
                                                child: MaterialButton(
                                                    color: Colors.grey.shade200,
                                                    onPressed: () async {
                                                      String suspOrAct = '';
                                                      if (cars[index]
                                                              .activeOrNot ==
                                                          't') {
                                                        suspOrAct = 'Suspend';
                                                      } else {
                                                        suspOrAct = 'Active';
                                                      }
                                                      final newCars =
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                        MaterialPageRoute(
                                                          settings:
                                                              const RouteSettings(
                                                                  name:
                                                                      "/Page1"),
                                                          builder: (context) =>
                                                              InfoCar(
                                                                  cars[index],
                                                                  suspOrAct,
                                                                  false,
                                                                  service:
                                                                      Service()),
                                                        ),
                                                      );

                                                      if (newCars != []) {
                                                        setState(() {
                                                          cars = newCars;
                                                        });
                                                      }
                                                    },
                                                    child: SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                            cars[index]
                                                                    .vehicle
                                                                    .toString() +
                                                                '-' +
                                                                cars[index]
                                                                    .model
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize:
                                                                    screenText *
                                                                        35,
                                                                fontWeight: FontWeight
                                                                    .w500)))),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.green,
                                                          spreadRadius: 6,
                                                          blurRadius: 2)
                                                    ]))
                                          ]));
                                })
                      ]))),
                  floatingActionButton: Container(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.1,
                      child: FloatingActionButton(
                          onPressed: () async {
                            final newCars = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNewCar(
                                          addNewCarService: Service(),
                                        )));
                            if (newCars.isNotEmpty) {
                              setState(() {
                                cars = newCars;
                              });
                            }
                          },
                          backgroundColor: Colors.grey,
                          tooltip: 'Add new car',
                          child: Icon(
                            Icons.add,
                            size: screenText * 25,
                          ))));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text('Your cars',
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  body: SingleChildScrollView(
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                        SizedBox(height: screenHeight * 0.03),
                        (cars.isEmpty)
                            ? Container(
                                height: screenHeight * 0.15,
                                width: screenWidth * 0.7,
                                child: Text('No cars yet :(',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: screenText * 34,
                                        fontWeight: FontWeight.bold)),
                                padding: EdgeInsets.fromLTRB(
                                    screenWidth * 0.02,
                                    screenHeight * 0.032,
                                    screenWidth * 0.02,
                                    screenHeight * 0.02),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 5.0, color: Colors.green),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          spreadRadius: 6,
                                          blurRadius: 2)
                                    ]))
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cars == [] ? 0 : cars.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                height: screenHeight * 0.03),
                                            Container(
                                                height: screenHeight * 0.15,
                                                width: screenWidth * 0.7,
                                                child: MaterialButton(
                                                    color: Colors.grey.shade200,
                                                    onPressed: () async {
                                                      String suspOrAct = '';
                                                      if (cars[index]
                                                              .activeOrNot ==
                                                          't') {
                                                        suspOrAct = 'Suspend';
                                                      } else {
                                                        suspOrAct = 'Active';
                                                      }
                                                      final newCars =
                                                          await Navigator.of(
                                                                  context)
                                                              .push(
                                                        MaterialPageRoute(
                                                          settings:
                                                              const RouteSettings(
                                                                  name:
                                                                      "/Page1"),
                                                          builder: (context) =>
                                                              InfoCar(
                                                                  cars[index],
                                                                  suspOrAct,
                                                                  false,
                                                                  service:
                                                                      Service()),
                                                        ),
                                                      );

                                                      if (newCars != []) {
                                                        setState(() {
                                                          cars = newCars;
                                                        });
                                                      }
                                                    },
                                                    child: SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                            cars[index]
                                                                    .vehicle
                                                                    .toString() +
                                                                '-' +
                                                                cars[index]
                                                                    .model
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize:
                                                                    screenText *
                                                                        35,
                                                                fontWeight: FontWeight
                                                                    .w500)))),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.green,
                                                          spreadRadius: 6,
                                                          blurRadius: 2)
                                                    ]))
                                          ]));
                                })
                      ]))),
                  floatingActionButton: Container(
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.13,
                      child: FloatingActionButton(
                          onPressed: () async {
                            final newCars = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNewCar(
                                          addNewCarService: Service(),
                                        )));
                            if (newCars.isNotEmpty) {
                              setState(() {
                                cars = newCars;
                              });
                            }
                          },
                          backgroundColor: Colors.grey,
                          tooltip: 'Add new car',
                          child: Icon(
                            Icons.add,
                            size: screenText * 25,
                          ))));
            }
          });
  }
}
