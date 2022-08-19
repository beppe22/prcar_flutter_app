import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/homepage.dart';

void main() {
  group("homepage text", () {
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
