import 'package:flutter/material.dart';
import 'package:shopst/pages/homeDrawer.dart';
import 'package:shopst/pages/login.dart';
import 'package:shopst/pages/register.dart';
import 'package:shopst/pages/socialreg.dart';
import 'package:shopst/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF274B62)),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "home": (context) => HomeDrawer(),
        "login": (context) => LoginPage(),
        "register": (context) => RegisterPage(),
        "socialreg": (context) => SocialRegPage()
      },
    );
  }
}
