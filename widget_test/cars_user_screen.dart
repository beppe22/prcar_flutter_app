import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/cars_user.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("cars user screen test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Cars_user([], service: Service())));

      expect(find.text('Your cars'), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(2));
    });
  });
}
