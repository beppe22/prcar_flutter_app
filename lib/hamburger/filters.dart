import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import '../filters/fuel/fuel.dart';
import '../filters/least/least.dart';
import '../filters/position/position.dart';
import '../filters/price/price.dart';
import '../filters/seats/seats.dart';
import '../filters/vehicle/vehicle.dart';
import '../models/marker_to_pass.dart';
import '../models/search_model.dart';
import 'package:intl/intl.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  static late SearchModel search;
  final _auth = FirebaseAuth.instance;
  bool from = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    search = SearchModel(
        seats: '', fuel: '', price: '', least: '', vehicle: '', position: '');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    String? user = _auth.currentUser!.uid.toString();
    //least button field
    final leastButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.03,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              PassMarker.hpOrNot = false;
              SearchCar.date1Search = '';
              SearchCar.date2Search = '';
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Least()))
                  .then((data) {
                setState(() {
                  if (data != '') {
                    SearchCar.date1Search = data[0];
                    SearchCar.date2Search = data[1];
                  }
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text(
                _printLeast(SearchCar.date1Search, SearchCar.date2Search),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //position button field
    final positionButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Position()))
                  .then((data) {
                setState(() {
                  search.position = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text("Position: " + search.position.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenText * 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))))));

//vehicle button field
    final vehicleButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Vehicle()))
                  .then((data) {
                if (data != '') {
                  setState(() {
                    search.vehicle = SearchCar.vehicle + '-' + SearchCar.model;
                  });
                }
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text("Vehicle: " + search.vehicle.toString(),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenText * 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))))));

    //seats button field
    final seatsButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Seats(filter: true))).then((data) {
                setState(() {
                  search.seats = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Seats: " + search.seats.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //fuel button field
    final fuelButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Fuel()))
                  .then((data) {
                setState(() {
                  search.fuel = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Fuel: " + search.fuel.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    //price button field
    final priceButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Price(filter: true))).then((data) {
                setState(() {
                  search.price = data;
                });
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Price: " + search.price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

//clear button field
    final clearButton = Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.07,
        margin: EdgeInsets.only(
            top: screenHeight * 0.01,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: MaterialButton(
            onPressed: () {
              setState(() {
                search.fuel = '';
                search.model = '';
                search.least = '';
                search.price = '';
                search.vehicle = '';
                search.seats = '';
                search.position = '';
                SearchCar.latSearch = '';
                SearchCar.lngSearch = '';
                SearchCar.date1Search = '';
                SearchCar.date2Search = '';
              });
            },
            padding: EdgeInsets.fromLTRB(screenHeight * 0.01,
                screenWidth * 0.03, screenWidth * 0.03, screenHeight * 0.01),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            child: Text("Clear All",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenText * 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));

    return SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text('Filter', style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, size: screenText * 25),
                    onPressed: () {
                      setState(() {
                        search.fuel = '';
                        search.model = '';
                        search.least = '';
                        search.price = '';
                        search.vehicle = '';
                        search.seats = '';
                        search.position = '';
                        SearchCar.latSearch = '';
                        SearchCar.lngSearch = '';
                        SearchCar.date1Search = '';
                        SearchCar.date2Search = '';
                      });
                      Navigator.pop(context);
                    }),
                actions: [
                  Row(children: [
                    Text('Search!',
                        style: TextStyle(
                            fontSize: screenText * 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          List<CarModel> cars = await _fetchCar();
                          List<CarModel> searchCars =
                              await _searchCar(cars, search, user);
                          setState(() {
                            search.fuel = '';
                            search.model = '';
                            search.least = '';
                            search.price = '';
                            search.vehicle = '';
                            search.seats = '';
                            search.position = '';
                            SearchCar.latSearch = '';
                            SearchCar.lngSearch = '';
                            SearchCar.date1Search = '';
                            SearchCar.date2Search = '';
                          });
                          if (searchCars.isNotEmpty) {
                            PassMarker.from = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(searchCar: searchCars)));
                          } else {
                            Fluttertoast.showToast(
                                msg: 'No car found :( try with less parameters',
                                fontSize: 20);
                          }
                        },
                        icon: Icon(Icons.add_task, size: screenText * 25))
                  ])
                ]),
            body: Center(
                child: Column(children: <Widget>[
              SizedBox(height: screenHeight * 0.04),
              SizedBox(
                  height: screenHeight * 0.04,
                  child: Text("Apply filters for your need",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: screenText * 25))),
              SizedBox(height: screenHeight * 0.015),
              leastButton,
              SizedBox(height: screenHeight * 0.015),
              vehicleButton,
              SizedBox(height: screenHeight * 0.015),
              positionButton,
              SizedBox(height: screenHeight * 0.015),
              seatsButton,
              SizedBox(height: screenHeight * 0.015),
              fuelButton,
              SizedBox(height: screenHeight * 0.015),
              priceButton,
              SizedBox(height: screenHeight * 0.015),
              clearButton
            ]))));
  }

  String _printLeast(String start, String end) {
    if (start == '' && end == '') {
      return 'Least: ';
    } else {
      return 'Least: ' + start.substring(0, 5) + '-' + end.substring(0, 5);
    }
  }

  Future<List<CarModel>> _fetchCar() async {
    final _auth = FirebaseAuth.instance;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    List<CarModel> cars = [];

    if (user != null) {
      try {
        await firebaseFirestore.collection('users').get()
            //quando non ci sono macchine da errore
            .then((ds) async {
          for (var user_1 in ds.docs) {
            //print(user_1.data());
            await firebaseFirestore
                .collection('users')
                .doc(user_1.data()['uid'])
                .collection('cars')
                .get()
                .then((ds_1) {
              for (var car in ds_1.docs) {
                //print(car.data());
                if (car.data()['activeOrNot'] == 't') {
                  cars.add(CarModel.fromMap(car.data()));
                }
              }
            });
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "impossible to insert new car") {}
      }
    }
    return cars;
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
          (SearchCar.date1Search.toString() != '') &&
          (_freeDate(SearchCar.date1Search, SearchCar.date2Search,
              await _fetchDates(cars[i].uid, cars[i].cid)))) {
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
    final splitted = carsPos.split(',');
    double lat2 = double.parse(splitted[0]) / 57.29577951;
    double lng2 = double.parse(splitted[1]) / 57.29577951;
    double distance = 3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(lng2 - lng1)) *
        1.609344;
    return distance > 3;
  }

  bool _freeDate(String startDate, String endDate, List<String> allDate) {
    DateTime started = DateFormat("dd/MM/yyyy").parse(startDate);
    DateTime ended = DateFormat("dd/MM/yyyy").parse(endDate);
    if (allDate.isEmpty) {
      return false;
    } else {
      for (int i = 0; i < allDate.length; i++) {
        final splitted = allDate[i].split('-');
        String start = splitted[0];
        String end = splitted[1];
        DateTime startD = DateFormat("dd/MM/yyyy").parse(start);
        DateTime endD = DateFormat("dd/MM/yyyy").parse(end);
        if ((startD.compareTo(started) >= 0 && startD.compareTo(ended) <= 0) ||
            (endD.compareTo(started) >= 0 && endD.compareTo(ended) <= 0)) {
          return true;
        }
      }
      return false;
    }
  }

  Future<List<String>> _fetchDates(String? carsUid, String? carsCid) async {
    List<String> dates = [];

    var data = await firebaseFirestore
        .collection('users')
        .doc(carsUid)
        .collection('cars')
        .doc(carsCid)
        .collection('booking-in')
        .get();
    if (data.docs.isNotEmpty) {
      for (var bookIn in data.docs) {
        if (bookIn.data()['status'] != 'a') {
          dates.add(bookIn.data()['date']);
        }
      }
    }
    return dates;
  }
}
