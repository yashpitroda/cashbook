import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/supplier_provider.dart';

class Utility {
  // final currentUser = FirebaseAuth.instance.currentUser;

  static const BASEURL = "http://192.168.43.144:9000";
  // static const BASEURL = "http://192.168.1.33:9000";

  static String convertToIndianCurrency(
      {required String sourceNumber, required int decimalDigits}) {
    var format = NumberFormat.currency(
        locale: 'HI', symbol: "", decimalDigits: decimalDigits);

    return format.format(int.parse(sourceNumber));
  }

  static void displaysnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void SearchInSupplierListInProvider(
      String value, BuildContext context) {
    // onChangeOnSearchTextField
    Provider.of<SupplierProvider>(context, listen: false)
        .filterSearchResults(query: value);
  }

  static void removeFocus({required BuildContext context}) {
    //removeFocus -- remove keybord or all focusNode
    FocusScope.of(context).unfocus();
  }

  static String getCurrentUserEMAILID() {
    return FirebaseAuth.instance.currentUser!.email.toString();
    // return FirebaseAuth.instance.currentUser!;
  }

  static Future<void> refreshSupplier(BuildContext context) async {
    await Provider.of<SupplierProvider>(context, listen: false).fatchSupplier();
    // print('refresh done');
  }

  static DateFormat dateFormat_DDMMYYYY() {
    DateFormat formattedDate = DateFormat('dd/MM/yyyy');
    return formattedDate;
  }

  static String datetime_to_timeAMPM({required DateTime souceDateTime}) {
    return DateFormat('hh:mm a').format(souceDateTime);
    
  }

  static DateFormat dateFormat_DD_MonthName_YYYY() {
    DateFormat formattedDate = DateFormat('dd MMMM yyyy');
    return formattedDate;
  }

  static DateTime convertDatetimeToDateOnly({required DateTime souceDateTime}) {
    // return DateUtils.dateOnly( souceDateTime);
    return DateUtils.dateOnly(souceDateTime);
  }

  static bool check_is_A_sameday(
      {required DateTime souceDateTime_1, required DateTime souceDateTime_2}) {
    // return DateUtils.dateOnly( souceDateTime);
    return DateUtils.isSameDay(souceDateTime_1, souceDateTime_2);
  }
}
