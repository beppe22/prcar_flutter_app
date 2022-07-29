import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:prcarpolimi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      //AVVIARE IL LOGOUT
      final drawer = await find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final accountButton = await find.byType(ListTile).first;
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(accountButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final logoutButton = await find.byKey(Key("logout button tablet"));
      await tester.tap(logoutButton);
      await tester.pump(Duration(seconds: 2));

      //VERIFY WE ARE IN LOGIN PAGE
      expect(find.text('Login'), findsOneWidget);

      final fab = await find.byKey(Key("clickButtom2"));
      await tester.tap(fab);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));

      await tester.enterText(find.byKey(ValueKey(1)), 'marinvargasf@gmail.com');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey(2)), 'vargas22');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final fa12 = await find.byKey(Key("clickButtom2"));

      // Tap Login button
      await tester.tap(fa12);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(fa12);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 4));

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      //final accountButton = await find.byType(ListTile).first;
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(accountButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(find.text("Delete Account"), findsOneWidget);
      expect(find.text("Logout"), findsOneWidget);
      expect(find.text("Name: Francesco "), findsOneWidget);
      expect(find.text("Surname: Marin Vargas"), findsOneWidget);
      expect(find.text('marinvargasf@gmail.com'), findsOneWidget);
    });
  });
}
