import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'povider/google_auth_provider.dart';
import 'screen/auth_screen_final.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => GauthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), //it give a token whter it is authenticed or not
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return HomeScreen();
            } else {
              //and no data so not auth.. so retry
              return AuthScreen();
            }
          },
        ),
        routes: {
          AddInPayableScreen.routeName: (context) => AddInPayableScreen(),
        },
      ),
    );
  }
}
