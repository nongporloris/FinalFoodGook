import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'app/tabs/feeds/feedspage.dart';
import 'app/tabs/signin/signin.dart';
import 'app/tabs/signup/signup.dart';
import 'app/tabs/splash/splashpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'FoodGook',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(duration: 3, goToPage: SigninPage()),
        '/signinpage': (context) => SigninPage(),
        '/signuppage': (context) => SignupPage(),
        '/feedspage': (context) => FeedsPage(),
        // '/selectedcategorypage': (context) => SelectedCategoryPage(),
        // '/detailspage': (context) => DetailsPage(),
        // '/mappage': (context) => MapPage(),
        // '/onboardingpage': (context) => OnboardingPage(),
      },
    ),
  );
}
