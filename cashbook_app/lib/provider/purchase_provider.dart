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
    print(responseData);
    final List<Purchase> tempLoadedPurchaselist = [];
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GM

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
        cashOrBank: element["puchase_map"]["cashOrBank"].toString(),
        cashBankId: element["puchase_map"]["cashBankId"].toString(),
        remark: element["puchase_map"]["remark"].toString(),
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
        supplierObj: supplierProviderOBJ!.findSupplierBySID(
            sid: element["puchase_map"]["supplierId"].toString()),
      ));
    });

    _purchaseList = tempLoadedPurchaselist;
    _storedPurchaseList = _purchaseList; //for backup in searching
    print(_purchaseList);

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
      required int cashOrBank,
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
            "isBill": isBill,
            'cOrCr': cOrCr, //instant
            'cashOrBank': cashOrBank,
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
        supplierProviderOBJ!.fatchSupplier();
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
