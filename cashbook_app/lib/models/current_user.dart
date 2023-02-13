import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class CurrentUser {
  CurrentUser({
    required this.uid,
    required this.useremail,
    required this.userimageurl,
    required this.username,
    required this.cash_balance,
    required this.bank_balance,
  });
  String uid;
  String username;
  String useremail;
  String userimageurl;
  String cash_balance;
  String bank_balance;
}
