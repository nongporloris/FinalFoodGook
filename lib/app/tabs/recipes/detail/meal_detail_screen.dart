import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgook/app/tabs/profile/profilepageOther.dart';
import 'package:foodgook/app/tabs/stepByStep/stepByStepPage.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:foodgook/views/recipes_view.dart';
// import 'package:foodgook/models/popularbook_model.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class MealDetailScreen extends StatefulWidget {
  static const routeName = '/meal-detail';
  String docName;

  MealDetailScreen(String docName) {
    this.docName = docName;
    FirebaseFirestore.instance
        .collection("Recipes")
        .doc(docName)
        .update({'View': FieldValue.increment(1)});
  }

  State<StatefulWidget> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  String firstToUpper(String text) {
    String returntext = text.substring(0, 1).toUpperCase() + text.substring(1);
    return returntext;
  }

  _GroceryButton(String recipeID) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User_Profile')
            .doc(_auth.currentUser.uid)
            .collection('Relation_Detail')
            .doc('Grocery')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data['RecipeID'].contains(recipeID)) {
            return GestureDetector(
                onTap: () {
                  _RemoveGrocery(recipeID);
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 2, 10, 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.remove, color: Colors.white),
                          Text('Remove',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                  color: Colors.white))
                        ],
                      ),
                    )));
          } else if (snapshot.hasData &&
              !snapshot.data['RecipeID'].contains(recipeID)) {
            return GestureDetector(
                onTap: () {
                  _AddGrocery(recipeID);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF6240),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 2, 10, 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.white),
                          Text('Grocery',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                  color: Colors.white))
                        ],
                      ),
                    )));
          }
          return Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFF6240),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 2, 10, 2),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white),
                    Text('Grocery',
                        style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            color: Colors.white))
                  ],
                ),
              ));
        });
  }

  void _AddGrocery(String recipeID) {
    List<String> temp = [];
    temp.add(recipeID);
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .collection('Relation_Detail')
        .doc('Grocery')
        .update({'RecipeID': FieldValue.arrayUnion(temp)});
  }

  void _RemoveGrocery(String recipeID) {
    List<String> temp = [];
    temp.add(recipeID);
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .collection('Relation_Detail')
        .doc('Grocery')
        .update({'RecipeID': FieldValue.arrayRemove(temp)});
  }

  void _Follow(String recipeOwnerID) {
    List<String> temp = [];
    temp.add(recipeOwnerID);
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .collection('Relation_Detail')
        .doc('Following')
        .update({'UserUID': FieldValue.arrayUnion(temp)});
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(recipeOwnerID)
        .update({'Followers': FieldValue.increment(1)});
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .update({'Following': FieldValue.increment(1)});
  }

  void _UnFollow(String recipeOwnerID) {
    List<String> temp = [];
    temp.add(recipeOwnerID);
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .collection('Relation_Detail')
        .doc('Following')
        .update({'UserUID': FieldValue.arrayRemove(temp)});
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(recipeOwnerID)
        .update({'Followers': FieldValue.increment(-1)});
    FirebaseFirestore.instance
        .collection('User_Profile')
        .doc(_auth.currentUser.uid)
        .update({'Following': FieldValue.increment(-1)});
  }

  _FollowButton(String recipeOwnerID) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User_Profile')
            .doc(_auth.currentUser.uid)
            .collection('Relation_Detail')
            .doc('Following')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && recipeOwnerID == _auth.currentUser.uid) {
            return Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Text('',
                      style:
                          TextStyle(fontFamily: 'Rubik', color: Colors.indigo)),
                ));
          } else if (snapshot.hasData &&
              snapshot.data['UserUID'].contains(recipeOwnerID)) {
            return Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Container(
                        child: InkWell(
                      onTap: () {
                        _UnFollow(recipeOwnerID);
                      },
                      child: Text('Unfollow',
                          style: TextStyle(
                              fontFamily: 'Rubik', color: Colors.grey)),
                    ))));
          } else if (snapshot.hasData &&
              !snapshot.data['UserUID'].contains(recipeOwnerID)) {
            return Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: InkWell(
                      onTap: () {
                        _Follow(recipeOwnerID);
                      },
                      child: Text('Follow',
                          style: TextStyle(
                              fontFamily: 'Rubik', color: Colors.indigo)),
                    )));
          }
          return Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text('Follow',
                    style:
                        TextStyle(fontFamily: 'Rubik', color: Colors.indigo)),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
        body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Recipes")
                    .doc(widget.docName)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User_Profile')
                        .doc(snapshot.data['UserUID'])
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot2) {
                      if (!snapshot2.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Container(
                                height: 300,
                                width: double.infinity,
                                child: Image.network(
                                  snapshot.data['ImageURL'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios)),
                            ]),
                            DraggableScrollableSheet(
                                initialChildSize: 0.6,
                                minChildSize: 0.6,
                                maxChildSize: 1,
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                    controller: scrollController,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 20, 0, 0)),
                                            Row(children: <Widget>[
                                              Flexible(
                                                flex: 10,
                                                fit: FlexFit.tight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0, 0, 0, 0),
                                                  child: FittedBox(
                                                    child: Text(
                                                      snapshot
                                                          .data['Recipe_Name'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                  flex: 2,
                                                  child: Icon(
                                                    Icons.av_timer,
                                                    color: Colors.blue,
                                                    size: 18,
                                                  )),
                                              Text(
                                                  "${snapshot.data['Cook_Time'].toString()} Min",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              Icon(
                                                Icons
                                                    .signal_cellular_alt_rounded,
                                                color: Colors.green,
                                                size: 18,
                                              ),
                                              Text(snapshot.data['Level'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ]),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 0, 0, 0),
                                              child: Text(
                                                  snapshot.data['Tag']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0xFF00008B))),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                    snapshot
                                                        .data['Description'],
                                                    style: TextStyle(
                                                        fontFamily: 'Rubik'))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 0, 20, 20),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0x1BF9D758),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Flexible(
                                                          flex: 2,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20.0,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Icon(
                                                                Icons.star,
                                                                color: const Color(
                                                                    0xFFFF6240)),
                                                          ),
                                                        ),
                                                        Text(
                                                            snapshot.data[
                                                                    'Rating']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Rubik',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 20)),
                                                        Flexible(
                                                          flex: 7,
                                                          fit: FlexFit.tight,
                                                          child: Padding(
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  20.0,
                                                                  10,
                                                                  0,
                                                                  10),
                                                              child: Text(
                                                                  snapshot.data[
                                                                              'View']
                                                                          .toString() +
                                                                      ' people\nTry this recipe',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Rubik',
                                                                      color: Colors
                                                                          .grey))),
                                                        ),
                                                        Flexible(
                                                            flex: 1,
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10.0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color: Colors
                                                                        .grey)))
                                                      ],
                                                    ))),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 0, 0, 30),
                                              child: Row(children: <Widget>[
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfileViewOther(
                                                                      snapshot.data[
                                                                          'UserUID'])));
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xffE6E6E6),
                                                      radius: 20,
                                                      child: Icon(
                                                        Icons.person,
                                                        color:
                                                            Color(0xffCCCCCC),
                                                      ),
                                                      foregroundImage:
                                                          NetworkImage(
                                                        snapshot2
                                                            .data['ImageURL'],
                                                      ),
                                                    )),
                                                Flexible(
                                                    flex: 3,
                                                    child: Padding(
                                                        padding: const EdgeInsets
                                                                .fromLTRB(
                                                            10.0, 0, 15, 0),
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProfileViewOther(
                                                                              snapshot.data['UserUID'])));
                                                            },
                                                            child: RichText(
                                                                text: TextSpan(
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <
                                                                        TextSpan>[
                                                                  TextSpan(
                                                                      text: snapshot2.data[
                                                                              'Username'] +
                                                                          '\n',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontFamily:
                                                                              'Rubik')),
                                                                  TextSpan(
                                                                      text:
                                                                          "${snapshot2.data['Recipes'].toString()} Recipes",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Rubik',
                                                                          color:
                                                                              Colors.grey)),
                                                                ]))))),
                                                _FollowButton(
                                                    snapshot.data['UserUID']),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(children: <Widget>[
                                                    Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        color: Colors.grey,
                                                        size: 14),
                                                    Text(
                                                        snapshot.data['View']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.grey))
                                                  ]),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10, 0, 0, 0),
                                                          child: Icon(
                                                              Icons.thumb_up,
                                                              color:
                                                                  Colors.grey,
                                                              size: 14),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  2, 0, 0, 0),
                                                          child: Text(
                                                              snapshot.data[
                                                                      'Favorite']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: Colors
                                                                      .grey)),
                                                        )
                                                      ],
                                                    ))
                                              ]),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20.0, 0, 10, 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text('Ingredients',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Rubik',
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Flexible(
                                                      child: _GroceryButton(
                                                          widget.docName))
                                                ],
                                              ),
                                            ),

                                            for (int i = 0;
                                                i <
                                                    snapshot.data['Ingredient']
                                                        .length;
                                                i++)
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 0, 0),
                                                  child: Row(children: <Widget>[
                                                    Icon(Icons
                                                        .add_circle_outline),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                30, 0, 0, 0),
                                                        child: Text(
                                                            firstToUpper(snapshot
                                                                .data[
                                                                    'Ingredient']
                                                                    [i]
                                                                .toString()),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Rubik'))),
                                                  ])),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 30, 0, 0),
                                              child: Text('Directions',
                                                  style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),

                                            //  for(var item in snapshot.data['Direction'])
                                            for (int i = 1;
                                                i <=
                                                    snapshot.data['Direction']
                                                        .length;
                                                i++)
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 20, 0, 0),
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .black87),
                                                        child: Text(
                                                            i.toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Rubik',
                                                                fontSize: 16))),
                                                    Expanded(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  20, 20, 0, 0),
                                                          child: Text(
                                                              snapshot.data[
                                                                      'Direction']
                                                                      [i - 1]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Rubik'))),
                                                    )
                                                  ])),

                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 0, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StepbyStep(
                                                                  snapshot.data[
                                                                      'Direction'],
                                                                  snapshot.data[
                                                                      'Ingredient'],snapshot.data['Recipe_Name'],snapshot.data.id)));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              40,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFFF6240),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(Icons.play_arrow,
                                                              size: 36,
                                                              color:
                                                                  Colors.white),
                                                          Text('Step-by-step',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white))
                                                        ],
                                                      ),
                                                    ))),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 30))
                                          ]),
                                    ),
                                  );
                                })
                          ],
                        ),
                      );
                    },
                  );
                })));
  }
}
