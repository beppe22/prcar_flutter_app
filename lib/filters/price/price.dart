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
    return Scaffold(
        body: const Counter(),
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("Price"),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 300,
                  child:
                      Image.asset("assets/prcarlogo.png", fit: BoxFit.contain)),
              const SizedBox(
                  height: 50,
                  child: Text("Choose the price for you possibility. (€/day)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15))),
              PriceButton(value: counter.toString()),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(16.0)),
                    child: const Icon(Icons.remove),
                    onPressed: counter == 0 ? null : decrementCounter),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(16.0)),
                    child: const Icon(Icons.add),
                    onPressed: counter == 100 ? null : incrementCounter)
              ]),
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
