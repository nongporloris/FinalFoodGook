import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
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
                            radius: 50.0,
                            backgroundImage:
                                AssetImage('assets/images/cm0.jpeg'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Phatto33",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   "Phatto33",
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 100,
                                  // ),
                                  Expanded(
                                    child: Center(
                                      child: TextButton(
                                        child: Text('Edit Profile'),
                                        style: TextButton.styleFrom(
                                          primary: Color(0xffff6240),
                                          // backgroundColor: Colors.teal,
                                          // onSurface: Colors.grey,
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                          // side: BorderSide(
                                          //   color: Colors.red,
                                          //   width: 1,
                                          // ),
                                        ),
                                        onPressed: () {
                                          print('Pressed');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0), //change
                              Text(
                                "Passionate cook with more than six years.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
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
                              '62',
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
                              '500',
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
                              '540',
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
                  Tab(text: 'Cookbooks'),
                  Tab(text: 'Forums'),
                ],
              ),
            ),
            //if/else when no content
            Container(
              padding: EdgeInsets.only(top: 180),
              alignment: Alignment.center,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.local_dining,
                    //   color: Colors.grey[400],
                    //   size: 24,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 20, right: 20),
                    //   width: 1,
                    //   height: 50,
                    //   color: Colors.grey[400],
                    // ),
                    Text(
                      'There is no content to display.',
                      style: TextStyle(color: Colors.grey[400]),
                    )
                  ],
                ),
              ),
            ),

            // Expanded(
            //   child: TabBarView(
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
            // ),
//post here
          ],
        ),
      ),
    );
  }
}
