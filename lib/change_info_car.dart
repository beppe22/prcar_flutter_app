// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/carModel.dart';

class ChangeInfoCar extends StatelessWidget {
  CarModel carModel;
  ChangeInfoCar(this.carModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController model = TextEditingController(text: carModel.model);
    TextEditingController seats = TextEditingController(text: carModel.seats);
    TextEditingController price = TextEditingController(text: carModel.price);
    TextEditingController fuel = TextEditingController(text: carModel.fuel);
    TextEditingController vehicle =
        TextEditingController(text: carModel.vehicle);

    return MaterialApp(
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
                  const Text("Change car informations",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 50.8,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: vehicle,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: '',
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: model,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Car Model")),
                  const SizedBox(height: 44.0),
                  TextField(
                      controller: seats,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Number of seats",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: fuel,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Type of fuel",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  const SizedBox(
                    height: 44.0,
                  ),
                  TextField(
                      controller: price,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Price for day",
                        //prefixIcon: Icon(Icons.mail, color: Colors.black),
                      )),
                  /*Container(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: const Color(0xFF0069FE),
                        onPressed: () async {
                          List<CarModel> cars = await _addCar(model.text,
                              seats.text, fuel.text, vehicle.text, price.text);
                          if (cars != []) {
                            Navigator.pop(context, cars);
                          }
                        },
                        child: const Text("Add new car",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            )),
                      ))*/
                ])));
  }
}
