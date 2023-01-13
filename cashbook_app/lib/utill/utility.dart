import 'package:flutter/material.dart';

class Utility {
  static const BASEURL = "http://192.168.0.101:9000";

  // static void displaysnackbar( String message,{required BuildContext context}) {
  static void displaysnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
