import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:prcarpolimi/services/services.dart';

void main() {
  group("login page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('general test', (WidgetTester tester) async {
      final addEmail = await find.byKey(ValueKey(1));
      final addPassword = await find.byKey(ValueKey(2));

      await tester.pumpWidget(MaterialApp(
          home: Login(
        loginService: FakeService(),
      )));

      await tester.enterText(addPassword, 'nuova password');
      await tester.enterText(addEmail, "nuova email");

      expect(find.text('nuova password'), findsOneWidget);
      expect(find.text("nuova email"), findsOneWidget);
      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Password"), findsOneWidget);
      expect(find.text("Welcome to PrCar!"), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
    });
  });
}
