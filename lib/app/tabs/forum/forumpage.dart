import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgook/app/tabs/forum/ForumDetail.dart';
import 'package:foodgook/app/tabs/forum/addForum.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:get/get.dart';
import 'DataControllerForum.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List> getForum() async {
  List<Map> returnForum = [];
  Map temp;
  String usernameTemp;
  DocumentSnapshot _userQuery;
  CollectionReference _user = _firestore.collection('User_Profile');
  CollectionReference _forum = _firestore.collection('Forum');
  QuerySnapshot _forumQuery =
      await _forum.orderBy('postTime', descending: true).limit(10).get();

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

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

  TabController _tabController;
  bool switchValue = true;
  @override
  void initState() {
    this._tabController = TabController(
      length: 3,
      initialIndex: 0,
      vsync: this,
    );
    super.initState();
  }

  Widget searchedData() {
    return ListView.builder(
      itemCount: snapshotData.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              print('XDGo');
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => MealDetailScreen(queryData[index].id)));
            },
            child: ListTile(
              leading: Icon(Icons.contact_support_outlined,
                  color: Colors.deepOrangeAccent, size: 20),
              title: Text(
                snapshotData.docs[index].data()['Topic'],
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            GetBuilder<DataControllerForum>(
              init: DataControllerForum(),
              builder: (val) {
                return IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black54,
                    onPressed: () {
                      val.queryDataForum(searchController.text).then((value) {
                        snapshotData = value;
                        setState(() {
                          isExecuted = true;
                        });
                      });
                    });
              },
            )
          ],
          title: TextField(
            style: TextStyle(color: Colors.black54),
            decoration: InputDecoration(
              hintText: 'Search Topic',
              hintStyle: TextStyle(color: Colors.black54),
            ),
            controller: searchController,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: isExecuted
            ? searchedData()
            : FutureBuilder(
                future: getForum(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      body: SafeArea(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            //profile
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 25, right: 10, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Forum',
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
                                        icon: Icon(Icons.add),
                                        color: Colors.grey,
                                        iconSize: 24,
                                        tooltip: 'Add new post',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddForum()));
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
                            // Container(
                            //   // height: 40, //height of textfield
                            //   margin:
                            //       EdgeInsets.only(left: 20, right: 20, top: 20),
                            //   // decoration: BoxDecoration(
                            //   //     borderRadius: BorderRadius.circular(10), color: Colors.grey),
                            //   child: Stack(
                            //     children: <Widget>[
                            //       TextField(
                            //         decoration: InputDecoration(
                            //           contentPadding:
                            //               const EdgeInsets.symmetric(
                            //                   vertical: 10.0, horizontal: 10.0),
                            //           fillColor: Color(0xfff2f2f2),
                            //           filled: true,
                            //           hintText: 'Search for topic, tags...',
                            //           hintStyle: TextStyle(
                            //             color: Colors.grey,
                            //             // fontSize: 19.0,
                            //           ),
                            //           border: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(24.0),
                            //             borderSide: BorderSide.none,
                            //           ),
                            //           prefixIcon: Icon(
                            //             Icons.search,
                            //             size: 24,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            //Recent post
                            Container(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Wrap(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Recent post",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          snapshot.data.length,
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
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForumDetail(snapshot.data[index]['DocID'])));
                                                                            },
                                                                            child: Text(
                                                                              snapshot.data[index]['Topic'],
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
                                                                    timeago.format(DateTime.fromMicrosecondsSinceEpoch(snapshot
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
                                                                            "by ${snapshot.data[index]['Username']}",
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
                                                                            "${snapshot.data[index]['Comment']} anwsers",
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
                                                      }))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                }));
  }
}
