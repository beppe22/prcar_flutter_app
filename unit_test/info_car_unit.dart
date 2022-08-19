import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/info_car.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("info car tests", () {
    test('print car active', () async {
      PassMarker.useMobileLayout = true;
      final info = new InfoCarTest();
      String title = await info.activeString('t');
      expect(title, 'Active');
    });
    test('print car inactive', () async {
      PassMarker.useMobileLayout = true;
      final info = new InfoCarTest();
      String title = await info.activeString('f');
      expect(title, 'Inactive');
    });
    test('print car position', () async {
      PassMarker.useMobileLayout = true;
      final info = new InfoCarTest();
      String title1 = await info.positionString('ciaooooooooooo,testttttttttt');
      expect(title1, 'ciaoooo,testttt');
    });
  });
}
