import 'package:flutter/material.dart';
import 'pricebutton.dart';

class Price extends StatefulWidget {
  const Price({Key? key}) : super(key: key);
  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: const Counter(),
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text("Price", style: TextStyle(fontSize: screenText * 20)),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: screenText * 25),
                onPressed: () {
                  Navigator.pop(context, '');
                })));
  }
}

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      if (counter < 100) {
        counter++;
      }
    });
  }

  void decrementCounter() {
    setState(() {
      if (counter > 0) {
        counter--;
      }
    });
  }

  void setCounter(double newValue) {
    setState(() {
      counter = newValue.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return Padding(
        padding: EdgeInsets.all(screenHeight * 0.005),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                  height: screenHeight * 0.3,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              SizedBox(
                  height: screenHeight * 0.05,
                  child: Text("Choose the price (€/day)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: screenText * 24))),
              SizedBox(height: screenHeight * 0.05),
              PriceButton(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  screenText: screenText,
                  value: counter.toString()),
              SizedBox(height: screenHeight * 0.03),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.all(screenWidth * 0.04)),
                    child: Icon(Icons.remove, size: screenText * 25),
                    onPressed: counter == 0 ? null : decrementCounter),
                SizedBox(width: screenWidth * 0.2),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.all(screenWidth * 0.04)),
                    child: Icon(Icons.add, size: screenText * 25),
                    onPressed: counter == 100 ? null : incrementCounter)
              ]),
              SizedBox(height: screenHeight * 0.03),
              Slider(
                  activeColor: Colors.redAccent,
                  inactiveColor: Colors.blueGrey,
                  value: counter.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: setCounter)
            ]));
  }
}
