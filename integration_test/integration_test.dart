import 'package:flutter/material.dart';
import 'package:flutter_nodejs/login_screen_new.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock Classes
class MockAuthentication extends Mock implements Authentication {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLogger extends Mock implements Logger {}

// Widget Test File
void main() {
  loginScreenIntegrationTests();
}

// Integration Test File
void loginScreenIntegrationTests() {
  group('LoginScreenNew Integration Test', () {
    late MockAuthentication mockAuth;

    setUp(() {
      mockAuth = MockAuthentication();
      when(mockAuth.validateUserName(any)).thenReturn(null);
      when(mockAuth.validatePassword(any)).thenReturn(null);
    });

    testWidgets('User can log in and log out', (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(home: LoginScreenNew(auth: mockAuth)));

      await tester.enterText(
          find.byKey(const ValueKey('userName')), 'testUser');
      await tester.enterText(
          find.byKey(const ValueKey('password')), 'testPass');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Press to Logout'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Press to LogIn'), findsOneWidget);
    });
  });
}
