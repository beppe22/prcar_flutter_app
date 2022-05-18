// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:prcarpolimi/booking_page.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class LeastButton extends StatelessWidget {
  String value;
  LeastButton({Key? key, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (PassMarker.hpOrNot) {
            Navigator.pop(
                context,
                await BookingOut(
                        PassMarker.carModel.cid, PassMarker.carModel.uid)
                    .book());
          } else {
            Navigator.pop(context, value);
          }
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
