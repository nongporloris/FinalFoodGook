//feeds.dart
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:foodgook/app/components/utils.dart';
// import 'package:foodgook/app/tabs/recipes/recipes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgook/app/components/addpost_item.dart';
import 'package:foodgook/app/tabs/signin/signin.dart';
import 'details/nestedTabBarView.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    Color _notiIconColor = Colors.grey;
    return Scaffold(
      body: ListView(
        //safe area and nested tab
        children: [
          Container(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 21.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Row(
                          //search bar and notifications
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    fillColor: Color(0xfff2f2f2),
                                    filled: true,
                                    hintText: 'Search for people, recipes...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 19.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.search,
                                        size: 24, color: Color(0xffff6240)),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.notifications_none),
                                  color: Colors.grey,
                                  iconSize: 24,
                                  tooltip: 'Show all notifications',
                                  //Still can't change color when clicked
                                  onPressed: () {
                                    print('Pressed');
                                    setState(() {
                                      if (_notiIconColor == Colors.grey) {
                                        _notiIconColor = Color(0xffff6240);
                                      } else {
                                        _notiIconColor = Colors.grey;
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.all(15.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                );
              })
        ],
      ),
    );
  }
}
