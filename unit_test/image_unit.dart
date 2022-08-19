import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/about_your_car/image_car.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("image test", () {
    test('print image test true', () async {
      PassMarker.useMobileLayout = true;
      final image = new ImageTest();
      String title = await image.printTitle(true);
      expect(title, 'Insert your car\'s pictures \n (min. 1, max 6)');
    });
    test('print image test false', () async {
      PassMarker.useMobileLayout = true;
      final image = new ImageTest();
      String title1 = await image.printTitle(false);
      expect(title1, 'Reset and add new car\' pictures \n (min. 1, max 6)');
    });
  });
}
