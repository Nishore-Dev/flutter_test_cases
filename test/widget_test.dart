// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_nodejs/login_screen_new.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

// Mock Logger
class MockLogger extends Mock implements Logger {}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockLogger mockLogger;
  late Authentication auth;

  Widget createLoginScreen() => MaterialApp(
          home: LoginScreenNew(
        auth: auth,
      ));

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockLogger = MockLogger();
    auth = Authentication(localStorage: mockPrefs, logger: mockLogger);
  });

  group('Authentication Unit Tests', () {
    test('setUserName should log message and set userName', () {
      const name = 'testuser';

      auth.setUserName(name);

      verify(mockLogger.logMessage(name)).called(1);
      expect(auth.getUsernName(), name);
    });

    test('isLoggedIn should return true when key is set to true', () {
      when(mockPrefs.getBool('isLoggedIn')).thenReturn(true);
      final result = auth.isLoggedIn();
      expect(result, true);
    });

    test('isLoggedIn should return false when key is not set', () {
      when(mockPrefs.getBool('isLoggedIn')).thenReturn(null);
      final result = auth.isLoggedIn();
      expect(result, false);
    });

    test('validateUserName should return error for empty name', () {
      final result = auth.validateUserName('');
      expect(result, 'Enter user name');
    });

    test('validateUserName should return error for name with spaces', () {
      final result = auth.validateUserName('test user');
      expect(result, 'user name must not contain empty space');
    });

    test('validateUserName should return null for valid name', () {
      final result = auth.validateUserName('testuser');
      expect(result, null);
    });

    test('validatePassword should return error for empty password', () {
      final result = auth.validatePassword('');
      expect(result, 'Enter Password');
    });
  });

  group('Testcases for title Text', () {
    testWidgets('testing if  title- Welcome User is avialable or not',
        (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final titleFinder = find.text('Welcome User');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('testing username textfield exists', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final textfieldFinder = find.byKey(const ValueKey('userName'));
      expect(textfieldFinder, findsOneWidget);
    });

    testWidgets('testing password textfield exists', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final textfieldFinder = find.byKey(const ValueKey('password'));
      expect(textfieldFinder, findsOneWidget);
    });

    testWidgets('testing login button exist', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('testing login with label', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final buttonFinder = find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.text('Press to LogIn'));
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('testing Column widgets exists', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final buttonFinder = find.ancestor(
          of: find.byType(ElevatedButton), matching: find.byType(Column));
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('testing if login button can has max 2 lines', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final buttonFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.maxLines == 2);
      expect(buttonFinder, findsOneWidget);
    });
  });
}
