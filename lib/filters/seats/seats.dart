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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text("Seats", style: TextStyle(fontSize: screenText * 20)),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: screenText * 25),
                onPressed: () {
                  Navigator.pop(context, '');
                })),
        backgroundColor: Colors.white,
        body: Column(children: [
          SizedBox(height: screenHeight * 0.03),
          SizedBox(
              height: screenHeight * 0.28,
              child: Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
          SizedBox(
              height: screenHeight * 0.05,
              child: Text("Choose how many seats",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: screenText * 23))),
          SizedBox(height: screenHeight * 0.02),
          SeatsButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              screenText: screenText,
              value: '2'),
          SizedBox(height: screenHeight * 0.02),
          SeatsButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              screenText: screenText,
              value: '3'),
          SizedBox(height: screenHeight * 0.02),
          SeatsButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              screenText: screenText,
              value: '4'),
          SizedBox(height: screenHeight * 0.02),
          SeatsButton(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              screenText: screenText,
              value: '5')
        ]));
  }
}
