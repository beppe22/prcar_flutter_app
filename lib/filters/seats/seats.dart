import 'package:flutter/material.dart';
import 'seatsbotton.dart';

class Seats extends StatefulWidget {
  const Seats({Key? key}) : super(key: key);
  @override
  _SeatsState createState() => _SeatsState();
}

class _SeatsState extends State<Seats> {
  late String value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Seats"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, '');
                })),
        backgroundColor: Colors.white,
        body: Column(children: [
          const SizedBox(height: 30),
          SizedBox(
              height: 175,
              child: Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          const SizedBox(
              height: 50,
              child: Text("Choose how many seats do you need.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 20))),
          SeatsButton(value: '2'),
          SeatsButton(value: '3'),
          SeatsButton(value: '4'),
          SeatsButton(value: '5')
        ]));
  }
}
