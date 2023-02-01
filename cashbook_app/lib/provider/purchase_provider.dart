import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cashbook_app/models/supplier.dart';
import 'package:flutter/material.dart';

import '../utill/utility.dart';

class PurchaseProvider extends ChangeNotifier {
  Future<String> submit_IN_Purchase(
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
    // print(isBillValue);
    // print(c_cr);
    // print(cash_bank);
    // isBillValue -- 0 or 1
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
      // print('its products retruns data is not avalible in firebase server');
      return "error";
    }
    final responseData = json.decode(response.body);
    final status = responseData["status"];
    print(status);
    return status; //success
  }
}
