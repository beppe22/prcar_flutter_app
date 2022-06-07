// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/configuration/front_license.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final drivingLicenseCodeEditingController = TextEditingController();
  final expiryDateEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final licenseCodeField = TextFormField(
        autofocus: false,
        controller: drivingLicenseCodeEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Driving License code can't be Empty");
          }
          return null;
        },
        onSaved: (value) {
          drivingLicenseCodeEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Driving License Code",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //second name field
    final expiryDateEditingField = TextFormField(
        autofocus: false,
        controller: expiryDateEditingController,
        //keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Expiry Date can't be Empty");
          }
          try {
            if (int.parse((date.year).toString()) >
                    int.parse(value.toString().substring(6)) ||
                (int.parse((date.year).toString()) ==
                        int.parse(value.toString().substring(6)) &&
                    int.parse((date.month).toString()) >
                        int.parse(value.toString().substring(3, 5))) ||
                (int.parse((date.year).toString()) ==
                        int.parse(value.toString().substring(6)) &&
                    int.parse((date.month).toString()) ==
                        int.parse(value.toString().substring(3, 5)) &&
                    int.parse((date.day).toString()) >
                        int.parse(value.toString().substring(0, 2)))) {
              return ("Expiry Date already passed");
            }
          } on FormatException {
            return ("Wrong Date Format");
          }
          if (value.toString()[2] != '/' ||
              value.toString()[5] != '/' ||
              value.length != 10) {
            return ("Wrong Date Format");
          }
          try {
            if (int.parse(value[0]) > 3 || int.parse(value[3]) > 1) {
              return ("Wrong Date Format");
            }
          } on FormatException {
            return ("Wrong Date Format");
          }
          return null;
        },
        onSaved: (value) {
          expiryDateEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Expiry date (dd/MM/yyyy)",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    return !PassMarker.driveInserted
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: const Text('Driving license'),
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          const SizedBox(height: 20),
                          const Text(
                              'You need to insert your driving license code, the  ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                          const Text('expiry date of your driving license and ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                          const Text(
                              'front/bottom picture of your driving license',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          SizedBox(
                              height: 250,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          const SizedBox(height: 20),
                          licenseCodeField,
                          const SizedBox(height: 20),
                          expiryDateEditingField,
                          const SizedBox(height: 20),
                          Container(
                              height: 90,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 5.0, color: Colors.grey)),
                              child: (MaterialButton(
                                  onPressed: () {
                                    nextPage();
                                  },
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: const Text(
                                      "Insert driving license picture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))))
                        ])))))
        : Scaffold(
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
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(height: 35),
              Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      border: Border.all(width: 5.0, color: Colors.grey)),
                  child: (MaterialButton(
                      onPressed: () {
                        final _auth = FirebaseAuth.instance;
                        User? user = _auth.currentUser;
                        PassMarker.driveInserted = false;
                        _deleteDrivingLicense(user!.uid);
                        Fluttertoast.showToast(
                            msg: 'Driving license info resetted succesfully :)',
                            fontSize: 20);
                        Navigator.pop(context);
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

  void nextPage() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FrontLicense(
                  drivingCode: drivingLicenseCodeEditingController.text,
                  expiryDate: expiryDateEditingController.text)));
    }
  }

  _deleteDrivingLicense(String uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final delete1 =
        storage.ref().child("$uid/drivingLicenseData/bottomLicense");
    await delete1.delete();
    final delete2 = storage.ref().child("$uid/drivingLicenseData/frontLicense");
    await delete2.delete();
    final delete3 = storage.ref().child("$uid/drivingLicenseData/expiryDate");
    await delete3.delete();
    final delete4 = storage.ref().child("$uid/drivingLicenseData/drivingCode");
    await delete4.delete();
  }
}
