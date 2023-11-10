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
  String _totalLastMounthPurchase = "0";
  String _totalThisMounthPurchase = "0";

  String _totalPurchase = "0";
  String _totalPaid = "0";
  String _withBillPurchase = "0";
  String _withBillPaid = "0";
  String _chalanPaid = "0";
  String _chalanPurchase = "0";

  String _totalAdvance = "0";
  String _totalDue = "0";
  String _withBillAdvance = "0";
  String _chalanAdvance = "0";
  String _withBillDue = "0";
  String _chalanDue = "0";

  SupplierProvider? supplierProviderOBJ;

  void update({required SupplierProvider supplierProvider_obj}) {
    supplierProviderOBJ = supplierProvider_obj;
  }

  List<Purchase>? _purchaseList;
  List<Purchase>? _storedPurchaseList; //for backup

  List<Purchase>? get getPurchaseList {
    return _purchaseList == null ? null : [..._purchaseList!];
  }

  String get getTotalAdvance {
    return _totalAdvance;
  }

  String get getTotalLastMounthPurchase {
    return _totalLastMounthPurchase;
  }

  String get getTotalThisMounthPurchase {
    return _totalThisMounthPurchase;
  }

  String get getTotalPaid {
    return _totalPaid;
  }

  String get getTotalPurchase {
    return _totalPurchase;
  }

  String get getTotalDue {
    return _totalDue;
  }

  String get getWithBillAdvance {
    return _withBillAdvance;
  }

  String get getWithBillDue {
    return _withBillDue;
  }

  String get getChalanAdvance {
    return _chalanAdvance;
  }

  String get getChalanDue {
    return _chalanDue;
  }

  String get getWithBillPurchase {
    return _withBillPurchase;
  }

  String get getWithBillPaid {
    return _withBillPaid;
  }

  String get getChalanPaid {
    return _chalanPaid;
  }

  String get getChalanPurchase {
    return _chalanPurchase;
  }

  Purchase findPurchaseObjByPID({required String pid}) {
    return _purchaseList!.firstWhere((element) {
      return element.pid == pid;
    });
  }

  void updateDueAndAdvanceAmounts() {
    _totalAdvance = "0";
    _totalDue = "0";
    _withBillAdvance = "0";
    _chalanAdvance = "0";
    _withBillDue = "0";
    _chalanDue = "0";
    Set<int> supplierIdSet = {};
    if (_purchaseList == null) {
      return;
    }
    for (int i = 0; i < _purchaseList!.length; i++) {
      Purchase purchaseObj = _purchaseList![i];
      supplierIdSet.add(int.parse(purchaseObj.supplierId));
    }
    if (supplierIdSet.isEmpty || supplierProviderOBJ == null) {
      return;
    }

    for (int uniqueSid in supplierIdSet) {
      Supplier supplierObj =
          supplierProviderOBJ!.findSupplierBySID(sid: uniqueSid.toString());

      _totalAdvance = (int.parse(_totalAdvance) +
              int.parse(supplierObj.advance_amount_with_bill) +
              int.parse(supplierObj.advance_amount_without_bill))
          .toString();
      _totalDue = (int.parse(_totalDue) +
              int.parse(supplierObj.outstanding_amount_withbill) +
              int.parse(supplierObj.outstanding_amount_without_bill))
          .toString();
      _withBillAdvance = (int.parse(_withBillAdvance) +
              int.parse(supplierObj.advance_amount_with_bill))
          .toString();
      _withBillDue = (int.parse(_withBillDue) +
              int.parse(supplierObj.outstanding_amount_withbill))
          .toString();
      _chalanAdvance = (int.parse(_chalanAdvance) +
              int.parse(supplierObj.advance_amount_without_bill))
          .toString();
      _chalanDue = (int.parse(_chalanDue) +
              int.parse(supplierObj.outstanding_amount_without_bill))
          .toString();
    }
    notifyListeners();
  }

  void upadatePaidAndPurchase() {
    _totalPurchase = "0";
    _totalPaid = "0";
    _withBillPurchase = "0";
    _withBillPaid = "0";
    _chalanPaid = "0";
    _chalanPurchase = "0";
    if (_purchaseList == null) {
      return;
    }
    for (int i = 0; i < _purchaseList!.length; i++) {
      Purchase purchaseObj = _purchaseList![i];
      _totalPurchase =
          (int.parse(_totalPurchase) + int.parse(purchaseObj.biilAmount))
              .toString();
      _totalPaid = (int.parse(_totalPaid) + int.parse(purchaseObj.paidAmount))
          .toString();
      if (int.parse(purchaseObj.isBill) == 1) {
        _withBillPurchase =
            (int.parse(_withBillPurchase) + int.parse(purchaseObj.biilAmount))
                .toString();
        _withBillPaid =
            (int.parse(_withBillPaid) + int.parse(purchaseObj.paidAmount))
                .toString();
      } else {
        _chalanPaid =
            (int.parse(_chalanPaid) + int.parse(purchaseObj.paidAmount))
                .toString();
        _chalanPurchase =
            (int.parse(_chalanPurchase) + int.parse(purchaseObj.biilAmount))
                .toString();
      }
    }
    notifyListeners();
  }

  void updateThisAndLastMounthPurchaseAndPaid() {
    _totalLastMounthPurchase = "0";
    _totalThisMounthPurchase = "0";

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

      if (objMounth == currentMonth) {
        _totalThisMounthPurchase = (int.parse(_totalThisMounthPurchase) +
                int.parse(purchaseObj.biilAmount))
            .toString();
      }
      if (objMounth == lastMounth) {
        _totalLastMounthPurchase = (int.parse(_totalLastMounthPurchase) +
                int.parse(purchaseObj.biilAmount))
            .toString();
      }
    }
  }

  Future<void> fatchPurchase() async {
    Uri url = Uri.parse("${Utill.BASEURL}/purchase/fetchall");

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
      _purchaseList = null;
      _storedPurchaseList = null;
      notifyListeners();
      return;
    }
    final List<Purchase> tempLoadedPurchaselist = [];
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GM
    for (var element in responsePurchaseDataList) {
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
    }

    _purchaseList = tempLoadedPurchaselist;
    _storedPurchaseList = _purchaseList; //for backup in searching

    if (_purchaseList != null) {
      upadatePaidAndPurchase();
      updateDueAndAdvanceAmounts();
      updateThisAndLastMounthPurchaseAndPaid();
    }

    notifyListeners();
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
      final url = Uri.parse("${Utill.BASEURL}/purchase/addone");

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
