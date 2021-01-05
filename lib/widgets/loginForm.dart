//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_note_app/screens/homescreen.dart';
import 'package:firebase_note_app/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loading = false;
  bool validate = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Form(
        key: _loginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmail(),
            _buildpassWord(),
            SizedBox(
              height: 50,
            ),
            loading
                ? CircularProgressIndicator()
                : Container(
                    height: 40,
                    width: 140,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Theme.of(context).accentColor,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: () {
                        if (_loginKey.currentState.validate()) {
                          _signIn();
                        }
                      },
                    ),
                  ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SignUp(),
                      ),
                    );
                  },
                  child: Text(
                    'SignUp',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 14),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.

  _signIn() async {
    FormState form = _loginKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      Fluttertoast.showToast(
        msg: "Fix the Errors before submitting.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } else {
      setState(() {
        loading = true;
      });
      _auth
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((result) {
        FirebaseUser user = result.user;
        setState(() {
          loading = false;
        });
        print(user);
        Fluttertoast.showToast(
          msg: "Login Successful ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return HomeScreen();
            },
          ),
        );
      }).catchError((e) {
        // showInSnackBar(e.toString());
        Fluttertoast.showToast(
          msg: (e.toString()),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
        );
        setState(() {
          loading = false;
        });
      });
    }
  }

  Widget _buildEmail() {
    return Theme(
      data: ThemeData(primaryColor: Theme.of(context).accentColor),
      child: TextFormField(
        autovalidate: true,
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is Required';
          }
          if (!RegExp(
                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              .hasMatch(value)) {
            return 'Please enter a valid Email';
          }
          return null;
        },
        /* onSaved: (String value) {
          _email = value;
        }, */
      ),
    );
  }

  Widget _buildpassWord() {
    return Theme(
      data: ThemeData(primaryColor: Theme.of(context).accentColor),
      child: TextFormField(
        autovalidate: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          } else if (value.length < 4) {
            return "Password must be atleast 4 character";
          }
          return null;
        },
        /*  onSaved: (String value) {
          _password = value;
        }, */
        obscureText: true,
      ),
    );
  }
}
