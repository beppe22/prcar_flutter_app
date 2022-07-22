import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/booking_page.dart';

import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("booking page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: MessagePage(
        service: FakeService(),
      )));

      expect(find.text('All Booking'), findsOneWidget);
    });
  });
}
