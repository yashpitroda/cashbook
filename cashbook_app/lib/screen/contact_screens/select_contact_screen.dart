import 'package:cashbook_app/provider/client_contact_provider.dart';
import 'package:cashbook_app/widgets/customtextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class SelectContactScreen extends StatefulWidget {
  static const String routeName = '/SelectContactScreen';
  const SelectContactScreen({super.key});

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  TextEditingController searchTextController = TextEditingController();

  List<Contact> _dummycontactslist = [];
  List<Contact> contactList = [];
  List<Color> colorsList = [];

  bool _permissionDenied = false;
  int? isSelectedContactIndex;
  Contact? selectedContact;

// ------------------------------_fetchContactsFromDevice-----------------------------------
  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withAccounts: true);

      setState(() {
        _dummycontactslist.addAll(contacts);
      });
    }
  }

// ------------------------------initState-----------------------------------
  @override
  void initState() {
    super.initState();
    //add contact in list
    _fetchContacts().then((_) {
      contactList.addAll(_dummycontactslist);

      //add color in colorlist
      for (var i = 0; i < contactList.length; i++) {
        colorsList.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(0.2));
      }
    });
  }

// ------------------------------_onSubmitHandler-----------------------------------
  void _onSubmitHandler(BuildContext context) {
    Map<String, dynamic> finalselectedContactMap = {
      "cname": selectedContact!.displayName.toString().toLowerCase(),
      "cmobileno": selectedContact!.phones.first.number
          .toString()
          .replaceAll(" ", "")
          .replaceFirst("+91", ""),
      "cemail": (selectedContact!.emails.length == 0)
          ? null
          : selectedContact!.emails.first.address.toString().toLowerCase(),
    };

    // Provider.of<ClientContactProvider>(context, listen: false)
    //     .addNewClient(newClientContactMap: finalselectedContactMap);
    Navigator.of(context).pop(finalselectedContactMap);
  }

// ------------------------------filterSearchResults-----------------------------------
  void filterSearchResults(String query) {
    isSelectedContactIndex = null;
    List dummySearchList = [];
    dummySearchList.addAll(_dummycontactslist);
    print(dummySearchList);
    if (query.isNotEmpty) {
      List<Contact> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.displayName.toString().toLowerCase().contains(query)) {
          dummyListData.add(item);
        } else if (item.phones.first.number
            .toString()
            .replaceAll(" ", "")
            .replaceFirst("+91", "")
            .contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        contactList.clear();
        contactList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        contactList.clear();
        contactList.addAll(_dummycontactslist);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select contacts",
          style: TextStyle(fontFamily: "Rubik"),
        ),
        actions: [
          TextButton(
            onPressed: (!(isSelectedContactIndex == null))
                ? () => _onSubmitHandler(context)
                : null,
            child: const Text(
              "Done",
              style: TextStyle(fontFamily: "Rubik"),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: searchTextController,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          // letterSpacing: 1,
                          color: Colors.black,
                          // fontWeight: FontWeight.w500,
                          fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search), //icon at tail of input
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1.2,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(
                  height: 1.9,
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: _CustomContactListView(),
      ),
    );
  }

// ------------------------------_CustomContactListView-----------------------------------
  Widget _CustomContactListView() {
    if (_permissionDenied)
      return const Center(child: Text('Permission denied'));
    if (contactList == null)
      return const Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, i) => ListTile(
            leading: ((i == isSelectedContactIndex &&
                    !isSelectedContactIndex!.isNaN))
                ? const CircleAvatar(
                    child: Icon(Icons.check),
                    backgroundColor: Colors.blue,
                  )
                : CircleAvatar(
                    backgroundColor: colorsList[i],
                    child: Image.asset(
                      'assets/images/contect_icon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
            subtitle: Text(
              '${contactList[i].phones.isNotEmpty ? contactList[i].phones.first.number.toString().replaceAll(" ", "").replaceFirst("+91", "") : '(none)'}',
              style: TextStyle(
                  fontSize: ((i == isSelectedContactIndex &&
                          !isSelectedContactIndex!.isNaN))
                      ? 15
                      : 14,
                  fontFamily: "Rubik"),
            ),
            title: Text(
              contactList[i].displayName,
              style: TextStyle(
                overflow: TextOverflow.fade,
                fontWeight: (((i == isSelectedContactIndex &&
                        !isSelectedContactIndex!.isNaN)))
                    ? FontWeight.w500
                    : null,
                color: (((i == isSelectedContactIndex &&
                        !isSelectedContactIndex!.isNaN)))
                    ? Colors.blue
                    : Colors.black,
                fontFamily: 'Rubik',
                fontSize: (((i == isSelectedContactIndex &&
                        !isSelectedContactIndex!.isNaN)))
                    ? 20
                    : 16,
              ),
            ),
            onTap: () {
              setState(() {
                if (isSelectedContactIndex == null) {
                  isSelectedContactIndex = i;
                  selectedContact = contactList[i];
                } else if (isSelectedContactIndex == i) {
                  isSelectedContactIndex = null;
                } else if (isSelectedContactIndex != i) {
                  isSelectedContactIndex = i;
                  selectedContact = contactList[i];
                }
              });
            }));
  }
}
