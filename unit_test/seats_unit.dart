import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("String print title", () {
    PassMarker.useMobileLayout = true;
    test('String from filter', () async {
      final seats = new SeatsString();
      String title = seats.seatsString(true);
      expect(title, 'Choose the minimum car\'s seats');
    });

    test('String from add new car', () async {
      final seats = SeatsString();
      String title1 = seats.seatsString(false);
      expect(title1, 'Choose car\'s seats ');
    });
  });
}
