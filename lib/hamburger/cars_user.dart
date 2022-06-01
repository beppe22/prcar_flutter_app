// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';
import '../about_your_car/addNewCar.dart';

class Cars_user extends StatefulWidget {
  List<CarModel> cars;
  Cars_user(this.cars, {Key? key}) : super(key: key);

  @override
  _Cars_userState createState() => _Cars_userState(cars);
}

class _Cars_userState extends State<Cars_user> {
  List<CarModel> cars;
  _Cars_userState(this.cars);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Your cars'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 40),
              (cars.isEmpty)
                  ? Container(
                      height: 70,
                      width: 350,
                      child: const Text('No cars yet :(',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 5.0, color: Colors.redAccent),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 6,
                                blurRadius: 2)
                          ]))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cars == [] ? 0 : cars.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                      height: 50,
                                      width: 350,
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
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            InfoCar(cars[index],
                                                                suspOrAct)));
                                            if (newCars != []) {
                                              setState(() {
                                                cars = newCars;
                                              });
                                            }
                                          },
                                          child: Text(
                                              cars[index].vehicle.toString() +
                                                  '-' +
                                                  cars[index].model.toString(),
                                              style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 35,
                                                  fontWeight:
                                                      FontWeight.w500))),
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
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newCars = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddNewCar()));
              if (newCars.isNotEmpty) {
                setState(() {
                  cars = newCars;
                });
              }
            },
            backgroundColor: Colors.grey,
            tooltip: 'Add new car',
            child: const Icon(Icons.add)));
  }
}