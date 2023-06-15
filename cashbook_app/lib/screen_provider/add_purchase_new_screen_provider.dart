import 'package:cashbook_app/models/supplier.dart';
import 'package:flutter/material.dart';

class AddPurchaseNewScreenProvider with ChangeNotifier {
  //initialization
  bool isBill = true;
  Supplier? selectedSupplier;
  String outstandingAmount = "0";
  String advanceAmount = "0";

  //getter
  bool get getIsBill {
    return isBill;
  }

  String get getOutstandingAmount {
    return outstandingAmount;
  }

  String get getAdvanceAmount {
    return advanceAmount;
  }

  Supplier? get getSelectedSupplier {
    return selectedSupplier == null ? null : selectedSupplier!;
  }

  //opration on var
  void changeIsBill({required bool newIsBill}) {
    isBill = newIsBill;

    updateOutAdv();
    notifyListeners();
  }

  void updateOutAdv() {
    if (selectedSupplier != null) {
      if (isBill == true) {
        outstandingAmount = selectedSupplier!.outstanding_amount_withbill;
        advanceAmount = selectedSupplier!.advance_amount_with_bill;
      } else {
        outstandingAmount = selectedSupplier!.outstanding_amount_without_bill;
        advanceAmount = selectedSupplier!.advance_amount_without_bill;
      }
    } else {
      outstandingAmount = "0";
      advanceAmount = "0";
    }
    print(outstandingAmount);
    print(advanceAmount);

    notifyListeners();
  }

  void addSelectSupplier({required Supplier? supplierobj}) {
    selectedSupplier = supplierobj;
    updateOutAdv();

    notifyListeners();
  }

  String onChangedInINSTANT_PAYMENT({required String value}) {
    String pa;
    if (selectedSupplier == null) {
      notifyListeners();
      return "";
    }
    if (value.isEmpty) {
      updateOutAdv();
      notifyListeners();
      return "0";
    }
    if (value == "") {
      updateOutAdv();
      notifyListeners();
      return "0";
    }

    if (isBill == true) {
      // updatedoutstandingamountController.text =
      //     selectedSupplierobj!.outstanding_amount_withbill;
      if ((int.parse(value) >
          int.parse((selectedSupplier!.advance_amount_with_bill)))) {
        pa = (int.parse(value) -
                int.parse((selectedSupplier!.advance_amount_with_bill)))
            .toString();
        advanceAmount = "0";
      } else {
        advanceAmount = (-(int.parse(value) -
                int.parse((selectedSupplier!.advance_amount_with_bill))))
            .toString();
        pa = "0";
      }
    } else {
      // updatedoutstandingamountController.text =
      //     selectedSupplierobj!.outstanding_amount_without_bill;
      if ((int.parse(value) >
          int.parse((selectedSupplier!.advance_amount_without_bill)))) {
        pa = (int.parse(value) -
                int.parse((selectedSupplier!.advance_amount_without_bill)))
            .toString();
        advanceAmount = "0";
      } else {
        advanceAmount = (-(int.parse(value) -
                int.parse((selectedSupplier!.advance_amount_without_bill))))
            .toString();
        pa = "0";
      }
    }
    notifyListeners();
    return pa;
  }
}
