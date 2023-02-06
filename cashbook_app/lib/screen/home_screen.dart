// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/purchase_screen.dart';
import 'package:cashbook_app/screen/supplier_screen.dart';

import '../provider/google_auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
        ),
        // body: scafold_body(context),
        body: FutureBuilder(
            future: Provider.of<GauthProvider>(context).adduserindatabase(
                context,
                currentUser!.displayName.toString(),
                currentUser.email.toString(),
                currentUser.photoURL.toString()),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return scafold_body(context);
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () =>
                          Provider.of<GauthProvider>(context, listen: false)
                              .signOutWithGoogle(),
                      child: Text("Logout")),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            })));
  }

  Column scafold_body(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PurchaseScreen.routeName);
//               Navigator.of(MaterialApp).push(
//   MaterialPageRoute(builder: (MaterialAppContext) => ScreenB())
// )
            },
            child: Text("go to purchase screen")),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ClientScreen.routeName);
            },
            child: Text("go to purchase screen")),
        Center(
          child: Text("home"),
        ),
      ],
    );
  }
}
