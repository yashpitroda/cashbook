import 'dart:convert';

import 'package:cashbook_app/models/account.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../utill/utility.dart';

class CategoryProvider with ChangeNotifier {
  List<Category_> _categoryList = [];
  List<Category_> _storedCategoryList = []; //for backup

  List<Category_> get getCategoryList {
    return [..._categoryList];
  }

  // Account findSupplierByPID({required String accountId}) {
  //   return _categoryList.firstWhere((element) {
  //     return element.accountId == accountId;
  //   });
  // }

  Future<void> fetchCategory({required String type}) async {
    print("fetchCategory is call");
    String useremail = Utility.getCurrentUserEMAILID();
    final url = Uri.parse(Utility.BASEURL + "/category/fetchall");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'useremail': useremail,
          'type': type,
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    // print(responseData);
    List responseDataList = responseData['datalist']; //[{},{},{}]
    final List<Category_> tempLoadedCategorylist = [];

    // Wed, 28 Dec 2022 13:34:09 GMT //element['entrydatetime'] -- hold this type of formate --this formate coming form flask server
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GMT

    responseDataList.forEach((element) {
      tempLoadedCategorylist.add(Category_(
          categoryId: element["categoryId"],
          categorytName: element["categorytName"],
          useremail: element["useremail"],
          date: stirngToDateTmeFormatter.parse(element["date"]),
          type: element["type"]));
    });
    _categoryList = tempLoadedCategorylist;
    _storedCategoryList = _categoryList; //for backup in searching
    print(_categoryList);
    notifyListeners();
  }

  Future<void> submit_In_add_New_account({
    required String categorytName,
    required String type,
    required DateTime date,
  }) async {
    try {
      // final url = Uri.parse(Utility.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utility.BASEURL + "/account/addone");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "categorytName": categorytName,
            'type': type, //instant
            'useremail': Utility.getCurrentUserEMAILID(),
            'date': date.toString(),
          },
        ),
      );
      if (response.body == 'null') {
        return;
      }
      final responseData = json.decode(response.body);
      final status = responseData["status"];
      if (status == Utility.CHECK_STATUS) {
        // supplierProviderOBJ!.fatchSupplier();
        // fatchPurchase();
      }
    } catch (e) {
      print(e);
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
