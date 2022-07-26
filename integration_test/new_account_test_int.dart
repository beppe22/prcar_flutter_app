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

      expect(drawer, findsWidgets);

      await tester.tap(drawer);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final accountButton = await find.byType(ListTile).first;
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(accountButton);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final logoutButton = await find.byKey(Key("logout button"));
      await tester.tap(logoutButton);
      await tester.pump(Duration(seconds: 2));

      //WE ARE IN LOGIN PAGE

      final fab = await find.byKey(Key("New Account"));
      await tester.tap(fab);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(Key("first name field")), 'Giuseppe');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(Key("second name field")), 'Italia');
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(find.byKey(ValueKey("email field")),
          "giuseppe.italia@mail.polimi.it");
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(
          find.byKey(ValueKey("password field")), "ciaociao22");
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.enterText(
          find.byKey(ValueKey("confirmed password field")), "ciaociao22");
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300));
      await tester.pumpAndSettle();

      // Emulate a tap on the floating action button.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byKey(Key("sign up buttom")));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byKey(Key("sign up buttom")));
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));

      expect(find.text('Resent Email'), findsOneWidget);
    });
  });
}
