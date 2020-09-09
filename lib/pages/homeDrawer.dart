import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:shopst/pages/home.dart';

final GlobalKey<InnerDrawerState> _innerDrawerKey =
    GlobalKey<InnerDrawerState>();

class HomeDrawer extends StatefulWidget {
  void innerKeyAc() {
    print("key açıldı");
    _innerDrawerKey.currentState.toggle();
  }

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true, // default false
      swipe: true, // default true
      // colorTransition: Color.red, // default Color.black54

      // DEPRECATED: use offset
      leftOffset: 0.6, // Will be removed in 0.6.0 version
      rightOffset: 0.6, // Will be removed in 0.6.0 version

      //When setting the vertical offset, be sure to use only top or bottom
      offset: IDOffset.only(bottom: 0.0, right: 0.5, left: 0.2),

      // DEPRECATED:  use scale
      leftScale: 0.9, // Will be removed in 0.6.0 version
      rightScale: 0.9, // Will be removed in 0.6.0 version

      scale: IDOffset.horizontal(0.8), // set the offset in both directions

      proportionalChildArea: true, // default true
      borderRadius: 25, // default 0
      leftAnimationType: InnerDrawerAnimation.static, // default static
      rightAnimationType: InnerDrawerAnimation.quadratic,
      backgroundDecoration: BoxDecoration(color: Colors.black),
      innerDrawerCallback: (a) =>
          print(a), // return  true (open) or false (close)
      leftChild: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTileTheme(
                  selectedColor: Colors.white,
                  child: ListTile(
                    //selected: anasayfadami,
                    leading: Icon(Icons.close),
                    title: Text("Çıkış Yap"),
                    onTap: () async {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      scaffold: HomePage(),
    );
  }
}
