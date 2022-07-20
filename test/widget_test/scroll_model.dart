import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/vehicle/model.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'dart:math';

void main() {
  group("ScrollCar", () {
    PassMarker.useMobileLayout = true;
    testWidgets("should scroll with more than N elements",
        (WidgetTester tester) async {
      Random random = new Random();
      int randomNumber = random.nextInt(13) + 2;
      await tester.pumpWidget(MaterialApp(home: Models(indice: randomNumber)));
      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pump();
    });
  });
}
