import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Auth({this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  void login(String email, String password) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      showSnackBar('Logged in: ${user.uid}');
    }
    catch (e) {
      showSnackBar(e.toString());
    }
  }

  void register(String email, String password) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      print('Account created: ${user.uid}');
      showSnackBar('Account created: ${user.uid}');

    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void showSnackBar(String message) {

    final snackbar = new SnackBar(
      content: new Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}