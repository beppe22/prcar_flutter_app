import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/filters.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("Configuration print", () {
    test('filter text', () async {
      PassMarker.useMobileLayout = true;
      final filter = new FilterTest();
      double title = await filter.printSize();
      expect(title, 22.0);
    });

    test('filter text', () async {
      PassMarker.useMobileLayout = false;
      final filter = new FilterTest();
      double title = await filter.printSize();
      expect(title, 32.0);
    });

    test('print least', () async {
      final filter = new FilterTest();
      String title1 = await filter.printLeast('', '');
      expect(title1, 'Least: ');
    });

    test('nearby position', () async {
      final filter = new FilterTest();
      bool pos = await filter.nearbyPosition('0', '0', '80,80');
      expect(pos, true);
    });
  });
}
