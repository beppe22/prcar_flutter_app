import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

class FakeChangeInfoCarService implements ChangeInfoCarService {
  @override
  firebasefirestore() {
    return null;
  }
}

void main() {
  group("change info car test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeInfoCar(
        changeInfoCarService: FakeService(),
        carModel: CarModel.initialize(),
      )));

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Seats: "), findsOneWidget);
      expect(find.text("Fuel: "), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(8));
    });
  });
}
