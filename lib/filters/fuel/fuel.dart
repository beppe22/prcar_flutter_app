import 'package:flutter/material.dart';
import 'fuelbotton.dart';

class Fuel extends StatefulWidget {
  const Fuel({Key? key}) : super(key: key);
  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Fuel"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, '');
                })),
        backgroundColor: Colors.white,
        body: Column(children: [
          const SizedBox(height: 20),
          SizedBox(
              height: 150,
              child: Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          FuelButton(value: "Oil"),
          FuelButton(value: "Methane"),
          FuelButton(value: "Diesel"),
          FuelButton(value: "Electric"),
          FuelButton(value: "Hibryd"),
          FuelButton(value: "Anything")
        ]));
  }
}
