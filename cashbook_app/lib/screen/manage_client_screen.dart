import 'package:cashbook_app/provider/client_contact_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_client_screen.dart';

class ManageClientScreen extends StatefulWidget {
  static const String routeName = '/ManageClientScreen';
  ManageClientScreen({super.key});

  @override
  State<ManageClientScreen> createState() => _ManageClientScreenState();
}

class _ManageClientScreenState extends State<ManageClientScreen> {
  TextEditingController editingController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  var _isInit = true;
  var _isloading = false;

  Future<void> _refreshClient(BuildContext context) async {
    await Provider.of<ClientContactProvider>(context, listen: false)
        .fatchCilentContact(useremail: currentUser!.email.toString());

    print('refresh done');
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<ClientContactProvider>(context, listen: false)
          .fatchCilentContact(useremail: currentUser!.email.toString())
          .then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _showMyDialog(String cmobileno, String useremail) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to delete item?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.withOpacity(0.2))),
              child: const Text('No,Keep it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Yes,Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Provider.of<ClientContactProvider>(context, listen: false)
                    .deleteClient(cmobileno: cmobileno, useremail: useremail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onTapOnEdit() {}

  void _onTapOnDelete({required String cmobileno, required String useremail}) {
    _showMyDialog(cmobileno, useremail);
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    final items = Provider.of<ClientContactProvider>(context, listen: true)
        .clientContactList;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Manage Client",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: (_isloading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshClient(context),
              child: Container(
                color: Colors.grey.withOpacity(0.09),
                child: Column(
                  children: [
                    SizedBox(
                      height: mqhight * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        onChanged: (value) {
                          Provider.of<ClientContactProvider>(context,
                                  listen: false)
                              .filterSearchResults(value);
                        },
                        controller: editingController,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          labelText: "Search",
                          labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mqhight * 0.02,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${items[index].fermname}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Rubik"),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "${items[index].cname}",
                                          style: const TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        Text(
                                          "+91 ${items[index].cmobileno}",
                                          style: const TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _onTapOnDelete(
                                              cmobileno: items[index].cmobileno,
                                              useremail: currentUser!.email
                                                  .toString()),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider(
                                  //   thickness: 1.4,
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onPressed: () {
          // Add your onPressed code here!
          Navigator.of(context).pushNamed(AddClientScreen.routeName);
          // .then((_) => _refreshProducts(context));
        },
        label: const Text('Add Client'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
