import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../povider/google_auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                Provider.of<GauthProvider>(context, listen: false)
                    .signOutWithGoogle();
                print("logout");
                // Navigator.of(context).pop();
              },
              child: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Image.network(Provider.of<GauthProvider>(context).Imageurl ?? ""),
          Center(child: Text("data")),
        ],
      ),
    );
  }
}
