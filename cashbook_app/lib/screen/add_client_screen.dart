import 'package:cashbook_app/models/client_contact.dart';
import 'package:cashbook_app/screen/contact_screens/select_contact_screen.dart';
import 'package:cashbook_app/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/client_contact_provider.dart';

class AddupdateClientScreen extends StatefulWidget {
  static const String routeName = '/AddupdateClientScreen';
  // AddupdateClientScreen({
  //   // required this.isUpdate
  //   });

  @override
  State<AddupdateClientScreen> createState() => _AddupdateClientScreenState();
}

class _AddupdateClientScreenState extends State<AddupdateClientScreen> {
  var _isInit = true;
  var _isloading = false;
  bool? isUpdate;
  User? currentUser = FirebaseAuth.instance.currentUser;
  String? clientOldMobileno;
  String? useremail;

  TextEditingController cnameController = TextEditingController();
  TextEditingController cmobilenoController = TextEditingController();
  TextEditingController cemailController = TextEditingController();
  TextEditingController fermnameController = TextEditingController();

  FocusNode? cnameFocusNode;
  FocusNode? cemailFocusNode;
  FocusNode? cmobilenoFocusNode;
  FocusNode? fremnameFocusNode;
  @override
  void initState() {
    cnameFocusNode = FocusNode();
    cemailFocusNode = FocusNode();
    cmobilenoFocusNode = FocusNode();
    fremnameFocusNode = FocusNode();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments;
      final cid = args;
      isUpdate = (cid != null) ? true : false;
      print(isUpdate);
      if (cid != null) {
        //edit/update product
        //find object by id
        ClientContact _editedclientobj =
            Provider.of<ClientContactProvider>(context)
                .findClientContactByCID(cid: cid as String);
        //store data for updating --primaryKey(cmobileno,useremail) -- for where
        clientOldMobileno = _editedclientobj.cmobileno;
        useremail = currentUser!.email.toString();

        //add this object vlaue to controler
        // print(_editedclientobj.cemail!.isEmpty);
        cnameController.text = _editedclientobj.cname;
        cmobilenoController.text = _editedclientobj.cmobileno;
        cemailController.text = _editedclientobj.cemail ?? "";
        // cemailController.text = _editedclientobj.cemail as String?;
        fermnameController.text = _editedclientobj.fermname;
        print(_editedclientobj.cemail);
      }
    }
    //  else  add product
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    cnameFocusNode!.dispose();
    cemailFocusNode!.dispose();
    cmobilenoFocusNode!.dispose();
    fremnameFocusNode!.dispose();
    super.dispose();
  }

  Map? selectedContactMap;
  void gotoContactsScreen() {
    Navigator.of(context)
        .pushNamed(SelectContactScreen.routeName)
        .then((value) {
      selectedContactMap = value as Map;
      // print(selectedContactMap);
      cnameController.text = selectedContactMap!['cname'];
      cmobilenoController.text = selectedContactMap!['cmobileno'];
      cemailController.text = selectedContactMap!['cemail'];
    });
  }

  void _onSubmitHandler() {
    if (cnameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(cnameFocusNode);
      return;
    }
    if (fermnameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(fremnameFocusNode);
      return;
    }
    if (cmobilenoController.text.isEmpty) {
      FocusScope.of(context).requestFocus(cmobilenoFocusNode);
      return;
    }

    final currentTime = DateTime.now();
    Map<String, dynamic> finalContactMap = {
      "cname": cnameController.text.toString(),
      "cmobileno": cmobilenoController.text.toString(),
      "fermname": fermnameController.text.toString().toLowerCase(),
      "cemail": (cemailController.text.isEmpty)
          ? null
          : cemailController.text.toString().toLowerCase(),
      "useremail": currentUser!.email.toString(),
      "entrydatetime": currentTime.toString(),
    };
    // print(finalContactMap);

    if (isUpdate == false) {
      //add client
      Provider.of<ClientContactProvider>(context, listen: false)
          .addNewClient(newClientContactMap: finalContactMap);
      print("add client com");
      Navigator.of(context).pop();
    } else {
      //update client
      Provider.of<ClientContactProvider>(context, listen: false)
          .updateExistingClient(
              updateClientContactMap: finalContactMap,
              oldcMobileNo: clientOldMobileno!);
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
          (isUpdate == true) ? "Update Client" : "Add Client",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: Container(
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
                  label: Text(
                    "Select Contact",
                    style: TextStyle(fontFamily: "Rubik"),
                  ),
                ),
              ),
              // SizedBox(
              //   height: mqhight * 0.005,
              // ),
              Divider(
                thickness: 1.4,
              ),
              SizedBox(
                height: mqhight * 0.005,
              ),
              CustomTextField(
                  customtextinputaction: TextInputAction.next,
                  customfocusnode: cnameFocusNode,
                  customController: cnameController,
                  labeltext: 'client name',
                  hinttext: null,
                  triling_iconname: null,
                  leadding_iconname: null,
                  textinputtype: TextInputType.name),
              SizedBox(
                height: mqhight * 0.02,
              ),
              CustomTextField(
                  customtextinputaction: TextInputAction.next,
                  customfocusnode: fremnameFocusNode,
                  customController: fermnameController,
                  labeltext: 'ferm name',
                  hinttext: null,
                  triling_iconname: null,
                  leadding_iconname: null,
                  textinputtype: TextInputType.name),
              SizedBox(
                height: mqhight * 0.02,
              ),
              CustomTextField(
                  customtextinputaction: TextInputAction.next,
                  customfocusnode: cmobilenoFocusNode,
                  customController: cmobilenoController,
                  labeltext: 'client mobile number',
                  hinttext: null,
                  triling_iconname: null,
                  leadding_iconname: null,
                  textinputtype: TextInputType.phone),
              SizedBox(
                height: mqhight * 0.02,
              ),
              CustomTextField(
                  customtextinputaction: TextInputAction.done,
                  customfocusnode: cemailFocusNode,
                  customController: cemailController,
                  labeltext: 'client email',
                  hinttext: null,
                  triling_iconname: null,
                  leadding_iconname: null,
                  textinputtype: TextInputType.emailAddress)
            ],
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
