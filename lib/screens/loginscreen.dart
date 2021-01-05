import 'package:firebase_note_app/widgets/loginForm.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/noteslogo.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                LoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
