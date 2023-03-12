//feeds.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:foodgook/app/components/utils.dart';
// import 'package:foodgook/app/tabs/recipes/recipes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgook/app/components/addpostMain.dart';
import 'package:foodgook/app/components/addpost_item.dart';
import 'package:foodgook/app/tabs/profile/profilepageOther.dart';
import 'DataControllerFeed.dart';
import 'package:foodgook/app/tabs/signin/signin.dart';
import 'details/nestedTabBarView.dart';
import 'package:get/get.dart';
import 'DataControllerFeed.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;

  Widget searchedData() {
    return ListView.builder(
      itemCount: snapshotData.docs.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => MealDetailScreen(queryData[index].id)));
            },
            child: ListTile(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProfileViewOther(snapshotData.docs[index].id)));
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    child: Icon(
                      Icons.person,
                      color: Color(0xffCCCCCC),
                    ),
                    foregroundImage: NetworkImage(
                      snapshotData.docs[index]["ImageURL"],
                    ),
                  )),
              title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ProfileViewOther(snapshotData.docs[index].id)));
                },
                child: Text(snapshotData.docs[index].data()['Username'],
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    Color _notiIconColor = Colors.grey;
    return Scaffold(
      appBar: AppBar(
        actions: [
          GetBuilder<DataControllerFeed>(
            init: DataControllerFeed(),
            builder: (val) {
              return IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black54,
                  onPressed: () {
                    val.queryDataFeed(searchController.text).then((value) {
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
            hintText: 'Search People',
            hintStyle: TextStyle(color: Colors.black54),
          ),
          controller: searchController,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: isExecuted
          ? searchedData()
          : ListView(
              //safe area and nested tab
              children: [
                Container(
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      // padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          //All feeds
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // Row(
                            //   //search bar and notifications
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: Container(
                            //         // height: 40,
                            //
                            //         child: TextField(
                            //           keyboardType: TextInputType.text,
                            //           autocorrect: true,
                            //           decoration: InputDecoration(
                            //             contentPadding: const EdgeInsets.symmetric(
                            //                 vertical: 10.0, horizontal: 10.0),
                            //             fillColor: Color(0xfff2f2f2),
                            //             filled: true,
                            //             hintText: 'Search for people, recipes...',
                            //             hintStyle: TextStyle(
                            //               color: Colors.grey,
                            //               // fontSize: 19.0,
                            //             ),
                            //             border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(24.0),
                            //               borderSide: BorderSide.none,
                            //             ),
                            //             prefixIcon: Icon(
                            //               Icons.search,
                            //               size: 24,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Row(
                            //       children: [
                            //         IconButton(
                            //           icon: Icon(Icons.notifications_none),
                            //           color: Colors.grey,
                            //           iconSize: 24,
                            //           tooltip: 'Show all notifications',
                            //           //Still can't change color when clicked
                            //           onPressed: () {
                            //             print('Pressed');
                            //             setState(() {
                            //               if (_notiIconColor == Colors.grey) {
                            //                 _notiIconColor = Color(0xffff6240);
                            //               } else {
                            //                 _notiIconColor = Colors.grey;
                            //               }
                            //             });
                            //           },
                            //           padding: const EdgeInsets.all(15.0),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                NestedTabBar(), //feeds and live show
              ],
            ),
      //FAB
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Color(0xffff6240),
        foregroundColor: Colors.white,
        // child: Icon(Icons.ac_unit),
        //change to foodgook
        child:
            SvgPicture.asset('assets/svg/fabButton.svg'), //change to foodgook

        overlayColor: Colors.grey,
        overlayOpacity: 0.4,
        curve: Curves.easeIn,
        onOpen: () => print('Opening'),
        onClose: () => print('Closing'),
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add recipe',
            backgroundColor: Colors.white,
            foregroundColor: Color(0xffff6240),
            // onTap: () => print('First'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddRecipeScreen()), //addpost_item.dart
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.live_tv_rounded),
            label: 'Live show',
            backgroundColor: Colors.white,
            foregroundColor: Color(0xffff6240),
            onTap: () => print('Second'),
          ),
          SpeedDialChild(
              child: Icon(Icons.logout),
              label: 'Log out',
              backgroundColor: Colors.white,
              foregroundColor: Color(0xffff6240),
              onTap: () {
                print('Third');
                _auth.signOut();
                // Navigator.pop(context);
                // Utils.mainAppNav.currentState.pushNamed('/signinpage');
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
