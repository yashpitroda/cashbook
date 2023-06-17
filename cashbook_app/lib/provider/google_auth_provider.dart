import 'dart:convert';
import 'package:cashbook_app/services/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../services/widget_component_utill.dart';

class GauthProvider extends ChangeNotifier {
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signUpWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      //if it is website
      GoogleAuthProvider gAuthProvider = GoogleAuthProvider();

      UserCredential result = await fireauth.signInWithPopup(gAuthProvider);
    } else {
      //mobile divice
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result =
            await fireauth.signInWithCredential(authCredential);
      }
    }
  }

  Future<bool> adduserindatabase(BuildContext context, String username,
      String useremail, String userimageurl) async {
    final url = Uri.parse(Utill.BASEURL + "/users/addone");
    print("called");
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(
        {
          'username': username,
          'useremail': useremail,
          'userimageurl': userimageurl,
        },
      ),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['status'].toString() == "database error") {
        UtillComponent.displaysnackbar(
            context: context, message: 'something went wrong');
        return false;
      }

      print("u are authnticated");
      return true;
    } else if (response.statusCode == 500) {
      print('Internal Server Error');
      print(response.statusCode);
      UtillComponent.displaysnackbar(
          context: context, message: 'Internal Server Error');
      return false;
    } else {
      print('something went wrong -- authentication');
      print(response.statusCode);
      UtillComponent.displaysnackbar(
          context: context, message: 'something went wrong -- authentication');
      return false;
    }
  }

  void signOutWithGoogle() {
    // Sign out with firebase
    // Sign out with google
    googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
