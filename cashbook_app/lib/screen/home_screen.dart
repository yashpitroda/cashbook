// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cashbook_app/screen/add_purchase_new_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/screen/purchase_screen.dart';
import 'package:cashbook_app/screen/supplier_screen.dart';

import '../provider/google_auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/home';

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PurchaseScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // const end = Offset(0.0, 1.0);
        const begin = Offset(1, 0);

        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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
          print("xcxc");
          print(currentUser.email);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return __child(context);
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

  // FutureBuilder scafold_body(BuildContext context) {
  //   return FutureBuilder(
  //     future:
  //     //  Provider.of<CurrentUserProvider>(context, listen: false)
  //     //     .fatchCurrentuserInfo(),
  //     builder: ((context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return __child(context);
  //       }
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton(
  //               onPressed: () =>
  //                   Provider.of<GauthProvider>(context, listen: false)
  //                       .signOutWithGoogle(),
  //               child: Text("Logout")),
  //           Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         ],
  //       );
  //     }),
  //   );
  //   //  __child(context);
  // }

  Container __child(BuildContext context) {
    // CurrentUser? cUser =
    //     Provider.of<CurrentUserProvider>(context).getCurrentUserObj;
    return Container(
      child:
          //  (cUser == null)
          //     ? Center(child: Text("data"))
          //     :
          Column(
        children: [
          //   Text(cUser.bank_balance.toString()),
          //   Text(cUser.useremail.toString()),
          //   Image.network(cUser.userimageurl.toString()),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
                // Navigator.of(context).pushNamed(PurchaseScreen.routeName);
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
          ElevatedButton(
              onPressed: () =>
                  Provider.of<GauthProvider>(context, listen: false)
                      .signOutWithGoogle(),
              child: Text("Logout")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPurchaseNewScreen.routeName);
              },
              child: Text("nothing"))
        ],
      ),
    );
  }
}
