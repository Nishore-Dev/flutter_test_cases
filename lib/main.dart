import 'package:flutter/material.dart';
import 'package:flutter_nodejs/login_screen_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create a Logger instance
  final logger = Logger();

  // Create an Authentication instance
  final auth = Authentication(localStorage: sharedPreferences, logger: logger);

  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final Authentication auth;

  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreenNew(auth: auth), // Pass the auth instance here
    );
  }
}

