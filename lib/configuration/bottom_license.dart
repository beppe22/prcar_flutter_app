// ignore_for_file: avoid_print, no_logic_in_create_state, must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomLicense extends StatefulWidget {
  String expiryDate, drivingCode;
  File frontImage;
  BottomLicense(
      {Key? key,
      required this.expiryDate,
      required this.drivingCode,
      required this.frontImage})
      : super(key: key);

  @override
  State<BottomLicense> createState() =>
      _BottomLicenseState(expiryDate, drivingCode, frontImage);
}

class _BottomLicenseState extends State<BottomLicense> {
  File? bottomImage;
  File frontImage;
  bool? ok;
  String expiryDate, drivingCode;

  _BottomLicenseState(this.expiryDate, this.drivingCode, this.frontImage);

  @override
  void initState() {
    super.initState();
    ok = false;
  }

  Future pickImage(ImageSource source) async {
    try {
      final bottomImage = await ImagePicker().pickImage(source: source);
      if (bottomImage == null) return;
      final imageTemporary = File(bottomImage.path);
      setState(() {
        this.bottomImage = imageTemporary;
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
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(
          title: Text('Bottom picture',
              style: TextStyle(fontSize: screenText * 20)),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, size: screenText * 25),
              onPressed: () {
                Navigator.pop(context);
              })),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Insert your bottom license picture',
            style: TextStyle(
                fontSize: screenText * 28,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        SizedBox(height: screenHeight * 0.05),
        bottomImage != null
            ? Image.file(bottomImage!,
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
                onPressed: () async {
                  if (await NetworkCheck().check()) {
                    if (ok!) {
                      final _auth = FirebaseAuth.instance;
                      User? user = _auth.currentUser;
                      String uidCode = user!.uid;
                      final frontPath = frontImage.path;
                      final bottomPath = bottomImage!.path;
                      final expiryPath = expiryDate;
                      final drivingCodePath = drivingCode;
                      await _updateIsConfirmed(user);
                      storage.uploadFile(frontPath, 'frontLicense', uidCode);
                      storage.uploadFile(bottomPath, 'bottomLicense', uidCode);
                      storage.uploadString(expiryPath, 'expiryDate', uidCode);
                      storage.uploadString(
                          drivingCodePath, 'drivingCode', uidCode);
                      Fluttertoast.showToast(
                          msg:
                              'Driving license inserted :) the administrator will check soon your information and will confirm',
                          fontSize: 20);
                      Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'No picture inserted :(', fontSize: 20);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'No internet connection', fontSize: 20);
                  }
                },
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.02,
                    screenHeight * 0.015,
                    screenWidth * 0.02,
                    screenHeight * 0.015),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text("Done!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: screenText * 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)))))
      ])),
    );
  }

  _updateIsConfirmed(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update({'isConfirmed': 'underControl'});
  }
}
