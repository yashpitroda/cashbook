import 'package:cashbook_app/provider/client_contact_provider.dart';
import 'package:cashbook_app/screen/add_client_screen.dart';
import 'package:cashbook_app/screen/contact_screens/select_contact_screen.dart';
import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/home_screen.dart';
import 'package:cashbook_app/screen/manage_client_screen.dart';
import 'package:cashbook_app/screen/select_client_sreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'provider/google_auth_provider.dart';
import 'screen/auth_screen_final.dart';
import 'screen/client_screen.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => ClientContactProvider(),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        debugShowCheckedModeBanner: false,
        title: 'cashbook',
        theme: ThemeData(
          fontFamily: 'Rubik',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          // useMaterial3: true,
          // textTheme:
          //     const TextTheme(bodyMedium: TextStyle(fontFamily: "Rubik")),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance
              .authStateChanges(), //it give a token whter it is authenticed or not
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              print("called2");
              return ClientScreen();
            } else {
              //and no data so not auth.. so retry
              return const AuthScreen();
              // return const AddInPayableScreen();
            }
          },
        ),
        routes: {
          AddInPayableScreen.routeName: (context) => const AddInPayableScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          ClientScreen.routeName: (context) => ClientScreen(),
          SelectClintScreen.routeName: (context) => SelectClintScreen(),
          AddupdateClientScreen.routeName: (context) => AddupdateClientScreen(),
          ManageClientScreen.routeName: (context) => ManageClientScreen(),
          SelectContactScreen.routeName: (context) => SelectContactScreen(),
        },
      ),
    );
  }
}
