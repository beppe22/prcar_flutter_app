import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  group("Configuration print", () {
    test('hp text', () async {
      final hp = new HomePageTest();
      String title = await hp.printInfoWindow('test', 'test', 'test');
      expect(title, 'My car: click for details');
    });

    test('hp text2', () async {
      final hp = new HomePageTest();
      String title = await hp.printInfoWindow('test', 'test1', 'test');
      expect(title, 'test');
    });
  });
}
