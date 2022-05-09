// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/filters/position/location_service.dart';
import 'package:prcarpolimi/models/car_parameter.dart';

class Position extends StatefulWidget {
  const Position({Key? key}) : super(key: key);
  @override
  _Position createState() => _Position();
}

class _Position extends State<Position> {
  double lat = 0;
  double lng = 0;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchcontroller = TextEditingController();
  String position = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Position"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, '');
                }),
            actions: [
              Row(children: [
                const Text('Search!',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      SearchCar.latSearch = lat.toString();
                      SearchCar.lngSearch = lng.toString();
                      Navigator.pop(context, position);
                    },
                    icon: const Icon(Icons.add_location_alt_outlined))
              ])
            ]),
        body: Column(children: [
          Row(children: [
            Expanded(
                child: TextFormField(
                    controller: _searchcontroller,
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        const InputDecoration(hintText: 'Search Car Position'),
                    onChanged: (value) {})),
            IconButton(
                onPressed: () async {
                  var place =
                      await LocationService().getPlace(_searchcontroller.text);
                  _goToPlace(place);
                },
                icon: const Icon(Icons.search))
          ]),
          Expanded(
              child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: const CameraPosition(
                target: LatLng(45.47811155714095, 9.227444681728846), zoom: 16),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ))
        ]));
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    lat = place['geometry']['location']['lat'];
    lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 16)));
    position = place['formatted_address'].toString();
  }
}
