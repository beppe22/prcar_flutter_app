import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';

import 'package:prcarpolimi/models/marker_to_pass.dart';

class FakeAddNewCarService implements AddNewCarService {
  @override
  firebasefirestore() {
    return null;
  }

  @override
  User? currentUser() {
    return null;
  }

  @override
  storage() {
    return null;
  }
}

void main() {
  group("add new car test rest", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AddNewCar(
        addNewCarService: FakeAddNewCarService(),
      )));

      expect(find.text("Position: "), findsOneWidget);
    });
  });
}
