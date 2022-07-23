import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("price test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Price(
        filter: true,
        service: FakeService(),
      )));

      expect(find.text("Price"), findsOneWidget);
    });
  });
}
