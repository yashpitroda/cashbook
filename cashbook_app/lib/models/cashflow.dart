import 'package:cashbook_app/models/account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Cashflow {
  String? cashflowId;
  String? accountId;
  DateTime? date;
  String? debit;
  String? credit;
  String? balance;
  String? particulars;
  String? useremail;
  Account? accountObj;

  Cashflow({
    required this.cashflowId,
    required this.useremail,
    required this.accountId,
    required this.date,
    required this.balance,
    required this.credit,
    required this.debit,
    required this.particulars,
    required this.accountObj,
  });

  Cashflow.fromJSON({required Map<String, dynamic> jsonData}) {
    //json to obj
    accountId = jsonData["accountId"].toString();
    useremail = jsonData["useremail"].toString();
    cashflowId = jsonData["cashflowId"].toString();
    date = jsonData["date"];
    balance = jsonData["balance"].toString();
    credit = jsonData["credit"].toString();
    debit = jsonData["debit"].toString();
    particulars = jsonData["particulars"].toString();
    accountObj!.accountId = jsonData["accountObj"]["accountId"].toString();
    accountObj!.accountName = jsonData["accountObj"]["accountName"].toString();
    accountObj!.date = jsonData["accountObj"]["date"];
    accountObj!.useremail = jsonData["accountObj"]["useremail"].toString();

  }
  Map<String, dynamic> toJSON() {
    //obj to json
    final Map<String, dynamic> data = {};
    data["accountId"] = this.accountId;
    data["useremail"] = this.useremail;
    data["cashflowId"] = this.cashflowId;
    data["date"] = this.date;
    data["balance"] = this.balance;
    data["credit"] = this.credit;
    data["debit"] = this.debit;
    data["particulars"] = this.particulars;
    data["accountObj"]["accountId"] = this.accountObj!.accountId;
    data["accountObj"]["accountName"] = this.accountObj!.accountName;
    data["accountObj"]["date"] = this.accountObj!.date;
    data["accountObj"]["useremail"] = this.accountObj!.useremail;
    
    return data;
  }
}
