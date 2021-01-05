import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_note_app/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool loading = false;
  bool validate = false;

  final Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Form(
        key: _signupKey,
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
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: () {
                        _signUp();
                      },
                    ),
                  ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Theme(
      data: ThemeData(primaryColor: Theme.of(context).accentColor),
      child: TextFormField(
        autovalidate: true,
        controller: _emailController,
        decoration: InputDecoration(
          icon: Icon(Icons.email),
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
        /*  onSaved: (String value) {
          _email = value;
        }, */
      ),
    );
  }

  Widget _buildpassWord() {
    return Theme(
      data: ThemeData(primaryColor: Theme.of(context).accentColor),
      child: TextFormField(
        obscureText: false,
        autovalidate: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline),
          labelText: 'Password',
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          } else if (value.length < 4) {
            return "Password must be more than 4 character";
          }
          return null;
        },
        /*   onSaved: (String value) {
          _password = value;
        }, */
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _signUp() async {
    FormState form = _signupKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      Fluttertoast.showToast(
        msg: "Fix the Errors ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } else {
      setState(() {
        loading = true;
      });
      _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((result) {
        FirebaseUser user = result.user;
        firestore.collection("users").document(user.uid).setData({
          "email": _emailController.text,
        }).then((val) {
          setState(() {
            loading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return HomeScreen();
              },
            ),
          );
        }).catchError((e) {
          setState(() {
            loading = false;
          });
        });
      }).catchError((e) {
        setState(() {
          loading = false;
        });
      });
    }
  }
}
