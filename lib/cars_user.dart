// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:prcarpolimi/addNewCar.dart';
import 'package:prcarpolimi/info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';

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
            title: const Text('PrCar'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: ListView.builder(
            itemCount: cars == [] ? 0 : cars.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.all(8),
                  child: Expanded(
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
                                  if (cars[index].activeOrNot == 't') {
                                    suspOrAct = 'Suspend';
                                  } else {
                                    suspOrAct = 'Active';
                                  }
                                  final newCars = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InfoCar(cars[index], suspOrAct)));
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
                                        fontWeight: FontWeight.w500))),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.redAccent,
                                      spreadRadius: 6,
                                      blurRadius: 2)
                                ]))
                      ])));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newCars = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddNewCar()));
              setState(() {
                cars = newCars;
              });
            },
            backgroundColor: Colors.grey,
            tooltip: 'Add new car',
            child: const Icon(Icons.add)));
  }
}
