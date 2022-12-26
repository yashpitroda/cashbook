import 'package:flutter/material.dart';

class ManageClientScreen extends StatelessWidget {
  static const String routeName = '/ManageClientScreen';
  const ManageClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("manage client screen"),
      ),
    );
  }
}
