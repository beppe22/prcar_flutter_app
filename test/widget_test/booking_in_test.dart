import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/booking/booking_in.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("booking-in page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: BookingInPage(
        res: [],
        bookingId: '',
        fromHp: true,
        service: FakeService(),
      )));

      expect(find.text('Booking-In'), findsOneWidget);
    });
  });
}
