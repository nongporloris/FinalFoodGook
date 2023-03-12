import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodgook/app/tabs/feeds/feedspage.dart';

import '../../../app.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: missing_return
Future<String> _login() async {
  String returnString = 'loading';
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      returnString = e.code;
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      returnString = e.code;
    }
    print(e.code);
  }
  if (_auth.currentUser != null) {
    returnString = 'success';
  }
  return returnString;
}

Future<void> _showLoginDialog(BuildContext context) async {
  await _auth.signOut();
  Future<String> loginState = _login();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          child: Container(
        margin: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: loginState,
            builder: (context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.data == 'user-not-found') {
                children = <Widget>[
                  Text('This Email not found',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'rublik',
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'rublik',
                        )),
                  )
                ];
              } else if (snapshot.data == 'wrong-password') {
                children = <Widget>[
                  Text('Wrong password',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'rublik',
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'rublik',
                        )),
                  )
                ];
              } else if (snapshot.data == 'success') {
                print('Login Success');
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  )
                ];
                Navigator.pop(context);
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  _emailController.clear();
                  _passwordController.clear();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => App()));
                });
              } else {
                print('Loading');
                children = <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  )
                ];
              }
              return Column(children: children);
            },
          ),
        ),
      ));
    },
  );
}

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final validEmailCharacters = RegExp(r'^[a-zA-Z0-9@\.]+$');
  final validCharacters = RegExp(r'^[a-zA-Z0-9&%=]+$');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text('Hello',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                        child: Text('There',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rublik')),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(250.0, 175.0, 0.0, 0.0),
                        child: Text('.',
                            style: TextStyle(
                                fontFamily: 'Rublik',
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffff6240))),
                      )
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'Rublik',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffff6240)))),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !validEmailCharacters.hasMatch(value) ||
                                !value.contains('@')) {
                              return 'Please enter valid email';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'Rublik',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffff6240)))),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !validCharacters.hasMatch(value) ||
                                value.length < 8 ||
                                value.length > 16) {
                              return 'Password must contain 8 - 16 letters or numbers';
                            } else
                              return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            onTap: () {
                              // Navigator.of(context).pushNamed('/forgotpass');
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                  color: Color(0xffff6240),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Rublik',
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.orangeAccent,
                            color: Color(0xffff6240),
                            elevation: 7.0,
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  await _showLoginDialog(context);
                                }
                              },
                              child: Center(
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Rublik'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // SizedBox(height: 20.0),
                        // Container(
                        //   height: 40.0,
                        //   color: Colors.transparent,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //             color: Colors.black,
                        //             style: BorderStyle.solid,
                        //             width: 1.0),
                        //         color: Colors.transparent,
                        //         borderRadius: BorderRadius.circular(20.0)),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         Center(
                        //           child:
                        //               ImageIcon(AssetImage('assets/facebook.png')),
                        //         ),
                        //         SizedBox(width: 10.0),
                        //         Center(
                        //           child: Text('Sign in with facebook',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   fontFamily: 'Rublik')),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    )),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to FoodGook ?',
                      style: TextStyle(fontFamily: 'Rublik'),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signuppage');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Color(0xffff6240),
                            fontFamily: 'Rublik',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
