import 'dart:convert';

import 'package:cashbook_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../services/utility.dart';

class AccountProvider with ChangeNotifier {
  Account? _selectedAccountObj;
  List<Account> _accountList = [];
  List<Account> _storedAccountList = []; //for backup

  List<Account> get getAccountList {
    return [..._accountList];
  }

  Account? get getSelectedAccountObj {
    return _selectedAccountObj;
  }

  void setSelectedAccountObj({required Account? accountObj}) {
    _selectedAccountObj = (accountObj == null) ? null : accountObj;
    notifyListeners();
  }

  Account findAccountByAccountId({required String accountId}) {
    return _accountList.firstWhere((element) {
      return element.accountId == accountId;
    });
  }

  Future<void> fetchAccount() async {
    print("fetchAccount is call");
    String useremail = Utill.getCurrentUserEMAILID();
    final url = Uri.parse(Utill.BASEURL + "/account/fetchall");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'useremail': useremail,
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    // print(responseData);
    List responseSupplierDataList = responseData['datalist']; //[{},{},{}]
    final List<Account> tempLoadedSupplierlist = [];

    // Wed, 28 Dec 2022 13:34:09 GMT //element['entrydatetime'] -- hold this type of formate --this formate coming form flask server
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GMT

    responseSupplierDataList.forEach((element) {
      tempLoadedSupplierlist.add(Account(
        accountId: element['accountId'].toString(),
        accountName: element["accountName"], //if it will null or string
        balance: element['balance'].toString(),
        date: stirngToDateTmeFormatter.parse(element["date"]),
        useremail: element['useremail'].toString(),
      ));
    });
    _accountList = tempLoadedSupplierlist;
    _storedAccountList = _accountList; //for backup in searching
    print(_accountList);
    notifyListeners();
  }

  Future<void> submit_In_add_New_account({
    required String accountName,
    required String initialAmount,
    required DateTime date,
  }) async {
    try {
      // final url = Uri.parse(Utill.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utill.BASEURL + "/account/addone");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "accountName": accountName,
            'initialAmount': initialAmount, //instant
            'useremail': Utill.getCurrentUserEMAILID(),
            'date': date.toString(),
          },
        ),
      );
      if (response.body == 'null') {
        return;
      }
      final responseData = json.decode(response.body);
      final status = responseData["status"];
      if (status == Utill.CHECK_STATUS) {
        // supplierProviderOBJ!.fatchSupplier();
        await fetchAccount();
      }
    } catch (e) {
      print(e);
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
