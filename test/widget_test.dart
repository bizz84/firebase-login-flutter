import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login/login_page.dart';

import 'package:login/auth.dart';

class AuthMock implements Auth {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = false;
  bool didRequestLogout = false;

  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    return _userIdOrError();
  }

  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return _userIdOrError();
  }

  Future<String> currentUser() async {
    return _userIdOrError();
  }

  Future<void> signOut() async {
    didRequestLogout = true;
    return Future.value();
  }

  Future<String> _userIdOrError() {
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

    // Create an authorization mock
    AuthMock mock = new AuthMock(userId: 'uid');
    // create a LoginPage
    LoginPage loginPage = new LoginPage(title: 'test', auth: mock);
    // Add it to the widget tester
    await tester.pumpWidget(buildTestableWidget(loginPage));

    // tap on the login button
    Finder loginButton = find.byKey(new Key('login'));
    await tester.tap(loginButton);

    // 'pump' the tester again. This causes the widget to rebuild
    await tester.pump();

    // check that the hint text is empty
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
