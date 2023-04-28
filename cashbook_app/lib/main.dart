import 'package:cashbook_app/provider/account_provider.dart';
import 'package:cashbook_app/provider/category_provider.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/screen/add_supplier_screen.dart';
import 'package:cashbook_app/screen/contact_screens/select_contact_screen.dart';
import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/home_screen.dart';
import 'package:cashbook_app/screen/manage_supplier_screen.dart';
import 'package:cashbook_app/screen/add_update_purchase_screen.dart';
import 'package:cashbook_app/screen/purchase_screen.dart';
import 'package:cashbook_app/screen/selectAccountScreen.dart';
import 'package:cashbook_app/screen/select_supplier_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/palette.dart';
import 'provider/google_auth_provider.dart';
import 'screen/auth_screen_final.dart';
import 'screen/loading_screen.dart';
import 'screen/supplier_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => GauthProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (BuildContext ctx) => CurrentUserProvider(),
        // ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => SupplierProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => accountProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => CategoryProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => PurchaseProvider(),
        // ),
        ChangeNotifierProxyProvider<SupplierProvider, PurchaseProvider>(
          create: (BuildContext ctx) => PurchaseProvider(),
          update: (BuildContext ctx, value_supplierProvider,
                  previous_PurchaseProvider) =>
              previous_PurchaseProvider!
                ..update(supplierProvider_obj: value_supplierProvider),
        )
      ],
      child: MaterialApp(
        scrollBehavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        debugShowCheckedModeBanner: false,
        title: 'cashbook',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Palette.fontBlackColor)
              .copyWith(
                  // bodyText1: TextStyle(color: Palette.fontBlackColor),
                  // bodyText2: TextStyle(color: Palette.fontBlackColor),
                  ),
          appBarTheme: const AppBarTheme(
            elevation: 0.4,
            backgroundColor: Colors.white,
            foregroundColor: Palette.blackColor,
          ),
          primarySwatch: generateMaterialColor(Palette.primaryColor),
          //canvasColor: Palette.backgroundColor,
          scaffoldBackgroundColor: Palette.backgroundColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            iconColor: Colors.black,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              return const HomeScreen();
            } else {
              return const AuthScreen();
            }
          },
        ),
        routes: {
          LoadingScreen.routeName: (context) => const LoadingScreen(),
          AddInPayableScreen.routeName: (context) => const AddInPayableScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ClientScreen.routeName: (context) => ClientScreen(),
          SelectSupplierScreen.routeName: (context) => SelectSupplierScreen(),
          AddupdateSupplierScreen.routeName: (context) =>
              AddupdateSupplierScreen(),
          ManageSupplierScreen.routeName: (context) =>
              const ManageSupplierScreen(),
          SelectContactScreen.routeName: (context) =>
              const SelectContactScreen(),
          AddUpdatePurchaseScreen.routeName: (context) =>
              const AddUpdatePurchaseScreen(),
          PurchaseScreen.routeName: (context) => PurchaseScreen(),
        },
      ),
    );
  }
}
