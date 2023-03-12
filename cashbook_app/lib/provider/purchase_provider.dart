import 'dart:convert';
import 'package:cashbook_app/models/account.dart';
import 'package:cashbook_app/models/cashflow.dart';
import 'package:cashbook_app/models/purchase.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cashbook_app/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utill/utility.dart';

class PurchaseProvider extends ChangeNotifier {
  SupplierProvider? supplierProviderOBJ;
  String useremail = Utility.getCurrentUserEMAILID();

  void update({required SupplierProvider supplierProvider_obj}) {
    supplierProviderOBJ = supplierProvider_obj;
  }

  List<Purchase> _purchaseList = [];
  List<Purchase> _storedPurchaseList = []; //for backup

  List<Purchase> get getPurchaseList {
    return [..._purchaseList];
  }

  Purchase findSupplierByPID({required String pid}) {
    return _purchaseList.firstWhere((element) {
      return element.pid == pid;
    });
  }

  // List<Map> get getuniqueDateForCard {
  //   List<Map> t = [];
  //   for (int i = 0; i < _purchaseList.length; i++) {
  //     if ((i > 0) &&
  //         (_purchaseList[i].date.year == _purchaseList[i - 1].date.year &&
  //             _purchaseList[i].date.month == _purchaseList[i - 1].date.month &&
  //             _purchaseList[i].date.day == _purchaseList[i - 1].date.day)) {
  //     } else {
  //       t.add({i: _purchaseList[i].date});
  //     }
  //   }
  //   print(t);
  //   return t;
  // }

  Future<void> fatchPurchase() async {
    print("fatchPurchase is call");
    final url = Uri.parse(Utility.BASEURL + "/purchase/fetchall");
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
    final responseData = json.decode(response.body);
    List responsePurchaseDataList = responseData['datalist']; //[{},{},{}]
    print(responseData);
    final List<Purchase> tempLoadedPurchaselist = [];
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GM
    print("sd");
    // if (responseData["status"] == "success") {
    responsePurchaseDataList.forEach((element) {
      tempLoadedPurchaselist.add(Purchase(
        useremail: element["puchase_map"]["useremail"].toString(),
        supplierId: element["puchase_map"]["supplierId"].toString(),
        pid: element["puchase_map"]["pid"].toString(),
        isBill: element["puchase_map"]["isBill"].toString(),
        biilAmount: element["puchase_map"]["biilAmount"].toString(),
        paidAmount: element["puchase_map"]["paidAmount"].toString(),
        outstandingAmount:
            element["puchase_map"]["outstandingAmount"].toString(),
        advanceAmount: element["puchase_map"]["advanceAmount"].toString(),
        date: stirngToDateTmeFormatter.parse(element["puchase_map"]['date']),
        cOrCr: element["puchase_map"]["cOrCr"].toString(),
        accountId: element["puchase_map"]["accountId"].toString(),
        cashflowId: element["puchase_map"]["cashflowId"].toString(),
        remark: element["puchase_map"]["remark"].toString(),
        cashflowObj: Cashflow(
            cashflowId: element["cashflow_map"]["cashflowId"].toString(),
            credit: element["cashflow_map"]["credit"].toString(),
            balance: element["cashflow_map"]["balance"].toString(),
            debit: element["cashflow_map"]["debit"].toString(),
            accountId: element["cashflow_map"]["accountId"].toString(),
            accountObj: Account(
              accountId: element["account_map"]["accountId"].toString(),
              accountName: element["account_map"]["accountName"].toString(),
              useremail: element["account_map"]["useremail"].toString(),
              balance: null,
              date: stirngToDateTmeFormatter.parse(
                element["account_map"]["date"],
              ),
            ),
            date:
                stirngToDateTmeFormatter.parse(element["cashflow_map"]['date']),
            particulars: element["cashflow_map"]["particulars"].toString(),
            useremail: element["cashflow_map"]["useremail"].toString()),
        supplierObj: supplierProviderOBJ!.findSupplierBySID(
          sid: element["puchase_map"]["supplierId"].toString(),
        ),
      ));
    });
    _purchaseList = tempLoadedPurchaselist;
    _storedPurchaseList = _purchaseList; //for backup in searching
    notifyListeners();
    // } else {
    //   print("not add");
    //   print(responseData["status"]);
    // }
    print("hahs");
  }

  Future<void> submit_IN_Purchase(
      {required int isBill,
      required int cOrCr,
      required String accountId,
      required Supplier selectedSupplierobj,
      required int billAmount,
      required int paidAmount,
      required int updatedAdavanceAmount,
      required int updatedOutstandingAmount,
      required String remark,
      required DateTime finaldateTime}) async {
    try {
      // final url = Uri.parse(Utility.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utility.BASEURL + "/purchase/addone");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "isBill": isBill,
            'cOrCr': cOrCr, //instant
            'accountId': accountId,
            "paidAmount": paidAmount,
            'billAmount': billAmount,
            'updatedOutstandingAmount': updatedOutstandingAmount,
            'updatedAdavanceAmount': updatedAdavanceAmount,
            "sid": selectedSupplierobj.sid,
            'firmname': selectedSupplierobj.firmname,
            'smobileno': selectedSupplierobj.smobileno,
            'useremail': Utility.getCurrentUserEMAILID(),
            'date': finaldateTime.toString(),
            'remark': remark,
          },
        ),
      );
      if (response.body == 'null') {
        return;
      }
      final responseData = json.decode(response.body);
      final status = responseData["status"];
      if (status == Utility.CHECK_STATUS) {
       await supplierProviderOBJ!.fatchSupplier();
       await fatchPurchase();
      }
    } catch (e) {
      print(e);
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
