import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopst/backend/func.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String userID;
  bool userMail;

  @override
  void initState() {
    super.initState();
    uyeKont();
  }

  Future<void> uyeKont() async {
    var firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      print("ÜYE GİRİŞİ YAPILMIŞ");
      _auth.currentUser().then((user) async {
        String ipAddress = await Func().getIp();
        try {
          _firestore.collection("uyeler").document(user.uid).get().then((user) {
            if (user.data == null) {
              Navigator.pushReplacementNamed(context, "socialreg");
            }
          });
        } catch (hata) {
          Navigator.pushReplacementNamed(context, "socialreg");
        }
        if (user != null) userID = user.uid;
        if (user != null) userMail = user.isEmailVerified;
        if (!userMail) user.sendEmailVerification();
        _firestore.collection("uyeler").document(userID).updateData({
          "userMailVerification": userMail,
          "userLastIp": ipAddress,
          "userLastLogin": DateTime.now()
        });
      });
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "home");
      });
    } else {
      print("ÜYE GİRİŞİ YAPILMAMIŞ");
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "login");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Hero(
                tag: "loginBaslik",
                child: Text(
                  "ShopSt",
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontFamily: "VeganStyle",
                  ),
                ),
              ),
              SizedBox(height: 25),
              SpinKitDoubleBounce(
                color: Colors.white,
                size: 50,
              )
            ],
          ),
        ));
  }
}
