import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/hamburger/configuration.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("configuration page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Configuration(
        isConfirmed: '',
        service: FakeService(),
      )));

      expect(find.text('Configuration'), findsOneWidget);
      //expect(find.text('Insert your driving license info!'), findsOneWidget);
      //expect(find.text('Driving License Code'), findsOneWidget);
      //expect(find.text('Expiry date (dd/MM/yyyy)'), findsOneWidget);
      //expect(find.text('Insert driving license pictures'), findsOneWidget);

      expect(find.text("Driving License is under administrator's control"),
          findsOneWidget);

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(3));
    });
  });
}
