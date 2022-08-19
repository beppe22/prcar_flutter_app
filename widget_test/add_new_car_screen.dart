import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';

import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("add new car test rest", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AddNewCar(
        addNewCarService: FakeService(),
      )));

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(9));
      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: "), findsOneWidget);
      expect(find.text("Seats: "), findsOneWidget);
      expect(find.text("Fuel: "), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);
      expect(find.text("Add Car"), findsOneWidget);
      expect(find.text("Clear All"), findsOneWidget);
      expect(find.text("Done!"), findsOneWidget);

      final VehicleButton = await find.byKey(Key("Vehicle button"));
      await tester.tap(VehicleButton);
      await tester.pumpAndSettle();

      final buttonVehicle = await find.byKey(Key("button for vehicle")).first;
      await tester.tap(buttonVehicle);
      await tester.pumpAndSettle();

      final buttonModel = await find.byKey(Key("button for model")).first;
      await tester.tap(buttonModel);
      await tester.pumpAndSettle();

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: Alfa Romeo-145"), findsOneWidget);
      expect(find.text("Seats: "), findsOneWidget);
      expect(find.text("Fuel: "), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);
      expect(find.text("Add Car"), findsOneWidget);
      expect(find.text("Clear All"), findsOneWidget);
      expect(find.text("Done!"), findsOneWidget);
      expect(textWidgets, findsNWidgets(9));

      final buttonseatsVehicle = await find.byKey(Key("button for seats"));
      await tester.tap(buttonseatsVehicle);
      await tester.pumpAndSettle();

      final seatsVehicle = await find.byKey(Key("2 seats button"));
      await tester.tap(seatsVehicle);
      await tester.pumpAndSettle();

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: Alfa Romeo-145"), findsOneWidget);
      expect(find.text("Seats: 2"), findsOneWidget);
      expect(find.text("Fuel: "), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);
      expect(find.text("Add Car"), findsOneWidget);
      expect(find.text("Clear All"), findsOneWidget);
      expect(find.text("Done!"), findsOneWidget);
      expect(textWidgets, findsNWidgets(9));

      final buttonfuel = await find.byKey(Key("Button for fuel")).first;
      await tester.tap(buttonfuel);
      await tester.pumpAndSettle();

      final fuelVehicle = await find.byKey(ValueKey(2));
      await tester.tap(fuelVehicle);
      await tester.pumpAndSettle();

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: Alfa Romeo-145"), findsOneWidget);
      expect(find.text("Seats: 2"), findsOneWidget);
      expect(find.text("Fuel: Methane"), findsOneWidget);
      expect(find.text("Price: "), findsOneWidget);
      expect(find.text("Add Car"), findsOneWidget);
      expect(find.text("Clear All"), findsOneWidget);
      expect(find.text("Done!"), findsOneWidget);
      expect(textWidgets, findsNWidgets(9));

      final buttonprice = await find.byKey(Key("button for price")).first;
      await tester.tap(buttonprice);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      final addPrice = await find.byKey(Key("add button"));
      //await tester.pump(Duration(milliseconds: 300));
      await tester.tap(addPrice);
      await tester.pumpAndSettle();
      //await tester.pump(Duration(seconds: 2));

      final priceVehicle = await find.byKey(Key("price button"));
      await tester.tap(priceVehicle);
      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 2));

      expect(find.text("Position: "), findsOneWidget);
      expect(find.text("Vehicle: Alfa Romeo-145"), findsOneWidget);
      expect(find.text("Seats: 2"), findsOneWidget);
      expect(find.text("Fuel: Methane"), findsOneWidget);
      expect(find.text("Price: 1"), findsOneWidget);
      expect(find.text("Add Car"), findsOneWidget);
      expect(find.text("Clear All"), findsOneWidget);
      expect(find.text("Done!"), findsOneWidget);
      expect(textWidgets, findsNWidgets(9));
    });
  });
}
