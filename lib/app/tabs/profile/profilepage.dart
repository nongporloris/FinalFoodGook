import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodgook/app/tabs/forum/ForumDetail.dart';
import 'package:foodgook/app/tabs/recipes/detail/meal_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'editProfile.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  final String userID;

  const ProfileView(this.userID);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool switchValue = true;

  Future<List> getGrocery() async{
    List groceryID = [];
    DocumentReference grocery = FirebaseFirestore.instance.collection('User_Profile').doc(widget.userID).collection('Relation_Detail').doc('Grocery');
    CollectionReference recipes = FirebaseFirestore.instance.collection('Recipes');
    DocumentSnapshot grocerySnap = await grocery.get();
    groceryID = grocerySnap.data()['RecipeID'];
    List<DocumentSnapshot> groceryReturn = [];
    DocumentSnapshot temp;
    for (int i = 0; i< groceryID.length;i++)
      {
        temp = await recipes.doc(groceryID[i]).get();
        groceryReturn.add(temp);
      }
    return groceryReturn;
  }

  Future<List> getForum() async {
    List<Map> returnForum = [];
    Map temp;
    String usernameTemp;
    DocumentSnapshot _userQuery;
    CollectionReference _user = FirebaseFirestore.instance.collection('User_Profile');
    CollectionReference _forum = FirebaseFirestore.instance.collection('Forum');
    QuerySnapshot _forumQuery =
    await _forum.where('UserUID', isEqualTo: widget.userID).orderBy('postTime', descending: true).limit(10).get();

    for (int i = 0; i < _forumQuery.docs.length; i++) {
      temp = _forumQuery.docs[i].data();
      _userQuery = await _user.doc(temp['UserUID']).get();
      usernameTemp = _userQuery.data()['Username'];
      temp['Username'] = usernameTemp;
      temp['DocID'] = _forumQuery.docs[i].id;
      returnForum.add(temp);
    }
    return returnForum;
  }

  @override
  void initState() {
    this._tabController = TabController(
      length: 3,
      initialIndex: 0,
      vsync: this,
    );
    super.initState();
  }

  Widget _PostTab() {
    CollectionReference recipes =
        FirebaseFirestore.instance.collection('Recipes');
    return FutureBuilder(
        future: recipes
            .where('UserUID', isEqualTo: widget.userID)
            .orderBy('postTime', descending: true)
            .limit(5)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasData && snapshot2.data.docs.isEmpty) {
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
          } else if (snapshot2.hasData && snapshot2.data.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> docSnap = snapshot2.data.docs;
            return ListView.builder(
                itemCount: docSnap.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0), //10
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("ID:" + docSnap[index].id);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MealDetailScreen(
                                                      docSnap[index].id)));
                                    },
                                    child: Container(
                                      child: Image.network(
                                        docSnap[index]['ImageURL'],
                                        height: 170,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.shrink(),
                                // SizedBox(height: 8.0),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      docSnap[index]['Recipe_Name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye_rounded,
                                            color: Colors.grey),
                                        SizedBox(width: 3),
                                        Text(NumberFormat.compact()
                                            .format(docSnap[index]['View'])),
                                        SizedBox(width: 10),
                                        Icon(Icons.favorite,
                                            color: Color(0XFFEE2B4A)),
                                        SizedBox(width: 3),
                                        Text(NumberFormat.compact().format(
                                            docSnap[index]['Favorite'])),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        docSnap[index]['Description'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    for (var item in docSnap[index]['Tag'])
                                      Flexible(
                                        child: TextButton(
                                          onPressed: () {
                                            print("XD");
                                          },
                                          child: AutoSizeText(
                                            '#' + item,
                                            minFontSize: 8,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0XFF5D6890),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        });
  }

  Widget _GroceryTab() {
    return FutureBuilder(
        future: getGrocery(),
        builder:
            (BuildContext context, snapshot3) {
          if (snapshot3.hasData && snapshot3.data.isEmpty) {
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
          } else if (snapshot3.hasData && snapshot3.data.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot3.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0), //10
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("ID:" + snapshot3.data[index].id);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MealDetailScreen(
                                                      snapshot3.data[index].id)));
                                    },
                                    child: Container(
                                      child: Image.network(
                                        snapshot3.data[index]['ImageURL'],
                                        height: 170,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.shrink(),
                                // SizedBox(height: 8.0),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot3.data[index]['Recipe_Name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye_rounded,
                                            color: Colors.grey),
                                        SizedBox(width: 3),
                                        Text(NumberFormat.compact()
                                            .format(snapshot3.data[index]['View'])),
                                        SizedBox(width: 10),
                                        Icon(Icons.favorite,
                                            color: Color(0XFFEE2B4A)),
                                        SizedBox(width: 3),
                                        Text(NumberFormat.compact().format(
                                            snapshot3.data[index]['Favorite'])),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        snapshot3.data[index]['Description'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    for (var item in snapshot3.data[index]['Tag'])
                                      Flexible(
                                        child: TextButton(
                                          onPressed: () {
                                            print("XD");
                                          },
                                          child: AutoSizeText(
                                            '#' + item,
                                            minFontSize: 8,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0XFF5D6890),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        });
  }

  Widget _ForumTab(){
    CollectionReference recipes = FirebaseFirestore.instance.collection('Forum');
    return FutureBuilder(
        future: getForum(),
        builder:
            (BuildContext context, snapshot5) {
          if (snapshot5.hasData && snapshot5.data.isEmpty) {
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
          } else if (snapshot5.hasData && snapshot5.data.isNotEmpty) {
            return ListView.builder(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                shrinkWrap: true,
                itemCount:
                snapshot5.data.length,
                physics:
                BouncingScrollPhysics(),
                itemBuilder:
                    (context, index) {
                  return Container(
                      padding: EdgeInsets
                          .fromLTRB(0, 15,
                          0, 15),
                      decoration:
                      BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors
                                  .grey
                                  .shade400),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Row(children: [
                              Icon(
                                  Icons
                                      .contact_support_outlined,
                                  color: Colors
                                      .deepOrangeAccent,
                                  size:
                                  20),
                              Flexible(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForumDetail(snapshot5.data[index]['DocID'])));
                                      },
                                      child: Text(
                                        snapshot5.data[index]['Topic'],
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      )))
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              timeago.format(DateTime.fromMicrosecondsSinceEpoch(snapshot5
                                  .data[
                              index]
                              [
                              'postTime']
                                  .microsecondsSinceEpoch)),
                              overflow:
                              TextOverflow
                                  .clip,
                              style:
                              TextStyle(
                                color: Colors
                                    .grey
                                    .shade600,
                                fontSize:
                                14,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                                children: [
                                  Expanded(
                                      child:
                                      GestureDetector(
                                        onTap:
                                            () {
                                          print('to UserDetail');
                                        },
                                        child:
                                        Text(
                                          "by ${snapshot5.data[index]['Username']}",
                                          overflow:
                                          TextOverflow.clip,
                                          style:
                                          TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                    child:
                                    Text(
                                      "${snapshot5.data[index]['Comment']} anwsers",
                                      textAlign:
                                      TextAlign.end,
                                      overflow:
                                      TextOverflow.clip,
                                      style:
                                      TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ])
                          ]));
                });
          }
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        });

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference users =
        FirebaseFirestore.instance.collection('User_Profile');
    return FutureBuilder(
      future: users.doc(widget.userID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrongxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text(
              "Document does not existxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data.data() as Map<String, dynamic>;
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
                              'Profile',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontFamily: 'Rublik',
                              ),
                            ),
                            // SizedBox(
                            //   width: 215,
                            // ),
                            IconButton(
                              icon: Icon(Icons.settings_outlined),
                              color: Colors.grey,
                              iconSize: 24,
                              tooltip: 'Show all settings',
                              onPressed: () {
                                print('Pressed');
                              },
                            ),
                            // Icon(
                            //   Icons.settings_outlined,
                            //   color: Colors.grey,
                            //   size: 24,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //name+count
                  Container(
                    //name
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xffE6E6E6),
                                  radius: 50,
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xffCCCCCC),
                                  ),
                                  foregroundImage: NetworkImage(
                                    data["ImageURL"],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth - (screenWidth * 0.35),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              data['Username'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: 45,
                                              width: 100,
                                              // decoration: BoxDecoration(
                                              //   borderRadius: BorderRadius.circular(10),
                                              //   color: Color(0xFFebf4ef),
                                              // ),
                                              child: Center(
                                                child: TextButton(
                                                  child: Text('Edit Profile'),
                                                  style: TextButton.styleFrom(
                                                    primary: Color(0xffff6240),
                                                    // backgroundColor: Colors.teal,
                                                    // onSurface: Colors.grey,
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    // side: BorderSide(
                                                    //   color: Colors.red,
                                                    //   width: 1,
                                                    // ),
                                                  ),
                                                  onPressed: () {
                                                    print('Pressed');
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProfile(
                                                                    data[
                                                                        'ImageURL'],
                                                                    data[
                                                                        'Description'])));
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 0), //change
                                    Container(
                                      width: screenWidth - (screenWidth * 0.35),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              data['Description'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        //Count Recipes, Folliwing, Follower
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25.0,
                            horizontal: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Recipes',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    data['Recipes'].toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // Container(
                              //   height: 50,
                              //   child: VerticalDivider(
                              //     color: Colors.grey,
                              //   ),
                              // ),

                              Container(
                                color: Colors.grey[400],
                                height: 50,
                                width: 1,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    data['Following'].toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    data['Followers'].toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //tab view
                  Container(
                    child: TabBar(
                      controller: this._tabController,
                      indicatorColor: Color(0xffff6240),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Color(0xffff6240),
                      // labelStyle: TextStyle(fontSize: 20.0),
                      unselectedLabelColor: Colors.black,
                      tabs: <Widget>[
                        Tab(text: 'Posts'),
                        Tab(text: 'Grocery'),
                        Tab(text: 'Forums'),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          controller: this._tabController,
                          children: [
                        _PostTab(),
                        _GroceryTab(),
                            _ForumTab()
                      ]))
                  //if/else when no content

                  //     TabBarView(
                  //     controller: this._tabController,
                  //     children: <Widget>[
                  //       //post1
                  //       Container(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(20),
                  //           child: Wrap(
                  //             children: [
                  //               Padding(
                  //                 padding: EdgeInsets.only(top: 0), //10
                  //                 child: Column(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       child: Container(
                  //                         child: Image.asset(
                  //                           'assets/images/em3.jpeg',
                  //                           height: 170,
                  //                           width: MediaQuery.of(context).size.width,
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox.shrink(),
                  //                     // SizedBox(height: 8.0),
                  //                     SizedBox(height: 10),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Cupcake",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                           children: [
                  //                             Icon(Icons.remove_red_eye_rounded,
                  //                                 color: Colors.grey),
                  //                             SizedBox(width: 3),
                  //                             Text("14.1k"),
                  //                             SizedBox(width: 10),
                  //                             Icon(Icons.favorite,
                  //                                 color: Color(0XFFEE2B4A)),
                  //                             SizedBox(width: 3),
                  //                             Text("259"),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "“Our cream of chicken soup makes a rich and...”",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.w300,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "#cake  #dessert",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Color(0XFF5D6890),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     // SizedBox(
                  //                     //   height: 5,
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       //post1
                  //       Container(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(20),
                  //           child: Wrap(
                  //             children: [
                  //               Padding(
                  //                 padding: EdgeInsets.only(top: 0), //10
                  //                 child: Column(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       child: Container(
                  //                         child: Image.asset(
                  //                           'assets/images/em3.jpeg',
                  //                           height: 170,
                  //                           width: MediaQuery.of(context).size.width,
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox.shrink(),
                  //                     // SizedBox(height: 8.0),
                  //                     SizedBox(height: 10),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Cupcake",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                           children: [
                  //                             Icon(Icons.remove_red_eye_rounded,
                  //                                 color: Colors.grey),
                  //                             SizedBox(width: 3),
                  //                             Text("14.1k"),
                  //                             SizedBox(width: 10),
                  //                             Icon(Icons.favorite,
                  //                                 color: Color(0XFFEE2B4A)),
                  //                             SizedBox(width: 3),
                  //                             Text("259"),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "“Our cream of chicken soup makes a rich and...”",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.w300,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "#cake  #dessert",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Color(0XFF5D6890),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     // SizedBox(
                  //                     //   height: 5,
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       //post1
                  //       Container(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(20),
                  //           child: Wrap(
                  //             children: [
                  //               Padding(
                  //                 padding: EdgeInsets.only(top: 0), //10
                  //                 child: Column(
                  //                   children: [
                  //                     ClipRRect(
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       child: Container(
                  //                         child: Image.asset(
                  //                           'assets/images/em3.jpeg',
                  //                           height: 170,
                  //                           width: MediaQuery.of(context).size.width,
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox.shrink(),
                  //                     // SizedBox(height: 8.0),
                  //                     SizedBox(height: 10),
                  //                     Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         Text(
                  //                           "Cupcake",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                         Row(
                  //                           children: [
                  //                             Icon(Icons.remove_red_eye_rounded,
                  //                                 color: Colors.grey),
                  //                             SizedBox(width: 3),
                  //                             Text("14.1k"),
                  //                             SizedBox(width: 10),
                  //                             Icon(Icons.favorite,
                  //                                 color: Color(0XFFEE2B4A)),
                  //                             SizedBox(width: 3),
                  //                             Text("259"),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "“Our cream of chicken soup makes a rich and...”",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.w300,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(height: 5),
                  //                     Row(
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "#cake  #dessert",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Color(0XFF5D6890),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     // SizedBox(
                  //                     //   height: 5,
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
//post here
                ],
              ),
            ),
          );
        }
        return SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        );
      },
    );
  }
}
