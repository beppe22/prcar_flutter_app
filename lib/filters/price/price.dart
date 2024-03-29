// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';
import 'pricebutton.dart';

class Price extends StatefulWidget {
  bool filter;
  Service service;
  Price({Key? key, required this.filter, required this.service})
      : super(key: key);
  @override
  _PriceState createState() => _PriceState(filter);
}

class _PriceState extends State<Price> {
  bool filter;
  _PriceState(this.filter);

  @override
  Widget build(BuildContext context) {
    //final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenText = MediaQuery.of(context).textScaleFactor;
    return PassMarker.useMobileLayout!
        ? Scaffold(
            body: Counter(filter: filter),
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text("Price", style: TextStyle(fontSize: screenText * 20)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 25),
                    onPressed: () {
                      Navigator.pop(context, '');
                    })))
        : Scaffold(
            body: Counter(filter: filter),
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title:
                    Text("Price", style: TextStyle(fontSize: screenText * 30)),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white, size: screenText * 35),
                    onPressed: () {
                      Navigator.pop(context, '');
                    })));
  }
}

class Counter extends StatefulWidget {
  bool filter;
  Counter({Key? key, required this.filter}) : super(key: key);

  @override
  _CounterState createState() => _CounterState(filter);
}

class _CounterState extends State<Counter> {
  bool filter;
  int counter = 0;

  _CounterState(this.filter);
  @override
  void initState() {
    super.initState();
    int counter = 0;
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
    return PassMarker.useMobileLayout!
        ? Padding(
            padding: EdgeInsets.all(screenHeight * 0.005),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                      height: screenHeight * 0.3,
                      child: Image.asset("assets/prcarlogo.png",
                          fit: BoxFit.contain)),
                  SizedBox(
                      height: screenHeight * 0.1,
                      child: Text(_priceString(filter),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: screenText * 22))),
                  SizedBox(height: screenHeight * 0.05),
                  PriceButton(
                      key: Key("price button"),
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
                        onPressed: () {
                          if (counter != 0) {
                            setState(() {
                              counter = Operation().decrementCounter(counter);
                            });
                          }
                        }),
                    SizedBox(width: screenWidth * 0.2),
                    TextButton(
                        key: Key("add button"),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.all(screenWidth * 0.04)),
                        child: Icon(Icons.add, size: screenText * 25),
                        onPressed: () {
                          if (counter != 100) {
                            setState(() {
                              counter = Operation().incrementCounter(counter);
                            });
                          }
                        })
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
                ]))
        : OrientationBuilder(builder: (_, orientation) {
            if (orientation == Orientation.portrait) {
              return Padding(
                  padding: EdgeInsets.all(screenHeight * 0.005),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                            height: screenHeight * 0.35,
                            child: Image.asset("assets/prcarlogo.png",
                                fit: BoxFit.contain)),
                        SizedBox(
                            height: screenHeight * 0.1,
                            child: Text(_priceString(filter),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontSize: screenText * 32))),
                        SizedBox(height: screenHeight * 0.02),
                        PriceButton(
                            key: Key("price button tablet"),
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            screenText: screenText,
                            value: counter.toString()),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.04)),
                                  child:
                                      Icon(Icons.remove, size: screenText * 28),
                                  onPressed: () {
                                    if (counter != 0) {
                                      setState(() {
                                        counter = Operation()
                                            .decrementCounter(counter);
                                      });
                                    }
                                  }),
                              SizedBox(width: screenWidth * 0.2),
                              TextButton(
                                  key: Key("add button tablet"),
                                  style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.redAccent,
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.04)),
                                  child: Icon(Icons.add, size: screenText * 28),
                                  onPressed: () {
                                    if (counter != 100) {
                                      setState(() {
                                        counter = Operation()
                                            .incrementCounter(counter);
                                      });
                                    }
                                  })
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
            } else {
              return Padding(
                  padding: EdgeInsets.all(screenHeight * 0.005),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        SizedBox(
                            height: screenHeight * 0.35,
                            child: Image.asset("assets/prcarlogo.png",
                                fit: BoxFit.contain)),
                        SizedBox(
                            height: screenHeight * 0.1,
                            child: Text(_priceString(filter),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontSize: screenText * 32))),
                        SizedBox(height: screenHeight * 0.02),
                        PriceButton(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            screenText: screenText,
                            value: counter.toString()),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth * 0.1,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      child: Icon(Icons.remove,
                                          size: screenText * 22),
                                      onPressed: () {
                                        if (counter != 0) {
                                          setState(() {
                                            counter = Operation()
                                                .decrementCounter(counter);
                                          });
                                        }
                                      })),
                              SizedBox(width: screenWidth * 0.2),
                              Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth * 0.1,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      child: Icon(Icons.add,
                                          size: screenText * 22),
                                      onPressed: () {
                                        if (counter != 100) {
                                          counter = Operation()
                                              .incrementCounter(counter);
                                        }
                                      }))
                            ]),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                            width: screenWidth * 0.7,
                            child: Slider(
                                activeColor: Colors.redAccent,
                                inactiveColor: Colors.blueGrey,
                                value: counter.toDouble(),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                onChanged: setCounter))
                      ]));
            }
          });
  }

//Function that prints different title (it depends from which screen we arrive)
  String _priceString(bool filter) {
    if (filter) {
      return 'Choose the maximum car\'s price (€/day)';
    } else {
      return 'Choose car\'s price (€/day)';
    }
  }
}

class Operation {
  int incrementCounter(int counter) {
    if (counter < 100) {
      counter++;
    }
    return counter;
  }

  int decrementCounter(int counter) {
    if (counter > 0) {
      counter--;
    }
    return counter;
  }
}
