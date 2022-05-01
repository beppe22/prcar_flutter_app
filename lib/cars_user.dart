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
                },
              ),
            ),
            body: ListView.builder(
                itemCount: cars == [] ? 0 : cars.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 6),
                      child: Container(
                          color: Colors.redAccent,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10, height: 50),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: RawMaterialButton(
                                                    fillColor:
                                                        const Color(0xFF0069FE),
                                                    onPressed: () async {
                                                      final new_cars =
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      InfoCar(cars[
                                                                          index])));

                                                      if (new_cars != []) {
                                                        setState(() {
                                                          cars = new_cars;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      cars[index]
                                                          .vehicle
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 30.8,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  )),
                                            ])))
                              ])));
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final newCars = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNewCar()));
                setState(() {
                  cars = newCars;
                });
              },
              tooltip: 'Add new car',
              child: const Icon(Icons.add),
            )));
  }
}
