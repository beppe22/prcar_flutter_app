import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/change_info_car.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("change info car tests", () {
    test('print position test', () async {
      PassMarker.useMobileLayout = true;
      final pos = new PosChange();
      String title = await pos.printPosition('ciaooooooooo,testtttt');
      expect(title, 'ciaoooo,testttt');
    });

    test('height test', () async {
      PassMarker.useMobileLayout = true;
      final pos = new PosChange();
      double title = await pos.height(1.0);
      double title1 = await pos.text(1.0);
      expect(title, 0.07);
      expect(title1, 20.0);
    });
    test('add new car mobile', () async {
      PassMarker.useMobileLayout = false;
      final pos = new PosChange();
      double title = await pos.height(1.0);
      double title1 = await pos.text(1.0);
      expect(title, 0.09);
      expect(title1, 30.0);
    });
  });
}
