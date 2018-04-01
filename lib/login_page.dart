import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();

  @override
  _LoginPageState createState() => new _LoginPageState(auth: auth);
}

enum LoginFormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.auth});
  final BaseAuth auth;

  static final scaffoldKey = LoginPage.scaffoldKey;
  static final formKey = LoginPage.formKey;

  String _email;
  String _password;
  LoginFormType _formType = LoginFormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Username: $_email, password: $_password");
      return true;
    }
    return false;
  }
  
  void validateAndLogin() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await auth.signIn(_email, _password);
        _showSnackBar('Logged in: ${user.uid}');
      }
      catch (e) {
        _showSnackBar(e.toString());
      }
    }
  }

  void validateAndRegister() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await auth.createUser(_email, _password);
        _showSnackBar('Account created: ${user.uid}');

      } catch (e) {
        _showSnackBar(e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.login;
    });
  }

  void _showSnackBar(String message) {

    final snackbar = new SnackBar(
      content: new Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }


  List<Widget> usernameAndPassword() {
    return [
      new TextFormField(
        key: new Key('email'),
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      ),
      new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      ),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case LoginFormType.login:
        return [
          new RaisedButton(
            key: new Key('login'),
            child: new Text("Login"),
            onPressed: validateAndLogin
          ),
          new FlatButton(
            key: new Key('need-account'),
            child: new Text("Need an account? Register"),
            onPressed: moveToRegister
          ),
        ];
      case LoginFormType.register:
        return [
          new RaisedButton(
            key: new Key('register'),
            child: new Text("Create an account"),
            onPressed: validateAndRegister
          ),
          new FlatButton(
            key: new Key('need-login'),
            child: new Text("Have an account? Login"),
            onPressed: moveToLogin
          ),
        ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: usernameAndPassword() + submitWidgets(),
          )
        )
      )
    );
  }
}
