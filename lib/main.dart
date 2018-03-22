import 'package:flutter/material.dart';
// todo: add this
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(title: 'Flutter Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum LoginFormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _fullName;
  String _email;
  String _password;
  LoginFormType _formType = LoginFormType.login;

  void validateAndLogin() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Username: $_email, password: $_password");
      performLogin();
    }
  }

  void validateAndRegister() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Email: $_email, password: $_password");
      performRegister();
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

  void performLogin() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

      showSnackBar('Logged in: ${user.uid}');
    }
    catch (e) {
      showSnackBar(e.toString());
    }
  }

  void performRegister() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      print('Account created: ${user.uid}');
      // TODO: To logged in screen
      setState(() {
        _formType = LoginFormType.login;
      });
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

  Widget buildFormContents() {
    switch (_formType) {
      case LoginFormType.login:
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
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
            new RaisedButton(
                child: new Text("Login"),
                onPressed: validateAndLogin),
            new FlatButton(
                child: new Text("Need an account? Register"),
                onPressed: moveToRegister),
          ],
        );
      case LoginFormType.register:
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            new TextFormField(
              key: new Key('fullName'),
              decoration: new InputDecoration(labelText: 'Your full name'),
              validator: (val) => val.isEmpty ? 'Name can\'t be empty.' : null,
              onSaved: (val) => _fullName = val,
            ),
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
            new RaisedButton(
                child: new Text("Create an account"),
                onPressed: validateAndRegister),
            new FlatButton(
                child: new Text("Have an account? Login"),
                onPressed: moveToLogin),
          ],
        );
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
          child: buildFormContents()
        )
      )
    );
  }
}
