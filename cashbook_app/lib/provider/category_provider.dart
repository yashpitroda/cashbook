import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../services/utility.dart';

class CategoryProvider with ChangeNotifier {
  Category_? _selectedcategoryObj;

  List<Category_> _categoryList = [];
  List<Category_> _storedCategoryList = []; //for backup

  List<Category_> get getCategoryList {
    return [..._categoryList];
  }

  Category_? get getSelectedcategoryObj {
    return _selectedcategoryObj;
  }

  void setSelectedCategoryObj({required Category_? categoryObj}) {
    _selectedcategoryObj = (categoryObj==null)?null:categoryObj;
    notifyListeners();
  }

  // Account findSupplierByPID({required String accountId}) {
  //   return _categoryList.firstWhere((element) {
  //     return element.accountId == accountId;
  //   });
  // }
  Category_ findCategoryByCategoryId({required String categoryId}) {
    return _categoryList.firstWhere((element) {
      return element.categoryId == categoryId;
    });
  }

  Future<void> fetchCategory({required String type}) async {
    print("fetchCategory is call");
    String useremail = Utill.getCurrentUserEMAILID();
    final url = Uri.parse(Utill.BASEURL + "/category/fetchall");
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
    List responseDataList = responseData['datalist'];
    final List<Category_> tempLoadedCategorylist = [];
    final stirngToDateTmeFormatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');

    responseDataList.forEach((element) {
      tempLoadedCategorylist.add(Category_(
          categoryId: element["categoryId"].toString(),
          categoryName: element["categoryName"].toString(), //categoryName
          useremail: element["useremail".toString()],
          date: stirngToDateTmeFormatter.parse(element["date"]),
          type: element["type"].toString()));
    });

    _categoryList = tempLoadedCategorylist;
    _storedCategoryList = _categoryList; //for backup in searching
    print(_categoryList);
    notifyListeners();
  }

  Future<void> addNewCategory({
    required String categorytName,
    required String type,
    required DateTime date,
  }) async {
    try {
      // final url = Uri.parse(Utill.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utill.BASEURL + "/category/addone");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "categoryName": categorytName,
            'type': type, //instant
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
        fetchCategory(type: type);
      }
    } catch (e) {
      print(e);
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
