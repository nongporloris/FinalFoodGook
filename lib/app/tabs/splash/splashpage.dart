import 'package:flutter/material.dart';
import 'package:foodgook/app/tabs/signin/signin.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'app/tabs/signin/signin.dart';
// import 'app/tabs/signup/signup.dart';

// ignore: must_be_immutable
class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  SplashPage({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    /// Logo with Typer Animated Text example
    ///
    Future.delayed(
      Duration(seconds: 3000),
      () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => this.goToPage));
      },
    );
    Widget splash = SplashScreenView(
      //package: splash_screen_view
      home: FBinit(), //SignInPage
      duration: 3000,
      imageSize: 100,
      imageSrc: "logo.png",
      text: "FoodGook",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
        color: Colors.white,
      ),
      backgroundColor: Color(0xffff6240),
    );

    return Scaffold(
      body: Container(
        child: splash,
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffff6240),
    );
  }
}

class ErrorLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}

class FBinit extends StatelessWidget {
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Init Error');
          return ErrorLoading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print('Init Complete');
          return SigninPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        print('Loading');
        return Loading();
      },
    );
  }
}
