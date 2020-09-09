import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class User {
  User({
    @required this.userLastIp,
    @required this.userCreateTime,
    @required this.userPhone,
    @required this.userMail,
    @required this.userFirstIp,
    @required this.userLastLogin,
    @required this.userMailVerification,
    @required this.userName,
    @required this.userId,
  });

  String userLastIp;
  Timestamp userCreateTime;
  String userPhone;
  String userMail;
  String userFirstIp;
  Timestamp userLastLogin;
  bool userMailVerification;
  String userName;
  String userId;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        userLastIp: json["userLastIp"] == null ? null : json["userLastIp"],
        userCreateTime:
            json["userCreateTime"] == null ? null : json["userCreateTime"],
        userPhone: json["userPhone"] == null ? null : json["userPhone"],
        userMail: json["userMail"] == null ? null : json["userMail"],
        userFirstIp: json["userFirstIp"] == null ? null : json["userFirstIp"],
        userLastLogin:
            json["userLastLogin"] == null ? null : json["userLastLogin"],
        userMailVerification: json["userMailVerification"] == null
            ? null
            : json["userMailVerification"],
        userName: json["userName"] == null ? null : json["userName"],
        userId: json["userID"] == null ? null : json["userID"],
      );

  Map<String, dynamic> toMap() => {
        "userLastIp": userLastIp == null ? null : userLastIp,
        "userCreateTime": userCreateTime == null ? null : userCreateTime,
        "userPhone": userPhone == null ? null : userPhone,
        "userMail": userMail == null ? null : userMail,
        "userFirstIp": userFirstIp == null ? null : userFirstIp,
        "userLastLogin": userLastLogin == null ? null : userLastLogin,
        "userMailVerification":
            userMailVerification == null ? null : userMailVerification,
        "userName": userName == null ? null : userName,
        "userID": userId == null ? null : userId,
      };
}
