import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopst/backend/func.dart';
import 'package:shopst/models/userModel.dart';
import 'package:shopst/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void showInSnackBar(String value, Color renk) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
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
      ),
    );
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: AlertDialog(
                      backgroundColor: Color(0xFF274B62),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(16.0)),
                      title: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[_buildEmailTF()],
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          //width: double.infinity,
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () async {
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
                              final bool isValid =
                                  EmailValidator.validate(email.text);
                              if (isValid) {
                                try {
                                  await _auth.sendPasswordResetEmail(
                                      email: email.text);
                                  showInSnackBar(
                                      "Mail Gönderme Başarılı", Colors.green);
                                } catch (e) {
                                  showInSnackBar(
                                      "Mail Gönderme Başarısız", Colors.red);
                                }
                              } else {
                                showInSnackBar(
                                    "Doğru Bir Mail Adresi Girmelisiniz!",
                                    Colors.red);
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.white,
                            child: Text(
                              'GÖNDER',
                              style: TextStyle(
                                color: Color(0xFF527DAA),
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierDismissible: true,
              context: context,
              barrierLabel: '',
              pageBuilder: (context, animation1, animation2) {
                return Container();
              });
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Şifremi Unuttum',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Beni Hatırla',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          final bool isValid = EmailValidator.validate(email.text);
          String userID;
          bool userMail;
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
            try {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var firebaseUser = await _auth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              if (firebaseUser != null) {
                showInSnackBar("Giriş Başarılı", Colors.green);
                if (_rememberMe) {
                  print("beni hatırla işaretlendi");
                  prefs.setString("email", email.text);
                } else {
                  prefs.remove("email");
                }
                print(
                    "uid ${firebaseUser.user.uid} mail ${firebaseUser.user.email}");
                _auth.currentUser().then((user) async {
                  String ipAddress = await Func().getIp();
                  setState(() {
                    if (user != null) userID = user.uid;
                    if (user != null) userMail = user.isEmailVerified;
                    if (!userMail) user.sendEmailVerification();
                    _firestore
                        .collection("uyeler")
                        .document(userID)
                        .updateData({
                      "userMailVerification": userMail,
                      "userLastIp": ipAddress,
                      "userLastLogin": DateTime.now()
                    });
                  });
                  User _user = User.fromMap(await _firestore
                      .collection("uyeler")
                      .document(userID)
                      .get()
                      .then((value) => value.data));
                  print(_user.userPhone);
                });
                Navigator.pushReplacementNamed(context, "home");
              }
            } catch (e) {
              Navigator.pop(context);
              showInSnackBar("Giriş Başarısız", Colors.red);
              print(e);
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
          'GİRİŞ YAP',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- VEYA -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Bunları kullan',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {
              String userID;
              bool userMail;
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
              try {
                _googleSignIn.signIn().then((sonuc) {
                  sonuc.authentication.then((googleKeys) {
                    AuthCredential credential =
                        GoogleAuthProvider.getCredential(
                            idToken: googleKeys.idToken,
                            accessToken: googleKeys.accessToken);
                    _auth.signInWithCredential(credential).then((user) {
                      if (user != null) {
                        try {
                          _firestore
                              .collection("uyeler")
                              .document(user.user.uid)
                              .get()
                              .then((user) {
                            if (user.data == null) {
                              Navigator.pushReplacementNamed(
                                  context, "socialreg");
                            } else {
                              _auth.currentUser().then((user) async {
                                String ipAddress = await Func().getIp();
                                setState(() {
                                  if (user != null) userID = user.uid;
                                  if (user != null)
                                    userMail = user.isEmailVerified;
                                  if (!userMail) user.sendEmailVerification();
                                  _firestore
                                      .collection("uyeler")
                                      .document(userID)
                                      .updateData({
                                    "userMailVerification": userMail,
                                    "userLastIp": ipAddress,
                                    "userLastLogin": DateTime.now()
                                  });
                                });
                              });
                              Navigator.pushReplacementNamed(context, "home");
                            }
                          });
                        } catch (hata) {
                          Navigator.pushReplacementNamed(context, "socialreg");
                        }
                      }
                    });
                  });
                }).catchError((error) {
                  Navigator.pop(context);
                  print("hata! 1 : $error");
                });
              } catch (hata) {
                Navigator.pop(context);
                print("hata! : $hata");
              }
            },
            AssetImage(
              'assets/icons/google.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/icons/facebook.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "register"),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Hesabın yok mu? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Kayıt Ol',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> kayitliVeriGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String emaill = prefs.getString("email");
    setState(() {
      print("mail getirildi $emaill");
      email.text = emaill;
      if (emaill != null) {
        _rememberMe = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    kayitliVeriGetir();
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
                vertical: 37.0,
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
                  SizedBox(height: 30.0),
                  _buildEmailTF(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildPasswordTF(),
                  _buildForgotPasswordBtn(),
                  _buildRememberMeCheckbox(),
                  _buildLoginBtn(),
                  _buildSignInWithText(),
                  _buildSocialBtnRow(),
                  _buildSignupBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
