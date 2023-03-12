import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final TextEditingController _replyController = TextEditingController();
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

void closePage() {
  _replyController.clear();
}

class addComment extends StatefulWidget {
  // final Recipe recipe;]

  String docID;

  addComment(this.docID);

  @override
  State<StatefulWidget> createState() => _addCommentState();
}

class _addCommentState extends State<addComment> {
  NumberPicker integerNumberPicker;
  final _formKey = GlobalKey<FormState>();

  final tagController = TextEditingController();
  String dropdownValue = '';
  // List<String> _dynamicChips = [];
  var isSubmiting = false;

  @override
  void initState() {
    super.initState();
    /* nameController..text = widget.recipe != null ? widget.recipe.name : '';
    servesController..text = widget.recipe != null ? widget.recipe.serves : '';
    linkController..text = widget.recipe != null ? widget.recipe.ytUrl : '';
    prepareTimeController
      ..text = widget.recipe != null ? widget.recipe.preparationTime : '';
    dropdownValue = widget.recipe != null ? widget.recipe.complexity : '';
    _setMetaTags(); */
  }

  @override
  void dispose() {
    super.dispose();
    tagController.dispose();
  }

  Future<String> postComment() async {
    CollectionReference comment = _firestore.collection('Forum').doc(widget.docID).collection('Comment');
    DocumentReference docID = await comment.add({
      'Description': _replyController.text,
      'UserUID': _auth.currentUser.uid,
      'postTime': DateTime.now(),
    });
    if (docID != null) {
      return 'sucess';
    } else {
      print('Error');
      return 'error';
    }
  }

  Future<void> _postProcessDialog(BuildContext context) async {
    Future<String> postState = postComment();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                margin: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: postState,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      List<Widget> children;
                      if (snapshot.data == 'sucess') {
                        children = <Widget>[
                          Text('Reply Succes',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'rublik',
                              )),
                          TextButton(
                            onPressed: () {
                              closePage();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'rublik',
                                )),
                          )
                        ];
                      } else if (snapshot.data == 'error') {
                        children = <Widget>[
                          Text('Error occured',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'rublik',
                              )),
                          TextButton(
                            onPressed: () {
                              closePage();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('OK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'rublik',
                                )),
                          )
                        ];
                      } else {
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
                )),
          );
        });
  }

  //fix deprecated
  @override
  Widget build(BuildContext context) {
    // change to TransformerPageView
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              closePage();
              Navigator.pop(context);
            },
            child: Icon(Icons.close, color: Colors.grey[700], size: 24),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              'Reply Forum',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: ListView(
                //wrap
                // key: _formKey,
                children: <Widget>[
              Scrollbar(
                  child: ListView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      //input form
                      children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Padding(
                        // padding: const EdgeInsets.all(25.0),
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 30),
                        child: Column(
                          children: <Widget>[
                            //Menu
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: TextFormField(
                                maxLines: null,
                                // textInputAction: TextInputAction.newline,
                                controller: _replyController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText: "Reply..",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffff6240)),
                                    ),
                                    errorStyle: TextStyle(
                                        color: Colors.red,
                                        decorationColor: Colors.red),
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, right: 15)),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Reply';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.only(top: 20, right: 20, left: 20),
                              // alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // SizedBox(width: 340),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      //next button
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xffff6240),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x54000000),
                                                  spreadRadius: 10,
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                            height: 500,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 45,
                                          width: 100,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(15.0),
                                              primary: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _postProcessDialog(context);
                                              }
                                            },
                                            child: Text('Reply'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]))
            ])));
  }
}
