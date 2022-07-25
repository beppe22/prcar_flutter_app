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
      /*expect(find.text('Login'), findsOneWidget);

      await tester.tap(find.byKey(Key("clickButtom")));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 1));

      expect(find.text('Login'), findsOneWidget);

      await tester.enterText(find.byKey(ValueKey(1)), 'marinvargasf@gmail.com');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey(2)), 'vargas22');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(find.byKey(Key("clickButtom")));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(find.byKey(Key("clickButtom")));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));*/

      //HOMEPAGE

      final drawer = await find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(drawer, findsWidgets);

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final aboutYourCarButton = await find.byType(ListTile).at(2);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(aboutYourCarButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      /*await tester.tap(aboutYourCarButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));*/

      final car = await find.byKey(Key("car")).first;

      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(car);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      /*expect(find.text('Model: '), findsOneWidget);
      expect(find.text('Seats: '), findsOneWidget);
      expect(find.text('Fuel: '), findsOneWidget);
      expect(find.text('Position: '), findsOneWidget);
      expect(find.text('Price for day: '), findsOneWidget);
      expect(find.text('Status: '), findsOneWidget);*/
      expect(find.text("Change Info"), findsOneWidget);
      expect(find.text("Delete"), findsOneWidget);
    });
  });
}
