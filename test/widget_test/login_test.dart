import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

class FakeLoginService implements LoginService {
  @override
  User? currentUser() {
    return null;
  }

  @override
  Future<User?> signInWithemailandpass(String email, String password) async {
    return null;
  }

  @override
  firebasefirestore() {
    return null;
  }
}

void main() {
  group("login page test", () {
    PassMarker.useMobileLayout = true;

    testWidgets('email, password and button are found',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Login(
        loginService: FakeLoginService(),
      )));

      expect(find.text("User Email"), findsOneWidget);
    });
  });
}
/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prcarpolimi/auth/login.dart';
import 'package:prcarpolimi/main.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());

  group("aaaaaaa", () {
    PassMarker.useMobileLayout = true;
    testWidgets("ciao", (WidgetTester tester) async {
      final addField = find.byKey(ValueKey(1));

      await tester.pumpWidget(MaterialApp(home: Login()));
      await tester.enterText(addField, "ciaociao");
      await tester.pump();

      expect(find.text("ciaociao"), findsOneWidget);
    });
  });
}
*/