
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/purchase_provider.dart';
import '../provider/supplier_provider.dart';

class ProviderUtill {
  static void searchInSupplierListInProvider(
      String value, BuildContext context) {
    Provider.of<SupplierProvider>(context, listen: false)
        .filterSearchResults(query: value);
  }

  static Future<void> refreshSupplier(BuildContext context) async {
    await Provider.of<SupplierProvider>(context, listen: false).fatchSupplier();
  }

  static Future<void> refreshPurchase(BuildContext context) async {
    await Provider.of<PurchaseProvider>(context, listen: false).fatchPurchase();
  }
}