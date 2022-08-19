// ignore_for_file: must_be_immutable, avoid_print, no_logic_in_create_state

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class ImageCar extends StatefulWidget {
  bool add;
  ImageCar({Key? key, required this.add}) : super(key: key);

  @override
  State<ImageCar> createState() => _ImageCarState(add);
}

class _ImageCarState extends State<ImageCar> {
  File? image1;
  File? image2;
  File? image3;
  File? image4;
  File? image5;
  File? image6;
  bool add;

  _ImageCarState(this.add);

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            appBar: AppBar(
                title: Text('Car\'s picture',
                    style: TextStyle(fontSize: screenText * 20)),
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      List<File?> nullValue = [];
                      Navigator.pop(context, nullValue);
                    }),
                actions: [
                  Row(children: [
                    Text('Save!',
                        style: TextStyle(
                            fontSize: screenText * 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          if (image1 != null) {
                            Navigator.pop(context, [
                              image1,
                              image2,
                              image3,
                              image4,
                              image5,
                              image6
                            ]);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'No pictures added! Please take at least one picture!',
                                fontSize: 20);
                          }
                        },
                        icon: Icon(Icons.add_task, size: screenText * 25))
                  ])
                ]),
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  SizedBox(height: screenHeight * 0.05),
                  Text(ImageTest().printTitle(add),
                      style: TextStyle(
                          fontSize: screenText * 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      textAlign: TextAlign.center),
                  SizedBox(height: screenHeight * 0.05),
                  Row(children: [
                    SizedBox(width: screenWidth * 0.05),
                    Column(children: [
                      image1 != null
                          ? ClipOval(
                              child: Image.file(image1!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.08),
                      image3 != null
                          ? ClipOval(
                              child: Image.file(image3!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.08),
                      image5 != null
                          ? ClipOval(
                              child: Image.file(image5!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain))
                    ]),
                    SizedBox(width: screenWidth * 0.03),
                    Column(children: [
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () async {
                          if (PassMarker.photoCount <= 5) {
                            pickImage(
                                ImageSource.camera, PassMarker.photoCount);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Max number of photo\'s loaded',
                                fontSize: 20);
                          }
                        },
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.photo_camera, size: screenText * 25),
                      ),
                      SizedBox(height: screenHeight * 0.25),
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () async {
                          if (PassMarker.photoCount <= 5) {
                            pickImage(
                                ImageSource.gallery, PassMarker.photoCount);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Max number of photo\'s loaded',
                                fontSize: 20);
                          }
                        },
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.photo_library, size: screenText * 25),
                      )
                    ]),
                    SizedBox(width: screenWidth * 0.03),
                    Column(children: [
                      image2 != null
                          ? ClipOval(
                              child: Image.file(image2!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.08),
                      image4 != null
                          ? ClipOval(
                              child: Image.file(image4!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain)),
                      SizedBox(height: screenHeight * 0.08),
                      image6 != null
                          ? ClipOval(
                              child: Image.file(image6!,
                                  width: screenHeight * 0.16,
                                  height: screenHeight * 0.16,
                                  fit: BoxFit.cover))
                          : SizedBox(
                              height: screenHeight * 0.16,
                              child: Image.asset("assets/prcarlogo.png",
                                  fit: BoxFit.contain))
                    ])
                  ])
                ])))
        : Scaffold(
            appBar: AppBar(
                title: Text('Car\'s picture',
                    style: TextStyle(fontSize: screenText * 30)),
                backgroundColor: Colors.redAccent,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 35),
                    onPressed: () {
                      List<File?> nullValue = [];
                      Navigator.pop(context, nullValue);
                    }),
                actions: [
                  Row(children: [
                    Text('Save!',
                        style: TextStyle(
                            fontSize: screenText * 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          if (image1 != null) {
                            Navigator.pop(context, [
                              image1,
                              image2,
                              image3,
                              image4,
                              image5,
                              image6
                            ]);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'No pictures added! Please take at least one picture!',
                                fontSize: 20);
                          }
                        },
                        icon: Icon(Icons.add_task, size: screenText * 35))
                  ])
                ]),
            backgroundColor: Colors.white,
            body: OrientationBuilder(builder: (_, orientation) {
              if (orientation == Orientation.portrait) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      SizedBox(height: screenHeight * 0.05),
                      Text(ImageTest().printTitle(add),
                          style: TextStyle(
                              fontSize: screenText * 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          textAlign: TextAlign.center),
                      SizedBox(height: screenHeight * 0.05),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              image1 != null
                                  ? ClipOval(
                                      child: Image.file(image1!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain)),
                              SizedBox(height: screenHeight * 0.08),
                              image3 != null
                                  ? ClipOval(
                                      child: Image.file(image3!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain)),
                              SizedBox(height: screenHeight * 0.08),
                              image5 != null
                                  ? ClipOval(
                                      child: Image.file(image5!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain))
                            ]),
                            SizedBox(width: screenWidth * 0.03),
                            Column(children: [
                              Container(
                                  height: screenHeight * 0.12,
                                  width: screenWidth * 0.1,
                                  child: FloatingActionButton(
                                      heroTag: "btn1",
                                      onPressed: () async {
                                        if (PassMarker.photoCount <= 5) {
                                          pickImage(ImageSource.camera,
                                              PassMarker.photoCount);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Max number of photo\'s loaded',
                                              fontSize: 20);
                                        }
                                      },
                                      backgroundColor: Colors.redAccent,
                                      child: Icon(Icons.photo_camera,
                                          size: screenText * 35))),
                              SizedBox(height: screenHeight * 0.25),
                              Container(
                                  height: screenHeight * 0.12,
                                  width: screenWidth * 0.1,
                                  child: FloatingActionButton(
                                    heroTag: "btn2",
                                    onPressed: () async {
                                      if (PassMarker.photoCount <= 5) {
                                        pickImage(ImageSource.gallery,
                                            PassMarker.photoCount);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Max number of photo\'s loaded',
                                            fontSize: 20);
                                      }
                                    },
                                    backgroundColor: Colors.redAccent,
                                    child: Icon(Icons.photo_library,
                                        size: screenText * 35),
                                  ))
                            ]),
                            SizedBox(width: screenWidth * 0.03),
                            Column(children: [
                              image2 != null
                                  ? ClipOval(
                                      child: Image.file(image2!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain)),
                              SizedBox(height: screenHeight * 0.08),
                              image4 != null
                                  ? ClipOval(
                                      child: Image.file(image4!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain)),
                              SizedBox(height: screenHeight * 0.08),
                              image6 != null
                                  ? ClipOval(
                                      child: Image.file(image6!,
                                          width: screenHeight * 0.2,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover))
                                  : SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Image.asset("assets/prcarlogo.png",
                                          fit: BoxFit.contain))
                            ])
                          ])
                    ]));
              } else {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      SizedBox(height: screenHeight * 0.05),
                      Text(ImageTest().printTitle(add),
                          style: TextStyle(
                              fontSize: screenText * 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          textAlign: TextAlign.center),
                      SizedBox(height: screenHeight * 0.05),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  image1 != null
                                      ? ClipOval(
                                          child: Image.file(image1!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain)),
                                  SizedBox(width: screenWidth * 0.15),
                                  image2 != null
                                      ? ClipOval(
                                          child: Image.file(image3!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain)),
                                  SizedBox(width: screenWidth * 0.15),
                                  image3 != null
                                      ? ClipOval(
                                          child: Image.file(image5!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain))
                                ]),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: screenHeight * 0.12,
                                      width: screenWidth * 0.06,
                                      child: FloatingActionButton(
                                          heroTag: "btn1",
                                          onPressed: () async {
                                            if (PassMarker.photoCount <= 5) {
                                              pickImage(ImageSource.camera,
                                                  PassMarker.photoCount);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Max number of photo\'s loaded',
                                                  fontSize: 20);
                                            }
                                          },
                                          backgroundColor: Colors.redAccent,
                                          child: Icon(Icons.photo_camera,
                                              size: screenText * 35))),
                                  SizedBox(width: screenWidth * 0.2),
                                  Container(
                                      height: screenHeight * 0.12,
                                      width: screenWidth * 0.06,
                                      child: FloatingActionButton(
                                        heroTag: "btn2",
                                        onPressed: () async {
                                          if (PassMarker.photoCount <= 5) {
                                            pickImage(ImageSource.gallery,
                                                PassMarker.photoCount);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Max number of photo\'s loaded',
                                                fontSize: 20);
                                          }
                                        },
                                        backgroundColor: Colors.redAccent,
                                        child: Icon(Icons.photo_library,
                                            size: screenText * 35),
                                      ))
                                ]),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  image4 != null
                                      ? ClipOval(
                                          child: Image.file(image2!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain)),
                                  SizedBox(width: screenWidth * 0.15),
                                  image5 != null
                                      ? ClipOval(
                                          child: Image.file(image4!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain)),
                                  SizedBox(width: screenWidth * 0.15),
                                  image6 != null
                                      ? ClipOval(
                                          child: Image.file(image6!,
                                              width: screenHeight * 0.23,
                                              height: screenHeight * 0.23,
                                              fit: BoxFit.cover))
                                      : SizedBox(
                                          height: screenHeight * 0.23,
                                          child: Image.asset(
                                              "assets/prcarlogo.png",
                                              fit: BoxFit.contain))
                                ])
                          ])
                    ]));
              }
            }));
  }
}

class ImageTest {
//Function that prints different titles (it depend on where I come from)
  String printTitle(bool where) {
    if (where) {
      return 'Insert your car\'s pictures \n (min. 1, max 6)';
    } else {
      return 'Reset and add new car\' pictures \n (min. 1, max 6)';
    }
  }
}
