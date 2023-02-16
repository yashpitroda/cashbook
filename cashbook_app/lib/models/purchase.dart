import 'package:cashbook_app/models/account.dart';
import 'package:cashbook_app/models/supplier.dart';

import 'cashflow.dart';

class Purchase {
  String pid;
  String supplierId;
  String biilAmount;
  String paidAmount;
  String advanceAmount;
  String outstandingAmount;
  DateTime date;
  String remark;
  String accountId;
  String cOrCr;
  String isBill;
  String cashflowId;
  String useremail;
  Cashflow cashflowObj;
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
    required this.cashflowId,
    required this.remark,
    required this.accountId,
    required this.cashflowObj,
    required this.supplierObj,
  });
}
