// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PriceButton extends StatelessWidget {
  String value;
  PriceButton({Key? key, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context, value);
        },
        child: Container(
            width: double.maxFinite,
            height: 70,
            margin:
                const EdgeInsets.only(top: 15, left: 40, right: 40, bottom: 15),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))));
  }
}
