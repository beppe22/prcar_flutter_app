import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("seats test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Seats(
        filter: true,
        service: FakeService(),
      )));

      expect(find.text("2"), findsOneWidget);
      expect(find.text("3"), findsOneWidget);
      expect(find.text("4"), findsOneWidget);
      expect(find.text("5"), findsOneWidget);
      expect(find.text("Seats"), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(6));
    });
  });
}
