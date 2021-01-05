import 'package:firebase_note_app/widgets/signupForm.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                SignupForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
