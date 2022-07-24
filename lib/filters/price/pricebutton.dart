// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class PriceButton extends StatelessWidget {
  String value;
  double screenHeight, screenWidth, screenText;
  PriceButton(
      {Key? key,
      required this.value,
      required this.screenHeight,
      required this.screenWidth,
      required this.screenText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    width() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return screenWidth * 0.6;
      } else {
        return screenWidth * 0.4;
      }
    }

    heigth() {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return screenHeight * 0.08;
      } else {
        return screenHeight * 0.12;
      }
    }

    return PassMarker.useMobileLayout!
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context, value);
            },
            child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.08,
                margin: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.03,
                    bottom: screenHeight * 0.01),
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(value,
                        style: TextStyle(
                            fontSize: screenText * 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)))))
        : GestureDetector(
            onTap: () {
              Navigator.pop(context, value);
            },
            child: Container(
                width: width(),
                height: heigth(),
                margin: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.03,
                    bottom: screenHeight * 0.01),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(value,
                        style: TextStyle(
                            fontSize: screenText * 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)))));
  }
}
