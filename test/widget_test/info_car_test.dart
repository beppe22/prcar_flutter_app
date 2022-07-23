import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("info car test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      //final addEmail = await find.byKey(ValueKey(1));
      //final addPassword = await find.byKey(ValueKey(2));

      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(
            home: InfoCar(
          CarModel.initialize(),
          "",
          true,
          service: FakeService(),
        )));

        expect(find.text('Model: '), findsOneWidget);
      });
    });
  });
}
