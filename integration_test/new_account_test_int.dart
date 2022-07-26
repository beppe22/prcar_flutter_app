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

      //PER FARE LOGOUT
      /*final logout = await find.byKey(Key("logout button"));
      await tester.tap(logout);
      await tester.pump(Duration(seconds: 2));*/

      expect(find.text('Login'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = await find.byKey(Key("New Account"));

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
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

      final fa12 = await find.byKey(Key("sign up buttom"));
      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300));
      await tester.pumpAndSettle();

      // Emulate a tap on the floating action button.
      await tester.tap(fa12);
      await tester.pump();
      await tester.pump(Duration(seconds: 2));

      await tester.tap(fa12);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5));

      expect(find.text('Resent Email'), findsOneWidget);
    });
  });
}
