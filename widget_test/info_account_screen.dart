import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/infoAccount.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("info-account page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: InfoAccount(
        service: FakeService(),
      )));

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(6));
    });
  });
}
