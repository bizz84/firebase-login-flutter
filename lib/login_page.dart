import 'package:flutter/material.dart';
import 'auth.dart';

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

enum AuthStatus {
  notSubmitted,
  success,
  failure
}

String authHintMessage(LoginFormType formType, AuthStatus authStatus) {
  switch (authStatus) {
    case AuthStatus.notSubmitted:
      return '';
    case AuthStatus.success:
      return formType == LoginFormType.login ? 'Signed In' : 'Account Created';
    case AuthStatus.failure:
      return formType == LoginFormType.login ? 'Sign In Error' : 'Account Creation Error';
  }
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.auth});
  final BaseAuth auth;

  static final scaffoldKey = LoginPage.scaffoldKey;
  static final formKey = LoginPage.formKey;

  String _email;
  String _password;
  LoginFormType _formType = LoginFormType.login;
  AuthStatus _authStatus = AuthStatus.notSubmitted;
  String _authHint = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Username: $_email, password: $_password");
      return true;
    }
    return false;
  }
  
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == LoginFormType.login
            ? await auth.signIn(_email, _password)
            : await auth.createUser(_email, _password);
        setState(() {
          _authStatus = AuthStatus.success;
          _authHint = 'User id: $userId';
        });
      }
      catch (e) {
        setState(() {
          _authStatus = AuthStatus.failure;
          _authHint = e.toString();
        });
        print(e);
      }
    } else {
      setState(() {
        _authStatus = AuthStatus.notSubmitted;
        _authHint = "";
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.register;
      _authStatus = AuthStatus.notSubmitted;
      _authHint = "";
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.login;
      _authStatus = AuthStatus.notSubmitted;
      _authHint = "";
    });
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
            child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
            onPressed: validateAndSubmit
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
            child: new Text("Create an account", style: new TextStyle(fontSize: 20.0)),
            onPressed: validateAndSubmit
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

  Widget hintText() {
    String message = authHintMessage(_formType, _authStatus);
    return new Container(
        height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            '$message\n\n$_authHint',
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
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
            children: usernameAndPassword() + submitWidgets() + [ hintText() ],
          )
        )
      )
    );
  }
}
