import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'addpost_item2.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:numberpicker/numberpicker.dart';

import 'addpost_item3.dart';



final TextEditingController _menunameController = TextEditingController();
final TextEditingController _descnameController = TextEditingController();
List<TextEditingController> tagConList = List.generate(5, (i) => TextEditingController());
int _TimeValue = 5;
String _Difficult = "Easy";
File imageFile2;


List<String> sendPage1String(){
  List<String> _Sender = [_menunameController.text,_descnameController.text,_Difficult];
  return _Sender;
}

int sendTime(){
  return _TimeValue;
}

File imageSend(){
  return imageFile2;
}

void closePage(){
  _menunameController.clear();
  _descnameController.clear();
  for(int i = 0; i < 5; i++) {
    tagConList[i].clear();
  }
  for(int i = 0; i < 10; i++) {
    conList[i].clear();
  }
  for(int i = 0; i < 10; i++) {
    dirConList[i].clear();
  }
  _Difficult = "Easy";
  _TimeValue = 5;
  imageFile2 = null;
}

class AddRecipeScreen extends StatefulWidget {
  // final Recipe recipe;]

  AddRecipeScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {

  NumberPicker integerNumberPicker;
  final _formKey = GlobalKey<FormState>();

  static int tagCount = 1;

  final tagController = TextEditingController();
  String dropdownValue = '';
  // List<String> _dynamicChips = [];
  var isSubmiting = false;

  void addTag(){
    if(tagCount < 5)
    {
      tagCount++;
    }
    setState(() {
    });
  }

  void reduceTag(){
    if(tagCount > 1)
    {
      tagCount--;
    }
    setState(() {
    });
  }

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

  //fix deprecated
  @override
  Widget build(BuildContext context) {

    _openGallery(BuildContext context) async {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile2 = imageFile;
      });
      Navigator.of(context).pop();
    }

    _openCamera(BuildContext context) async {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        imageFile2 = imageFile;
      });
      Navigator.of(context).pop();
    }

    Widget _decideImageView() {
      if (imageFile2 != null) {
        return Image.file(
          imageFile2,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/images/recipe_place_holder.jpg',
          fit: BoxFit.cover,
        );
      }
    }

    Future<void> _showPickerDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select a photo from'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Gallery'),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text('Camera'),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ),
            );
          });
    }

    Future<void> _showIntegerDialog() async {
      await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return new StatefulBuilder(
                builder: (context, setState2) {
                  return AlertDialog(
                    content: NumberPicker(
                      value: _TimeValue,
                      minValue: 5,
                      maxValue: 300,
                      step: 5,
                      onChanged: (value) {
                        setState(() => _TimeValue = value);
                        setState2(() => _TimeValue = value);
                      },
                    ),
                  );
                }
            );
          }
      );
    }

    Future<void> _AlertImageNotPick() async {
      await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Please select the image"),
                  );
                }
            );
          }

    // dynamicChips() {
    //   return Wrap(
    //     spacing: 6.0,
    //     runSpacing: 6.0,
    //     children: List<Widget>.generate(_dynamicChips.length, (int index) {
    //       return Chip(
    //         label: Text(_dynamicChips[index]),
    //         onDeleted: () {
    //           setState(() {
    //             _dynamicChips.removeAt(index);
    //           });
    //         },
    //         deleteIcon: Icon(Icons.delete),
    //       );
    //     }),
    //   );
    // }

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
            'Menu',
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
            Column(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StepProgressIndicator(
                        totalSteps: 3,
                        currentStep: 1,
                        // selectedColor: Colors.green[400],
                        selectedColor: Color(0xffff6240),
                        unselectedColor: Colors.grey[200],
                      )
                    ],
                  ),
                ),
                Container(
                  //image and close icon
                  decoration: new BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _decideImageView(),
                          ),
                        ),
                        onTap: () {
                          _showPickerDialog(context);
                        },
                      ),
                      // Positioned(
                      //   //close
                      //   top: 10,
                      //   left: 20,
                      //   child: IconButton(
                      //     //change button position //on photo
                      //     icon: const Icon(Icons.close),
                      //     color: Colors.grey,
                      //     iconSize: 24,
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
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
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                // textInputAction: TextInputAction.newline,
                                controller: _menunameController,
                                keyboardType: TextInputType.text,

                                decoration: const InputDecoration(
                                    hintText: "Menu",
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
                                    return 'Please Enter Menu Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //Description
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                controller: _descnameController,
                                keyboardType: TextInputType.text,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    hintText: "Description",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffff6240)),
                                    ),
                                    errorStyle: const TextStyle(
                                        color: Colors.red,
                                        decorationColor: Colors.red),
                                    contentPadding: const EdgeInsets.only(
                                        left: 15, right: 15)),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Description!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            //Tag

                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tagCount,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: TextFormField(
                                      controller: tagConList[index],
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      hintText: "Add food tag e.g. salmon, dinner",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xffff6240)),
                                      ),
                                      errorStyle: const TextStyle(
                                          color: Colors.red,
                                          decorationColor: Colors.red),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, right: 15)),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Tag!';
                                    }
                                    return null;
                                  },
                                )
                                    )
                                  ]
                                );
                              }
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      addTag();
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
                                    'Tags',
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
                                      reduceTag();
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
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cooking Time",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {_showIntegerDialog();},
                                          child : Container(
                                              color: Color(0xFFF0F0F0) ,
                                              padding: const EdgeInsets.only(left: 10 , right: 10 ,top: 8 ,bottom: 8),
                                              margin: const EdgeInsets.only(left: 15),
                                              child : Text( _TimeValue.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 24,
                                                ),)
                                          )
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Minute",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Skill",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      child: DropdownButton<String>(
                                        value: _Difficult,
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
                                            _Difficult = newValue;
                                          });
                                        },
                                        items: <String>["Easy", "Medium", "Hard"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            //Next button
            Padding(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
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
                              if( imageFile2 != null){
                                  print("image selected");
                                if (_formKey.currentState.validate()) {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) =>
                                      AddRecipe2Screen()));
                                  }
                              }
                              else{
                                print("image not selected");
                                _AlertImageNotPick();
                              }
                              },
                            child: Text('NEXT'),
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

