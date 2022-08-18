import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/fuel/fuel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("fuel test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Fuel(
        service: FakeService(),
      )));

      expect(find.text("Choose the fuel"), findsOneWidget);
    });
  });
}
