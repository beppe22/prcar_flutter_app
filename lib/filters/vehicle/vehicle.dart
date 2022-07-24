// ignore_for_file: library_prefixes, unnecessary_null_comparison, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'ProductDataModel.dart';
import 'model.dart';

class Vehicle extends StatefulWidget {
  Service service;
  Vehicle({Key? key, required this.service}) : super(key: key);
  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: Text("Vehicle",
                    style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context, '');
                    })),
            body: FutureBuilder(
                future: readJsonData(),
                builder: (context, data) {
                  if (data.hasError) {
                    return Center(child: Text("${data.error}"));
                  } else if (data.hasData) {
                    var items = data.data as List<VehicleDataModel>;
                    return ListView.builder(
                        itemCount: items == null ? 0 : items.length,
                        itemBuilder: (context, index) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: screenHeight * 0.035),
                                Container(
                                    width: screenWidth * 0.87,
                                    height: screenHeight * 0.1,
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Models(
                                                                indice: index,
                                                                service:
                                                                    Service())));
                                              },
                                              child: Text(
                                                  items[index].brand.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: screenText * 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)))
                                        ]))
                              ]);
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text("Vehicle",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context, '');
                          })),
                  body: FutureBuilder(
                      future: readJsonData(),
                      builder: (context, data) {
                        if (data.hasError) {
                          return Center(child: Text("${data.error}"));
                        } else if (data.hasData) {
                          var items = data.data as List<VehicleDataModel>;
                          return ListView.builder(
                              itemCount: items == null ? 0 : items.length,
                              itemBuilder: (context, index) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screenHeight * 0.035),
                                      Container(
                                          width: screenWidth * 0.87,
                                          height: screenHeight * 0.1,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Models(
                                                                      indice:
                                                                          index,
                                                                      service:
                                                                          Service())));
                                                    },
                                                    child: Text(
                                                        items[index]
                                                            .brand
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText * 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)))
                                              ]))
                                    ]);
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }));
            } else {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text("Vehicle",
                          style: TextStyle(fontSize: screenText * 30)),
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: screenText * 35),
                          onPressed: () {
                            Navigator.pop(context, '');
                          })),
                  body: FutureBuilder(
                      future: readJsonData(),
                      builder: (context, data) {
                        if (data.hasError) {
                          return Center(child: Text("${data.error}"));
                        } else if (data.hasData) {
                          var items = data.data as List<VehicleDataModel>;
                          return ListView.builder(
                              itemCount: items == null ? 0 : items.length,
                              itemBuilder: (context, index) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screenHeight * 0.035),
                                      Container(
                                          width: screenWidth * 0.7,
                                          height: screenHeight * 0.13,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Models(
                                                                      indice:
                                                                          index,
                                                                      service:
                                                                          Service())));
                                                    },
                                                    child: Text(
                                                        items[index]
                                                            .brand
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenText * 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)))
                                              ]))
                                    ]);
                              });
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }));
            }
          });
  }

  Future<List<VehicleDataModel>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/carmodels.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => VehicleDataModel.fromJson(e)).toList();
  }
}
