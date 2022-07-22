import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/models/carModel.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class FakeChangeInfoCarService implements ChangeInfoCarService {
  @override
  firebasefirestore() {
    return null;
  }
}

void main() {
  group("change info car rest", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: ChangeInfoCar(
        changeInfoCarService: FakeChangeInfoCarService(),
        carModel: CarModel.initialize(),
      )));

      expect(find.text("Position: "), findsOneWidget);
    });
  });
}
