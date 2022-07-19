import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/vehicle/vehicle.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("ScrollCar", () {
    PassMarker.useMobileLayout = true;
    testWidgets("should scroll with more than N elements",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Vehicle()));
      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pump();
    });
  });
}
