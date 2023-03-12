import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int _TimeValue = 10;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;


String printTimer(CurrentRemainingTime time) {
  int min = time.min;
  int sec = time.sec;
  String secStr = sec.toString();

  if(min == null)
    min = 0;

  if(sec < 10)
    secStr = '0' + sec.toString();

  return '${min}:' + secStr;

}


class StepbyStep extends StatefulWidget {
  List direction;
  List ingredients;
  String name;
  String docID;

  StepbyStep(this.direction, this.ingredients, this.name, this.docID);

  @override
  _StepbyStepState createState() => _StepbyStepState();
}

class _StepbyStepState extends State<StepbyStep> {
  String firstToUpper(String text) {
    String returntext = text.substring(0, 1).toUpperCase() + text.substring(1);
    return returntext;
  }

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isTimerCount = false;
  double rating = 0;
  double submitRating = 0;

  Future<String> submitRatingPress(double ratingValue) async{
    double recipeRating;
    double ratingCount;
    double oldRating;
    double newRecipeRating;
    DocumentReference DocRef = _firestore.collection('Recipes').doc(widget.docID).collection('Rating').doc(_auth.currentUser.uid);
    DocumentReference RecipeRef = _firestore.collection('Recipes').doc(widget.docID);
    DocumentSnapshot doc = await DocRef.get();

    if(doc.exists)
    {
      oldRating = doc.data()['Rating'].toDouble();
      _firestore.runTransaction((transaction) async{
        DocumentSnapshot docSnap = await transaction.get(RecipeRef);
        recipeRating = docSnap.data()['Rating'].toDouble();
        ratingCount = docSnap.data()['RatingCount'].toDouble();

        newRecipeRating = ((recipeRating*ratingCount)-oldRating+ratingValue)/ratingCount;
        newRecipeRating = double.parse(newRecipeRating.toStringAsFixed(2));
        DocRef.update({
          'Rating': ratingValue
        });
        transaction.update(RecipeRef, {
          'Rating': newRecipeRating
        });
      });
      return 'Succes';
    }
    else if(!doc.exists)
    {
      _firestore.runTransaction((transaction) async{
        DocumentSnapshot docSnap = await transaction.get(RecipeRef);
        recipeRating = docSnap.data()['Rating'].toDouble();
        ratingCount = docSnap.data()['RatingCount'].toDouble();

        newRecipeRating = ((recipeRating*ratingCount)+ratingValue)/(ratingCount+1);
        newRecipeRating = double.parse(newRecipeRating.toStringAsFixed(2));
        DocRef.set({
          'Rating': ratingValue
        });
        transaction.update(RecipeRef, {
          'Rating': newRecipeRating,
          'RatingCount': ratingCount+1
        });
      });
      return 'Succes';
    }
  }

  Future<void> _showIntegerDialog() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              content: NumberPicker(
                value: _TimeValue,
                minValue: 1,
                maxValue: 60,
                step: 1,
                onChanged: (value) {
                  setState(() => _TimeValue = value);
                  setState2(() => _TimeValue = value);
                },
              ),
            );
          });
        });
  }

  Future<void> _reviewDialog() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new StatefulBuilder(builder: (context, setState2) {
            return Dialog(
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 150,
              child: Column(
                children : [
                  Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text('Rating this recipe?', style: TextStyle(fontSize: 20),)),
                SmoothStarRating(
                  allowHalfRating: true,
                  onRated: (v) {
                      print(v);
                      submitRating = v;
                  },
                  starCount: 5,
                  rating: rating,
                  size: 40.0,
                  isReadOnly:false,
                  filledIconData: Icons.star_rate_rounded,
                  halfFilledIconData: Icons.star_half_rounded,
                  defaultIconData: Icons.star_border_rounded,
                  color: Colors.yellow.shade700,
                  borderColor: Colors.yellow.shade700,
                  spacing:2.0
              ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }, child: Text('No')),
                      TextButton(onPressed: (){
                        _finishReview(submitRating);
                      }, child: Text('Submit'))
                    ],
                  )
              ])
            ));
          });
        });
  }

  Future<void> _finishReview(double sumbitRatingF) async{
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
            return Dialog(
                child:  FutureBuilder(future: submitRatingPress(sumbitRatingF),
          builder: (context, snapshot) {
                  if(snapshot.hasData && snapshot.data == 'Succes')
                    return TextButton(onPressed: ()
                        {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, child: Text('OK'));
                  return SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  );
          }));
        });
  }

  Widget countDownTimer() {
    if (isTimerCount == false) {
      return Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    _showIntegerDialog();
                  },
                  child: Container(
                      color: Color(0xFFF0F0F0),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      margin: const EdgeInsets.only(left: 15),
                      child: Text(
                        _TimeValue.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 24,
                        ),
                      ))),
              SizedBox(
                width: 20,
              ),
              Text(
                "Minute",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              TextButton(
                  onPressed: () {
                    timerStart();
                  },
                  child: Text('Start'))
            ],
          ));
    } else
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
          child: CountdownTimer(
            endTime: endTime,
            widgetBuilder: (_, CurrentRemainingTime time) {
              if (time == null) {
                return Column(children: [
                  Text('0:00',
                    style: TextStyle(fontSize: 48),),
                  TextButton(
                      onPressed: () {
                        timerReset();
                      },
                      child: Text('Reset'))
                ]);
              }
              return Column(children: [
                Text(printTimer(time),
                style: TextStyle(fontSize: 48),),
              TextButton(
              onPressed: () {
              timerReset();
              },
              child: Text('Reset'))
              ]);
            },
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.name),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Color(0xffff6240),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
             child:
              Text('Countdown Timer',
                  style: TextStyle(fontSize: 16),
              ),
            ),
            countDownTimer(),
            Expanded(
              child: Theme(
                data: ThemeData(
                  accentColor: Color(0xffff6240),
                    colorScheme: ColorScheme.light(
                        primary: Color(0xffff6240)
                    )
                ),
                    child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: Text('Prepare Ingredients'),
                    content: Column(
                      children: <Widget>[
                        for (int i = 0; i < widget.ingredients.length; i++)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(children: <Widget>[
                                Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Text(
                                        firstToUpper(
                                            widget.ingredients[i].toString()),
                                        style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))),
                              ])),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  for (int i = 0; i < widget.direction.length; i++)
                    Step(
                      title: Text(widget.direction[i]),
                      content: Column(
                        children: <Widget>[],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                ],
              ),
              )
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < widget.direction.length) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _reviewDialog();
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.pop(context);
    }
  }

  timerStart() {
    isTimerCount = true;
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * _TimeValue;
    setState(() {});
  }

  timerReset() {
    isTimerCount = false;
    setState(() {});
  }
}
