import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'about_your_car/album.dart';

class MapBottomPill extends StatelessWidget {
  const MapBottomPill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30),
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
                        width: 100,
                        height: 85,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter)),
                Column(children: [
                  const Text('Selected car, click below for',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  const Text('more details: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Container(
                      width: 140,
                      margin: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          onPressed: () async {
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 6,
                                      child: Column(children: <Widget>[
                                        const SizedBox(height: 20),
                                        const Center(
                                            child: Text('Car Information',
                                                style: TextStyle(
                                                    fontSize: 38,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        const SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.vehicle
                                                .toString(),
                                            'VEHICLE'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.model
                                                .toString(),
                                            'MODEL'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.fuel.toString(),
                                            'FUEL'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.seats
                                                .toString(),
                                            'SEATS'),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.price
                                                .toString(),
                                            'PRICE FOR DAY'),
                                        const SizedBox(height: 20),
                                        FloatingActionButton(
                                            onPressed: () async {
                                              /*String files = await urlFile(
                                                  PassMarker.carModel.uid!,
                                                  PassMarker.carModel.cid!);
                                              */
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Album(
                                                              cid: PassMarker
                                                                  .carModel
                                                                  .cid!,
                                                              uid: PassMarker
                                                                  .carModel
                                                                  .uid!,
                                                              files: '')));
                                            },
                                            backgroundColor: Colors.redAccent,
                                            child:
                                                const Icon(Icons.photo_album)),
                                        const SizedBox(height: 40),
                                        Container(
                                            child: MaterialButton(
                                                height: 50,
                                                minWidth: 200,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  if (PassMarker
                                                      .driveInserted) {
                                                    PassMarker.hpOrNot = true;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Least()));
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'No driving license info inserted. Go to configuration for more details',
                                                        fontSize: 18);
                                                  }
                                                },
                                                child: const Text("Reserve",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0))),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.deepPurple,
                                                      spreadRadius: 6,
                                                      blurRadius: 3)
                                                ])),
                                        const SizedBox(height: 30),
                                        Container(
                                            child: MaterialButton(
                                                height: 50,
                                                minWidth: 200,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  Navigator.pop(context, '');
                                                },
                                                child: const Text("Return",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22.0))),
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.deepPurple,
                                                      spreadRadius: 6,
                                                      blurRadius: 3)
                                                ]))
                                      ]));
                                });
                            if (result == '1') {
                              /*showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Congra'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Your Booked your car'),
                                          
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Navigator.pop(context, '1')
                                    ],
                                  );
                                },
                              );*/
                            }
                            //fare spuntare un label per comunicare se la reservation ha avuto buon fine
                          },
                          child: const Text('Reserve'))),
                ], mainAxisAlignment: MainAxisAlignment.center)
              ]))
        ]));
  }

  Widget _buildRow(String imageAsset, String value, String type) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          const SizedBox(height: 12),
          //Container(height: 2, color: Colors.redAccent),
          Row(children: <Widget>[
            //CircleAvatar(backgroundImage: AssetImage(imageAsset)),
            const SizedBox(width: 12),
            Text(
              type.toUpperCase(),
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[900],
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ))
          ])
        ]));
  }
}
