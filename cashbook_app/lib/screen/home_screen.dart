import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/supplier_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("home"),
    ));
  }
}
