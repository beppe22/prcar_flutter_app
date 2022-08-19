import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("add new car size", () {
    test('add new car mobile', () async {
      PassMarker.useMobileLayout = true;
      final add = new AddCarSize();
      double title = await add.sizeAddCar(1.0);
      expect(title, 20.0);
    });
    test('add new car tablet', () async {
      PassMarker.useMobileLayout = false;
      final add = new AddCarSize();
      double title = await add.sizeAddCar(1.0);
      expect(title, 30.0);
    });
  });
}
