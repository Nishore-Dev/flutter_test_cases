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
  authenticationUnitTests();
}

// Unit Test File
void authenticationUnitTests() {
  group('Authentication Unit Tests', () {
    late Authentication auth;
    late MockSharedPreferences mockPrefs;
    late MockLogger mockLogger;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockLogger = MockLogger();
      auth = Authentication(localStorage: mockPrefs, logger: mockLogger);
    });

    test('validateUserName returns correct error messages', () {
      expect(auth.validateUserName(''), 'Enter user name');
      expect(auth.validateUserName('a bc'),
          'user name must not contain empty space');
      expect(auth.validateUserName('abc'),
          'name should conatin atleast 4 characters');
      expect(auth.validateUserName('a' * 17),
          'name can conatin atmost 16 characters');
      expect(auth.validateUserName('validName'), isNull);
    });

    test('validatePassword returns correct error messages', () {
      expect(auth.validatePassword(''), 'Enter Password');
      expect(auth.validatePassword('123'),
          'password should conatin atleast 4 characters');
      expect(auth.validatePassword('validPass123'), isNull);
    });
  });
}
