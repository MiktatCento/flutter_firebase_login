import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopst/pages/homeDrawer.dart';

/*
StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("uyeler")
                .document(userID)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else if (!snapshot.hasData)
                return CircularProgressIndicator();
              else if (snapshot.data == null)
                return Text("Veri bulunamadı!");
              else {
                return Text(snapshot.data["userName"]);
              }
            },
          ),
*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String userID;
  bool userMail;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((user) async {
      setState(() {
        if (user != null) userID = user.uid;
        if (user != null) userMail = user.isEmailVerified;
      });
    });
  }

  GlobalKey<ScaffoldState> key = GlobalKey();
  bool expanded = true;
  AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ShopSt"),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              HomeDrawer().innerKeyAc();
            }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.all_inclusive), onPressed: () {}),
        ],
      ),

      //{userLastIp: 88.224.163.208, userCreateTime: Timestamp(seconds=1596450777, nanoseconds=14000000), userPhone: 5456052210, userMail: cento277@gmail.com, userFirstIp: 88.252.250.148, userLastLogin: Timestamp(seconds=1596735987, nanoseconds=881000000), userMailVerification: true, userName: Mustafa Cento, userID: 7iqsID5dYgPBUqTkmknHPADC5gx2}
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Giriş yapan kullanıcı id: $userID\nÜye Mail doğrulamış mı: $userMail",
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              "VERİLERİ GETİR",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print(
                jsonDecode(await Firestore.instance
                    .collection("uyeler")
                    .document(userID)
                    .get()
                    .then((value) => value.data.toString())),
              );
            },
          ),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              "ÇIKIŞ YAP",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
        ],
      )),
    );
  }
}
