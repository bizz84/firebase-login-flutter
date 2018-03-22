import 'package:flutter/material.dart';

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
      print("Username: $_email, password: $_password");
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

  void performLogin() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('Email: $_email, password: $_password'),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void performRegister() {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text('Full Name: $_fullName, email: $_email, password: $_password'),
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
