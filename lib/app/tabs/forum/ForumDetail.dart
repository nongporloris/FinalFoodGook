import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgook/app/tabs/forum/addComment.dart';
import 'package:foodgook/app/tabs/profile/profilepageOther.dart';
import 'package:timeago/timeago.dart' as timeago;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ForumDetail extends StatefulWidget {
  String ForumID;

  ForumDetail(this.ForumID);

  @override
  State<StatefulWidget> createState() => _forumDetailState();
}

class _forumDetailState extends State<ForumDetail> {
  Future<Map> getForumDetail() async {
    Map returnForumDetail;
    String usernameTemp;
    String imageTemp;
    DocumentSnapshot _userQuery;
    CollectionReference _user = _firestore.collection('User_Profile');
    CollectionReference _forum = _firestore.collection('Forum');
    DocumentSnapshot _forumDoc = await _forum.doc(widget.ForumID).get();

    returnForumDetail = _forumDoc.data();
    _userQuery = await _user.doc(returnForumDetail['UserUID']).get();
    usernameTemp = _userQuery.data()['Username'];
    imageTemp = _userQuery.data()['ImageURL'];
    returnForumDetail['Username'] = usernameTemp;
    returnForumDetail['ImageURL'] = imageTemp;
    return returnForumDetail;
  }

  Stream<List> getComment() async* {
    List<Map> returnComment = [];
    Map temp;
    String usernameTemp;
    String imageTemp;
    DocumentSnapshot _userQuery;
    CollectionReference _user = _firestore.collection('User_Profile');
    CollectionReference _forumComment = _firestore
        .collection('Forum')
        .doc(widget.ForumID)
        .collection('Comment');
    QuerySnapshot _CommentQuery =
        await _forumComment.orderBy('postTime', descending: true).get();

    for (int i = 0; i < _CommentQuery.docs.length; i++) {
      temp = _CommentQuery.docs[i].data();
      _userQuery = await _user.doc(temp['UserUID']).get();
      usernameTemp = _userQuery.data()['Username'];
      imageTemp = _userQuery.data()['ImageURL'];
      temp['Username'] = usernameTemp;
      temp['ImageURL'] = imageTemp;
      returnComment.add(temp);
    }
    yield returnComment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getForumDetail(),
            builder: (BuildContext context, snapshotDetail) {
              if (snapshotDetail.hasData) {
                return StreamBuilder(
                    stream: getComment(),
                    builder: (BuildContext context, snapshotComment) {
                      if (snapshotComment.hasData) {
                        return Scaffold(
                            body: SafeArea(
                                child: SingleChildScrollView(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                              alignment: Alignment.centerLeft,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              color: Colors.deepOrangeAccent,
                                              iconSize: 30,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 20, 0, 20),
                                              icon: const Icon(
                                                  Icons.arrow_back_ios))),
                                      Expanded(
                                          child: IconButton(
                                              alignment: Alignment.centerRight,
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            addComment(widget
                                                                .ForumID))).then(
                                                    (value) => setState(() {}));
                                              },
                                              color: Colors.deepOrangeAccent,
                                              iconSize: 36,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 20, 0, 20),
                                              icon: const Icon(Icons.add))),
                                    ],
                                  )),
                              Flexible(
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      child: Row(children: [
                                        Icon(Icons.contact_support_outlined,
                                            color: Colors.deepOrangeAccent,
                                            size: 28),
                                        Flexible(
                                            child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          child: Text(
                                            snapshotDetail.data['Topic'],
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              fontFamily: 'Rublik',
                                            ),
                                          ),
                                        ))
                                      ]))),
                              Flexible(
                                  child: Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 15, 40, 40),
                                    child: Text(
                                      snapshotDetail.data['Description'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54,
                                        fontFamily: 'Rublik',
                                      ),
                                    ),
                                  ))
                                ],
                              )),
                              Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 40, 30),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileViewOther(
                                                          snapshotDetail.data[
                                                              'UserUID'])));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xffE6E6E6),
                                          radius: 20,
                                          child: Icon(
                                            Icons.person,
                                            color: Color(0xffCCCCCC),
                                          ),
                                          foregroundImage: NetworkImage(
                                            snapshotDetail.data['ImageURL'],
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileViewOther(
                                                              snapshotDetail
                                                                      .data[
                                                                  'UserUID'])));
                                            },
                                            child: Text(
                                              snapshotDetail.data['Username'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                        SizedBox(height: 2),
                                        Text(
                                          timeago.format(DateTime
                                              .fromMicrosecondsSinceEpoch(
                                                  snapshotDetail
                                                      .data['postTime']
                                                      .microsecondsSinceEpoch)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 500,
                                color: Colors.grey.shade200,
                                child: ListView.builder(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  itemCount: snapshotComment.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.grey.shade300),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileViewOther(
                                                                  snapshotComment
                                                                              .data[
                                                                          index]
                                                                      [
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
                                                        snapshotComment
                                                                .data[index]
                                                            ['ImageURL'],
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProfileViewOther(
                                                                          snapshotComment.data[index]
                                                                              [
                                                                              'UserUID'])));
                                                        },
                                                        child: Text(
                                                          snapshotComment
                                                                  .data[index]
                                                              ['Username'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      timeago.format(DateTime
                                                          .fromMicrosecondsSinceEpoch(
                                                              snapshotComment
                                                                  .data[index][
                                                                      'postTime']
                                                                  .microsecondsSinceEpoch)),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshotComment.data[index]
                                                    ['Description'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black54,
                                                  fontFamily: 'Rublik',
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ]))));
                      }
                      return SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      );
                    });
              }
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              );
            }));
  }
}
