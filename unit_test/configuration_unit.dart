import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("Configuration print", () {
    test('configuration text', () async {
      PassMarker.useMobileLayout = true;
      final text = new TextConfiguration();
      double title = await text.text(1.0);
      expect(title, 20.0);
    });

    test('configuration text', () async {
      PassMarker.useMobileLayout = false;
      final text1 = new TextConfiguration();
      double title1 = await text1.text(1.0);
      expect(title1, 30.0);
    });
  });
}
