
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;



Future<String> updateProfile(File ImageFile, String Description) async{

  String imageURL;
  CollectionReference users = _firestore.collection('User_Profile');
  if(ImageFile == null){
    await users.doc(_auth.currentUser.uid).update({
      'Description': Description
    }).then((value) => print("Succes to update"))
        .catchError((error) {
      print("Failed to update");
    });
    return 'succes';
  }
  else if(ImageFile != null) {
    imageURL = await uploadImage(ImageFile, _auth.currentUser.uid);

    await users.doc(_auth.currentUser.uid).update({
      'Description': Description,
      'ImageURL': imageURL
    }).then((value) => print("Succes to update imageurl"))
        .catchError((error) {
      print("Failed to update imageurl");
    });
    return 'succes';
  }
}

Future<String> uploadImage(File _image, String userID) async {
  String url;
  Reference firebaseStorageRef =
  FirebaseStorage.instance.ref().child('ProfilePicture/$userID/ProfileImage');
  UploadTask uploadTask =  firebaseStorageRef.putFile(_image);
  await uploadTask.then((res) async{
    url = await res.ref.getDownloadURL();
  }).catchError((onError) {
    print('error2');
  });
  return url;
}

Future<void> _updateProcessDialog(BuildContext context, File ImageFile, String Description) async{
  Future<String> updateState = updateProfile(ImageFile,Description);
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Dialog(
          child: Container(
              margin: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: updateState,
                  builder: (context, AsyncSnapshot<String> snapshot){
                    List<Widget> children;
                    if(snapshot.data == 'succes') {
                      children = <Widget>[
                        Text('Update Succes',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'rublik',
                            )),
                        TextButton(
                          onPressed: () {
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
                    else if(snapshot.hasError) {
                      children = <Widget>[
                        Text('Error occured',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'rublik',
                            )),
                        TextButton(
                          onPressed: () {
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

class EditProfile extends StatefulWidget{

  final String _ImageURL;
  final String _Description;

  EditProfile(
      this._ImageURL,
      this._Description
      );


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>{

  File imageFile;
  final TextEditingController _descController = TextEditingController();

  void initState(){
    _descController..text = widget._Description;
  }

  @override
  Widget build(BuildContext context) {
    _openGallery(BuildContext context) async {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        this.imageFile = imageFile;
      });
      Navigator.of(context).pop();
    }

    _openCamera(BuildContext context) async {
      var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        this.imageFile = imageFile;
      });
      Navigator.of(context).pop();
    }

    Widget _decideImageView() {
      if (imageFile != null) {
        return CircleAvatar(
          foregroundImage: FileImage(imageFile),
          backgroundColor: Color(
              0xffE6E6E6),
          radius: 50,
          child: Icon(
            Icons.person,
            color: Color(0xffCCCCCC),
          ),
        );
      } else if(widget._ImageURL.isNotEmpty){
        print(imageFile);
        return CircleAvatar(
          backgroundColor: Color(
              0xffE6E6E6),
          radius: 50,
          child: Icon(
            Icons.person,
            color: Color(0xffCCCCCC),
          ),
          foregroundImage: NetworkImage(
            widget._ImageURL,
          ),
        );
      }
      else {
        return CircleAvatar(
          backgroundColor: Color(
              0xffE6E6E6),
          radius: 50,
          child: Icon(
            Icons.person,
            color: Color(0xffCCCCCC),
          ),
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

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //profile
            Padding(
              padding: EdgeInsets.only(left: 25, right: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          fontFamily: 'Rublik',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //name+count
            Container(
              //name
                padding: EdgeInsets.only(top: 20, left: screenWidth/2 - 50),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap : (){
                            _showPickerDialog(context);
                            },
                          child: _decideImageView(),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20) ,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          maxLength: 240,
                          maxLines: null,
                          controller: _descController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: "Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xffff6240)),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0)
                                  )
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 25, bottom: 25)),
                        )
                      )],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 20, left: 20),
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
                              _updateProcessDialog(context,imageFile,_descController.text);
                            },
                            child: Text('UPDATE'),
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