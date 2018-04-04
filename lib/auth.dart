import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> createUser(String email, String password);
}

class Auth implements BaseAuth {
  Future<FirebaseUser> signIn(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }
}