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

      // Avviare il login
      //expect(find.text('Login'), findsOneWidget);

      //final fab = find.byKey(Key("clickButtom"));

      //await tester.tap(fab);

      /*await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Login'), findsOneWidget);

      await tester.enterText(find.byKey(ValueKey(1)), 'marinvargasf@gmail.com');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey(2)), 'vargas22');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final fa12 = find.byKey(Key("clickButtom"));

      await tester.tap(fa12);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(fa12);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 20));*/

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text("PrCar"), findsOneWidget);

      final drawer = await find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(drawer, findsWidgets);

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final accountButton = await find.byType(ListTile).first;
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(accountButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(find.text("Delete Account"), findsOneWidget);
      expect(find.text("Logout"), findsOneWidget);
    });
  });
}
