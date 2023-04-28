import 'package:cashbook_app/services/palette.dart';
import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/screen/manage_supplier_screen.dart';
import 'package:cashbook_app/widgets/customsearch_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/constants.dart';
import '../services/date_time_utill.dart';
import '../services/provider_utill.dart';
import '../services/utility.dart';
import '../services/widget_component_utill.dart';

class SelectSupplierScreen extends StatefulWidget {
  static const String routeName = '/SelectSupplierScreen';
  const SelectSupplierScreen({super.key});

  @override
  State<SelectSupplierScreen> createState() => _SelectSupplierScreenState();
}

class _SelectSupplierScreenState extends State<SelectSupplierScreen> {
  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextfocusnode = FocusNode();

  var _isInit = true;
  var _isloading = false;
  String? selectedSupplierSid;
  Supplier? selectedSupplierObj;
  bool issearchon = false;
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
          final args = ModalRoute.of(context)!.settings.arguments;
          final sid = args;
          if (sid != null) {
            selectedSupplierSid = sid as String?;
          }
          _isloading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void clearTextOnSearchTextField() {
    searchTextController.clear();
    searchTextfocusnode.unfocus();
    ProviderUtill.refreshSupplier(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Supplier> _supplierList =
        Provider.of<SupplierProvider>(context, listen: true).supplierList;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Select supplier",
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ManageSupplierScreen.routeName);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Visibility(
          visible: (!_isloading),
          replacement: WidgetComponentUtill.loadingIndicator(),
          child: _body(_supplierList, context)),
    );
  }

  GestureDetector _body(List<Supplier> _supplierlist, BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchTextfocusnode.unfocus();
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Constants.defaultPadding_8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomSearchTextField(
                  customController: searchTextController,
                  labeltext: "search",
                  hinttext: null,
                  textinputtype: TextInputType.name,
                  customfocusnode: searchTextfocusnode,
                  customOnChangedFuction:
                      ProviderUtill.searchInSupplierListInProvider,
                  customClearSearchFuction: clearTextOnSearchTextField),
            ),
            const SizedBox(
              height: 6,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ProviderUtill.refreshSupplier(context),
                child: (_supplierlist.isEmpty)
                    ? const Center(
                        child: Text("Empty List"),
                      )
                    : ListView.builder(
                        itemCount: _supplierlist.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: Constants.defaultPadding_8),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          Constants.borderRadius_6 * 2),
                                      bottomLeft: Radius.circular(
                                          Constants.borderRadius_6 * 2))),
                              elevation: 0.7,
                              color: Colors.white,
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_supplierlist[index].firmname,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                    Text(
                                        DateTimeUtill.returnDateAndMounth(
                                            souceDateTime: _supplierlist[index]
                                                .entrydatetime),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${_supplierlist[index].sname} : +91 ${_supplierlist[index].smobileno}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                                value: _supplierlist[index].sid,
                                groupValue: selectedSupplierSid,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSupplierSid = value;
                                    selectedSupplierObj =
                                        Provider.of<SupplierProvider>(context,
                                                listen: false)
                                            .findSupplierBySID(sid: value!);
                                  });

                                  Navigator.of(context)
                                      .pop(selectedSupplierObj);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
