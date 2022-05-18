// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

import 'configuration.dart';

class Configuration2 extends StatefulWidget {
  const Configuration2({Key? key}) : super(key: key);

  @override
  State<Configuration2> createState() => _Configuration2State();
}

class _Configuration2State extends State<Configuration2> {
  final drivingLicenseCodeEditingController = TextEditingController();
  final expiryDateEditingController = TextEditingController();

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
        body: Center(
            child: Column(children: [
          const SizedBox(height: 35),
          const Text(
            'Driving License info already inserted, click below for reset your info',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent),
          ),
          const SizedBox(height: 35),
          SizedBox(
              height: 250,
              child: Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          const SizedBox(height: 35),
          Container(
              height: 70,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () {
                    PassMarker.driveInserted2 = false;
                    PassMarker.returnHP = true;
                    Fluttertoast.showToast(
                        msg: 'Driving license info resetted succesfully :)',
                        fontSize: 20);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Configuration()));
                  },
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text("Reset driving license info!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))))
        ])));
  }
}
