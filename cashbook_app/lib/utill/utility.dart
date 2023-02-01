import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/supplier_provider.dart';

class Utility {
  // final currentUser = FirebaseAuth.instance.currentUser;

  static const BASEURL = "http://192.168.43.144:9000";

  // static void displaysnackbar( String message,{required BuildContext context}) {
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
    await Provider.of<SupplierProvider>(context, listen: false).fatchSupplier(
        useremail: FirebaseAuth.instance.currentUser!.email.toString());
    // print('refresh done');
  }
}
