// class Account {
//   String? accountId;
//   String? accountName;
//   String? useremail;
//   DateTime? date;
//   String? balance;

//   Account({
//     required this.accountId,
//     required this.accountName,
//     required this.useremail,
//     required this.date,
//     required this.balance
//   });

//   Account.fromJSON({required Map<String, dynamic> jsonData}) {
//     //json to obj
//     accountId = jsonData["accountId"].toString();
//     useremail = jsonData["useremail"].toString();
//     accountName = jsonData["accountName"].toString();
//     date = jsonData["date"];
//     balance = jsonData["balance"].toString();
//   }
//   Map<String, dynamic> toJSON() {
//     //obj to json
//     final Map<String, dynamic> data = {};
//     data["accountId"] = this.accountId;
//     data["useremail"] = this.useremail;
//     data["accountName"] = this.accountName;
//     data["date"] = this.date;
//     data["balance"] = this.balance;
//     return data;
//   }
// }

import 'package:intl/intl.dart';

class Account {
  String? accountId;
  String? accountName;
  String? useremail;
  DateTime? date;
  String? balance;

  Account({
    required this.accountId,
    required this.accountName,
    required this.useremail,
    required this.date,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    final stirngToDateTmeFormatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');
    return Account(
      accountId: json['accountId'].toString(),
      accountName: json['accountName'].toString(),
      useremail: json['useremail'].toString(),
      date: stirngToDateTmeFormatter.parse(json["date"].toString()),
      balance: json['balance'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountName': accountName,
      'useremail': useremail,
      'date': date?.toIso8601String(),
      'balance': balance,
    };
  }

  @override
  String toString() {
    return 'Account(accountId: $accountId, accountName: $accountName, useremail: $useremail, date: $date, balance: $balance)';
  }

  Account copyWith({
    String? accountId,
    String? accountName,
    String? useremail,
    DateTime? date,
    String? balance,
  }) {
    return Account(
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      useremail: useremail ?? this.useremail,
      date: date ?? this.date,
      balance: balance ?? this.balance,
    );
  }
}
