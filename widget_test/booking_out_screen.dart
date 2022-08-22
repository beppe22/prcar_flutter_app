import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/booking/booking_out.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("booking-out page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BookingOutPage(
        res: [],
        service: FakeService(),
      )));

      expect(find.text('Booking-Out'), findsOneWidget);
      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(2));
    });
  });
}
