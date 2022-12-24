import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../provider/google_auth_provider.dart';
import '../widgets/scrollableappbar.dart';

class ClientScreen extends StatelessWidget {
  static const String routeName = '/clientscreen';

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
                    return Container(
                      height: constraint.maxHeight,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          10, constraint.maxHeight * 0.12, 0, 6),
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                            children: [Tabs(context), Tabbarview(context)]),
                      ),
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
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xfff1f1f1)),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xffcbcbcb),
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
      ),
    );
  }

  // ------------------------------TABBAR-----------------------------------
  Widget Tabbarview(BuildContext context) {
    return Expanded(
      child: Container(
        child: TabBarView(children: [
          ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                color: Color(0xfff1f1f1),
                shadowColor: Color.fromRGBO(250, 250, 250, 0.5),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    "yash",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            itemCount: 10,
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
