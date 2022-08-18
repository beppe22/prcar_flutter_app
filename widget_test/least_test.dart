import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("least test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Least(
        service: FakeService(),
      )));

      expect(find.text("Choose for how long are you in need"), findsOneWidget);
    });
  });
}
