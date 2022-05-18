// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomLicense extends StatefulWidget {
  const BottomLicense({Key? key}) : super(key: key);

  @override
  State<BottomLicense> createState() => _BottomLicenseState();
}

class _BottomLicenseState extends State<BottomLicense> {
  File? image;
  bool? ok;

  @override
  void initState() {
    super.initState();
    ok = false;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        ok = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Driving license'),
          backgroundColor: Colors.redAccent,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Insert your bottom driving license picture',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        image != null
            ? Image.file(image!, width: 160, height: 160, fit: BoxFit.cover)
            : SizedBox(
                height: 175,
                child:
                    Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
        const SizedBox(height: 20),
        Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 5.0, color: Colors.grey)),
            child: (MaterialButton(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Text("Take from Gallery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))))),
        const SizedBox(height: 40),
        Container(
            height: 60,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 5.0, color: Colors.grey)),
            child: (MaterialButton(
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Text("Take from Camera",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))))),
        const SizedBox(height: 40),
        Container(
            height: 60,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                border: Border.all(width: 5.0, color: Colors.grey)),
            child: (MaterialButton(
                onPressed: () {
                  if (ok!) {
                    PassMarker.driveInserted2 = true;
                    if (PassMarker.returnHP) {
                      PassMarker.returnHP = false;
                      Fluttertoast.showToast(
                          msg: 'Driving license inserted :)', fontSize: 20);
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop()
                        ..pop();
                    } else {
                      PassMarker.returnHP = false;
                      Fluttertoast.showToast(
                          msg: 'Driving license inserted :)', fontSize: 20);
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop();
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'No picture inserted :(', fontSize: 20);
                  }
                },
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Text("Done!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))))
      ])),
    );
  }
}
