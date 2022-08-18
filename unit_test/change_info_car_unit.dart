import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/addNewCar.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("add new car size", () {
    test('add new car mobile', () async {
      PassMarker.useMobileLayout = true;
      final pos = new PosChange();
      String title = await pos.printPosition('ciaooooooooo,testtttt');
      expect(title, 'ciaoooo,testttt');
    });
  });
}
