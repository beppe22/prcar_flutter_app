// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/auth/storage_service.dart';
import 'package:prcarpolimi/booking/booking_in.dart';
import 'package:prcarpolimi/chatImplementation/chatDetail.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/hamburger/infoAccount.dart';
import 'package:prcarpolimi/hamburger/booking_page.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/car_parameter.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/static_user.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/services/services.dart';
import 'Internet/NetworkCheck.dart';
import 'bottom_pill.dart';
import 'filters/least/least.dart';
import 'hamburger/cars_user.dart';
import 'hamburger/filters.dart';
import 'dart:io' show Platform;
import 'hamburger/help.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

const double pinVisiblePosition = 50;
const double pinVisiblePosition2 = 150;
const double pinVisiblePosition3 = 20;
const double pinInvisiblePosition = -220;
const double pinInvisiblePosition2 = -1020;

class HomePage extends StatefulWidget {
  List<CarModel>? searchCar;
  List<String>? positionString;
  Service homePageService;

  HomePage(
      {Key? key,
      required this.homePageService,
      this.searchCar,
      this.positionString})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(searchCar, positionString);
}

class _HomePageState extends State<HomePage> {
  List<CarModel>? searchCar;
  List<String>? positionString;
  _HomePageState(this.searchCar, this.positionString);
  double? pinPillPosition;
  BitmapDescriptor? icon;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (PassMarker.useMobileLayout!) {
      pinPillPosition = -220;
    } else {
      pinPillPosition = -1020;
    }
    _updateMarkers();
    _updateTimer();

    _saveToken();
    if (Platform.isAndroid) {
      _listen();

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        print('Message clicked!');
        print(message.notification!.body);
        if (message.data["type"] == 'booking') {
          List<String> bookIn = await _fetchOtherRes();
          //bookingId in input
          String bookingId = message.data["bookId"];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingInPage(
                      bookingId: bookingId,
                      res: bookIn,
                      fromHp: true,
                      service: Service())));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetail(
                      friendName: message.data['friendName'],
                      friendUid: message.data['friendId'],
                      hp: true)));
        }
      });
    }
  }

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double long = 0, lat = 0;
  late StreamSubscription<Position> positionStream;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenText = MediaQuery.of(context).textScaleFactor;
    GoogleMapController _controller;

    return PassMarker.useMobileLayout!
        ? WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                appBar: AppBar(
                    title: Text("PrCar",
                        style: TextStyle(fontSize: screenText * 20)),
                    backgroundColor: Colors.redAccent,
                    actions: [
                      !PassMarker.from
                          ? Row(children: [
                              Text('Clear filter!',
                                  style: TextStyle(
                                      fontSize: screenText * 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    PassMarker.from = true;
                                    _updateMarkers();
                                  },
                                  icon: Icon(Icons.autorenew_rounded,
                                      size: screenText * 25))
                            ])
                          : Row(children: [
                              Text('Filters',
                                  style: TextStyle(
                                      fontSize: screenText * 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    SearchCar.vehicle = '';
                                    SearchCar.model = '';
                                    SearchCar.date1Search = '';
                                    SearchCar.date2Search = '';
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Filters(
                                                    service: Service())))
                                        .then((data) {
                                      searchCar = data;
                                    });
                                  },
                                  icon:
                                      Icon(Icons.search, size: screenText * 25))
                            ])
                    ]),
                backgroundColor: Colors.white,
                drawer: Drawer(
                    key: ValueKey(10),
                    child: ListView(padding: EdgeInsets.zero, children: [
                      SizedBox(height: screenHeight * 0.08),
                      SizedBox(
                          child: Text("  Home",
                              style: TextStyle(
                                  fontSize: screenText * 30,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(height: screenHeight * 0.02),
                      ListTile(
                          title: Text("Account",
                              style: TextStyle(fontSize: screenText * 16)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InfoAccount(service: Service())));
                          }),
                      ListTile(
                          title: Text("Booking",
                              style: TextStyle(fontSize: screenText * 16)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagePage(
                                          service: Service(),
                                        )));
                          }),
                      ListTile(
                          title: Text("About your car",
                              style: TextStyle(fontSize: screenText * 16)),
                          onTap: () async {
                            List<CarModel> cars = await _fetchInfoCar();
                            if (cars != []) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Cars_user(cars,
                                          service: Service()))).then((data) {
                                if (mounted) {
                                  setState(() {
                                    _updateMarkers();
                                  });
                                }
                              });
                            }
                          }),
                      ListTile(
                          title: Text("Configuration",
                              style: TextStyle(fontSize: screenText * 16)),
                          onTap: () async {
                            User? user = widget.homePageService.currentUser();
                            String confirmed = await _isConfirmed(user!);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Configuration(
                                        isConfirmed: confirmed,
                                        service: Service())));
                          }),
                      ListTile(
                          title: Text("Help",
                              style: TextStyle(fontSize: screenText * 16)),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Help()));
                          })
                    ])),
                body: Stack(children: [
                  GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(45.47811155714095, 9.227444681728846),
                          zoom: 16),
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      onTap: (LatLng loc) {
                        if (mounted) {
                          setState(() {
                            pinPillPosition = pinInvisiblePosition;
                          });
                        }
                      }),
                  AnimatedPositioned(
                      left: 0,
                      curve: Curves.easeInOut,
                      right: 0,
                      bottom: pinPillPosition,
                      child: const MapBottomPill(),
                      duration: const Duration(milliseconds: 500))
                ])))
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                appBar: AppBar(
                    title: Text("PrCar",
                        style: TextStyle(fontSize: screenText * 30)),
                    backgroundColor: Colors.redAccent,
                    actions: [
                      !PassMarker.from
                          ? Row(children: [
                              Text('Clear filter!',
                                  style: TextStyle(
                                      fontSize: screenText * 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    PassMarker.from = true;
                                    _updateMarkers();
                                  },
                                  icon: Icon(Icons.autorenew_rounded,
                                      size: screenText * 30))
                            ])
                          : Row(children: [
                              Text('Filters',
                                  style: TextStyle(
                                      fontSize: screenText * 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () {
                                    SearchCar.date1Search = '';
                                    SearchCar.date2Search = '';
                                    SearchCar.vehicle = '';
                                    SearchCar.model = '';
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Filters(
                                                    service: Service())))
                                        .then((data) {
                                      searchCar = data;
                                    });
                                  },
                                  icon:
                                      Icon(Icons.search, size: screenText * 30))
                            ])
                    ]),
                backgroundColor: Colors.white,
                drawer: Drawer(
                    key: ValueKey(11),
                    child: ListView(padding: EdgeInsets.zero, children: [
                      SizedBox(height: screenHeight * 0.04),
                      SizedBox(
                          child: Text(" Home",
                              style: TextStyle(
                                  fontSize: screenText * 50,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(height: screenHeight * 0.02),
                      ListTile(
                          title: Text(" Account",
                              style: TextStyle(fontSize: screenText * 20)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InfoAccount(service: Service())));
                          }),
                      ListTile(
                          title: Text(" Booking",
                              style: TextStyle(fontSize: screenText * 20)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagePage(
                                          service: Service(),
                                        )));
                          }),
                      ListTile(
                          title: Text(" About your car",
                              style: TextStyle(fontSize: screenText * 20)),
                          onTap: () async {
                            List<CarModel> cars = await _fetchInfoCar();
                            if (cars != []) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Cars_user(cars,
                                          service: Service()))).then((data) {
                                if (mounted) {
                                  setState(() {
                                    _updateMarkers();
                                  });
                                }
                              });
                            }
                          }),
                      ListTile(
                          title: Text(" Configuration",
                              style: TextStyle(fontSize: screenText * 20)),
                          onTap: () async {
                            User? user = widget.homePageService.currentUser();
                            String confirmed = await _isConfirmed(user!);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Configuration(
                                        isConfirmed: confirmed,
                                        service: Service())));
                          }),
                      ListTile(
                          title: Text(" Help",
                              style: TextStyle(fontSize: screenText * 20)),
                          onTap: () async {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight
                            ]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Help()));
                          })
                    ])),
                body: Stack(children: [
                  GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(45.47811155714095, 9.227444681728846),
                          zoom: 16),
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      onTap: (LatLng loc) {
                        if (mounted) {
                          setState(() {
                            pinPillPosition = pinInvisiblePosition2;
                          });
                        }
                      }),
                  AnimatedPositioned(
                      left: 0,
                      curve: Curves.easeInOut,
                      right: 0,
                      bottom: pinPillPosition,
                      child: const MapBottomPill(),
                      duration: const Duration(milliseconds: 500))
                ])));
  }

  _fetchUserInfo() async {
    User? user = widget.homePageService.currentUser();

    if (user != null) {
      UserModel userModel = UserModel.fromMap(await widget.homePageService
          .firebasefirestore()
          .collection('users')
          .doc(widget.homePageService.currentUser()?.uid.toString())
          .get());

      StaticUser.email = userModel.email!;
      StaticUser.uid = userModel.uid!;
      StaticUser.firstName = userModel.firstName!;
      StaticUser.secondName = userModel.secondName!;
    }
  }

  _saveToken() {
    if (widget.homePageService.firebaseMessaging() != null) {
      widget.homePageService.firebaseMessaging().getToken().then((value) async {
        await _fetchUserInfo();
        if (value != null) {
          await widget.homePageService
              .firebasefirestore()
              .collection('tokens')
              .doc(StaticUser.uid)
              .set({
            'token': value,
            'createdAt': FieldValue.serverTimestamp(),
            'platform': Platform.operatingSystem
          });
        }
      });
    }
  }

  _listen() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings =
        await widget.homePageService.firebaseMessaging().requestPermission(
              alert: true,
              badge: true,
              provisional: false,
              sound: true,
            );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        final screenText = MediaQuery.of(context).textScaleFactor;
        print("message recieved");
        print(event.notification!.body);
        if (event.data['type'] == 'booking') {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(event.notification!.body.toString(),
                      style: TextStyle(
                          fontSize: screenText * 25,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  content: FloatingActionButton(
                    onPressed: () async {
                      List<String> bookIn = await _fetchOtherRes();
                      String bookingId = event.data["bookId"];
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingInPage(
                                  bookingId: bookingId,
                                  res: bookIn,
                                  fromHp: true,
                                  service: Service())));
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.book, size: screenText * 25),
                  )));
        } else {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(event.notification!.body.toString(),
                      style: const TextStyle(
                          fontSize: 28,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  content: FloatingActionButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                  friendName: event.data['friendName'],
                                  friendUid: event.data['friendId'],
                                  hp: true)));
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.message_rounded, size: screenText * 25),
                  )));
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<List<String>> _fetchOtherRes() async {
    User? user = widget.homePageService.currentUser();
    List<String> otherRes = [];
    PassMarker.uidFriend = [];
    PassMarker.cid = [];
    PassMarker.bookId = [];
    PassMarker.status = [];

    if (user != null) {
      var data = await widget.homePageService
          .firebasefirestore()
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get();
      if (data.docs.isNotEmpty) {
        for (var car in data.docs) {
          await widget.homePageService
              .firebasefirestore()
              .collection('users')
              .doc(car.data()['uid'])
              .collection('cars')
              .doc(car.data()['cid'])
              .collection('booking-in')
              .get()
              .then((ds) async {
            if (ds.docs.isNotEmpty) {
              for (var book in ds.docs) {
                String insert = book.data()['date'];
                var data1 = await widget.homePageService
                    .firebasefirestore()
                    .collection('users')
                    .doc(book.data()['uidOwner'])
                    .collection('cars')
                    .doc(book.data()['cid'])
                    .get();
                if (book.data()['status'] != 'e') {
                  PassMarker.uidFriend.add(book.data()['uidBooking']);
                  PassMarker.cid.add(book.data()['cid']);
                  PassMarker.bookId.add(book.data()['bookingId']);
                  PassMarker.status.add(book.data()['status']);
                  insert = insert +
                      '.' +
                      data1.data()!['veicol'] +
                      '-' +
                      data1.data()!['model'];

                  otherRes.add(insert);
                }
              }
            }
          });
        }
      }
    }
    return otherRes;
  }

//Function that fecth all the cars in the database
  Future<List<CarModel>> _fetchCar() async {
    User? user = widget.homePageService.currentUser();

    List<CarModel> cars = [];

    if (user != null) {
      try {
        await widget.homePageService
            .firebasefirestore()
            .collection('users')
            .get()
            .then((ds) async {
          for (var user_1 in ds.docs) {
            try {
              await widget.homePageService
                  .firebasefirestore()
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
            } on FirebaseAuthException catch (e) {
              print(e.code);
            }
          }
        });
      } on FirebaseAuthException catch (e) {
        print(e.code);
      }
    }
    return cars;
  }

//Function that fecth only user's car
  Future<List<CarModel>> _fetchInfoCar() async {
    User? user = widget.homePageService.currentUser();
    List<CarModel> cars = [];

    if (user != null) {
      try {
        await widget.homePageService
            .firebasefirestore()
            .collection('users')
            .doc(user.uid)
            .collection('cars')
            .get()
            .then((ds) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "cars not found") {}
      }
    }
    return cars;
  }

//Functions that updates markers periodically
  void _updateMarkers() async {
    try {
      String? userAuth = widget.homePageService.currentUser()?.uid.toString();
      if (PassMarker.from) {
        PassMarker.markerToPass = {};
        List<CarModel> cars = await _fetchCar();
        for (int i = 0; i < cars.length; i++) {
          String? carLatLng = cars[i].position;
          final splitted = carLatLng!.split(',');
          double lat = double.parse(splitted[0]);
          double lng = double.parse(splitted[1]);
          if (mounted) {
            setState(() {
              PassMarker.markerToPass.add(Marker(
                  markerId: MarkerId('marker$i'),
                  infoWindow: InfoWindow(
                      title: HomePageTest().printInfoWindow(
                          cars[i].uid.toString(),
                          userAuth!,
                          cars[i].vehicle.toString() +
                              '-' +
                              cars[i].model.toString()),
                      onTap: () {
                        if (cars[i].uid == userAuth) {
                          String suspOrAct = '';
                          if (cars[i].activeOrNot == 't') {
                            suspOrAct = 'Suspend';
                          } else {
                            suspOrAct = 'Active';
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoCar(
                                        cars[i],
                                        suspOrAct,
                                        true,
                                        service: Service(),
                                      )));
                        }
                      }),
                  position: LatLng(lat, lng),
                  icon: HomePageTest()
                      .iconColor(cars[i].uid.toString(), userAuth),
                  onTap: () async {
                    if (userAuth != cars[i].uid.toString()) {
                      PassMarker.carModel = cars[i];
                      if (mounted) {
                        if (PassMarker.useMobileLayout!) {
                          setState(() {
                            pinPillPosition = pinVisiblePosition;
                          });
                        } else {
                          String name =
                              await _nameString(PassMarker.carModel.uid!);
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
                                          SizedBox(height: 10),
                                          Center(
                                              child: Text('Car Information',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          SizedBox(height: 8),
                                          Text('Owner: ' + name,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          _buildRow(
                                              'assets/choc.png',
                                              PassMarker.carModel.vehicle
                                                  .toString(),
                                              'VEHICLE',
                                              200,
                                              20,
                                              20),
                                          SizedBox(height: 10),
                                          _buildRow(
                                              'assets/choc.png',
                                              PassMarker.carModel.model
                                                  .toString(),
                                              'MODEL',
                                              200,
                                              20,
                                              20),
                                          SizedBox(height: 10),
                                          _buildRow(
                                              'assets/choc.png',
                                              PassMarker.carModel.fuel
                                                  .toString(),
                                              'FUEL',
                                              200,
                                              20,
                                              20),
                                          SizedBox(height: 10),
                                          _buildRow(
                                              'assets/choc.png',
                                              PassMarker.carModel.seats
                                                  .toString(),
                                              'SEATS',
                                              200,
                                              20,
                                              20),
                                          SizedBox(height: 10),
                                          _buildRow(
                                              'assets/choc.png',
                                              PassMarker.carModel.price
                                                  .toString(),
                                              'PRICE FOR DAY',
                                              200,
                                              20,
                                              20),
                                          SizedBox(height: 10),
                                          FloatingActionButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                );
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
                                                Navigator.pop(context);
                                              },
                                              backgroundColor: Colors.redAccent,
                                              child: Icon(Icons.photo_library,
                                                  size: 25)),
                                          SizedBox(height: 10),
                                          Container(
                                              child: MaterialButton(
                                                  height: 20,
                                                  minWidth: 70,
                                                  color: Colors.redAccent,
                                                  onPressed: () async {
                                                    if (await NetworkCheck()
                                                        .check()) {
                                                      final _auth =
                                                          FirebaseAuth.instance;
                                                      User? user =
                                                          _auth.currentUser;
                                                      if (await _isConfirmed(
                                                              user!) ==
                                                          'confirmed') {
                                                        PassMarker.hpOrNot =
                                                            true;
                                                        var reserveResult =
                                                            'start';
                                                        reserveResult = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    Least(
                                                                        service:
                                                                            Service())));

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
                                                              fontSize: 20);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Driving License isn\'t confirmed yet :(',
                                                            fontSize: 20);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'No internet connection',
                                                          fontSize: 20);
                                                    }
                                                  },
                                                  child: Text("Reserve",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 23))),
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .deepPurple.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.deepPurple
                                                            .shade300,
                                                        spreadRadius: 6,
                                                        blurRadius: 3)
                                                  ])),
                                        ]));
                              });
                        }
                      }
                    } else {
                      if (mounted) {
                        setState(() async {
                          if (PassMarker.useMobileLayout!) {
                            pinPillPosition = pinInvisiblePosition;
                          } else {
                            String name =
                                await _nameString(PassMarker.carModel.uid!);
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
                                            SizedBox(height: 10),
                                            Center(
                                                child: Text('Car Information',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            SizedBox(height: 8),
                                            Text('Owner: ' + name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 8),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.vehicle
                                                    .toString(),
                                                'VEHICLE',
                                                200,
                                                20,
                                                20),
                                            SizedBox(height: 10),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.model
                                                    .toString(),
                                                'MODEL',
                                                200,
                                                20,
                                                20),
                                            SizedBox(height: 10),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.fuel
                                                    .toString(),
                                                'FUEL',
                                                200,
                                                20,
                                                20),
                                            SizedBox(height: 10),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.seats
                                                    .toString(),
                                                'SEATS',
                                                200,
                                                20,
                                                20),
                                            SizedBox(height: 10),
                                            _buildRow(
                                                'assets/choc.png',
                                                PassMarker.carModel.price
                                                    .toString(),
                                                'PRICE FOR DAY',
                                                200,
                                                20,
                                                20),
                                            SizedBox(height: 10),
                                            FloatingActionButton(
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                  );
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
                                                  Navigator.pop(context);
                                                },
                                                backgroundColor:
                                                    Colors.redAccent,
                                                child: Icon(Icons.photo_library,
                                                    size: 25)),
                                            SizedBox(height: 10),
                                            Container(
                                                child: MaterialButton(
                                                    height: 20,
                                                    minWidth: 70,
                                                    color: Colors.redAccent,
                                                    onPressed: () async {
                                                      if (await NetworkCheck()
                                                          .check()) {
                                                        final _auth =
                                                            FirebaseAuth
                                                                .instance;
                                                        User? user =
                                                            _auth.currentUser;
                                                        if (await _isConfirmed(
                                                                user!) ==
                                                            'confirmed') {
                                                          PassMarker.hpOrNot =
                                                              true;
                                                          var reserveResult =
                                                              'start';
                                                          reserveResult = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Least(
                                                                          service:
                                                                              Service())));

                                                          if (reserveResult ==
                                                              '1') {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop('dialog');
                                                          } else if (reserveResult ==
                                                              '0') {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Something went wrong, try again later',
                                                                fontSize: 20);
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Driving License isn\'t confirmed yet :(',
                                                              fontSize: 20);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No internet connection',
                                                            fontSize: 20);
                                                      }
                                                    },
                                                    child: Text("Reserve",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 23))),
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .deepPurple.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors
                                                              .deepPurple
                                                              .shade300,
                                                          spreadRadius: 6,
                                                          blurRadius: 3)
                                                    ])),
                                          ]));
                                });
                          }
                        });
                      }
                    }
                  }));
              PassMarker.markerId = PassMarker.markerId + 1;
            });
          }
        }
      } else {
        PassMarker.markerToPass = {};
        for (int i = 0; i < searchCar!.length; i++) {
          String? carLatLng = searchCar![i].position;
          final splitted = carLatLng!.split(',');
          double lat = double.parse(splitted[0]);
          double lng = double.parse(splitted[1]);
          if (mounted) {
            setState(() {
              PassMarker.markerToPass.add(Marker(
                  markerId: MarkerId('marker$i'),
                  infoWindow: InfoWindow(
                      title: HomePageTest().printInfoWindow(
                          searchCar![i].uid.toString(),
                          userAuth!,
                          searchCar![i].vehicle.toString() +
                              '-' +
                              searchCar![i].model.toString())),
                  position: LatLng(lat, lng),
                  icon: HomePageTest()
                      .iconColor(searchCar![i].uid.toString(), userAuth),
                  onTap: () async {
                    if (mounted) {
                      if (PassMarker.useMobileLayout!) {
                        setState(() {
                          pinPillPosition = pinVisiblePosition;
                        });
                      } else {
                        String name =
                            await _nameString(PassMarker.carModel.uid!);
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 6,
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 10),
                                        Center(
                                            child: Text('Car Information',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        SizedBox(height: 8),
                                        Text('Owner: ' + name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.vehicle
                                                .toString(),
                                            'VEHICLE',
                                            200,
                                            20,
                                            20),
                                        SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.model
                                                .toString(),
                                            'MODEL',
                                            200,
                                            20,
                                            20),
                                        SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.fuel.toString(),
                                            'FUEL',
                                            200,
                                            20,
                                            20),
                                        SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.seats
                                                .toString(),
                                            'SEATS',
                                            200,
                                            20,
                                            20),
                                        SizedBox(height: 10),
                                        _buildRow(
                                            'assets/choc.png',
                                            PassMarker.carModel.price
                                                .toString(),
                                            'PRICE FOR DAY',
                                            200,
                                            20,
                                            20),
                                        SizedBox(height: 10),
                                        FloatingActionButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                              List<String> files =
                                                  await urlFile(
                                                      PassMarker.carModel.uid!,
                                                      PassMarker.carModel.cid!);
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
                                                  context, multiImageProvider);
                                              Navigator.pop(context);
                                            },
                                            backgroundColor: Colors.redAccent,
                                            child: Icon(Icons.photo_library,
                                                size: 25)),
                                        SizedBox(height: 10),
                                        Container(
                                            child: MaterialButton(
                                                height: 20,
                                                minWidth: 70,
                                                color: Colors.redAccent,
                                                onPressed: () async {
                                                  if (await NetworkCheck()
                                                      .check()) {
                                                    final _auth =
                                                        FirebaseAuth.instance;
                                                    User? user =
                                                        _auth.currentUser;
                                                    if (await _isConfirmed(
                                                            user!) ==
                                                        'confirmed') {
                                                      PassMarker.hpOrNot = true;
                                                      var reserveResult =
                                                          'start';
                                                      reserveResult =
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Least(
                                                                          service:
                                                                              Service())));

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
                                                            fontSize: 20);
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Driving License isn\'t confirmed yet :(',
                                                          fontSize: 20);
                                                    }
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'No internet connection',
                                                        fontSize: 20);
                                                  }
                                                },
                                                child: Text("Reserve",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 23))),
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepPurple.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .deepPurple.shade300,
                                                      spreadRadius: 6,
                                                      blurRadius: 3)
                                                ])),
                                      ]));
                            });
                      }
                    }
                  }));
            });
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    _markers = PassMarker.markerToPass;
  }

  Widget _buildRow(String imageAsset, String value, String type,
      double screenWidth, double screenHeight, double screenText) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth),
        child: Column(children: <Widget>[
          SizedBox(height: screenHeight),
          Row(children: <Widget>[
            SizedBox(width: screenWidth),
            Text(
              type.toUpperCase(),
              style: TextStyle(fontSize: screenText),
            ),
            const Spacer(),
            Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 223, 162, 108), //Colors.yellow[900],
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight, horizontal: screenWidth),
                child: Text(
                  value,
                  style: TextStyle(fontSize: screenText),
                ))
          ])
        ]));
  }

  //Function to retrieve car's images
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

//Timer for updating markers
  _updateTimer() {
    const time = Duration(milliseconds: 100);
    Timer.periodic(time, (Timer t) {
      if (mounted) {
        _updateMarkers();
      }
    });
  }

//Function that checks if a user is confirmed for reserving other cars
  Future<String> _isConfirmed(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await widget
        .homePageService
        .firebasefirestore()
        .collection('users')
        .doc(user.uid)
        .get();
    return snapshot.data()!['isConfirmed'];
  }

  //Function that gives owner's name to the reservation info
  Future<String> _nameString(String uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firebaseFirestore.collection('users').doc(uid).get();
    String name = snapshot.data()!['firstName'].toString();
    String surname = snapshot.data()!['secondName'].toString();
    return name + ' ' + surname;
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class HomePageTest {
//Function that gives respective colors to different markers
  BitmapDescriptor iconColor(String owner, String user) {
    if (owner == user) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

//Functions that prints different InfoWindow for different markers
  String printInfoWindow(String owner, String user, String carOwner) {
    if (owner == user) {
      return 'My car: click for details';
    } else {
      return carOwner;
    }
  }
}
