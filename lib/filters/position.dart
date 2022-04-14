import 'package:flutter/material.dart';

class Position extends StatefulWidget {
  const Position({Key? key}) : super(key: key);
  @override
  _Position createState() => _Position();
}

class _Position extends State<Position> {
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
                  Navigator.pop(context);
                })));
  }
}
