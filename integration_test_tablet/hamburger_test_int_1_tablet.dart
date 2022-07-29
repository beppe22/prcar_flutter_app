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

      expect(find.text('Filters'), findsOneWidget);
      expect(find.text("PrCar"), findsOneWidget);

      final drawer = await find.byTooltip('Open navigation menu');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(drawer, findsWidgets);

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final bookingButton = await find.byType(ListTile).at(1);
      await tester.tap(bookingButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final otherResButton =
          await find.byKey(Key("Other reservation button tablet"));
      await tester.tap(otherResButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(find.text('Booking-In'), findsOneWidget);
    });
  });
}
