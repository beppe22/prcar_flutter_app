import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("Price should be incremented", () {
    PassMarker.useMobileLayout = true;
    test('value should increment', () async {
      final counter = Counter(filter: true);

      expect(counter.filter, true);
    });
  });
}
