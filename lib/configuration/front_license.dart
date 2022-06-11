// ignore_for_file: avoid_print, must_be_immutable, no_logic_in_create_state

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prcarpolimi/configuration/bottom_license.dart';

class FrontLicense extends StatefulWidget {
  String expiryDate, drivingCode;
  FrontLicense({Key? key, required this.expiryDate, required this.drivingCode})
      : super(key: key);

  @override
  State<FrontLicense> createState() =>
      _FrontLicenseState(expiryDate, drivingCode);
}

class _FrontLicenseState extends State<FrontLicense> {
  File? frontImage;
  bool? ok;
  String expiryDate, drivingCode;

  _FrontLicenseState(this.expiryDate, this.drivingCode);

  @override
  void initState() {
    super.initState();
    ok = false;
  }

  Future pickImage(ImageSource source) async {
    try {
      final frontImage = await ImagePicker().pickImage(source: source);
      if (frontImage == null) return;
      final imageTemporary = File(frontImage.path);
      setState(() {
        this.frontImage = imageTemporary;
        ok = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        appBar: AppBar(
            title: Text('Front picture',
                style: TextStyle(fontSize: screenText * 20)),
            backgroundColor: Colors.redAccent,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, size: screenText * 25),
                onPressed: () {
                  Navigator.pop(context);
                })),
        backgroundColor: Colors.white,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Insert your front license picture',
              style: TextStyle(
                  fontSize: screenText * 28,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          SizedBox(height: screenHeight * 0.05),
          frontImage != null
              ? Image.file(frontImage!,
                  width: screenHeight * 0.28,
                  height: screenHeight * 0.28,
                  fit: BoxFit.cover)
              : SizedBox(
                  height: screenHeight * 0.28,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          SizedBox(height: screenHeight * 0.05),
          Container(
              height: screenHeight * 0.1,
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.02,
                      screenHeight * 0.015,
                      screenWidth * 0.02,
                      screenHeight * 0.015),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Take from Gallery",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))))),
          SizedBox(height: screenHeight * 0.02),
          Container(
              height: screenHeight * 0.1,
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.02,
                      screenHeight * 0.015,
                      screenWidth * 0.02,
                      screenHeight * 0.015),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Take from Camera",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))))),
          SizedBox(height: screenHeight * 0.05),
          Container(
              height: screenHeight * 0.08,
              width: screenWidth * 0.6,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(width: 5.0, color: Colors.grey)),
              child: (MaterialButton(
                  onPressed: () {
                    if (ok!) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomLicense(
                                  expiryDate: expiryDate,
                                  drivingCode: drivingCode,
                                  frontImage: frontImage!)));
                    } else {
                      Fluttertoast.showToast(
                          msg: 'No picture inserted :(', fontSize: 20);
                    }
                  },
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.02,
                      screenHeight * 0.015,
                      screenWidth * 0.02,
                      screenHeight * 0.015),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Next!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenText * 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)))))
        ])));
  }
}
