import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/client_screen.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder(
        future: Provider.of<GauthProvider>(context).adduserindatabase(
            context,
            currentUser!.displayName.toString(),
            currentUser!.email.toString(),
            currentUser!.photoURL.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // return ClientScreen();
              return AddInPayableScreen();
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
