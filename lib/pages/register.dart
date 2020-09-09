import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopst/backend/func.dart';
import 'package:shopst/utilities/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();

  void showInSnackBar(String value, Color renk) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: renk,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'E-mail',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Color(0xFF274B62),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFF274B62),
              ),
              hintText: 'E-mail adresini yaz',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'İsim & Soyisim',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: name,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Color(0xFF274B62),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Color(0xFF274B62),
              ),
              hintText: 'İsmini ve soyismini yaz',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Telefon numarası',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF274B62),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.local_phone,
                color: Color(0xFF274B62),
              ),
              hintText: 'Telefon numaranı yaz',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Şifre',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: password,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFF274B62),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF274B62),
              ),
              hintText: 'Şifreni yaz',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildrePasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Şifre Tekrarı',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: repassword,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFF274B62),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF274B62),
              ),
              hintText: 'Şifreni tekrar yaz',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          final bool isValid = EmailValidator.validate(email.text);
          FocusScope.of(context).unfocus();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return SimpleDialog(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              });
          if (isValid) {
            if (password.text == repassword.text) {
              if (password.text.length >= 6) {
                if (name.text.isNotEmpty) {
                  if (phone.text.isNotEmpty) {
                    try {
                      String ipAddress = await Func().getIp();
                      await _auth
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password.text)
                          .then((user) {
                        _firestore
                            .collection("uyeler")
                            .document(user.user.uid)
                            .setData({
                          "userID": user.user.uid,
                          "userMail": email.text,
                          "userName": name.text,
                          "userPhone": phone.text,
                          "userFirstIp": ipAddress,
                          "userCreateTime": DateTime.now()
                        });
                        Navigator.pop(context);
                        if (!user.user.isEmailVerified)
                          user.user.sendEmailVerification();
                        showInSnackBar("Kayıt Başarılı", Colors.green);
                        Timer(Duration(seconds: 1), () {
                          Navigator.pushReplacementNamed(context, "home");
                        });
                      });
                    } catch (e) {
                      Navigator.pop(context);
                      showInSnackBar("Kayıt Başarısız", Colors.red);
                      print(e);
                    }
                  } else {
                    Navigator.pop(context);
                    showInSnackBar("Telefon numarası zorunludur!", Colors.red);
                  }
                } else {
                  Navigator.pop(context);
                  showInSnackBar("İsim zorunludur!", Colors.red);
                }
              } else {
                Navigator.pop(context);
                showInSnackBar("Şifre en az 6 haneli olmalı!", Colors.red);
              }
            } else {
              Navigator.pop(context);
              showInSnackBar("Şifreler uyuşmuyor!", Colors.red);
            }
          } else {
            Navigator.pop(context);
            showInSnackBar("Doğru Bir Mail Adresi Girmelisiniz!", Colors.red);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'KAYIT OL',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF274B62),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 45.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "loginBaslik",
                    child: Text(
                      "ShopSt",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontFamily: "VeganStyle",
                      ),
                    ),
                  ),
                  SizedBox(height: 0.0),
                  _buildEmailTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildNameTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPhoneTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildPasswordTF(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildrePasswordTF(),
                  _buildRegBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
