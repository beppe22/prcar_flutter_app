// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class LeastButton extends StatelessWidget {
  const LeastButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            width: double.maxFinite,
            height: 50,
            margin:
                const EdgeInsets.only(top: 15, left: 40, right: 40, bottom: 15),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text('Done',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)))));
  }
}
