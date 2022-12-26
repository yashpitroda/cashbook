import 'package:flutter/material.dart';

class AddclientSceen extends StatelessWidget {
  static const String routeName = '/AddclientSceen';
  const AddclientSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("add client"),
      ),
    );
  }
}
