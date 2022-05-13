// ignore_for_file: must_be_immutable, no_logic_in_create_state, library_prefixes
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:prcarpolimi/models/car_parameter.dart';
import 'ProductDataModel.dart';

class Models extends StatefulWidget {
  int indice;
  Models({Key? key, required this.indice}) : super(key: key);

  @override
  _ModelsState createState() => _ModelsState(indice);
}

class _ModelsState extends State<Models> {
  int indice, count = 0;
  _ModelsState(this.indice);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Models"),
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
                var modelNames = items[indice].models;
                return ListView.builder(
                    itemCount: modelNames == null ? 0 : modelNames.length,
                    itemBuilder: (context, index) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 35),
                            Container(
                                width: 350,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                              ..pop()
                                              ..pop();
                                            SearchCar.vehicle =
                                                items[indice].brand.toString();
                                            SearchCar.model =
                                                modelNames![index].toString();
                                          },
                                          child: Text(
                                              modelNames![index].toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)))
                                    ]))
                          ]);
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
