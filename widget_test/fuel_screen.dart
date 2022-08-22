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

      expect(find.text("Oil"), findsOneWidget);
      expect(find.text("Methane"), findsOneWidget);
      expect(find.text("Diesel"), findsOneWidget);
      expect(find.text("Electric"), findsOneWidget);
      expect(find.text("Hibryd"), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(7));
    });
  });
}
