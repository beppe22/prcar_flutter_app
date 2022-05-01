// ignore_for_file: library_prefixes, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'ProductDataModel.dart';
import 'model.dart';

class Vehicle extends StatefulWidget {
  const Vehicle({Key? key}) : super(key: key);
  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Vehicle"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 6),
                          child: Container(
                              color: Colors.redAccent,
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10, height: 50),
                                    Expanded(
                                        child: Container(
                                            width: double.maxFinite,
                                            height: 50,
                                            margin: const EdgeInsets.only(
                                                top: 15,
                                                left: 40,
                                                right: 40,
                                                bottom: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Models(
                                                                        indice:
                                                                            index)));
                                                      },
                                                      child: Text(
                                                          items[index]
                                                              .brand
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)))
                                                ])))
                                  ])));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<List<VehicleDataModel>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/carmodels.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => VehicleDataModel.fromJson(e)).toList();
  }
}
