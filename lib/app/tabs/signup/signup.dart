import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:country_pickers/country_pickers.dart';
// import 'package:email_validator/email_validator.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
String _gender = "Male";
DateTime selectedDOB = DateTime.now();
String selectedCountry = "United States";

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

enum _registerStatus { success, emailAlreadyUse }

_registerStatus registerStatus = _registerStatus.success;

Future<void> register() async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      registerStatus = _registerStatus.emailAlreadyUse;
    }
  } catch (e) {
    print(e);
  }
  if (_auth.currentUser != null) {
    registerStatus = _registerStatus.success;
    CollectionReference users = _firestore.collection('User_Profile');
    QuerySnapshot recQuery = await _firestore.collection('Recipes').orderBy('postTime', descending: true).limit(5).get();
    List recList = [];
    for(int i = 0; i< recQuery.docs.length; i++)
      {
        recList.add(recQuery.docs[i].id);
      }
    await users
        .doc(_auth.currentUser.uid)
        .set({
          'Email': _emailController.text,
          'Username': _usernameController.text,
          'Gender': _gender,
          'DOB': selectedDOB,
          'Nationality': selectedCountry,
          'Description': '',
          'Followers': 0,
          'Following': 0,
          'Recipes': 0,
          'ImageURL': '',
          'searchName' : _usernameController.text.toLowerCase()
        })
        .then((value) => print("User Added1"))
        .catchError((error) => print("Failed to add user: $error"));
    await users.doc(_auth.currentUser.uid).collection('Relation_Detail').doc('Following').set(
        {
          'UserUID': []
        }).then((value) => print("User Added2"))
        .catchError((error) => print("Failed to add user: $error"));
    await users.doc(_auth.currentUser.uid).collection('Relation_Detail').doc('Grocery').set(
        {
          'RecipeID': []
        }).then((value) => print("User Added3"))
        .catchError((error) => print("Failed to add user: $error"));
    await users.doc(_auth.currentUser.uid).collection('Relation_Detail').doc('Recommend').set(
        {
          'RecipeID': recList
        }).then((value) => print("User Added4"))
        .catchError((error) => print("Failed to add user: $error"));
    print(_emailController.text);
    print(_passwordController.text);
    print(_usernameController.text);
    print(_gender);
    print(selectedDOB);
    print(selectedCountry);
    print("UID:" + _auth.currentUser.uid);
    await _auth.signOut();
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final validEmailCharacters = RegExp(r'^[a-zA-Z0-9@\.]+$');
  final validCharacters = RegExp(r'^[a-zA-Z0-9&%=]+$');

  final _formKey = GlobalKey<FormState>();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text((() {
                  if (registerStatus == _registerStatus.success) {
                    return "Register Succesful";
                  } else if (registerStatus == _registerStatus.emailAlreadyUse)
                    return "Email already in use";
                })())
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (registerStatus == _registerStatus.success) {
                  _gender = 'Male';
                  selectedDOB = DateTime.now();
                  _emailController.clear();
                  _usernameController.clear();
                  _passwordController.clear();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else if (registerStatus == _registerStatus.emailAlreadyUse)
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDOB,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDOB)
      setState(() {
        selectedDOB = picked;
      });
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 250,
              child: Text("${country.name}", overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(295.0, 112.0, 0.0, 0.0),
                              child: Text(
                                '.',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffff6240)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 35.0, left: 20.0, right: 20.0),
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
                                    hintText: "example@gmail.com",
                                    // hintText: 'EMAIL',
                                    // hintStyle: ,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff6240)))),
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
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    labelText: 'USERNAME',
                                    labelStyle: TextStyle(
                                        fontFamily: 'rublik',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff6240)))),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !validCharacters.hasMatch(value) ||
                                      value.length < 8 ||
                                      value.length > 16) {
                                    return 'Username must contain 8 - 16 letters or numbers';
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'PASSWORD ',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Rublik',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    hintText: "Must have at least 8 characters",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff6240)))),
                                obscureText: true,
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
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'CONFIRM PASSWORD ',
                                    labelStyle: TextStyle(
                                        fontFamily: 'Rublik',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    hintText: "Must have at least 8 characters",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff6240)))),
                                obscureText: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Password must match';
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'GENDER',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontFamily: 'rublik',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey),
                                  )),
                              SizedBox(height: 5.0),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: DropdownButton<String>(
                                    value: _gender,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 20,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Color(0xffff6240),
                                        fontFamily: 'rublik',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    underline: Container(
                                        height: 2, color: Color(0xffff6240)),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _gender = newValue;
                                      });
                                    },
                                    items: <String>["Male", "Female"]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )),
                              SizedBox(height: 15.0),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'DATE OF BIRTH',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontFamily: 'rublik',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey),
                                  )),
                              SizedBox(height: 10.0),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Text(
                                      "${DateFormat.yMd().format(selectedDOB.toLocal())}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffff6240),
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2),
                                    ),
                                  )),
                              SizedBox(height: 15.0),
                              Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'NATIONALITY',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontFamily: 'rublik',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.grey),
                                  )),
                              SizedBox(height: 5.0),
                              CountryPickerDropdown(
                                initialValue: 'US',
                                itemBuilder: _buildDropdownItem,
                                onValuePicked: (Country country) {
                                  setState(() {
                                    selectedCountry = country.name;
                                  });
                                },
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                  height: 40.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.orangeAccent,
                                    color: Color(0xffff6240),
                                    elevation: 7.0,
                                    child: InkWell(
                                      onTap: () async {
                                        if (_formKey.currentState.validate()) {
                                          await register();
                                          print('Validate');
                                          _showMyDialog();
                                        } else {
                                          print('Error');
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Rublik'),
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 20.0),
                              Container(
                                height: 40.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: InkWell(
                                    onTap: () {
                                      _gender = 'Male';
                                      selectedDOB = DateTime.now();
                                      _emailController.clear();
                                      _usernameController.clear();
                                      _passwordController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Center(
                                      child: Text('Go Back',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Rublik')),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0)
                            ],
                          )),
                    ]))));
  }
}
