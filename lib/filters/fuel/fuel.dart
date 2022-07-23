// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'fuelbotton.dart';

class Fuel extends StatefulWidget {
  Service service;
  Fuel({Key? key, required this.service}) : super(key: key);
  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text("Fuel", style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context, '');
                    })),
            backgroundColor: Colors.white,
            body: Column(children: [
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                  height: screenHeight * 0.2,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              SizedBox(
                  height: screenHeight * 0.045,
                  child: Text("Choose the fuel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: screenText * 22))),
              FuelButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: "Oil"),
              SizedBox(height: screenHeight * 0.01),
              FuelButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: "Methane"),
              SizedBox(height: screenHeight * 0.01),
              FuelButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: "Diesel"),
              SizedBox(height: screenHeight * 0.01),
              FuelButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: "Electric"),
              SizedBox(height: screenHeight * 0.01),
              FuelButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: "Hibryd")
            ]))
        : Container();
  }
}
