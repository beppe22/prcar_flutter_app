import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/least/least.dart';
import 'package:prcarpolimi/filters/seats/seats.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("String print title", () {
    PassMarker.useMobileLayout = true;
    test('String from homepage', () async {
      PassMarker.hpOrNot = true;
      final least = new PrintLeast();
      String title = least.textReserveSave();
      expect(title, 'Reserve!');
    });
    test('String not from homepage', () async {
      PassMarker.hpOrNot = false;
      final least = new PrintLeast();
      String title = least.textReserveSave();
      expect(title, 'Save!');
    });
    test('String from', () async {
      final least = new PrintLeast();
      String title = least.fromString('');
      expect(title, 'From: ');
    });
    test('String until', () async {
      final least = new PrintLeast();
      String title = least.untilString('');
      expect(title, 'Until: ');
    });
  });
}
