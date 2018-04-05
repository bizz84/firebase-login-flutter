import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login/login_page.dart';

import 'package:login/auth.dart';

class AuthMock implements Auth {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = true;
  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw StateError('No user');
    }
  }
  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw StateError('No user');
    }
  }
}

void main() {

  Widget buildTestableWidget(Widget widget) {
    return new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: widget)
    );
  }

  testWidgets('empty email and password doesn\'t call sign in', (WidgetTester tester) async {

    AuthMock mock = new AuthMock(userId: 'uid');
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains(''), true);

    expect(mock.didRequestSignIn, false);
  });

  testWidgets('non-empty email and password, valid account, calls sign in, succeeds', (WidgetTester tester) async {

    AuthMock mock = new AuthMock(userId: 'uid');
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains('Signed In'), true);

    expect(mock.didRequestSignIn, true);
  });

  testWidgets('non-empty email and password, invalid account, calls sign in, fails', (WidgetTester tester) async {

    AuthMock mock = new AuthMock(userId: null);
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    await tester.pumpWidget(buildTestableWidget(loginPage));

    Finder emailField = find.byKey(new Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, 'password');

    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    await tester.pump();

    Finder hintText = find.byKey(new Key('hint'));
    expect(hintText.toString().contains('Sign In Error'), true);

    expect(mock.didRequestSignIn, true);
  });
}
