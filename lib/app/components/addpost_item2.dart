import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgook/app/tabs/feeds/feedspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'addpost_item.dart';
import 'addpost_item3.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

List<TextEditingController> conList = List.generate(10, (i) => TextEditingController());

class AddRecipe2Screen extends StatefulWidget {
  // final Recipe recipe;

  AddRecipe2Screen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddRecipe2ScreenState();
}

class _AddRecipe2ScreenState extends State<AddRecipe2Screen> {

  static int ingCount = 1;
  final _formKey = GlobalKey<FormState>();

  final tagController = TextEditingController();
  String dropdownValue = '';
  // List<String> _dynamicChips = [];
  File imageFile;
  var isSubmiting = false;

  void addIng(){
    if(ingCount < 10)
      {
        ingCount++;
      }
    setState(() {
    });
  }

  void reduceIng(){
    if(ingCount > 1)
    {
      ingCount--;
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
          },
          child: Icon(Icons.close, color: Colors.grey[700], size: 24),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            'Ingredients',
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
                    currentStep: 2,
                    selectedColor: Color(0xffff6240),
                    unselectedColor: Colors.grey[200],
                  )
                ],
              ),
            ),
            // Column(
            //   children: <Widget>[
            //     Container(
            //       //image and close icon
            //       decoration: new BoxDecoration(color: Colors.white),
            //       child: Positioned(
            //         top: 10,
            //         left: 20,
            //         child: IconButton(
            //           //change button position //on photo
            //           icon: const Icon(Icons.close),
            //           color: Colors.grey,
            //           iconSize: 24,
            //           onPressed: () {
            //             Navigator.pop(context);
            //             Navigator.pop(context);
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
                  Form(
                    key: _formKey,
                   child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingCount,
                  itemBuilder: (context, index) {
                  return  Column(
                          children: <Widget>[
                            //ingre1
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0,left: 20, right: 20),
                              child: TextFormField(
                                controller: conList[index],
                                validator: (value) {
                                  if (value == null || value.isEmpty){
                                    return 'Please enter remain ingredients';
                                  }
                                  return null;
                                },
                                // textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "${index+1}. ingredients",
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
            //Next button
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      addIng();
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
                    'Ingredients',
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
                      reduceIng();
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
                                  if (_formKey.currentState.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddRecipe3Screen()));
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
