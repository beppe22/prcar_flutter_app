// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class Help extends StatefulWidget {
  Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => HelpState();
}

class HelpState extends State<Help> {
  HelpState({Key? key});

  String messaggio = '';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title:
                    Text("Help", style: TextStyle(fontSize: screenText * 20))),
            body: Center(
                child: Column(children: [
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                  height: screenHeight * 0.35,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              Text('For any problem, please \n contact us by e-mail:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Text('francesco.marin@mail.polimi.it',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold))
            ])))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      title: Text("Help",
                          style: TextStyle(fontSize: screenText * 30))),
                  body: Center(
                      child: Column(children: [
                    SizedBox(height: screenHeight * 0.1),
                    SizedBox(
                        height: screenHeight * 0.45,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                    Text('For any problem, please \n contact us by e-mail:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    Text('francesco.marin@mail.polimi.it',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold))
                  ])));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      title: Text("Help",
                          style: TextStyle(fontSize: screenText * 30))),
                  body: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Row(children: [
                          SizedBox(width: screenWidth * 0.05),
                          SizedBox(
                              height: screenHeight * 0.45,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(width: screenWidth * 0.1),
                          Column(children: [
                            Text(
                                'For any problem, please \n contact us by e-mail:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text('francesco.marin@mail.polimi.it',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold))
                          ])
                        ])
                      ])));
            }
          });
  }
}
