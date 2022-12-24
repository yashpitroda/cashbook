import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/google_auth_provider.dart';
import '../widgets/signup_card.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  Future<void> onSubmitGoogleSignup(BuildContext context) async {
   
    await Provider.of<GauthProvider>(context, listen: false)
        .signUpWithGoogle(context);
    
  }

  @override
  Widget build(BuildContext context) {
    final mxheight = MediaQuery.of(context).size.height;
    final mxwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => onSubmitGoogleSignup(context),
              child: SignupCard(
                mxheight: mxheight,
                mxwidth: mxwidth,
                title: "Signup with Google",
                imagepath: "assets/images/g-logo-2.png",
              ),
            ),
          ],
        ),
      )),
    );
  }
}
