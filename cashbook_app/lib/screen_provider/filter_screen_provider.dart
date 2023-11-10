import 'package:flutter/material.dart';

enum Filter { date, supplier, paymentMode, category }

class FilterScreenProvider with ChangeNotifier {
  get dateValue {
    return Filter.date.name;
  }

  get dateIndex {
    return Filter.date.index.toString();
  }

  get supplierValue {
    return Filter.supplier.name;
  }

  get supplierIndex {
    return Filter.supplier.index.toString();
  }

  get paymentModeValue {
    return Filter.paymentMode.name;
  }

  get paymentModeIndex {
    return Filter.paymentMode.index.toString();
  }

  get categoryModeValue {
    return Filter.category.name;
  }

  get categoryModeIndex {
    return Filter.category.index.toString();
  }

  final List<Map<dynamic,dynamic>> _dateList = [
  // {"today":,},
  ];
  // "yesterday",
  //   "this month",
  //   "last month",
  //   "this year",
  //   "last year"

  get getDateList {
    return [..._dateList];
  }
}
