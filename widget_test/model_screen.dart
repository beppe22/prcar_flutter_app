import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/filters/vehicle/model.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("model test", () {
    PassMarker.useMobileLayout = true;
    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Models(
        indice: 0,
        service: FakeService(),
      )));

      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pump();

      expect(find.text("Models"), findsOneWidget);
      expect(find.text("145"), findsOneWidget);
      expect(find.text("146"), findsOneWidget);
      expect(find.text("147"), findsOneWidget);
      expect(find.text("155"), findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(6));
    });
  });
}
