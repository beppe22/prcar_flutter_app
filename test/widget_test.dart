// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/booking/booking_in.dart';
import 'package:prcarpolimi/homepage.dart';

import 'package:prcarpolimi/main.dart';

/*void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}*/

void main() {
  Firebase.initializeApp();
  testWidgets('PrCarFirstTest', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(HomePage());

    final prCarFinder = find.text('PrCar');
    expect(prCarFinder, findsOneWidget);
  });
}
