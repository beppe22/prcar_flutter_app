import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:prcarpolimi/homepage.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("homepage test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('email', (WidgetTester tester) async {
      //final addEmail = await find.byKey(ValueKey(1));
      //final addPassword = await find.byKey(ValueKey(2));

      await tester.runAsync(() async {
        final future = Future<void>.error(42);

        await tester.pumpWidget(FutureBuilder(
          future: future,
          builder: (_, snapshot) {
            return MaterialApp(
                home: HomePage(
              homePageService: FakeService(),
            ));
          },
        ));

        expect(find.text("PrCar"), findsOneWidget);
        expect(find.text('Filters'), findsOneWidget);
      });

      /*await tester.pumpWidget(MaterialApp(
          home: HomePage(
        homePageService: FakeHomePageService(),
      )));*/
      //await tester.pumpAndSettle(const Duration(seconds: 10));

      //await tester.enterText(addPassword, 'nuova password');
      //await tester.enterText(addEmail, "nuova email");
    });
  });
}
