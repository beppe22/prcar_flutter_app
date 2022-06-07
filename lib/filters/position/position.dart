// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool index = false;
  Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title:
                Text("Position", style: TextStyle(fontSize: screenText * 20)),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: screenText * 25),
                onPressed: () {
                  Navigator.pop(context, '');
                }),
            actions: [
              Row(children: [
                Text('Okay!',
                    style: TextStyle(
                        fontSize: screenText * 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      SearchCar.latSearch = '';
                      SearchCar.lngSearch = '';
                      if (index) {
                        SearchCar.latSearch = lat.toString();
                        SearchCar.lngSearch = lng.toString();
                        index = true;
                        Navigator.pop(context, position);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'No place choosen :(', fontSize: 20);
                      }
                    },
                    icon: Icon(Icons.add_location_alt_outlined,
                        size: screenText * 25))
              ])
            ]),
        body: Column(children: [
          Row(children: [
            Expanded(
                child: TextFormField(
                    controller: _searchcontroller,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: ' Search Car Position',
                        hintStyle: TextStyle(fontSize: screenText * 18)),
                    onChanged: (value) {})),
            IconButton(
                onPressed: () async {
                  try {
                    var place = await LocationService()
                        .getPlace(_searchcontroller.text);
                    _goToPlace(place);
                    index = true;
                  } on RangeError catch (e) {
                    print(e);
                  }
                },
                icon: Icon(Icons.search, size: screenText * 25))
          ]),
          Expanded(
              child: GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(45.47811155714095, 9.227444681728846),
                      zoom: 16),
                  onTap: _handleTap,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  }))
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

  _handleTap(LatLng point) {
    setState(() {
      _markers = {};
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: 'Location',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
      lat = point.latitude;
      lng = point.longitude;
      index = true;
      position =
          lat.toString().substring(0, 6) + ',' + lng.toString().substring(0, 6);
    });
  }
}
