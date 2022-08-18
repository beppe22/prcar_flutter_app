// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'seatsbotton.dart';

class Seats extends StatelessWidget {
  bool filter;
  Service service;
  Seats({Key? key, required this.filter, required this.service})
      : super(key: key);

  late String value;
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
                    Text("Seats", style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context, '');
                    })),
            backgroundColor: Colors.white,
            body: Column(children: [
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                  height: screenHeight * 0.28,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              SizedBox(
                  height: screenHeight * 0.07,
                  child: Text(_seatsString(filter),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: screenText * 22))),
              SizedBox(height: screenHeight * 0.02),
              SeatsButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: '2'),
              SizedBox(height: screenHeight * 0.02),
              SeatsButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: '3'),
              SizedBox(height: screenHeight * 0.02),
              SeatsButton(
                  key: Key("4 seats button"),
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: '4'),
              SizedBox(height: screenHeight * 0.02),
              SeatsButton(
                  key: Key("5 seats button"),
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: '5')
            ]))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Seats",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context, '');
                          })),
                  backgroundColor: Colors.white,
                  body: Column(children: [
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                        height: screenHeight * 0.33,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                    SizedBox(
                        height: screenHeight * 0.07,
                        child: Text(_seatsString(filter),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                fontSize: screenText * 38))),
                    SizedBox(height: screenHeight * 0.02),
                    SeatsButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        screenText: screenText,
                        value: '2'),
                    SizedBox(height: screenHeight * 0.02),
                    SeatsButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        screenText: screenText,
                        value: '3'),
                    SizedBox(height: screenHeight * 0.02),
                    SeatsButton(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        screenText: screenText,
                        value: '4'),
                    SizedBox(height: screenHeight * 0.02),
                    SeatsButton(
                        key: Key("5 seats button tablet"),
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        screenText: screenText,
                        value: '5')
                  ]));
            } else {
              return Scaffold(
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Seats",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context, '');
                          })),
                  backgroundColor: Colors.white,
                  body: Center(
                      child: Row(children: [
                    SizedBox(width: screenWidth * 0.05),
                    Column(children: [
                      SizedBox(height: screenHeight * 0.15),
                      SizedBox(
                          height: screenHeight * 0.07,
                          child: Text(_seatsString(filter),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                  fontSize: screenText * 33))),
                      SizedBox(
                          height: screenHeight * 0.55,
                          child: Image.asset("assets/prcarlogo.png",
                              fit: BoxFit.contain)),
                    ]),
                    Column(children: [
                      SizedBox(height: screenHeight * 0.15),
                      SeatsButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          screenText: screenText,
                          value: '2'),
                      SizedBox(height: screenHeight * 0.02),
                      SeatsButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          screenText: screenText,
                          value: '3'),
                      SizedBox(height: screenHeight * 0.02),
                      SeatsButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          screenText: screenText,
                          value: '4'),
                      SizedBox(height: screenHeight * 0.02),
                      SeatsButton(
                          key: Key("5 seats button tablet2"),
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          screenText: screenText,
                          value: '5')
                    ])
                  ])));
            }
          });
  }

//Function that prints different title (it depends from which screen we arrive)
  String _seatsString(bool filter) {
    if (filter) {
      return 'Choose the minimum car\'s seats';
    } else {
      return 'Choose car\'s seats ';
    }
  }
}
