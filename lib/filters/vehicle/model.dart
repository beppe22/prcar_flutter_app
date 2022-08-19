// ignore_for_file: must_be_immutable, no_logic_in_create_state, library_prefixes
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:prcarpolimi/models/car_parameter.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'ProductDataModel.dart';

class Models extends StatefulWidget {
  int indice;
  Service service;
  Models({Key? key, required this.indice, required this.service})
      : super(key: key);

  @override
  _ModelsState createState() => _ModelsState(indice);
}

class _ModelsState extends State<Models> {
  int indice, count = 0;
  _ModelsState(this.indice);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text("Models", style: TextStyle(fontSize: screenText * 20)),
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
                    var modelNames = items[indice].models;
                    return ListView.builder(
                        itemCount: modelNames == null ? 0 : modelNames.length,
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
                                              key: Key("button for model"),
                                              onTap: () {
                                                Navigator.of(context)
                                                  ..pop()
                                                  ..pop();
                                                SearchCar.vehicle =
                                                    items[indice]
                                                        .brand
                                                        .toString();
                                                SearchCar.model =
                                                    modelNames![index]
                                                        .toString();
                                              },
                                              child: Text(
                                                  modelNames![index].toString(),
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
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Models",
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
                          var modelNames = items[indice].models;
                          return ListView.builder(
                              itemCount:
                                  modelNames == null ? 0 : modelNames.length,
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
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop();
                                                      SearchCar.vehicle =
                                                          items[indice]
                                                              .brand
                                                              .toString();
                                                      SearchCar.model =
                                                          modelNames![index]
                                                              .toString();
                                                    },
                                                    child: Text(
                                                        modelNames![index]
                                                            .toString(),
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
                  appBar: AppBar(
                      backgroundColor: Colors.redAccent,
                      title: Text("Models",
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
                          var modelNames = items[indice].models;
                          return ListView.builder(
                              itemCount:
                                  modelNames == null ? 0 : modelNames.length,
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
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop();
                                                      SearchCar.vehicle =
                                                          items[indice]
                                                              .brand
                                                              .toString();
                                                      SearchCar.model =
                                                          modelNames![index]
                                                              .toString();
                                                    },
                                                    child: Text(
                                                        modelNames![index]
                                                            .toString(),
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

//Function that retrieves the car list
  Future<List<VehicleDataModel>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/carmodels.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => VehicleDataModel.fromJson(e)).toList();
  }
}
