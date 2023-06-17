import 'package:cashbook_app/models/supplier.dart';
import 'package:flutter/material.dart';

class AddPurchaseNewScreenProvider with ChangeNotifier {
  //initialization
  bool isBill = true;
  bool isInstantPayment = true;
  bool isCreditAdvance = false;
  bool isOnlySettle = false;
  bool isLoadingOnSubmit = false;

  int isC_Cr = 0;

  Supplier? selectedSupplier;
  String outstandingAmount = "0";
  String advanceAmount = "0";

  //getter
  bool get getIsBill {
    return isBill;
  }

  bool get getIsLoadingOnSubmit {
    return isLoadingOnSubmit;
  }

  bool get getIsOnlySettle {
    return isOnlySettle;
  }

  bool get getIsCreditAdvance {
    return isCreditAdvance;
  }

  bool get getIsInstantPayment {
    return isInstantPayment;
  }

  int get getIsC_cr {
    return isC_Cr;
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

  void changeIsLoadingOnSubmit({required bool newIsLoadingOnSubmit}) {
    isLoadingOnSubmit = newIsLoadingOnSubmit;
    notifyListeners();
  }

  void changeIsOnlySettle() {
    isOnlySettle = !isOnlySettle;
    updateOutAdv();
    notifyListeners();
  }

  void resetIsOnlySettle() {
    isOnlySettle = false;
    updateOutAdv();
    notifyListeners();
  }

  void changeIsInstantPayment({required bool newIsInstantPayment}) {
    isInstantPayment = newIsInstantPayment;
    notifyListeners();
  }

  void changeIsCreditAdvance({required bool newIsCreditAdvance}) {
    isCreditAdvance = newIsCreditAdvance;
    notifyListeners();
  }

  void changeIsC_Cr({required int newIsC_Cr}) {
    isC_Cr = newIsC_Cr;
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

  void onChangedInCREDIT(
      {required String paidAmount, required String billAmount}) {
    if (selectedSupplier == null) {
      notifyListeners();
      return;
    }
    if (paidAmount.isEmpty || billAmount.isEmpty) {
      updateOutAdv();
      notifyListeners();
      return;
    }
    String currentOutstandingAmount =
        (int.parse(billAmount) - int.parse((paidAmount))).toString();
    String totalOutstandingAmount_withbill =
        (int.parse(currentOutstandingAmount) +
                int.parse((selectedSupplier!.outstanding_amount_withbill)))
            .toString();
    String totalOutstandingAmount_withoutbill =
        (int.parse(currentOutstandingAmount) +
                int.parse((selectedSupplier!.outstanding_amount_without_bill)))
            .toString();
    if (isBill == true) {
      if ((int.parse(totalOutstandingAmount_withbill) >
          int.parse((selectedSupplier!.advance_amount_with_bill)))) {
        advanceAmount = "0";
        outstandingAmount = (int.parse(totalOutstandingAmount_withbill) -
                int.parse((selectedSupplier!.advance_amount_with_bill)))
            .toString();
      } else {
        outstandingAmount = "0";
        advanceAmount = (-(int.parse(totalOutstandingAmount_withbill) -
                int.parse((selectedSupplier!.advance_amount_with_bill))))
            .toString();
      }
    } else {
      if ((int.parse(totalOutstandingAmount_withoutbill) >
          int.parse((selectedSupplier!.advance_amount_without_bill)))) {
        advanceAmount = "0";
        outstandingAmount = (int.parse(totalOutstandingAmount_withoutbill) -
                int.parse((selectedSupplier!.advance_amount_without_bill)))
            .toString();
      } else {
        outstandingAmount = "0";
        advanceAmount = (-(int.parse(totalOutstandingAmount_withoutbill) -
                int.parse((selectedSupplier!.advance_amount_without_bill))))
            .toString();
      }
    }
    notifyListeners();
  }
}
