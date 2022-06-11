// ignore_for_file: body_might_complete_normally_nullable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/configuration/front_license.dart';

class Configuration extends StatefulWidget {
  String isConfirmed;
  Configuration({Key? key, required this.isConfirmed}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState(isConfirmed);
}

class _ConfigurationState extends State<Configuration> {
  final drivingLicenseCodeEditingController = TextEditingController();
  final expiryDateEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  String isConfirmed;
  _ConfigurationState(this.isConfirmed);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
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
            prefixIcon: Icon(Icons.key, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Driving License Code",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //second name field
    final expiryDateEditingField = TextFormField(
        autofocus: false,
        controller: expiryDateEditingController,
        keyboardType: TextInputType.datetime,
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
            prefixIcon: Icon(Icons.calendar_today, size: screenText * 25),
            contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.02,
                screenHeight * 0.015, screenWidth * 0.02, screenHeight * 0.015),
            hintText: "Expiry date (dd/MM/yyyy)",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    return isConfirmed == 'negative'
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                title: Text('Configuration',
                    style: TextStyle(fontSize: screenText * 20)),
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          SizedBox(height: screenHeight * 0.05),
                          Text('Insert your driving license info!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: screenText * 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: screenHeight * 0.05),
                          SizedBox(
                              height: screenHeight * 0.3,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.04),
                          licenseCodeField,
                          SizedBox(height: screenHeight * 0.02),
                          expiryDateEditingField,
                          SizedBox(height: screenHeight * 0.05),
                          Container(
                              height: screenHeight * 0.13,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 5.0, color: Colors.grey)),
                              child: (MaterialButton(
                                  onPressed: () {
                                    nextPage();
                                  },
                                  padding: EdgeInsets.fromLTRB(
                                      screenWidth * 0.02,
                                      screenHeight * 0.015,
                                      screenWidth * 0.02,
                                      screenHeight * 0.015),
                                  child: Text("Insert driving license pictures",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: screenText * 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)))))
                        ])))))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text('Configuration',
                    style: TextStyle(fontSize: screenText * 20)),
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: Center(
                child: Column(children: [
              SizedBox(height: screenHeight * 0.05),
              isConfirmed == 'confirmed'
                  ? Text('Your driving license has been approved :)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey))
                  : Text(
                      'Driving License is under administrator\'s control',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
              SizedBox(height: screenHeight * 0.1),
              isConfirmed == 'confirmed'
                  ? Column(children: [
                      SizedBox(
                          height: screenHeight * 0.4,
                          child: Image.asset("assets/prcarlogo.png",
                              fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.04),
                      Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border:
                                  Border.all(width: 5.0, color: Colors.grey)),
                          child: (MaterialButton(
                              onPressed: () async {
                                if (await NetworkCheck().check()) {
                                  final _auth = FirebaseAuth.instance;
                                  User? user = _auth.currentUser;
                                  _updateIsConfirmed(user!);
                                  _deleteDrivingLicense(user.uid);
                                  Fluttertoast.showToast(
                                      msg:
                                          'Driving license info resetted succesfully :)',
                                      fontSize: 20);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'No internet connection',
                                      fontSize: 20);
                                }
                              },
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02,
                                  screenHeight * 0.015,
                                  screenWidth * 0.02,
                                  screenHeight * 0.015),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text("Reset driving license info!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenText * 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)))))
                    ])
                  : Column(children: [
                      SizedBox(
                          height: screenHeight * 0.25,
                          child: Image.asset("assets/prcarlogo.png",
                              fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.03),
                      Text(
                        'Your driving license\'s control will \n be fast :)',
                        style: TextStyle(
                            fontSize: screenText * 18, color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      SizedBox(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.2,
                          child: const CircularProgressIndicator(
                            color: Colors.grey,
                          ))
                    ])
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

  _updateIsConfirmed(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update({'isConfirmed': 'negative'});
  }
}
