import 'package:cashbook_app/models/client_contact.dart';
import 'package:cashbook_app/provider/client_contact_provider.dart';
import 'package:cashbook_app/screen/select_contact_screen.dart';
import 'package:cashbook_app/screen/manage_client_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_client_screen.dart';

class SelectClintScreen extends StatefulWidget {
  static const String routeName = '/SelectClintScreen';
  SelectClintScreen({super.key});

  @override
  State<SelectClintScreen> createState() => _SelectClintScreenState();
}

class _SelectClintScreenState extends State<SelectClintScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser!;
  bool issearchon = false;
  Future<void> _refreshClient(BuildContext context) async {
    await Provider.of<ClientContactProvider>(context, listen: false)
        .fatchCilentContact(useremail: currentUser!.email.toString());

    print('refresh done');
  }

  TextEditingController editingController = TextEditingController();
  FocusNode editingfocusnode = FocusNode();
  var _isInit = true;
  var _isloading = false;
  var selectedClient;

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
      // widget.duplicateItems =
      //     Provider.of<ClientContactProvider>(context).clientContactList;
      // items.addAll(duplicateItems);
    }
    // print(items);

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<ClientContact> items =
        Provider.of<ClientContactProvider>(context, listen: true)
            .clientContactList;

    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "select client",
          style: TextStyle(fontFamily: "Rubik"),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ManageClientScreen.routeName);
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: (_isloading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshClient(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              RadioListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${items[index].fermname}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Rubik"),
                                    ),
                                    Text(
                                      "${items[index].entrydatetime.toString().split(' ')[0]}",
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: "Rubik"),
                                    ),
                                  ],
                                ),

                                // "${items[index].cname} AND cid=${items[index].cid}"

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${items[index].cname} : +91 ${items[index].cmobileno}",
                                      style: TextStyle(fontFamily: "Rubik"),
                                    ),
                                  ],
                                ),
                                // subtitle: Text(" ${items[index].entrydatetime}"),
                                value: items[index],
                                groupValue: selectedClient,
                                // toggleable: true,
                                onChanged: (value) {
                                  setState(() {
                                    selectedClient = value;
                                  });

                                  Navigator.of(context).pop(selectedClient);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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
