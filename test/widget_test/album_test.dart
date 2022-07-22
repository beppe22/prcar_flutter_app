import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/album.dart';

import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("album test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Album(
        files: [],
      )));

      expect(find.text("Fuel"), findsOneWidget);
    });
  });
}
