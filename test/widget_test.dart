// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login/login_page.dart';

import 'package:login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMock implements Auth {
  bool didRequestSignIn = false;
  bool didRequestCreateUser = true;
  Future<FirebaseUser> signIn(String email, String password) async {
    didRequestSignIn = true;
    return null;
  }
  Future<FirebaseUser> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return null;
  }
}

void main() {

  Widget makeTestWidget(LoginPage loginPage) {
    return new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: loginPage)
    );
  }


  testWidgets('''
    Given email and password are empty
    When login button is pressed
    Then sign in is called
    ''', (WidgetTester tester) async {

    AuthMock mock = new AuthMock();
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    await tester.pumpWidget(makeTestWidget(loginPage));

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);
    
    expect(mock.didRequestSignIn, false);
  });

  testWidgets('''
    Given email and password are non-empty
    When login button is pressed
    Then sign is called
    ''', (WidgetTester tester) async {

    AuthMock mock = new AuthMock();
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    await tester.pumpWidget(makeTestWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);
    
    expect(mock.didRequestSignIn, true);
  });
}
