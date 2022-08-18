import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';

import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("add new car test rest", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AddNewCar(
        addNewCarService: FakeService(),
      )));

      expect(find.text("Position: "), findsOneWidget);
    });
  });
}
