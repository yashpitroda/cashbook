import 'package:cashbook_app/widgets/card_ui_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/google_auth_provider.dart';
import '../widgets/scrollableappbar.dart';

class ClientScreen extends StatelessWidget {
  static const String routeName = '/clientscreen';
  double padvalue = 110;
  List<Map<String, dynamic>> list = [
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'bank',
      'amount': '2000',
      'ispaid': 'payable'
    },
    {
      'user': 'keval',
      'date': '2022-10-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'ram',
      'date': '2022-11-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '5000',
      'ispaid': 'payable'
    },
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'bank',
      'amount': '2000',
      'ispaid': 'payable'
    },
    {
      'user': 'keval',
      'date': '2022-10-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'ram',
      'date': '2022-11-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '5000',
      'ispaid': 'payable'
    },
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'yash',
      'desc': 'hello world mf mf ',
      'date': '2022-10-10',
      'cashmode': 'bank',
      'amount': '2000',
      'ispaid': 'payable'
    },
    {
      'user': 'keval',
      'date': '2022-10-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '1000',
      'ispaid': 'paid'
    },
    {
      'user': 'ram',
      'date': '2022-11-10',
      'desc': 'hello world mf mf ',
      'cashmode': 'cash',
      'amount': '5000',
      'ispaid': 'payable'
    }
  ];
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder(
        future: Provider.of<GauthProvider>(context).adduserindatabase(
            context,
            currentUser!.displayName.toString(),
            currentUser.email.toString(),
            currentUser.photoURL.toString()),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                    return <Widget>[
                      scrollableAppbar(),
                    ];
                  }, body: LayoutBuilder(builder: (context, constraint) {
                    return Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey.shade100,
                            width: double.infinity,
                            child: AnimatedPadding(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.fromLTRB(
                                  10,
                                  constraint.biggest.height ==
                                          MediaQuery.of(context).size.height
                                      ? padvalue
                                      : 10,
                                  10,
                                  10),
                              child: DefaultTabController(
                                length: 3,
                                initialIndex: 0,
                                child: Column(children: [
                                  Tabs(context),
                                  Tabbarview(context)
                                ]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(10, 55),
                                      backgroundColor: Colors.green.shade800),
                                  child: const Text(
                                    'paid',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Rubik',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(10, 55),
                                      backgroundColor: Colors.red.shade800),
                                  child: const Text(
                                    'payable',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Rubik',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  })));
            }
          }
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                ElevatedButton(
                    onPressed: () =>
                        Provider.of<GauthProvider>(context, listen: false)
                            .signOutWithGoogle(),
                    child: Text("Logout"))
              ],
            ),
          );
        }));
  }

  // ------------------------------TABS-----------------------------------
  Widget Tabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.white),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xffb21c55)),
        tabs: const [
          Tab(
            child: Text(
              'Dump',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Tab(
            child: Text(
              'Client',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Tab(
            child: Text(
              'Date',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------TABBAR-----------------------------------
  Widget Tabbarview(BuildContext context) {
    return Expanded(
      child: Container(
        child: TabBarView(children: [
          GroupedListView<dynamic, String>(
            elements: list,
            groupBy: (element) => element['date'],
            groupSeparatorBuilder: (value) => Text(value),
            itemBuilder: (context, element) {
              return CardUI1();
            },
          ),
          ListView.builder(
            itemBuilder: (Ctx, index) {
              return Card(
                color: const Color(0xfff1f1f1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                shadowColor: const Color.fromRGBO(250, 250, 250, 0.5),
                elevation: 5,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  title: Text(
                    "yash",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xffac3452),
                    radius: 30,
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              );
            },
            itemCount: 10,
          )
        ]),
      ),
    );
  }
}
