import 'dart:convert';
import 'package:cashbook_app/models/account.dart';
import 'package:cashbook_app/models/cashflow.dart';
import 'package:cashbook_app/models/category.dart';
import 'package:cashbook_app/models/purchase.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/services/utility.dart';
import 'package:http/http.dart' as http;
import 'package:cashbook_app/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PurchaseProvider extends ChangeNotifier {
  String totalPurchase = "0";
  String totalLastMounthPurchase = "0";
  String totalThisMounthPurchase = "0";
  String totalPaid = "0";
  String totalAdvance = "0";
  String totalDue = "0";

  SupplierProvider? supplierProviderOBJ;

  void update({required SupplierProvider supplierProvider_obj}) {
    supplierProviderOBJ = supplierProvider_obj;
  }

  List<Purchase>? _purchaseList;
  List<Purchase>? _storedPurchaseList; //for backup

  List<Purchase>? get getPurchaseList {
    return _purchaseList == null ? null : [..._purchaseList!];
  }

  Purchase findPurchaseObjByPID({required String pid}) {
    return _purchaseList!.firstWhere((element) {
      return element.pid == pid;
    });
  }

  Future<void> fatchPurchase() async {
    Uri url = Uri.parse(Utill.BASEURL + "/purchase/fetchall");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'useremail': Utill.getCurrentUserEMAILID(),
        },
      ),
    );

    if (response.body == 'null') {
      return;
    }

    final responseData = json.decode(response.body);
    List responsePurchaseDataList = responseData['datalist']; //[{},{},{}]

    if (responsePurchaseDataList.isEmpty) {
      print("HAPPY");
      _purchaseList = null;
      _storedPurchaseList = null;
      notifyListeners();
      return;
    }
    final List<Purchase> tempLoadedPurchaselist = [];
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GM

    responsePurchaseDataList.forEach((element) {
      tempLoadedPurchaselist.add(Purchase(
        categoryObj: Category_(
          categoryId: element["category_map"]["categoryId"].toString(),
          categoryName: element["category_map"]["categoryName"].toString(),
          useremail: element["category_map"]["useremail"].toString(),
          date: stirngToDateTmeFormatter.parse(element["category_map"]['date']),
          type: element["category_map"]["type"].toString(),
        ),
        categoryId: element["puchase_map"]["categoryId"].toString(),
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
    totalPurchase = "0";
    totalLastMounthPurchase = "0";
    totalThisMounthPurchase = "0";
    totalPaid = "0";
    totalAdvance = "0";
    totalDue = "0";

    if (_purchaseList != null) {
      var dtNow = DateTime.now();
      int currentMonth = dtNow.month;
      for (var i = 0; i < _purchaseList!.length; i++) {
        Purchase purchaseObj = _purchaseList![i];
        int objMounth = purchaseObj.date.month;
        int lastMounth;
        if (currentMonth == 1) {
          lastMounth = 12;
        } else {
          lastMounth = currentMonth - 1;
        }
        totalPurchase =
            (int.parse(totalPurchase) + int.parse(purchaseObj.biilAmount))
                .toString();
        totalPaid = (int.parse(totalPaid) + int.parse(purchaseObj.paidAmount))
            .toString();
        totalAdvance =
            (int.parse(totalAdvance) + int.parse(purchaseObj.advanceAmount))
                .toString();
        totalDue =
            (int.parse(totalDue) + int.parse(purchaseObj.outstandingAmount))
                .toString();
        if (objMounth == currentMonth) {
          totalThisMounthPurchase = (int.parse(totalThisMounthPurchase) +
                  int.parse(purchaseObj.biilAmount))
              .toString();
        }
        if (objMounth == lastMounth) {
          totalLastMounthPurchase = (int.parse(totalLastMounthPurchase) +
                  int.parse(purchaseObj.biilAmount))
              .toString();
        }
      }
      print("totalPurchase :" + totalPurchase);
      print("totalPaid :" + totalPaid);
      print("totalAdvance :" + totalAdvance);
      print("totalDue :" + totalDue);
      print("totalThisMounthPurchase :" + totalThisMounthPurchase);

      print("totalLastMounthPurchase :" + totalLastMounthPurchase);
    }

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
      required String categoryId,
      required Supplier selectedSupplierobj,
      required int billAmount,
      required int paidAmount,
      required int updatedAdavanceAmount,
      required int updatedOutstandingAmount,
      required String remark,
      required DateTime finaldateTime}) async {
    try {
      // final url = Uri.parse(Utill.BASEURL + "/addinpurchas");
      // final url = Uri.parse(Utill.BASEURL + "/purchase/addone");
      final url = Uri.parse(Utill.BASEURL + "/purchase/addone");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "isBill": isBill,
            'cOrCr': cOrCr, //instant
            'accountId': accountId,
            'categoryId': categoryId,
            "paidAmount": paidAmount,
            'billAmount': billAmount,
            'updatedOutstandingAmount': updatedOutstandingAmount,
            'updatedAdavanceAmount': updatedAdavanceAmount,
            "sid": selectedSupplierobj.sid,
            'firmname': selectedSupplierobj.firmname,
            'smobileno': selectedSupplierobj.smobileno,
            'useremail': Utill.getCurrentUserEMAILID(),
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
      if (status == Utill.CHECK_STATUS) {
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
