import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CurrentUser {
  String? uid;
  String? username;
  String? useremail;
  String? userimageurl;
  String? cash_balance;
  String? bank_balance;
  CurrentUser({
    required this.uid,
    required this.useremail,
    required this.userimageurl,
    required this.username,
    required this.cash_balance,
    required this.bank_balance,
  });

  CurrentUser.fromJSON({required Map<String, dynamic> jsonData}) {
    //json to obj
    uid = jsonData["uid"].toString();
    useremail = jsonData["useremail"].toString();
    username = jsonData["username"].toString();
    cash_balance = jsonData["cash_balance"].toString();
    bank_balance = jsonData["bank_balance"].toString();
    userimageurl = jsonData["userimageurl"].toString();
  }
  Map<String, dynamic> toJSON() {
    //obj to json
    final Map<String, dynamic> data = {};
    data["uid"] = this.uid;
    data["useremail"] = this.useremail;
    data["username"] = this.username;
    data["cash_balance"] = this.cash_balance;
    data["bank_balance"] = this.bank_balance;
    data["userimageurl"] = this.userimageurl;
    return data;
  }
}
