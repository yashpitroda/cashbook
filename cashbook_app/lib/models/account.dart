

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
    required this.balance
  });

  Account.fromJSON({required Map<String, dynamic> jsonData}) {
    //json to obj
    accountId = jsonData["accountId"].toString();
    useremail = jsonData["useremail"].toString();
    accountName = jsonData["accountName"].toString();
    date = jsonData["date"];
    balance = jsonData["balance"].toString();
  }
  Map<String, dynamic> toJSON() {
    //obj to json
    final Map<String, dynamic> data = {};
    data["accountId"] = this.accountId;
    data["useremail"] = this.useremail;
    data["accountName"] = this.accountName;
    data["date"] = this.date;
    data["balance"] = this.balance;
    return data;
  }
}
