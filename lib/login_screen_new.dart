// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mocking_first_mocktail/auth/auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenNew extends StatefulWidget {
  final Authentication auth;
  const LoginScreenNew({super.key, required this.auth});
  // const LoginScreenNew({super.key});

  @override
  State<LoginScreenNew> createState() => _LoginScreenNewState();
}

class _LoginScreenNewState extends State<LoginScreenNew> {
  bool isLoggedIn = false, showLoader = false;
  final _userNameController = TextEditingController(),
      _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome User'),
              TextFormField(
                key: const ValueKey('userName'),
                controller: _userNameController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter User Name'),
                validator: (name) => widget.auth.validateUserName(name),
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('password'),
                controller: _passwordController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter Password'),
                validator: (password) => widget.auth.validatePassword(password),
              ),
              const SizedBox(height: 40),
              if (showLoader) ...[
                const CircularProgressIndicator()
              ] else ...[
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          showLoader = true;
                        });

                        //await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                        setState(() {
                          showLoader = false;
                        });
                        if (!isLoggedIn) {
                          _userNameController.clear();
                          _passwordController.clear();
                        }
                      }
                    },
                    child: Text(
                      isLoggedIn ? 'Press to Logout' : 'Press to LogIn',
                      maxLines: 2,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class Logger {
  void logMessage(String message) {
    print('Logged Messaage:$message');
  }

  void logError(String error) {
    print('Error: $error');
  }
}

class Authentication {
  final SharedPreferences localStorage;
  final Logger logger;

  final loginKey = 'isLoggedIn';
  String userName = '';
  Authentication({required this.localStorage, required this.logger});

  void setUserName(String name) {
    if (name.isNotEmpty) {
      logger.logMessage(name);
      userName = name;
    }
  }

  String getUsernName() => userName;

  bool isLoggedIn() {
    final status = localStorage.getBool(loginKey);
    return status ?? false;
  }

  Future<bool> setLoginStatus(bool status) async {
    try {
      return await localStorage.setBool(loginKey, status);
    } catch (e) {
      throw Exception('Failed to set status ( Exception:$e)');
    }
  }

  String? validateUserName(String? name) {
    /* validation rules:
    1. 4 <= name_length <= 16
    2. must not contain empty spaces
    */
    if (name == null || name.isEmpty) {
      return 'Enter user name';
    }
    if (name.contains(' ')) {
      return 'user name must not contain empty space';
    }
    if (name.length < 4) {
      return 'name should conatin atleast 4 characters';
    }
    if (name.length > 16) {
      return 'name can conatin atmost 16 characters';
    }
    return null;
  }

  String? validatePassword(String? password) {
    /* validation rule
    1. 8 <= name_length
    2. must contain atleast 1 number
    */
    if (password == null || password.isEmpty) {
      return 'Enter Password';
    }
    if (password.length < 4) {
      return 'password should conatin atleast 4 characters';
    }

    return null;
  }
}
