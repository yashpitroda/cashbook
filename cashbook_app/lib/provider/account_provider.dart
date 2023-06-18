import 'dart:convert';

import 'package:cashbook_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse("${Utill.BASEURL}/account/fetchall");

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
      return;
    }
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      final List<dynamic> responseDataList =
          responseData['datalist']; //[{},{},{}]
      final List<Account> tempLoadedAccountlist = [];

      for (Map<String, dynamic> element in responseDataList) {
        tempLoadedAccountlist.add(Account.fromJson(element));
      }
      _accountList = tempLoadedAccountlist;
      _storedAccountList = _accountList; //for backup in searching
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> submit_In_add_New_account({
    required String accountName,
    required String initialAmount,
    required DateTime date,
  }) async {
    try {
      // final url = Uri.parse(Utill.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utill.BASEURL + "/account/addone");

      ///account/addone
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
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
