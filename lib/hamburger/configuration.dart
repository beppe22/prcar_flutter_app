// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/configuration/front_license.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

class Configuration extends StatefulWidget {
  String isConfirmed;
  Service service;
  Configuration({Key? key, required this.isConfirmed, required this.service})
      : super(key: key);

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

    //Function that prints different width's size if a device is a smartphone or a tablet
    widthBottom() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return screenWidth * 0.8;
      } else {
        return screenWidth * 0.5;
      }
    }

    //licenseCode field
    final licenseCodeField = TextFormField(
        autofocus: false,
        style: TextStyle(fontSize: TextConfiguration().text(screenText)),
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
            hintStyle:
                TextStyle(fontSize: TextConfiguration().text(screenText)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    //expiryDate field
    final expiryDateEditingField = TextFormField(
        autofocus: false,
        style: TextStyle(fontSize: TextConfiguration().text(screenText)),
        controller: expiryDateEditingController,
        keyboardType: PassMarker.useMobileLayout!
            ? TextInputType.datetime
            : TextInputType.name,
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
            hintStyle:
                TextStyle(fontSize: TextConfiguration().text(screenText)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    return PassMarker.useMobileLayout!
        ? isConfirmed == 'negative'
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
                                      child: Text(
                                          "Insert driving license pictures",
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
                                  border: Border.all(
                                      width: 5.0, color: Colors.grey)),
                              child: (MaterialButton(
                                  onPressed: () async {
                                    if (await NetworkCheck().check()) {
                                      User? user = widget.service.currentUser();
                                      _updateIsConfirmed(user!);
                                      _deleteDrivingLicense(user.uid);
                                      Fluttertoast.showToast(
                                          msg:
                                              'Driving license info resetted succesfully :)',
                                          fontSize: 20);
                                      //Navigator.pop(context);
                                      String conf = await _isConfirmed(user);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Configuration(
                                                      isConfirmed: conf,
                                                      service: Service())));
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
                                fontSize: screenText * 18,
                                color: Colors.redAccent),
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
                ])))
        : isConfirmed == 'negative'
            ? Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                    title: Text('Configuration',
                        style: TextStyle(fontSize: screenText * 30)),
                    backgroundColor: Colors.redAccent,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back, size: screenText * 35),
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
                                      fontSize: screenText * 40,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: screenHeight * 0.05),
                              SizedBox(
                                  height: screenHeight * 0.35,
                                  child: Image.asset("assets/prcarlogo.png",
                                      fit: BoxFit.contain)),
                              SizedBox(height: screenHeight * 0.04),
                              Container(
                                  child: licenseCodeField,
                                  width: screenWidth * 0.8),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                  child: expiryDateEditingField,
                                  width: screenWidth * 0.8),
                              SizedBox(height: screenHeight * 0.05),
                              Container(
                                  height: screenHeight * 0.1,
                                  width: widthBottom(),
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
                                      child: Text(
                                          "Insert driving license pictures",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: screenText * 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)))))
                            ])))))
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                    title: Text('Configuration',
                        style: TextStyle(fontSize: screenText * 30)),
                    backgroundColor: Colors.redAccent,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back, size: screenText * 35),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                body: Center(
                    child: Column(children: [
                  SizedBox(height: screenHeight * 0.05),
                  isConfirmed == 'confirmed'
                      ? Text('Your driving license has been \n approved :)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: screenText * 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey))
                      : Text(
                          'Driving License is under administrator\'s \ncontrol',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: screenText * 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                  SizedBox(height: screenHeight * 0.05),
                  isConfirmed == 'confirmed'
                      ? Column(children: [
                          SizedBox(
                              height: screenHeight * 0.4,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.04),
                          Container(
                              height: screenHeight * 0.1,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                      width: 5.0, color: Colors.grey)),
                              child: (MaterialButton(
                                  onPressed: () async {
                                    if (await NetworkCheck().check()) {
                                      User? user = widget.service.currentUser();
                                      _updateIsConfirmed(user!);
                                      _deleteDrivingLicense(user.uid);
                                      Fluttertoast.showToast(
                                          msg:
                                              'Driving license info resetted succesfully :)',
                                          fontSize: 20);
                                      //Navigator.pop(context);

                                      String conf = await _isConfirmed(user);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Configuration(
                                                      isConfirmed: conf,
                                                      service: Service())));
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
                                          fontSize: screenText * 35,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)))))
                        ])
                      : Column(children: [
                          SizedBox(
                              height: screenHeight * 0.35,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                            'Your driving license\'s control will \n be fast :)',
                            style: TextStyle(
                                fontSize: screenText * 38,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          SizedBox(
                              height: screenHeight * 0.17,
                              width: screenWidth * 0.25,
                              child: const CircularProgressIndicator(
                                color: Colors.redAccent,
                              ))
                        ])
                ])));
  }

//Function that pushes screen to the next page
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

//Function that deletes driving license info
  _deleteDrivingLicense(String uid) async {
    final delete1 =
        widget.service.storage().child("$uid/drivingLicenseData/bottomLicense");
    await delete1.delete();
    final delete2 = widget.service
        .storage()
        .ref()
        .child("$uid/drivingLicenseData/frontLicense");
    await delete2.delete();
    final delete3 = widget.service
        .storage()
        .ref()
        .child("$uid/drivingLicenseData/expiryDate");
    await delete3.delete();
    final delete4 = widget.service
        .storage()
        .ref()
        .child("$uid/drivingLicenseData/drivingCode");
    await delete4.delete();
  }

//Function that updates user's status after he resets driving license info
  _updateIsConfirmed(User user) async {
    await widget.service
        .firebasefirestore()
        .collection('users')
        .doc(user.uid)
        .update({'isConfirmed': 'negative'});
  }

//Function that checks a user's status
  Future<String> _isConfirmed(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await widget.service
        .firebasefirestore()
        .collection('users')
        .doc(user.uid)
        .get();
    return snapshot.data()!['isConfirmed'];
  }
}

class TextConfiguration {
  //Function that prints different text's size if a device is a smartphone or a tablet
  double text(double screenText) {
    if (PassMarker.useMobileLayout!) {
      return screenText * 20.0;
    } else {
      return screenText * 30.0;
    }
  }
}
