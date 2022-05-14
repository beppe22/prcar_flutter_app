// ignore_for_file: no_logic_in_create_state, must_be_immutable, unused_local_variable

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/booking_page.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/models/marker_to_search.dart';
import 'package:prcarpolimi/models/search_model.dart';

const double pinVisiblePosition = 10;
const double pinInvisiblePosition = -220;

class NewMap extends StatefulWidget {
  SearchModel search;
  List<CarModel> cars;
  NewMap(this.search, this.cars, {Key? key}) : super(key: key);

  @override
  _NewMapState createState() => _NewMapState(search, cars);
}

class _NewMapState extends State<NewMap> {
  SearchModel search;
  List<CarModel> cars;

  _NewMapState(this.search, this.cars);
  double pinPillPosition = pinInvisiblePosition;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;
    String? user = _auth.currentUser!.uid.toString();
    return Scaffold(
        appBar: AppBar(
            title: const Text("PrCar"),
            backgroundColor: Colors.redAccent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  SearchMarker.markerToSearch = {};
                  SearchMarker.countMarker = 0;
                  Navigator.pop(context);
                }),
            actions: [
              Row(children: [
                const Text('Reload!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () async {
                      List<CarModel> carsFiltered =
                          await _searchCar(cars, search, user);
                      for (int i = 0; i < carsFiltered.length; i++) {
                        String? carLatLng = carsFiltered[i].position;
                        final splitted = carLatLng!.split('-');
                        double lat = double.parse(splitted[0]);
                        double lng = double.parse(splitted[1]);
                        setState(() {
                          SearchMarker.markerToSearch.add(Marker(
                              markerId: MarkerId('marker$i'),
                              infoWindow:
                                  const InfoWindow(title: 'Searched car'),
                              position: LatLng(lat, lng),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                              onTap: () {
                                setState(() {
                                  pinPillPosition = pinVisiblePosition;
                                });
                              }));
                          SearchMarker.countMarker =
                              SearchMarker.countMarker + 1;
                        });
                      }
                    },
                    icon: const Icon(Icons.autorenew_rounded))
              ])
            ]),
        backgroundColor: Colors.white,
        body: Stack(children: [
          GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                  target: LatLng(45.47811155714095, 9.227444681728846),
                  zoom: 16),
              markers: SearchMarker.markerToSearch,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onTap: (LatLng loc) {
                setState(() {
                  pinPillPosition = pinInvisiblePosition;
                });
              }),
          AnimatedPositioned(
              left: 0,
              curve: Curves.easeInOut,
              right: 0,
              bottom: pinPillPosition,
              child: MapBottomPill(),
              duration: const Duration(milliseconds: 500))
        ]));
  }

  Future<List<CarModel>> _searchCar(
      List<CarModel> cars, SearchModel search, String user) async {
    List<CarModel> filteredCar = [];
    for (int i = 0; i < cars.length; i++) {
      bool j = true;
      String owner = cars[i].uid.toString();
      if (user == owner) {
        j = false;
      }
      if (j &&
          (search.seats.toString() != '') &&
          (int.parse(search.seats.toString()) >
              int.parse(cars[i].seats.toString()))) {
        j = false;
      }
      if (j &&
          (search.fuel.toString() != '') &&
          (search.fuel != cars[i].fuel)) {
        j = false;
      }
      String modelSearch = '';
      if (search.vehicle.toString() != '') {
        String toSplit = search.vehicle.toString();
        final splitted = toSplit.split('-');
        modelSearch = splitted[1];
      }
      if (j &&
          (search.vehicle.toString() != '') &&
          (modelSearch != cars[i].model)) {
        j = false;
      }
      if (j &&
          (search.price.toString() != '') &&
          (int.parse(search.price.toString()) <
              int.parse(cars[i].price.toString()))) {
        j = false;
      }
      if (j &&
          (SearchCar.latSearch.toString() != '') &&
          (_nearbyPosition(SearchCar.latSearch, SearchCar.lngSearch,
              cars[i].position.toString()))) {
        j = false;
      }
      if (j &&
              (SearchCar.date1Search.toString() !=
                  '') /* && (_freeDate(SearchCar.date1Search, SearchCar.date2Search,
      cars[i].date.toString()*/
          ) {
        j = false;
      }
      if (j) {
        filteredCar.add(cars[i]);
      }
    }
    return filteredCar;
  }

  bool _nearbyPosition(String lat, String lng, String carsPos) {
    double lat1 = double.parse(lat) / 57.29577951;
    double lng1 = double.parse(lng) / 57.29577951;
    final splitted = carsPos.split('-');
    double lat2 = double.parse(splitted[0]) / 57.29577951;
    double lng2 = double.parse(splitted[1]) / 57.29577951;
    double distance = 3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(lng2 - lng1)) *
        1.609344;
    return distance > 3;
  }

  /*bool _freeDate(String startDate, String endDate, List<String> allDate) {
    if(allDate.length == 0)
    {
      return false;
    }
    else
    {
      for (int i = 0; i < allDate.length; i++)
      {
        if ((int.parse(startDate.substring(6)) >= int.parse(allDate[i].substring(6,10)))) 
        {
          if((int.parse(startDate.substring(3,5)) >= int.parse(allDate[i].substring(3,5))))
          {
            if((int.parse(startDate.substring(0,2)) >= int.parse(allDate[i].substring(0,2))))
            {
              if ((int.parse(endDate.substring(6)) <= int.parse(allDate[i].substring(17)))) 
               {
                if((int.parse(endDate.substring(3,5)) <= int.parse(allDate[i].substring(14,16))))
                {
                  if((int.parse(endDate.substring(0,2)) <= int.parse(allDate[i].substring(11,13))))
                  {
                    return false;
                  }
                }
              }
            }
          }
        }
      }
      return true;
    }
  }*/
}

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
                                        SizedBox(
                                            height: 175,
                                            child: Image.asset(
                                                "assets/prcarlogo.png",
                                                fit: BoxFit.contain)),
                                        Container(
                                            child: MaterialButton(
                                                height: 50,
                                                minWidth: 200,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  Navigator.pop(
                                                      context,
                                                      await BookingOut(
                                                              PassMarker
                                                                  .carModel.cid,
                                                              PassMarker
                                                                  .carModel.uid)
                                                          .book());
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
