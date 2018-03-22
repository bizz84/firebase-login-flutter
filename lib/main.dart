import 'package:flutter/material.dart';
import 'auth.dart';

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
  Auth auth;

  String _email;
  String _password;
  LoginFormType _formType = LoginFormType.login;

  @override
  void initState() {
    auth = new Auth(scaffoldKey: scaffoldKey);
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print("Username: $_email, password: $_password");
      return true;
    }
    return false;
  }
  
  void validateAndLogin() {
    if (validateAndSave()) {
      auth.login(_email, _password);
    }
  }

  void validateAndRegister() {
    if (validateAndSave()) {
      auth.register(_email, _password);
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
            child: new Text("Login"),
            onPressed: validateAndLogin
          ),
          new FlatButton(
            child: new Text("Need an account? Register"),
            onPressed: moveToRegister
          ),
        ];
      case LoginFormType.register:
        return [
          new RaisedButton(
            child: new Text("Create an account"),
            onPressed: validateAndRegister
          ),
          new FlatButton(
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
