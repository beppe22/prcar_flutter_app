import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prcarpolimi/infoAccount.dart';
import 'package:prcarpolimi/infoCar.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/userModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'hamburger/filters.dart';

//import 'hamburger/filters.dart';
//import 'hamburger/start.dart';
//import 'hamburger/cars_owner.dart';

class HomePage extends StatefulWidget {
  UserModel userModel;

  HomePage(this.userModel, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(userModel);
}

class _HomePageState extends State<HomePage> {
  UserModel userModel;
  _HomePageState(this.userModel, {Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("PrCar"),
        backgroundColor: Colors.redAccent,
      ),
      body: (const GoogleMapScreen()),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            ListTile(
              title: const Text("Home",
                  style: TextStyle(fontSize: 30, color: Colors.redAccent)),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Account"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InfoAccount(userModel)),
                );
              },
            ),
            ListTile(
              title: const Text("Filters"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Filters()),
                );
              },
            ),
            ListTile(
              title: const Text("About your car"),
              onTap: () async {
                List<CarModel> cars = await _fetchInfoCar();

                if (cars != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoCar(cars)),
                  );
                }
              },
            ),
            ListTile(
              title: const Text("Help"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Configuration"),
              onTap: () {},
            )
          ],
        ),
      ),
    ));
  }

  static Future<List<CarModel>> _fetchInfoCar() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    CarModel carModel = CarModel();
    List<CarModel> cars = [];

    if (user != null) {
      try {
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            //quando non ci sono macchine da errore
            .collection('cars')
            .get()
            .then((ds) {
          for (var car in ds.docs) {
            cars.add(CarModel.fromMap(car.data()));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "cars not found") {
          print("No Cars found");
        }
      }
    }
    return cars;
  }
}

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(45.47811155714095, 9.227444681728846), zoom: 13),
      ),
    );
  }
}
