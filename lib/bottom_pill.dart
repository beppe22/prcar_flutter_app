import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'auth/storage_service.dart';

class MapBottomPill extends StatelessWidget {
  const MapBottomPill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
                          fontSize: screenWidth * 0.037,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Text('more details: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.037,
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
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          onPressed: () async {
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
                                                height: screenHeight * 0.02),
                                            Center(
                                                child: Text('Car Information',
                                                    style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.08,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.vehicle
                                                    .toString(),
                                                'VEHICLE',
                                                screenWidth,
                                                screenHeight),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.model
                                                    .toString(),
                                                'MODEL',
                                                screenWidth,
                                                screenHeight),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.fuel
                                                    .toString(),
                                                'FUEL',
                                                screenWidth,
                                                screenHeight),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.seats
                                                    .toString(),
                                                'SEATS',
                                                screenWidth,
                                                screenHeight),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.price
                                                    .toString(),
                                                'PRICE FOR DAY',
                                                screenWidth,
                                                screenHeight),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            FloatingActionButton(
                                                onPressed: () async {
                                                  List<String> files =
                                                      await urlFile(
                                                          PassMarker
                                                              .carModel.uid!,
                                                          PassMarker
                                                              .carModel.cid!);
                                                  final List<ImageProvider>
                                                      _imageProviders = [];
                                                  for (int i = 0;
                                                      i < files.length;
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
                                                },
                                                backgroundColor:
                                                    Colors.redAccent,
                                                child: const Icon(
                                                    Icons.photo_album)),
                                            SizedBox(
                                                height: screenHeight * 0.04),
                                            Container(
                                                child: MaterialButton(
                                                    height: screenHeight * 0.07,
                                                    minWidth: screenWidth * 0.6,
                                                    color: Colors.redAccent,
                                                    onPressed: () async {
                                                      if (PassMarker
                                                          .driveInserted) {
                                                        PassMarker.hpOrNot =
                                                            true;
                                                        var reserveResult =
                                                            'start';
                                                        reserveResult =
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const Least()));

                                                        if (reserveResult ==
                                                            '1') {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop('dialog');
                                                        } else if (reserveResult ==
                                                            '0') {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Something went wrong, try again later',
                                                              fontSize: 18);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No driving license info inserted. Go to configuration for more details',
                                                            fontSize: 18);
                                                      }
                                                    },
                                                    child: Text("Reserve",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                screenWidth *
                                                                    0.08))),
                                                decoration: BoxDecoration(
                                                    color: Colors.deepPurple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color:
                                                              Colors.deepPurple,
                                                          spreadRadius: 6,
                                                          blurRadius: 3)
                                                    ])),
                                            SizedBox(
                                                height: screenHeight * 0.05),
                                            Container(
                                                child: MaterialButton(
                                                    height: screenHeight * 0.07,
                                                    minWidth: screenWidth * 0.6,
                                                    color: Colors.redAccent,
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          context, '');
                                                    },
                                                    child: Text("Return",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                screenWidth *
                                                                    0.08))),
                                                decoration: BoxDecoration(
                                                    color: Colors.deepPurple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color:
                                                              Colors.deepPurple,
                                                          spreadRadius: 6,
                                                          blurRadius: 3)
                                                    ]))
                                          ]));
                                });
                          },
                          child: Text('Reserve',
                              style: TextStyle(fontSize: screenWidth * 0.03)))),
                ], mainAxisAlignment: MainAxisAlignment.center)
              ]))
        ]));
  }

  Widget _buildRow(String imageAsset, String value, String type,
      double screenWidth, double screenHeight) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.008),
        child: Column(children: <Widget>[
          SizedBox(height: screenHeight * 0.012),
          Row(children: <Widget>[
            SizedBox(width: screenWidth * 0.005),
            Text(
              type.toUpperCase(),
              style: TextStyle(fontSize: screenWidth * 0.055),
            ),
            const Spacer(),
            Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[900],
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.012,
                    horizontal: screenWidth * 0.06),
                child: Text(
                  value,
                  style: TextStyle(fontSize: screenWidth * 0.055),
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
}
