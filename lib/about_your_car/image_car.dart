// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class ImageCar extends StatefulWidget {
  const ImageCar({Key? key}) : super(key: key);

  @override
  State<ImageCar> createState() => _ImageCarState();
}

class _ImageCarState extends State<ImageCar> {
  File? image1;
  File? image2;
  File? image3;
  File? image4;
  File? image5;
  File? image6;

  @override
  void initState() {
    PassMarker.photoCount = 0;
    super.initState();
  }

  Future pickImage(ImageSource source, int i) async {
    try {
      if (i == 0) {
        final image1 = await ImagePicker().pickImage(source: source);
        if (image1 == null) return;
        final imageTemporary = File(image1.path);
        setState(() {
          this.image1 = imageTemporary;
        });
      } else if (i == 1) {
        final image2 = await ImagePicker().pickImage(source: source);
        if (image2 == null) return;
        final imageTemporary = File(image2.path);
        setState(() {
          this.image2 = imageTemporary;
        });
      } else if (i == 2) {
        final image3 = await ImagePicker().pickImage(source: source);
        if (image3 == null) return;
        final imageTemporary = File(image3.path);
        setState(() {
          this.image3 = imageTemporary;
        });
      } else if (i == 3) {
        final image4 = await ImagePicker().pickImage(source: source);
        if (image4 == null) return;
        final imageTemporary = File(image4.path);
        setState(() {
          this.image4 = imageTemporary;
        });
      } else if (i == 4) {
        final image5 = await ImagePicker().pickImage(source: source);
        if (image5 == null) return;
        final imageTemporary = File(image5.path);
        setState(() {
          this.image5 = imageTemporary;
        });
      } else if (i == 5) {
        final image6 = await ImagePicker().pickImage(source: source);
        if (image6 == null) return;
        final imageTemporary = File(image6.path);
        setState(() {
          this.image6 = imageTemporary;
        });
      }
      PassMarker.photoCount++;
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Car\'s picture'),
            backgroundColor: Colors.redAccent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  List<File?> nullValue = [];
                  Navigator.pop(context, nullValue);
                }),
            actions: [
              Row(children: [
                const Text('Save!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      if (image1 != null) {
                        Navigator.pop(context,
                            [image1, image2, image3, image4, image5, image6]);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'No pictures added! Please take at least one picture!',
                            fontSize: 20);
                      }
                    },
                    icon: const Icon(Icons.add_task))
              ])
            ]),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Text('Insert your car\'s pictures \n (min. 1, max 6)',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              SizedBox(
                  child: Row(children: [
                const SizedBox(width: 15),
                image1 != null
                    ? ClipOval(
                        child: Image.file(image1!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    if (PassMarker.photoCount <= 5) {
                      pickImage(ImageSource.camera, PassMarker.photoCount);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Max number of photo\'s loaded', fontSize: 20);
                    }
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.photo_camera),
                ),
                const SizedBox(width: 10),
                image2 != null
                    ? ClipOval(
                        child: Image.file(image2!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
              ])),
              const SizedBox(height: 20),
              SizedBox(
                  child: Row(children: [
                const SizedBox(width: 15),
                image3 != null
                    ? ClipOval(
                        child: Image.file(image3!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                const SizedBox(width: 70),
                image4 != null
                    ? ClipOval(
                        child: Image.file(image4!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
              ])),
              const SizedBox(height: 20),
              SizedBox(
                  child: Row(children: [
                const SizedBox(width: 15),
                image5 != null
                    ? ClipOval(
                        child: Image.file(image5!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () async {
                    if (PassMarker.photoCount <= 5) {
                      pickImage(ImageSource.gallery, PassMarker.photoCount);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Max number of photo\'s loaded', fontSize: 20);
                    }
                  },
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.photo_library),
                ),
                const SizedBox(width: 10),
                image6 != null
                    ? ClipOval(
                        child: Image.file(image6!,
                            width: 120, height: 120, fit: BoxFit.cover))
                    : SizedBox(
                        height: 120,
                        child: Image.asset("assets/prcarlogo.png",
                            fit: BoxFit.contain)),
              ]))
            ])));
  }
}
