import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/filters.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("filter test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Filters(
        service: FakeService(),
      )));

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: "), findsOneWidget);
      expect(find.text("Seats: "), findsOneWidget);
      expect(find.text("Fuel: "), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);
      expect(find.text("Least: "), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(6));
    });
  });
}
