import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/utill/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/customsearch_textfield.dart';
import 'add_supplier_screen.dart';

class ManageSupplierScreen extends StatefulWidget {
  static const String routeName = '/ManageSupplierScreen';
  ManageSupplierScreen({super.key});

  @override
  State<ManageSupplierScreen> createState() => _ManageSupplierScreenState();
}

class _ManageSupplierScreenState extends State<ManageSupplierScreen> {
  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextfocusnode = FocusNode();
  final currentUser = FirebaseAuth.instance.currentUser;
  var _isInit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<SupplierProvider>(context, listen: false)
          .fatchSupplier(useremail: currentUser!.email.toString())
          .then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _showAlertDialog(
      {required String smobileno, required String useremail}) async {
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
                Provider.of<SupplierProvider>(context, listen: false)
                    .deleteSupplier(smobileno: smobileno, useremail: useremail);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onTapOnDelete({required String smobileno, required String useremail}) {
    _showAlertDialog(smobileno: smobileno, useremail: useremail);
  }

  void clearTextOnSearchTextField() {
    searchTextController.clear();
    searchTextfocusnode.unfocus();
    Utility.refreshSupplier(context);
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    final items =
        Provider.of<SupplierProvider>(context, listen: true).supplierList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage supplier",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: (_isloading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                searchTextfocusnode.unfocus();
              },
              child: Container(
                color: Colors.grey.withOpacity(0.09),
                child: Column(
                  children: [
                    SizedBox(
                      height: mqhight * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomSearchTextField(
                          customController: searchTextController,
                          labeltext: "search",
                          hinttext: null,
                          textinputtype: TextInputType.name,
                          customfocusnode: searchTextfocusnode,
                          customtextinputaction: null,
                          customOnChangedFuction:
                              Utility.SearchInSupplierListInProvider,
                          customClearSearchFuction: clearTextOnSearchTextField),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   child: TextField(
                    //     focusNode: searchTextfocusnode,
                    //     onChanged: (value) {
                    //       Provider.of<SupplierProvider>(context, listen: false)
                    //           .filterSearchResults(query: value);
                    //     },
                    //     controller: searchTextController,
                    //     cursorColor: Colors.black,
                    //     style: const TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 16),
                    //     decoration: InputDecoration(
                    //       suffixIcon: searchTextfocusnode.hasFocus
                    //           ? IconButton(
                    //               icon: Icon(Icons.clear),
                    //               onPressed: () {
                    //                 searchTextController.clear();
                    //                 searchTextfocusnode.unfocus();
                    //                 Utility.refreshSupplier(context);
                    //               },
                    //             )
                    //           : null,
                    //       prefixIcon: Icon(Icons.search_rounded),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(14)),
                    //       ),
                    //       labelText: "Search",
                    //       labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
                    //       hintStyle: TextStyle(fontSize: 13),
                    //       contentPadding:
                    //           EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: mqhight * 0.02,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => Utility.refreshSupplier(context),
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${items[index].firmname}",
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
                                            "${items[index].sname}",
                                            style: const TextStyle(
                                              fontFamily: "Rubik",
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 1,
                                          ),
                                          Text(
                                            "+91 ${items[index].smobileno}",
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
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  AddupdateSupplierScreen
                                                      .routeName,
                                                  arguments: items[index].sid);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _onTapOnDelete(
                                                smobileno:
                                                    items[index].smobileno,
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
                      ),
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          // Navigator.of(context).pushNamed(AddClientScreen.routeName);
          Navigator.of(context).pushNamed(
            AddupdateSupplierScreen.routeName,
          );
          // .then((_) => _refreshProducts(context));
        },
        label: const Text('Add supplier'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
