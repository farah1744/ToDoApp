import 'package:flutter/material.dart';
import 'package:todoapp/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  //const AuthScreen({ Key? key }) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentification')),
      body: AuthForm(),
    );
  }
}
