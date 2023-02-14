// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashbook_app/models/current_user.dart';
import 'package:cashbook_app/provider/current_user_provider.dart';
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
        future: Provider.of<GauthProvider>(
          context,
        ).adduserindatabase(context, currentUser!.displayName.toString(),
            currentUser.email.toString(), currentUser.photoURL.toString()),
        // Provider.of<CurrentUserProvider>(context, listen: false)
        //     .fatchCurrentInfo(),

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
        }),
      ),
    );
  }

  FutureBuilder scafold_body(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CurrentUserProvider>(context, listen: false)
          .fatchCurrentuserInfo(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return __child(context);
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
      }),
    );
    //  __child(context);
  }

  Container __child(BuildContext context) {
    CurrentUser? cUser =
        Provider.of<CurrentUserProvider>(context).getCurrentUserObj;
    return Container(
      child: (cUser == null)
          ? Center(child: Text("data"))
          : Column(
              children: [
                Text(cUser.bank_balance.toString()),
                Text(cUser.useremail.toString()),
                Image.network(cUser.userimageurl.toString()),
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
            ),
    );
  }
}
