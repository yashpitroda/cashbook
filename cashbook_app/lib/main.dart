import 'package:cashbook_app/provider/account_provider.dart';
import 'package:cashbook_app/provider/category_provider.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/screen/add_purchase_new_screen.dart';
import 'package:cashbook_app/screen/add_supplier_screen.dart';
import 'package:cashbook_app/screen/contact_screens/select_contact_screen.dart';
import 'package:cashbook_app/screen/add_in_payable_screen.dart';
import 'package:cashbook_app/screen/filter_screen.dart';
import 'package:cashbook_app/screen/home_screen.dart';
import 'package:cashbook_app/screen/manage_supplier_screen.dart';
import 'package:cashbook_app/screen/add_update_purchase_screen.dart';
import 'package:cashbook_app/screen/purchase_analitics_screeen.dart';
import 'package:cashbook_app/screen/purchase_screen.dart';
import 'package:cashbook_app/screen/select_supplier_screen.dart';
import 'package:cashbook_app/screen_provider/PurchaseAnalyticsScreeen_provider.dart';
import 'package:cashbook_app/screen_provider/add_purchase_new_screen_provider.dart';
import 'package:cashbook_app/screen_provider/filter_screen_provider.dart';
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
          create: (BuildContext ctx) => AccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => CategoryProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => PurchaseProvider(),
        // ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => AddPurchaseNewScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => PurchaseAnalyticsScreenProvider(),
        ),

        ChangeNotifierProxyProvider<SupplierProvider, PurchaseProvider>(
          create: (BuildContext ctx) => PurchaseProvider(),
          update: (BuildContext ctx, valueSupplierProvider,
                  previousPurchaseProvider) =>
              previousPurchaseProvider!
                ..update(supplierProvider_obj: valueSupplierProvider),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => FilterScreenProvider(),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        debugShowCheckedModeBanner: false,
        title: 'cashbook',
        theme: ThemeData(
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          bottomSheetTheme: BottomSheetThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          cardTheme: const CardTheme(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
          primarySwatch: generateMaterialColor(Palette.primaryColor),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            extendedTextStyle: Theme.of(context).textTheme.titleSmall,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          scaffoldBackgroundColor: Palette.backgroundColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Palette.fontBlackColor)
              .copyWith(),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0.4,
            backgroundColor: Colors.white,
            foregroundColor: Palette.blackColor,
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
          SelectSupplierScreen.routeName: (context) =>
              const SelectSupplierScreen(),
          AddupdateSupplierScreen.routeName: (context) =>
              AddupdateSupplierScreen(),
          ManageSupplierScreen.routeName: (context) =>
              const ManageSupplierScreen(),
          SelectContactScreen.routeName: (context) =>
              const SelectContactScreen(),
          AddUpdatePurchaseScreen.routeName: (context) =>
              const AddUpdatePurchaseScreen(),
          AddPurchaseNewScreen.routeName: (context) => AddPurchaseNewScreen(),
          PurchaseScreen.routeName: (context) => PurchaseScreen(),
          PurchaseAnalyticsScreeen.routeName: (context) =>
              const PurchaseAnalyticsScreeen(),
          FilterScreen.routeName: (context) => const FilterScreen(),
        },
      ),
    );
  }
}
