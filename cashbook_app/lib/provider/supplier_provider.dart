
import 'package:cashbook_app/services/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/supplier.dart';

class SupplierProvider with ChangeNotifier {
  String totalAdvance = "0";
  String totalDue = "0";

  List<Supplier> _supplierList = [];
  List<Supplier> _storedSupplierList = [];

  // getter
  List<Supplier> get supplierList {
    return [..._supplierList];
  }

  String get getTotalAdvance {
    return totalAdvance;
  }

  String get getTotalDue {
    return totalDue;
  }

  Supplier findSupplierBySID({required String sid}) {
    return _supplierList.firstWhere((element) {
      return int.parse(element.sid) == int.parse(sid);
    });
  }

  Supplier findSupplierBymobileno({required String smobileno}) {
    return _supplierList.firstWhere((element) {
      return element.smobileno == smobileno;
    });
  }

  void updateDueAndAdvance() {
    totalAdvance = "0";
    totalDue = "0";
    for (var i = 0; i < _supplierList.length; i++) {
      totalAdvance = (int.parse(totalAdvance) +
              int.parse(_supplierList[i].advance_amount_with_bill) +
              int.parse(_supplierList[i].advance_amount_without_bill))
          .toString();
      totalDue = (int.parse(totalDue) +
              int.parse(_supplierList[i].outstanding_amount_withbill) +
              int.parse(_supplierList[i].outstanding_amount_without_bill))
          .toString();
    }
    notifyListeners();
  }

  void filterSearchResults({required String query}) {
    if (query.isNotEmpty) {
      List<Supplier> matchDataWithQueryList =
          []; //foundedDataList -- mached data from query

      //use foreach-- method 1
      // _storedContactList.forEach((item) {
      //   if (item.cname.contains(query)) {
      //     dummyListData.add(item);

      //     // print(dummyListData);
      //   } else if (item.cmobileno.toString().contains(query)) {
      //     dummyListData.add(item);
      //   }
      // });

      // or
      matchDataWithQueryList = _storedSupplierList.where((item) {
        return item.sname.contains(query) ||
            item.smobileno.toString().contains(query) ||
            item.firmname.toString().contains(query);
      }).toList();
      // _clientContactList.clear();
      // _clientContactList.addAll(dummyListData); //it is not right way
      _supplierList = matchDataWithQueryList; //right way
      notifyListeners();
    } else {
      //if query is empty  then _storedContactList add to _clientContactList
      _supplierList = _storedSupplierList;
      notifyListeners();
    }
  }

// ------------------------------fatchCilentContact-----------------------------------
  Future<void> fatchSupplier() async {
    print("fatchSupplier is call");
    String useremail = Utill.getCurrentUserEMAILID();
    final url = Uri.parse(Utill.BASEURL + "/supplier/fetchall");
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
    final List<Supplier> tempLoadedSupplierlist = [];

    // Wed, 28 Dec 2022 13:34:09 GMT //element['entrydatetime'] -- hold this type of formate --this formate coming form flask server
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GMT

    responseSupplierDataList.forEach((element) {
      tempLoadedSupplierlist.add(Supplier(
        sid: element['sid'].toString(),
        semail: element["semail"], //if it will null or string
        firmname: element['firmname'].toString(),
        sname: element['sname'].toString(),
        smobileno: element['smobileno'].toString(),
        entrydatetime: stirngToDateTmeFormatter.parse(
          element['entrydatetime'],
        ), //element['entrydatetime'] is alreeady in string
        outstanding_amount_withbill:
            element["outstanding_amount_withbill"].toString(),
        outstanding_amount_without_bill:
            element["outstanding_amount_without_bill"].toString(),
        advance_amount_with_bill:
            element["advance_amount_with_bill"].toString(),
        advance_amount_without_bill:
            element["advance_amount_without_bill"].toString(),
      ));
    });
    _supplierList = tempLoadedSupplierlist;
    _storedSupplierList = _supplierList;
    updateDueAndAdvance();
    notifyListeners();
  }

// ------------------------------addNewClient-----------------------------------
  Future<void> addNewSupplier({required Map newSupplierMap}) async {
    print(newSupplierMap['useremail']);
    final url = Uri.parse(Utill.BASEURL + "/supplier/addone");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "sname": newSupplierMap['sname'],
          "firmname": newSupplierMap['firmname'],
          "smobileno": newSupplierMap['smobileno'],
          "semail": newSupplierMap['semail'],
          'useremail': newSupplierMap['useremail'],
          'entrydatetime': newSupplierMap['entrydatetime']
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    print(responseData);
    await fatchSupplier();
  }

  // ------------------------------findClientContactByCID-----------------------------------
  Future<void> updateExistingSupplier(
      {required Map updateSupplierMap, required String oldcMobileNo}) async {
    print(updateSupplierMap['useremail']);
    final url = Uri.parse(Utill.BASEURL + "/supplier/updateone");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'useremail': updateSupplierMap['useremail'],
          'oldcmobileno': oldcMobileNo,
          "sname": updateSupplierMap['sname'],
          "firmname": updateSupplierMap['firmname'],
          "smobileno": updateSupplierMap['smobileno'],
          "semail": updateSupplierMap['semail'],
          'entrydatetime': updateSupplierMap['entrydatetime']
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    print(responseData);
    await fatchSupplier();
  }

  Future<void> deleteSupplier(
      {required String smobileno, required String useremail}) async {
    final url = Uri.parse(Utill.BASEURL + "/supplier/deleteone");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {"smobileno": smobileno, "useremail": useremail},
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    await fatchSupplier();
    print("detetion done");
  }
}
