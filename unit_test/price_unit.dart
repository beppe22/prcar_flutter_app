import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/price/price.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  group("Price should be incremented", () {
    PassMarker.useMobileLayout = true;
    test('value should increment', () async {
      final funcs = new Operation();
      int value = 0;
      int res = await funcs.incrementCounter(value);
      expect(res, 1);
    });
    test('value should decrement', () async {
      final funcs = Operation();
      int value1 = 1;
      int res1 = await funcs.decrementCounter(value1);
      expect(res1, 0);
    });
  });
}
