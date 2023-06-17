import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/constants.dart';
import '../widgets/customsearch_textfield.dart';
import 'add_supplier_screen.dart';
import '../services/provider_utill.dart';
import '../services/widget_component_utill.dart';

class ManageSupplierScreen extends StatefulWidget {
  static const String routeName = '/ManageSupplierScreen';
  const ManageSupplierScreen({super.key});

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
          .fatchSupplier()
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
      {required String smobileno,
      required String useremail,
      required String firmname}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Constants.borderRadius_6))),
          title: Text(
            firmname,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to delete item?',
                  style: Theme.of(context).textTheme.caption,
                ),
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
              child: Text(
                'No,Keep it',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: Text(
                'Yes,Delete',
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.white),
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

  void _onTapOnDelete(
      {required String smobileno,
      required String useremail,
      required String firmname}) {
    _showAlertDialog(
        smobileno: smobileno, useremail: useremail, firmname: firmname);
  }

  void clearTextOnSearchTextField() {
    searchTextController.clear();
    searchTextfocusnode.unfocus();
    UtillProvider.refreshSupplier(context);
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    final _supplierlist =
        Provider.of<SupplierProvider>(context, listen: true).supplierList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage supplier",
        ),
      ),
      body: Visibility(
          visible: (!_isloading),
          replacement: UtillComponent.loadingIndicator(),
          child: _body(_supplierlist, mqhight, context)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddupdateSupplierScreen.routeName,
          );
        },
        label: const Text('Add supplier'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  GestureDetector _body(
      List<Supplier> _supplierlist, double mqhight, BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchTextfocusnode.unfocus();
      },
      child: Container(
        // color: Colors.grey.withOpacity(0.09),
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
                  customOnChangedFuction:
                      UtillProvider.searchInSupplierListInProvider,
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
                onRefresh: () => UtillProvider.refreshSupplier(context),
                child: (_supplierlist.isEmpty)
                    ? const Center(
                        child: Text("Empty List"),
                      )
                    : ListView.builder(
                        itemCount: _supplierlist.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: Constants.defaultPadding_8 * 1.4),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          Constants.borderRadius_6 * 2),
                                      bottomLeft: Radius.circular(
                                          Constants.borderRadius_6 * 2))),
                              elevation: 0.7,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${_supplierlist[index].firmname}",
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
                                          "${_supplierlist[index].sname}",
                                          style: const TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 1,
                                        ),
                                        Text(
                                          "+91 ${_supplierlist[index].smobileno}",
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
                                                arguments:
                                                    _supplierlist[index].sid);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _onTapOnDelete(
                                              smobileno: _supplierlist[index]
                                                  .smobileno,
                                              firmname:
                                                  _supplierlist[index].firmname,
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
    );
  }
}
