// import 'dart:convert';

// import 'package:cashbook_app/models/current_user.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../utill/utility.dart';

// class CurrentUserProvider with ChangeNotifier {
//   CurrentUser? _currentUserObj;
//   CurrentUser? get getCurrentUserObj {
//     return _currentUserObj ?? null;
//   }

//   // // ------------------------------findClientContactByCID-----------------------------------
//   // CurrentUser findSupplierBySID({required String sid}) {
//   //   return _supplierList.firstWhere((element) {
//   //     return element.sid == sid;
//   //   });
//   // }
//   Future<void> fatchCurrentuserInfo() async {
//     print("fatchCurrentInfo is call");
//     final url = Uri.parse(Utility.BASEURL + "/users/currentuser");
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: json.encode(
//         {
//           'useremail': Utility.getCurrentUserEMAILID(),
//         },
//       ),
//     );
//     if (response.body == 'null') {
//       return;
//     }
//     final responseData = json.decode(response.body);
//     Map<String, dynamic> currentUserMap = responseData['data'];
//     CurrentUser tempCurrentUserObj =
//         CurrentUser.fromJSON(jsonData: currentUserMap); //json to obj
//     _currentUserObj = tempCurrentUserObj;
//     notifyListeners();
//   }
// }
