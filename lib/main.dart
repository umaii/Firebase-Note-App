import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_app/screens/homescreen.dart';
import 'package:firebase_note_app/screens/loginscreen.dart';
import 'package:firebase_note_app/utils/constants.dart';
import 'package:flutter/material.dart';

void main() => runApp((MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Constants.darkTheme,
      home: LoginScreen(),
    );
  }

  buildHome() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        print(snapshot?.data);
        if (snapshot.hasData) {
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}

