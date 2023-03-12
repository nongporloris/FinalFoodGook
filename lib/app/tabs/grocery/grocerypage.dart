//card with contents
library circular_check_box;

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodgook/app/models/grocerybook_model.dart';
import 'package:flutter/widgets.dart';
import 'package:foodgook/app/tabs/recipes/detail/meal_detail_screen.dart';


// import 'package:foodgook/app/models/grocery_model.dart';

FirebaseAuth _auth = FirebaseAuth.instance;


class IngGrocery {
  bool isCheck = false;
  String ingredient;


  IngGrocery(
    this.ingredient,
      );
}

class _grocery{
  DocumentSnapshot doc;
  List<IngGrocery> grocery =[];
  bool expanded = false;

  _grocery(
      this.doc,
      );

  void addIng(IngGrocery ing){
    grocery.add(ing);
  }

}

String firstToUpper(String text) {
  String returntext = text.substring(0, 1).toUpperCase() + text.substring(1);
  return returntext;
}

Future<List> queryGrocery() async {
  List _GroceryReturn = [];
  List<DocumentSnapshot> RecRecipe = [];
  List<IngGrocery> IngRecipe = [];
  List<_grocery> returnList = [];
  DocumentSnapshot temp;
  bool ready = false;
  DocumentReference userGrocery = FirebaseFirestore.instance.collection(
      'User_Profile').doc(_auth.currentUser.uid)
      .collection('Relation_Detail')
      .doc('Grocery');
  DocumentSnapshot _QueryResult = await userGrocery.get();
  _GroceryReturn = _QueryResult.data()['RecipeID'];

  for (int i = 0; i < _GroceryReturn.length; i++) {
    temp = await FirebaseFirestore.instance.collection('Recipes').doc(
        _GroceryReturn[i]).get();
    RecRecipe.add(temp);
  }

  for(int i = 0; i < RecRecipe.length; i++){
    returnList.add(_grocery(RecRecipe[i]));
    for(int j = 0; j< RecRecipe[i].data()['Ingredient'].length; j++)
      {
        returnList[i].addIng(IngGrocery(RecRecipe[i].data()['Ingredient'][j]));
      }
  }
  return returnList;
}

class GroceryPage extends StatefulWidget {
  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  bool isChecked = false;
  Future<List> _groceryReturn;

  void initState(){
    _groceryReturn = queryGrocery();
  }




  Map<String, bool> numbers = {
    'One': false,
    'Two': false,
    'Three': false,
  };

  var holder_1 = [];

  getItems() {
    numbers.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(holder_1);

    // Clear array after use.
    holder_1.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

        future: _groceryReturn,
        builder: (BuildContext context , snapshot) {
          if(snapshot.hasData) {
           return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    //Topic: Grocery
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Grocery',
                            style: TextStyle(
                              // fontFamily: GoogleFonts.openSans ,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontFamily: 'Rublik',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(
                        top: 25,
                        right: 25,
                        left: 25,
                      ),
                      //between Grocery and listview

                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      // itemCount: populars.length,
                      itemCount: snapshot.data.length,

                      itemBuilder: (context, index) {
                        return ExpansionPanelList(
                          animationDuration: Duration(milliseconds: 1000),
                          dividerColor: Colors.yellow,
                          elevation: 1,
                          //shadow
                          children: [
                            ExpansionPanel(
                              body: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Column(
                                  children:
                                    List.generate(snapshot.data[index].grocery.length, (i)
                                    {
                                      return CheckboxListTile(
                                        activeColor: Color(0xffff6240),
                                        title: Text(firstToUpper(snapshot.data[index].grocery[i].ingredient)),
                                        value: snapshot.data[index].grocery[i].isCheck,
                                        onChanged: (bool value) {
                                          setState(() {
                                            snapshot.data[index].grocery[i].isCheck = value;
                                          });
                                        },
                                      );
                                    })
                                    //   Text(
                                    //     'XD',
                                    //     style: TextStyle(fontSize: 16),
                                    //   )
                                ),
                              ),
                              headerBuilder: (BuildContext context,
                                  bool isExpanded) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => MealDetailScreen(snapshot.data[index].doc.id)));
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              //photo
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        snapshot.data[index].doc.data()['ImageURL']),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  color: Colors.deepOrangeAccent),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8.0, bottom: 4.0),
                                                  child:
                                                  Row(
                                                    children: [
                                                      Container(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width - 280,
                                                          child: Text(snapshot.data[index].doc.data()['Recipe_Name']
                                                            ,overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight
                                                                  .w700,
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding: EdgeInsets.only(
                                                //       top: 0.0, bottom: 4.0),
                                                //   child: Row(
                                                //     children: [
                                                //       Text(
                                                //         populars[index].price,
                                                //         overflow: TextOverflow.ellipsis,
                                                //         style: TextStyle(
                                                //           fontSize: 14,
                                                //           // fontWeight: FontWeight.w700,
                                                //           color: Color(0xffff6240),
                                                //         ),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (context) => MealDetailScreen(snapshot.data[index].doc.id)));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.0, bottom: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'See this recipe',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight
                                                                .w700,
                                                            color: Color(
                                                                0xffff6240),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              isExpanded: snapshot.data[index].expanded,
                            ),
                          ],
                          expansionCallback: (int item, bool status) {
                            setState(
                                  () {
                                    snapshot.data[index].expanded =
                                !snapshot.data[index].expanded;
                              },
                            );
                          },
                        );
                      },
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
        }
    );
  }
}