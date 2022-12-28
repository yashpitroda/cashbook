import 'package:cashbook_app/utill/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/client_contact.dart';

class ClientContactProvider with ChangeNotifier {
  // ------------------------------initialization-----------------------------------
  // User? currentUser = FirebaseAuth.instance.currentUser!; //this is not use here // it is passes from frentend fuction
  List<ClientContact> _clientContactList = [];
  List<ClientContact> _storedContactList =
      []; //for backup of _clientContactList --

  // ------------------------------getter-----------------------------------
  List<ClientContact> get clientContactList {
    return [..._clientContactList];
  }

// ------------------------------filterSearchResults-----------------------------------
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<ClientContact> matchDataWithQueryList =
          []; //foundedDataList -- mached data from query

      //use foreach-- method 1
      // _storedContactList.forEach((item) {
      //   if (item.cname.contains(query)) {
      //     dummyListData.add(item);

      //     // print(dummyListData);
      //   } else if (item.cmobileno.toString().contains(query)) {
      //     dummyListData.add(item);
      //   }
      // });

      // or
      matchDataWithQueryList = _storedContactList.where((item) {
        return item.cname.contains(query) ||
            item.cmobileno.toString().contains(query) ||
            item.fermname.toString().contains(query);
      }).toList();
      // _clientContactList.clear();
      // _clientContactList.addAll(dummyListData); //it is not right way
      _clientContactList = matchDataWithQueryList; //right way //
      notifyListeners();
    } else {
      //if query is empty  then _storedContactList add to _clientContactList
      _clientContactList = _storedContactList; //right way
      notifyListeners();
    }
  }

// ------------------------------fatchCilentContact-----------------------------------
  Future<void> fatchCilentContact({required useremail}) async {
    print("hahs");
    final url = Uri.parse(Utility.BASEURL + "/fetchclient");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'useremail': useremail,
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    // print(responseData);
    List responseContactDataList = responseData['datalist']; //[{},{},{}]
    final List<ClientContact> loadedClientOrderlist = [];

    // Wed, 28 Dec 2022 13:34:09 GMT //element['entrydatetime'] -- hold this type of formate --this formate coming form flask server
    final stirngToDateTmeFormatter =
        DateFormat('EEE, d MMM yyyy HH:mm:ss'); // Wed, 28 Dec 2022 13:34:09 GMT

    responseContactDataList.forEach((element) {
      loadedClientOrderlist.add(ClientContact(
        cid: element['cid'].toString(),
        cemail: element["email"], //if it will null or string
        fermname: element['fermname'].toString(),
        cname: element['cname'].toString(),
        cmobileno: element['cmobileno'].toString(),
        entrydatetime: stirngToDateTmeFormatter.parse(element[
            'entrydatetime']), //element['entrydatetime'] is alreeady in string
      ));
    });
    _clientContactList = loadedClientOrderlist;
    _storedContactList = _clientContactList; //for backup in searching

    notifyListeners();
  }

// ------------------------------addNewClient-----------------------------------
  Future<void> addNewClient({required Map newClientContactMap}) async {
    print(newClientContactMap['useremail']);
    final url = Uri.parse(Utility.BASEURL + "/clientadd");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "cname": newClientContactMap['cname'],
          "fermname": newClientContactMap['fermname'],
          "cmobileno": newClientContactMap['cmobileno'],
          "cemail": newClientContactMap['cemail'],
          'useremail': newClientContactMap['useremail'],
          'entrydatetime': newClientContactMap['entrydatetime']
        },
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    final responseData = json.decode(response.body);
    print(responseData);
    fatchCilentContact(useremail: newClientContactMap['useremail']);
  }

  Future<void> deleteClient(
      {required String cmobileno, required String useremail}) async {
    final url = Uri.parse(Utility.BASEURL + "/clientdelete");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {"cmobileno": cmobileno, "useremail": useremail},
      ),
    );
    if (response.body == 'null') {
      print('its products retruns data is not avalible in firebase server');
      return;
    }
    fatchCilentContact(useremail: useremail);
    print("detetion done");
  }
}
