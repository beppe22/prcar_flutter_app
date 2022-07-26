// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/booking/booking_in.dart';
import 'package:prcarpolimi/chatImplementation/chatDetail.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/hamburger/infoAccount.dart';
import 'package:prcarpolimi/hamburger/booking_page.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/static_user.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:prcarpolimi/services/services.dart';
import 'bottom_pill.dart';
import 'hamburger/cars_user.dart';
import 'hamburger/filters.dart';
import 'dart:io' show Platform;

const double pinVisiblePosition = 50;
const double pinInvisiblePosition = -220;
const double pinInvisiblePosition2 = -620;

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
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (PassMarker.useMobileLayout!) {
      pinPillPosition = -220;
    } else {
      pinPillPosition = -620;
    }

    _updateMarkers();
    _updateTimer();

    _saveToken();
    if (Platform.isAndroid) {
      _listen();
      //_checkForInitialMessage();

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;
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
                                setState(() {
                                  _updateMarkers();
                                });
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
                          onTap: () async {})
                    ])),
                body: Stack(children: [
                  GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(45.47811155714095, 9.227444681728846),
                          zoom: 16),
                      markers: _markers,
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
                                      builder: (context) =>
                                          Cars_user(cars, service: Service())))
                              .then((data) {
                            setState(() {
                              _updateMarkers();
                            });
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
                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);
                        } else {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        }
                      })
                ])),
                body: Stack(children: [
                  GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                          target: LatLng(45.47811155714095, 9.227444681728846),
                          zoom: 16),
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      onTap: (LatLng loc) {
                        setState(() {
                          pinPillPosition = pinInvisiblePosition2;
                        });
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
        //popoliamo la variabile staticUser
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
        //final screenHeight = MediaQuery.of(context).size.height;
        //final screenWidth = MediaQuery.of(context).size.width;
        final screenText = MediaQuery.of(context).textScaleFactor;
        print("message recieved");
        print(event.notification!.body);
        //print(event.data["bookId"]);
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
                      //bookingId in input
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
                    child: Icon(Icons.add_location_alt_outlined,
                        size: screenText * 25),
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

  /*_checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print('Message ripreso!');
      if (initialMessage.data["type"] == 'booking') {
        List<String> bookIn = await _fetchOtherRes();
        //bookingId in input
        String bookingId = initialMessage.data["bookId"];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingInPage(
                    bookingId: bookingId, res: bookIn, fromHp: true)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetail(
                    friendName: initialMessage.data['friendName'],
                    friendUid: initialMessage.data['friendId'],
                    hp: true)));
      }
      /*List<String> bookIn = await _fetchOtherRes();
      //bookingId in input
      String bookingId = initialMessage.data["bookId"];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookingInPage(
                  bookingId: bookingId, res: bookIn, fromHp: true)));*/
    }
  }*/

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
            //quando non ci sono macchine da errore
            .then((ds) async {
          for (var user_1 in ds.docs) {
            //print(user_1.data());
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
        //if (e.code == "impossible to insert new car") {}
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

  BitmapDescriptor _iconColor(String owner, String user) {
    if (owner == user) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  String _printInfoWindow(String owner, String user, String carOwner) {
    if (owner == user) {
      return 'My car: click for details';
    } else {
      return carOwner;
    }
  }

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
          setState(() {
            PassMarker.markerToPass.add(Marker(
                markerId: MarkerId('marker$i'),
                infoWindow: InfoWindow(
                    title: _printInfoWindow(
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
                icon: _iconColor(cars[i].uid.toString(), userAuth),
                onTap: () {
                  if (userAuth != cars[i].uid.toString()) {
                    PassMarker.carModel = cars[i];
                    setState(() {
                      pinPillPosition = pinVisiblePosition;
                    });
                  } else {
                    if (PassMarker.useMobileLayout!) {
                      setState(() {
                        pinPillPosition = pinInvisiblePosition;
                      });
                    } else {
                      setState(() {
                        pinPillPosition = pinInvisiblePosition2;
                      });
                    }
                  }
                }));
            PassMarker.markerId = PassMarker.markerId + 1;
          });
        }
      } else {
        PassMarker.markerToPass = {};
        for (int i = 0; i < searchCar!.length; i++) {
          String? carLatLng = searchCar![i].position;
          final splitted = carLatLng!.split(',');
          double lat = double.parse(splitted[0]);
          double lng = double.parse(splitted[1]);
          setState(() {
            PassMarker.markerToPass.add(Marker(
                markerId: MarkerId('marker$i'),
                infoWindow: InfoWindow(
                    title: _printInfoWindow(
                        searchCar![i].uid.toString(),
                        userAuth!,
                        searchCar![i].vehicle.toString() +
                            '-' +
                            searchCar![i].model.toString())),
                position: LatLng(lat, lng),
                icon: _iconColor(searchCar![i].uid.toString(), userAuth),
                onTap: () {
                  setState(() {
                    pinPillPosition = pinVisiblePosition;
                  });
                }));
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    _markers = PassMarker.markerToPass;
  }

  _updateTimer() {
    const time = Duration(milliseconds: 50);
    Timer.periodic(time, (Timer t) {
      if (mounted) {
        _updateMarkers();
      }
    });
  }

  Future<String> _isConfirmed(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await widget
        .homePageService
        .firebasefirestore()
        .collection('users')
        .doc(user.uid)
        .get();
    return snapshot.data()!['isConfirmed'];
  }
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
