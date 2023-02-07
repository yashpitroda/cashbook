import 'dart:convert';
import 'package:cashbook_app/models/cashbank.dart';
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
    final url = Uri.parse(Utility.BASEURL + "/fetchpurchase");
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
    final List<Purchase> tempLoadedPurchaselist = [];
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GM

    if (responseData["status"] == "success") {
      responsePurchaseDataList.forEach((element) {
        tempLoadedPurchaselist.add(Purchase(
          pid: element["puchase_map"]["pid"].toString(),
          isbillvalue: element["puchase_map"]["isbillvalue"].toString(),
          firmname: element["puchase_map"]["firmname"].toString(),
          bill_amount: element["puchase_map"]["bill_amount"].toString(),
          paidamount: element["puchase_map"]["paidamount"].toString(),
          outstanding_amount:
              element["puchase_map"]["outstanding_amount"].toString(),
          advance_amount: element["puchase_map"]["advance_amount"].toString(),
          date: stirngToDateTmeFormatter.parse(element["puchase_map"]['date']),
          c_cr: element["puchase_map"]["c_cr"].toString(),
          cash_bank: element["puchase_map"]["cash_bank"].toString(),
          cbid: element["puchase_map"]["cbid"].toString(),
          remark: element["puchase_map"]["remark"].toString(),
          smobileno: element["puchase_map"]["smobileno"].toString(),
          cashBankObj: CashBank(
              cbid: element["cash_bank_map"]["cbid"].toString(),
              is_paymentmode:
                  element["cash_bank_map"]["is_paymentmode"].toString(),
              cash_balance: element["cash_bank_map"]["cash_balance"].toString(),
              cash_credit: element["cash_bank_map"]["cash_credit"].toString(),
              cash_debit: element["cash_bank_map"]["cash_debit"].toString(),
              bank_balance: element["cash_bank_map"]["bank_balance"].toString(),
              bank_credit: element["cash_bank_map"]["bank_credit"].toString(),
              bank_debit: element["cash_bank_map"]["bank_debit"].toString(),
              date: stirngToDateTmeFormatter
                  .parse(element["cash_bank_map"]['date']),
              particulars: element["cash_bank_map"]["particulars"].toString(),
              useremail: element["cash_bank_map"]["useremail"].toString()),
          supplierObj: supplierProviderOBJ!.findSupplierBymobileno(
              smobileno: element["puchase_map"]["smobileno"].toString()),
        )
            // supplierObj: null),
            );
      });

      _purchaseList = tempLoadedPurchaselist;
      _storedPurchaseList = _purchaseList; //for backup in searching
      print(_purchaseList);

      notifyListeners();
    } else {
      print("not add");
      print(responseData["status"]);
    }
    print("hahs");
  }

  Future<void> submit_IN_Purchase(
      {required int isBillValue,
      required int c_cr,
      required int cash_bank,
      required Supplier selectedSupplierobj,
      required int billAmount,
      required int paidAmount,
      required int updatedAdavanceAmount,
      required int updatedOutstandingAmount,
      required String remark,
      required DateTime finaldateTime}) async {
    try {
      // final url = Uri.parse(Utility.BASEURL + "/addinpurchas");
      final url = Uri.parse(Utility.BASEURL + "/addinpurchase");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "isbillvalue": isBillValue,
            'c_cr': c_cr, //instant
            'cash_bank': cash_bank,
            "paidamount": paidAmount,
            'bill_amount': billAmount,
            'updated_outstanding_amount': updatedOutstandingAmount,
            'updated_advance_amount': updatedAdavanceAmount,
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
        fatchPurchase();
      }
    } catch (e) {
      print(e);
      throw e;
    }

    // print(status);
    // return status; //success
  }
}
