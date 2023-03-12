import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:foodgook/app/tabs/feeds/feedspage.dart';
import 'package:foodgook/app/tabs/forum/forumpage.dart';
import 'package:foodgook/app/tabs/grocery/grocerypage.dart';
import 'package:foodgook/app/tabs/profile/profilepage.dart';
import 'package:foodgook/app/tabs/recipes/recipespage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/components/addpost_item.dart';
import 'app/tabs/signin/signin.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),

        //list bottom nav
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt,
            ),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.forum,
            ),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_grocery_store,
            ),
            label: 'Grocery',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xffff6240),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
      //FAB
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   backgroundColor: Color(0xffff6240),
      //   foregroundColor: Colors.white,
      //   // child: Icon(Icons.ac_unit),
      //   //change to foodgook
      //   child:
      //       SvgPicture.asset('assets/svg/fabButton.svg'), //change to foodgook

      //   overlayColor: Colors.grey,
      //   overlayOpacity: 0.4,
      //   curve: Curves.easeIn,
      //   onOpen: () => print('Opening'),
      //   onClose: () => print('Closing'),
      //   children: [
      //     SpeedDialChild(
      //       child: Icon(Icons.add),
      //       label: 'Add recipe',
      //       backgroundColor: Colors.white,
      //       foregroundColor: Color(0xffff6240),
      //       // onTap: () => print('First'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>
      //                   AddRecipeScreen()), //addpost_item.dart
      //         );
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: Icon(Icons.live_tv_rounded),
      //       label: 'Live show',
      //       backgroundColor: Colors.white,
      //       foregroundColor: Color(0xffff6240),
      //       onTap: () => print('Second'),
      //     ),
      //     SpeedDialChild(
      //         child: Icon(Icons.logout),
      //         label: 'Log out',
      //         backgroundColor: Colors.white,
      //         foregroundColor: Color(0xffff6240),
      //         onTap: () {
      //           print('Third');
      //           _auth.signOut();
      //           // Navigator.pop(context);
      //           // Utils.mainAppNav.currentState.pushNamed('/signinpage');
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => SigninPage()),
      //           );
      //         })
      //   ],
      // ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0: //feeds
        return FeedsPage(); //FeedsPage() error
      case 1: //recipes
        return RecipesView();
      case 2: //forum
        return ForumPage();
      case 3: //grocery
        return GroceryPage();
      case 4: //profile
        return ProfileView(_auth.currentUser.uid);
    }

    return Center(
      child: Text("There is no page builder for this index."),
    );
  }

  // @override
  // Widget build(BuildContext context) {}
}
