import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgook/app/tabs/feeds/feedspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'addpost_item.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'addpost_item2.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
List<TextEditingController> dirConList = List.generate(10, (i) => TextEditingController());
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> postRecipe() async{
  List<String> page1String = sendPage1String();
  int _Time = sendTime();
  File image = imageSend();
  String imageURL;
  String serachName;

  serachName = page1String[0].toLowerCase();

  List<String> tagList =[];
  for(int i = 0; i<5; i++)
    {
      if(tagConList[i].hasListeners)
        {
          tagList.add(tagConList[i].text.toLowerCase());
        }
    }

  List<String> ingList =[];
  for(int i = 0; i<10; i++)
  {
    if(conList[i].hasListeners)
    {
      ingList.add(conList[i].text.toLowerCase());
    }
  }

  List<String> dirList =[];
  for(int i = 0; i<5; i++)
  {
    if(dirConList[i].hasListeners)
    {
      dirList.add(dirConList[i].text);
    }
  }

  CollectionReference recipes = _firestore.collection('Recipes');
  DocumentReference docID = await recipes.add({
      'Cook_Time': _Time,
      'Description': page1String[1],
      'Direction': dirList,
      'Favorite': 0,
      'Ingredient': ingList,
      'Level': page1String[2],
      'Rating': 0,
      'RatingCount': 0,
      'Recipe_Name': page1String[0],
      'Tag': tagList,
      'UserUID': _auth.currentUser.uid,
      'View': 0,
      'postTime': DateTime.now(),
      'searchName': serachName
  });
  if(docID != null) {
    print('Add succes');
    imageURL = await uploadImage(image, docID.id);
    docID.update({'ImageURL': imageURL}).then((value) => print(imageURL))
        .catchError((error) => print("Failed to update imageurl: $error"));
    _firestore.collection('User_Profile').doc(_auth.currentUser.uid).update({'Recipes' : FieldValue.increment(1)});
    return 'sucess';
  }
  else
    {
      print('Error');
      return 'error';
    }

}

Future<void> _postProcessDialog(BuildContext context) async{
  Future<String> postState = postRecipe();
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: postState,
                builder: (context, AsyncSnapshot<String> snapshot){
                  List<Widget> children;
                  if(snapshot.data == 'sucess') {
                    children = <Widget>[
                      Text('Post Succes',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'rublik',
                          )),
                      TextButton(
                        onPressed: () {
                          closePage();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
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
                  }
                  else if(snapshot.data == 'error') {
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
                  }
                  else{
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
            )
          ),
        );
        }
        );
}

Future<String> uploadImage(File _image, String docID) async {
  String url;
  Reference firebaseStorageRef =
  FirebaseStorage.instance.ref().child('recipeImage/$docID/MainRecipeImage');
  UploadTask uploadTask =  firebaseStorageRef.putFile(_image);
  await uploadTask.then((res) async{
    url = await res.ref.getDownloadURL();
  }).catchError((onError) {
    print(onError);
  });
  return url;
}

class AddRecipe3Screen extends StatefulWidget {
  // final Recipe recipe;

  AddRecipe3Screen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddRecipe3ScreenState();
}

class _AddRecipe3ScreenState extends State<AddRecipe3Screen> {

  static int dirCount = 1;
  final _formKey = GlobalKey<FormState>();

  final tagController = TextEditingController();
  String dropdownValue = '';
  // List<String> _dynamicChips = [];
  File imageFile;
  var isSubmiting = false;

  void addDir(){
    if(dirCount < 10)
    {
      dirCount++;
    }
    setState(() {
    });
  }

  void reduceDir(){
    if(dirCount > 1)
    {
      dirCount--;
    }
    setState(() {
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
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Icon(Icons.close, color: Colors.grey[700], size: 24),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            'Directions',
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
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StepProgressIndicator(
                    totalSteps: 3,
                    currentStep: 3,
                    selectedColor: Color(0xffff6240),
                    unselectedColor: Colors.grey[200],
                  )
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dirCount,
                  itemBuilder: (context, index) {
                    return  Column(
                      children: <Widget>[
                        //ingre1
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0,left: 20, right: 20),
                          child: TextFormField(
                            maxLines: null,
                            controller: dirConList[index],
                            validator: (value) {
                              if (value == null || value.isEmpty){
                                return 'Please enter remain ingredients';
                              }
                              return null;
                            },
                            // textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "${index+1}. Direction",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xffff6240)),
                                ),
                                errorStyle: TextStyle(
                                    color: Colors.red,
                                    decorationColor: Colors.red),
                                contentPadding: const EdgeInsets.only(
                                    left: 15, right: 15)),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      addDir();
                    },
                    child : Container(
                      child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Direction',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      reduceDir();
                    },
                    child : Container(
                      child: Icon(
                        Icons.exposure_minus_1,
                        color: Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              // alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    child: Stack(
                      //back button
                      children: <Widget>[
                        SizedBox(
                          height: 45,
                          width: 100,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'BACK',
                              style: TextStyle(
                                color: Color(0xffff6240),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              side: BorderSide(
                                  width: 1, color: Color(0xffff6240)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      //post button
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
                            width: MediaQuery.of(context).size.width,
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
                              if (_formKey.currentState.validate()) {
                                  _postProcessDialog(context);
                              }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => FeedsPage(),
                              //   ),
                              // );
                            },
                            child: Text('POST'),
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
    );
  }
}
