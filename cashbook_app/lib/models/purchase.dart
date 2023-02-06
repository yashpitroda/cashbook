import 'package:cashbook_app/models/supplier.dart';

import 'cashbank.dart';

class Purchase {
  String pid;
  String isbillvalue;
  String firmname;
  String bill_amount;
  String paidamount;
  String advance_amount;
  String outstanding_amount;
  String c_cr;
  String remark;
  String smobileno;
  String cbid;
  DateTime date;
  String cash_bank;
  CashBank cashBankObj;
  Supplier? supplierObj;

  Purchase({
    required this.pid,
    required this.isbillvalue,
    required this.firmname,
    required this.bill_amount,
    required this.paidamount,
    required this.
    outstanding_amount,
    required this.
    advance_amount,
    required this.date,
    required this.c_cr,
    required this.cash_bank,
    required this.cbid,
    required this.remark,
    required this.smobileno,
    required this.cashBankObj,
    required this.supplierObj,
  });
}
