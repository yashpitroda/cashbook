import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  static const CHECK_STATUS = "success";

  static const BASEURL =
      "http://192.168.43.144:9000"; //http://192.168.0.105:9000 //http://192.168.1.123:9000

  static String convertToIndianCurrency(
      {required String sourceNumber, required int decimalDigits}) {
    var format = NumberFormat.currency(
        locale: 'HI', symbol: "", decimalDigits: decimalDigits);
    return format.format(int.parse(sourceNumber));
  }

  static void removeFocus({required BuildContext context}) {
    //removeFocus -- remove keybord or all focusNode
    FocusScope.of(context).unfocus();
  }

  static String getCurrentUserEMAILID() {
    return FirebaseAuth.instance.currentUser!.email.toString();
  }

  static void scrollUp({required ScrollController customScrollController}) {
    customScrollController.animateTo(
      customScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }
}
