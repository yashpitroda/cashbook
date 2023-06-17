import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtillDatetime {
  static bool checkIsSameDay(
      {required DateTime souceDateTime_1, required DateTime souceDateTime_2}) {
    return DateUtils.isSameDay(souceDateTime_1, souceDateTime_2);
  }

  static String returnMonth({required DateTime date}) {
    return DateFormat.MMMM().format(date);
  }

  static String returnDDMMYY({required DateTime souceDateTime}) {
    return DateFormat('dd/MM/yyyy').format(souceDateTime);
  }

  static String datetimeToTimeAmPm({required DateTime souceDateTime}) {
    return DateFormat('hh:mm a').format(souceDateTime);
  }

  static String returnDateAndMounth({required DateTime souceDateTime}) {
    return DateFormat('dd MMM').format(souceDateTime);
  }

  static String returnDateMounthAndYear({required DateTime souceDateTime}) {
    return DateFormat('dd MMMM yyyy').format(souceDateTime);
  }

  static DateTime convertDatetimeToDateOnly({required DateTime souceDateTime}) {
    return DateUtils.dateOnly(souceDateTime);
  }
}