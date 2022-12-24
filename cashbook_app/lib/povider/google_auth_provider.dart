import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class GauthProvider extends ChangeNotifier {
  String? imageurl;
  final FirebaseAuth fireauth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? get Imageurl {
    return imageurl;
  }

  Future<void> signUpWithGoogle(
    BuildContext context,
  ) async {
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

        //print user data
        print(result.user!);
        print("*********");
        print(result.user!.email.toString());
        // print(result.user!.phoneNumber.toString());
        // print(result.user!.emailVerified.toString());
        print(result.user!.photoURL);
        print(result.user!.uid);
        imageurl = result.user!.photoURL;
        notifyListeners();
      }
    }
  }

  void signOutWithGoogle() {
    // Sign out with firebase
    // Sign out with google
    googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
  }
}
