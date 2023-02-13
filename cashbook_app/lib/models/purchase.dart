import 'package:cashbook_app/models/supplier.dart';

import 'cashbank.dart';

class Purchase {
  String pid;
  String supplierId;
  String biilAmount;
  String paidAmount;
  String advanceAmount;
  String outstandingAmount;
  DateTime date;
  String remark;
  String cOrCr;
  String isBill;
  String cashOrBank;
  String cashBankId;
  String useremail;
  CashBank cashBankObj;
  Supplier? supplierObj;

  Purchase({
    required this.useremail,
    required this.supplierId,
    required this.pid,
    required this.isBill,
    required this.biilAmount,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.advanceAmount,
    required this.date,
    required this.cOrCr,
    required this.cashOrBank,
    required this.cashBankId,
    required this.remark,
    required this.cashBankObj,
    required this.supplierObj,
  });
}
