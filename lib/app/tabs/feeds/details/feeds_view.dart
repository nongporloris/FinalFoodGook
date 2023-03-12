import 'package:flutter/material.dart';
import 'package:foodgook/app/components/post_item.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Map> recipeResultAll = [];
String downloadURL;
String lastedUID;

Future<void> getData() async{
  recipeResultAll.clear();
  Map recipeFeedDetail;
  List<String> userUID;
  List<String> tempUserUID;
  await _firestore.collection("User_Profile").doc(_auth.currentUser.uid).collection("Relation_Detail").doc('Following').get().then((docSnap){
    print(docSnap.data());
    tempUserUID = docSnap['UserUID'].cast<String>();
    tempUserUID.shuffle();
    if(tempUserUID.length > 10){
      userUID = tempUserUID.getRange(0, 9);
    }
    else if(tempUserUID.length <= 10){
      userUID = tempUserUID;
    }
  });
  await _firestore.collection("Recipes").where('UserUID', whereIn: userUID).orderBy('postTime', descending: true).limit(10).get().then((collSnap){
    collSnap.docs.forEach((result){
      recipeFeedDetail = result.data();
      print(recipeFeedDetail['Recipe_Name']);
      recipeFeedDetail['docID'] = result.id;
      recipeResultAll.add(recipeFeedDetail);
    });
  });
  await Future.forEach(recipeResultAll, (element) async{
    await _firestore.collection("User_Profile").doc(element['UserUID']).get().then((userSnap){
      element['userName'] = userSnap.data()['Username'];
      element['userImageURL'] = userSnap.data()['ImageURL'];
    });
  });


}

Future<String> getDataCheck() async {
  if(lastedUID != _auth.currentUser.uid){
    recipeResultAll.clear();
    lastedUID = _auth.currentUser.uid;
  }
  if(recipeResultAll.isEmpty){
    print('...Getting data...');
    await getData();
  }
  if(recipeResultAll.isNotEmpty){
    print('Done');
    return 'Done';
  }
}



class FeedsView extends StatefulWidget {
  @override
  _FeedsViewState createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getDataCheck(),
            builder: (BuildContext context ,AsyncSnapshot snapshot){
              print(recipeResultAll.length);
              if (recipeResultAll.length == 0)
              {
                return Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'There is no content to display.',
                          style: TextStyle(color: Colors.grey[400]),
                        )
                      ],
                    ),
                  ),
                );
              }
              else if(recipeResultAll.length != 0)
              {
                return RefreshIndicator(
                  onRefresh: () async{
                    await getData();
                    setState(() {
                    });
                  },
                  child: ListView.builder(
                    key: PageStorageKey('Feeds'),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: recipeResultAll.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map recipeResult = recipeResultAll[index];
                      return PostItem(
                        img: recipeResult['ImageURL'],
                        name: recipeResult['userName'],
                        dp: recipeResult['userImageURL'], //profile pic
                        time: recipeResult['postTime'],
                        foodname: recipeResult['Recipe_Name'],
                        description: recipeResult['Description'],
                        tag: recipeResult['Tag'],
                        view: recipeResult['View'],
                        favorite: recipeResult['Favorite'],
                        docID: recipeResult['docID'],
                        UserUID : recipeResult['UserUID']
                      );
                    },
                  ),
                );
              }
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }
        ));
  }
}
