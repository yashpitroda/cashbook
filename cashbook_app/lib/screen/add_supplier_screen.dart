import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/screen/contact_screens/select_contact_screen.dart';
import 'package:cashbook_app/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/supplier_provider.dart';

class AddupdateSupplierScreen extends StatefulWidget {
  static const String routeName = '/AddupdateSupplierScreen';
  // AddupdateClientScreen({
  //   // required this.isUpdate
  //   });

  @override
  State<AddupdateSupplierScreen> createState() =>
      _AddupdateSupplierScreenState();
}

class _AddupdateSupplierScreenState extends State<AddupdateSupplierScreen> {
  var _isInit = true;
  var _isloading = false;
  bool? isUpdate;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? suppilerOldMobileno;
  String? useremail;

  TextEditingController snameController = TextEditingController();
  TextEditingController smobilenoController = TextEditingController();
  TextEditingController semailController = TextEditingController();
  TextEditingController firmnameController = TextEditingController();

  FocusNode? snameFocusNode;
  FocusNode? semailFocusNode;
  FocusNode? smobilenoFocusNode;
  FocusNode? firmnameFocusNode;
  @override
  void initState() {
    snameFocusNode = FocusNode();
    semailFocusNode = FocusNode();
    smobilenoFocusNode = FocusNode();
    firmnameFocusNode = FocusNode();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final sid = args;
      isUpdate = (sid != null) ? true : false;
      print(isUpdate);
      if (sid != null) {
        //edit/update product
        //find object by id
        Supplier _editedclientobj = Provider.of<SupplierProvider>(context)
            .findSupplierBySID(sid: sid as String);
        //store data for updating --primaryKey(cmobileno,useremail) -- for where
        suppilerOldMobileno = _editedclientobj.smobileno;
        useremail = currentUser!.email.toString();

        //add this object vlaue to controler
        // print(_editedclientobj.cemail!.isEmpty);
        snameController.text = _editedclientobj.sname;
        smobilenoController.text = _editedclientobj.smobileno;
        semailController.text = _editedclientobj.semail ?? "";
        // cemailController.text = _editedclientobj.cemail as String?;
        firmnameController.text = _editedclientobj.firmname;
        // print(_editedclientobj.semail);
      }
    }
    //  else  add product
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    snameFocusNode!.dispose();
    semailFocusNode!.dispose();
    smobilenoFocusNode!.dispose();
    firmnameFocusNode!.dispose();
    super.dispose();
  }

  Map? selectedContactMap;
  void gotoContactsScreen() {
    Navigator.of(context)
        .pushNamed(SelectContactScreen.routeName)
        .then((value) {
      selectedContactMap = value as Map?;
      // print(selectedContactMap);
      if (selectedContactMap != null) {
        snameController.text = selectedContactMap!['name'];
        smobilenoController.text = selectedContactMap!['mobileno'];
        semailController.text = selectedContactMap!['email'];
      }
    });
  }

  void _onSubmitHandler() {
    if (snameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(snameFocusNode);
      return;
    }
    if (firmnameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(firmnameFocusNode);
      return;
    }
    if (smobilenoController.text.isEmpty) {
      FocusScope.of(context).requestFocus(smobilenoFocusNode);
      return;
    }

    final currentTime = DateTime.now();
    Map<String, dynamic> finalsupplierMap = {
      "sname": snameController.text.toString(),
      "smobileno": smobilenoController.text.toString(),
      "firmname": firmnameController.text.toString().toLowerCase(),
      "semail": (semailController.text.isEmpty)
          ? null
          : semailController.text.toString().toLowerCase(),
      "useremail": currentUser!.email.toString(),
      "entrydatetime": currentTime.toString(),
    };
    // print(finalContactMap);

    if (isUpdate == false) {
      //add client
      Provider.of<SupplierProvider>(context, listen: false)
          .addNewSupplier(newSupplierMap: finalsupplierMap);
      // print("add client com");
      Navigator.of(context).pop();
    } else {
      //update client
      Provider.of<SupplierProvider>(context, listen: false)
          .updateExistingSupplier(
              updateSupplierMap: finalsupplierMap,
              oldcMobileNo: suppilerOldMobileno!);
      // print("update client com");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (isUpdate == true) ? "Update Supplier" : "Add Supplier",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          snameFocusNode!.unfocus();
          semailFocusNode!.unfocus();
          smobilenoFocusNode!.unfocus();
          firmnameFocusNode!.unfocus();
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                Container(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.contacts_sharp),
                    onPressed: gotoContactsScreen,
                    label: const Text(
                      "Select Contact",
                      style: TextStyle(fontFamily: "Rubik"),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: mqhight * 0.005,
                // ),
                const Divider(
                  thickness: 1.4,
                ),
                SizedBox(
                  height: mqhight * 0.005,
                ),
                CustomTextField(
                    customtextinputaction: TextInputAction.next,
                    customfocusnode: snameFocusNode,
                    customController: snameController,
                    labeltext: 'Supplier name',
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.name),
                SizedBox(
                  height: mqhight * 0.02,
                ),
                CustomTextField(
                    customtextinputaction: TextInputAction.next,
                    customfocusnode: firmnameFocusNode,
                    customController: firmnameController,
                    labeltext: 'firm name',
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.name),
                SizedBox(
                  height: mqhight * 0.02,
                ),
                CustomTextField(
                    customtextinputaction: TextInputAction.next,
                    customfocusnode: smobilenoFocusNode,
                    customController: smobilenoController,
                    labeltext: 'Phone',
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.phone),
                SizedBox(
                  height: mqhight * 0.02,
                ),
                CustomTextField(
                    customtextinputaction: TextInputAction.done,
                    customfocusnode: semailFocusNode,
                    customController: semailController,
                    labeltext: 'Email',
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.emailAddress)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSubmitHandler,
        label: Text((isUpdate == true) ? "Update" : 'Submit'),
        icon: const Icon(Icons.check_sharp),
      ),
    );
  }
}
