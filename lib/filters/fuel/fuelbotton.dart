// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class FuelButton extends StatelessWidget {
  double screenHeight, screenWidth, screenText;
  String value;
  FuelButton(
      {Key? key,
      required this.value,
      required this.screenHeight,
      required this.screenWidth,
      required this.screenText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context, value);
        },
        child: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.07,
            margin: EdgeInsets.only(
                top: screenHeight * 0.01,
                left: screenWidth * 0.15,
                right: screenWidth * 0.15,
                bottom: screenHeight * 0.01),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(value,
                    style: TextStyle(
                        fontSize: screenText * 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))));
  }
}
