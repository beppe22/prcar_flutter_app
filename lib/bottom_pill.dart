import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/Internet/NetworkCheck.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:prcarpolimi/services/services.dart';
import 'auth/storage_service.dart';

class MapBottomPill extends StatelessWidget {
  const MapBottomPill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;

    size() {
      if (Orientation.portrait == MediaQuery.of(context).orientation) {
        return screenWidth * 0.06;
      } else {
        return screenWidth * 0.04;
      }
    }

    widthImage() {
      if (Orientation.portrait == MediaQuery.of(context).orientation) {
        return screenWidth * 0.25;
      } else {
        return screenWidth * 0.13;
      }
    }

    heightImage() {
      if (Orientation.portrait == MediaQuery.of(context).orientation) {
        return screenHeight * 0.15;
      } else {
        return screenHeight * 0.2;
      }
    }

    reserveWidth() {
      if (Orientation.portrait == MediaQuery.of(context).orientation) {
        return screenWidth * 0.4;
      } else {
        return screenWidth * 0.3;
      }
    }

    reserveHeight() {
      if (Orientation.portrait == MediaQuery.of(context).orientation) {
        return screenHeight * 0.04;
      } else {
        return screenHeight * 0.1;
      }
    }

    return PassMarker.useMobileLayout!
        ? Container(
            margin: EdgeInsets.all(screenWidth * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.08),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(screenWidth * 0.2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 80,
                      offset: Offset.zero)
                ]),
            child: Column(children: [
              Container(
                  color: Colors.redAccent,
                  child: Row(children: [
                    ClipOval(
                        child: Image.asset('assets/prcarlogo.png',
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.15,
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter)),
                    Column(children: [
                      Text('Selected car, click below for',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: screenText * 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                      Text('more details: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: screenText * 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                      Container(
                          width: screenWidth * 0.3,
                          margin: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              left: screenWidth * 0.015,
                              right: screenWidth * 0.005,
                              bottom: screenHeight * 0.005),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                              onPressed: () async {
                                String name =
                                    await _nameString(PassMarker.carModel.uid!);
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 6,
                                          content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Center(
                                                    child: Text(
                                                        'Car Information',
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText * 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.001),
                                                Text(name,
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenText * 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.01),
                                                _buildRow(
                                                    'assets/choc.png',
                                                    PassMarker.carModel.vehicle
                                                        .toString(),
                                                    'VEHICLE',
                                                    screenWidth,
                                                    screenHeight,
                                                    screenText),
                                                _buildRow(
                                                    'assets/choc.png',
                                                    PassMarker.carModel.model
                                                        .toString(),
                                                    'MODEL',
                                                    screenWidth,
                                                    screenHeight,
                                                    screenText),
                                                _buildRow(
                                                    'assets/choc.png',
                                                    PassMarker.carModel.fuel
                                                        .toString(),
                                                    'FUEL',
                                                    screenWidth,
                                                    screenHeight,
                                                    screenText),
                                                _buildRow(
                                                    'assets/choc.png',
                                                    PassMarker.carModel.seats
                                                        .toString(),
                                                    'SEATS',
                                                    screenWidth,
                                                    screenHeight,
                                                    screenText),
                                                _buildRow(
                                                    'assets/choc.png',
                                                    PassMarker.carModel.price
                                                        .toString(),
                                                    'PRICE FOR DAY',
                                                    screenWidth,
                                                    screenHeight,
                                                    screenText),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                FloatingActionButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                      );
                                                      List<String> files =
                                                          await urlFile(
                                                              PassMarker
                                                                  .carModel
                                                                  .uid!,
                                                              PassMarker
                                                                  .carModel
                                                                  .cid!);
                                                      final List<ImageProvider>
                                                          _imageProviders = [];
                                                      for (int i = 0;
                                                          i < files.length;
                                                          i++) {
                                                        _imageProviders.insert(
                                                            i,
                                                            Image.network(
                                                                    files[i])
                                                                .image);
                                                      }
                                                      MultiImageProvider
                                                          multiImageProvider =
                                                          MultiImageProvider(
                                                              _imageProviders);
                                                      await showImageViewerPager(
                                                          context,
                                                          multiImageProvider);
                                                      Navigator.pop(context);
                                                    },
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    child: Icon(
                                                        Icons.photo_library,
                                                        size: screenText * 25)),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.04),
                                                Container(
                                                    child: MaterialButton(
                                                        height:
                                                            screenHeight * 0.07,
                                                        minWidth:
                                                            screenWidth * 0.4,
                                                        color: Colors.redAccent,
                                                        onPressed: () async {
                                                          if (await NetworkCheck()
                                                              .check()) {
                                                            final _auth =
                                                                FirebaseAuth
                                                                    .instance;
                                                            User? user = _auth
                                                                .currentUser;
                                                            if (await _isConfirmed(
                                                                    user!) ==
                                                                'confirmed') {
                                                              PassMarker
                                                                      .hpOrNot =
                                                                  true;
                                                              var reserveResult =
                                                                  'start';
                                                              reserveResult = await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Least(
                                                                              service: Service())));

                                                              if (reserveResult ==
                                                                  '1') {
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(
                                                                        'dialog');
                                                              } else if (reserveResult ==
                                                                  '0') {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'Something went wrong, try again later',
                                                                        fontSize:
                                                                            20);
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Driving License isn\'t confirmed yet :(',
                                                                      fontSize:
                                                                          20);
                                                            }
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'No internet connection',
                                                                fontSize: 20);
                                                          }
                                                        },
                                                        child: Text("Reserve",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    screenText *
                                                                        23))),
                                                    decoration: BoxDecoration(
                                                        color: Colors.deepPurple
                                                            .shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .deepPurple
                                                                  .shade300,
                                                              spreadRadius: 6,
                                                              blurRadius: 3)
                                                        ])),
                                              ]));
                                    });
                              },
                              child: Text('Reserve',
                                  style:
                                      TextStyle(fontSize: screenText * 14)))),
                    ], mainAxisAlignment: MainAxisAlignment.center)
                  ]))
            ]))
        : Container(
            margin: EdgeInsets.all(screenWidth * 0.01),
            padding: EdgeInsets.only(
              top: size(),
              bottom: size(),
            ),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(screenWidth * 0.2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: Offset.zero)
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: screenWidth * 0.7,
                      color: Colors.redAccent,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                                child: Image.asset('assets/prcarlogo.png',
                                    width: widthImage(),
                                    height: heightImage(),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.topCenter)),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Selected car, click below for \n more details: ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: screenText * 22,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                      width: screenWidth * 0.25,
                                      margin: EdgeInsets.only(
                                          top: screenHeight * 0.005,
                                          left: screenWidth * 0.015,
                                          right: screenWidth * 0.005,
                                          bottom: screenHeight * 0.005),
                                      decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: Colors.redAccent),
                                          onPressed: () async {
                                            String name = await _nameString(
                                                PassMarker.carModel.uid!);
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                      elevation: 6,
                                                      content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.02),
                                                            Center(
                                                                child: Text(
                                                                    'Car Information',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            screenText *
                                                                                35,
                                                                        fontWeight:
                                                                            FontWeight.bold))),
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.001),
                                                            Text(name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenText *
                                                                            24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.01),
                                                            _buildRow(
                                                                'assets/choc.png',
                                                                PassMarker
                                                                    .carModel
                                                                    .vehicle
                                                                    .toString(),
                                                                'VEHICLE',
                                                                screenWidth,
                                                                screenHeight,
                                                                screenText),
                                                            _buildRow(
                                                                'assets/choc.png',
                                                                PassMarker
                                                                    .carModel
                                                                    .model
                                                                    .toString(),
                                                                'MODEL',
                                                                screenWidth,
                                                                screenHeight,
                                                                screenText),
                                                            _buildRow(
                                                                'assets/choc.png',
                                                                PassMarker
                                                                    .carModel
                                                                    .fuel
                                                                    .toString(),
                                                                'FUEL',
                                                                screenWidth,
                                                                screenHeight,
                                                                screenText),
                                                            _buildRow(
                                                                'assets/choc.png',
                                                                PassMarker
                                                                    .carModel
                                                                    .seats
                                                                    .toString(),
                                                                'SEATS',
                                                                screenWidth,
                                                                screenHeight,
                                                                screenText),
                                                            _buildRow(
                                                                'assets/choc.png',
                                                                PassMarker
                                                                    .carModel
                                                                    .price
                                                                    .toString(),
                                                                'PRICE FOR DAY',
                                                                screenWidth,
                                                                screenHeight,
                                                                screenText),
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.02),
                                                            FloatingActionButton(
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false,
                                                                    builder: (context) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                  );
                                                                  List<String> files = await urlFile(
                                                                      PassMarker
                                                                          .carModel
                                                                          .uid!,
                                                                      PassMarker
                                                                          .carModel
                                                                          .cid!);
                                                                  final List<
                                                                          ImageProvider>
                                                                      _imageProviders =
                                                                      [];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          files
                                                                              .length;
                                                                      i++) {
                                                                    _imageProviders.insert(
                                                                        i,
                                                                        Image.network(files[i])
                                                                            .image);
                                                                  }
                                                                  MultiImageProvider
                                                                      multiImageProvider =
                                                                      MultiImageProvider(
                                                                          _imageProviders);
                                                                  await showImageViewerPager(
                                                                      context,
                                                                      multiImageProvider);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                backgroundColor:
                                                                    Colors
                                                                        .redAccent,
                                                                child: Icon(
                                                                    Icons
                                                                        .photo_library,
                                                                    size:
                                                                        screenText *
                                                                            25)),
                                                            SizedBox(
                                                                height:
                                                                    screenHeight *
                                                                        0.04),
                                                            Container(
                                                              child:
                                                                  MaterialButton(
                                                                      height:
                                                                          reserveHeight(),
                                                                      minWidth:
                                                                          reserveWidth(),
                                                                      color: Colors
                                                                          .redAccent,
                                                                      onPressed:
                                                                          () async {
                                                                        if (await NetworkCheck()
                                                                            .check()) {
                                                                          final _auth =
                                                                              FirebaseAuth.instance;
                                                                          User?
                                                                              user =
                                                                              _auth.currentUser;
                                                                          if (await _isConfirmed(user!) ==
                                                                              'confirmed') {
                                                                            PassMarker.hpOrNot =
                                                                                true;
                                                                            var reserveResult =
                                                                                'start';
                                                                            reserveResult =
                                                                                await Navigator.push(context, MaterialPageRoute(builder: (context) => Least(service: Service())));

                                                                            if (reserveResult ==
                                                                                '1') {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                            } else if (reserveResult ==
                                                                                '0') {
                                                                              Fluttertoast.showToast(msg: 'Something went wrong, try again later', fontSize: 20);
                                                                            }
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                msg: 'Driving License isn\'t confirmed yet :(',
                                                                                fontSize: 20);
                                                                          }
                                                                        } else {
                                                                          Fluttertoast.showToast(
                                                                              msg: 'No internet connection',
                                                                              fontSize: 20);
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          "Reserve",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: screenText * 28))),
                                                            ),
                                                          ]));
                                                });
                                          },
                                          child: Text('Reserve',
                                              style: TextStyle(
                                                  fontSize: screenText * 24)))),
                                ])
                          ]))
                ]));
  }

  Widget _buildRow(String imageAsset, String value, String type,
      double screenWidth, double screenHeight, double screenText) {
    text() {
      if (PassMarker.useMobileLayout!) {
        return screenText * 16;
      } else {
        return screenText * 20;
      }
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.008),
        child: Column(children: <Widget>[
          SizedBox(height: screenHeight * 0.012),
          Row(children: <Widget>[
            SizedBox(width: screenWidth * 0.005),
            Text(
              type.toUpperCase(),
              style: TextStyle(fontSize: text()),
            ),
            const Spacer(),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 223, 162, 108), //Colors.yellow[900],
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.012,
                    horizontal: screenWidth * 0.06),
                child: Text(
                  value,
                  style: TextStyle(fontSize: text()),
                ))
          ])
        ]));
  }

  Future<List<String>> urlFile(String uid, String cid) async {
    final Storage storage = Storage();
    final firebase_storage.FirebaseStorage storage2 =
        firebase_storage.FirebaseStorage.instance;
    List<String> urlList = [];
    firebase_storage.ListResult results =
        await storage2.ref('$uid/$cid/').listAll();
    for (int i = 0; i < results.items.length; i++) {
      String url = await storage.downloadURL(uid, cid, 'imageCar$i');
      urlList.insert(i, url);
    }
    return urlList;
  }

  Future<String> _nameString(String uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firebaseFirestore.collection('users').doc(uid).get();
    String name = snapshot.data()!['firstName'].toString();
    String surname = snapshot.data()!['secondName'].toString();
    return name + ' ' + surname;
  }

  Future<String> _isConfirmed(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firebaseFirestore.collection('users').doc(user.uid).get();
    return snapshot.data()!['isConfirmed'];
  }
}
