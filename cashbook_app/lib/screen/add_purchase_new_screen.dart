import 'package:cashbook_app/provider/account_provider.dart';
import 'package:cashbook_app/provider/category_provider.dart';
import 'package:cashbook_app/screen_provider/add_purchase_new_screen_provider.dart';
import 'package:cashbook_app/services/constants.dart';
import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/supplier.dart';
import '../services/utility.dart';
import 'selectAccountScreen.dart';
import 'select_supplier_screen.dart';

class AddPurchaseNewScreen extends StatelessWidget {
  static const routeName = '/AddPurchaseNewScreen';
  static const oprationType = "purchase";

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController billamountController = TextEditingController();
  TextEditingController paidamountController = TextEditingController();

  bool _is_INSTANT_PAYMENT = true;
  bool _isCREDIT_ADVANCE = false;
  int c_cr = 0;

  AddPurchaseNewScreen({Key? key}) : super(key: key);

  void doEmptyAllController() {
    billamountController.text = "";
    paidamountController.text = "";
  }

  void resetProvider(BuildContext context) {
    //tap on back btn
    Provider.of<AccountProvider>(context, listen: false)
        .setSelectedAccountObj(accountObj: null);
    Provider.of<CategoryProvider>(context, listen: false)
        .setSelectedCategoryObj(categoryObj: null);
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .changeIsBill(newIsBill: true);
  }

  void firmNameHandler(BuildContext context) {
    //_gotoselectSupplierScreen
    Navigator.of(context)
        .pushNamed(SelectSupplierScreen.routeName,
            arguments: (Provider.of<AddPurchaseNewScreenProvider>(context,
                            listen: false)
                        .getSelectedSupplier ==
                    null)
                ? null
                : Provider.of<AddPurchaseNewScreenProvider>(context,
                        listen: false)
                    .getSelectedSupplier!
                    .sid)
        .then((value) {
      Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
          .addSelectSupplier(supplierobj: value as Supplier?);
      if (Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
              .getSelectedSupplier !=
          null) {
        firmNameController.text =
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .getSelectedSupplier!
                .firmname;
        supplierNameController.text =
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .getSelectedSupplier!
                .sname;
      } else {
        firmNameController.text = "";
        supplierNameController.text = "";
      }

      doEmptyAllController();
    });
  }

  Future<void> accountHandler(BuildContext ctx) async {
    await showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return const SelectAccountScreen(
            true,
            oprationType,
          );
        });
  }

  Future<void> categoryHandler(BuildContext ctx) async {
    await showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return const SelectAccountScreen(
            false,
            oprationType,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        doEmptyAllController();
        resetProvider(context);
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .addSelectSupplier(supplierobj: null);
        return true;
        // return await showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: const Text('Confirm Exit'),
        //     content: const Text('Are you sure you want to exit?'),
        //     actions: [
        //       ElevatedButton(
        //         child: const Text('No'),
        //         onPressed: () => Navigator.of(context).pop(false),
        //       ),
        //       OutlinedButton(
        //         child: const Text('Yes'),
        //         onPressed: () => Navigator.of(context).pop(true),
        //       ),
        //     ],
        //   ),
        // );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            //invoice type header
            const SizedBox(
              height: 3,
            ),
            Container(
              color: Theme.of(context).dialogBackgroundColor,
              child: Padding(
                // padding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding_8, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Invoice type",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    ),
                    Consumer<AddPurchaseNewScreenProvider>(
                      builder: (context, addPurchaseNewScreenProvider, child) {
                        return Row(
                          children: [
                            ChoiceChip(
                              backgroundColor: Theme.of(context).focusColor,
                              selectedColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.76),
                              label: Text(
                                'WITH BILL',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(),
                              ),
                              selected:
                                  addPurchaseNewScreenProvider.getIsBill ==
                                      true,
                              onSelected: (bool selected) {
                                addPurchaseNewScreenProvider.changeIsBill(
                                    newIsBill: true);
                                doEmptyAllController();
                                Utility.removeFocus(context: context);
                              },
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            ChoiceChip(
                              backgroundColor: Theme.of(context).focusColor,
                              selectedColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.76),
                              label: Text(
                                'CHALAN',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(),
                              ),
                              selected:
                                  addPurchaseNewScreenProvider.getIsBill ==
                                      false,
                              onSelected: (bool selected) {
                                addPurchaseNewScreenProvider.changeIsBill(
                                    newIsBill: false);
                                doEmptyAllController();
                                Utility.removeFocus(context: context);
                              },
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            //
            const SizedBox(
              height: 4,
            ),
            //account and cate
            Container(
              color: Theme.of(context).dialogBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding_8,
                    vertical: Constants.defaultPadding_8 / 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Account",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(),
                          ),
                          Card(
                            elevation: 1,
                            child: InkWell(
                              splashColor: Theme.of(context).focusColor,
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await accountHandler(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black45),
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Consumer<AccountProvider>(
                                      builder:
                                          (context, accountProvider, child) {
                                        return Flexible(
                                          child: Text(
                                            (accountProvider
                                                        .getSelectedAccountObj ==
                                                    null)
                                                ? "Select Account"
                                                : accountProvider
                                                    .getSelectedAccountObj!
                                                    .accountName
                                                    .toString(),
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(),
                                          ),
                                        );
                                      },
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      size: 26,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Category",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(),
                          ),
                          Card(
                            elevation: 1,
                            child: InkWell(
                              splashColor: Theme.of(context).focusColor,
                              borderRadius: BorderRadius.circular(5),
                              onTap: () async {
                                await categoryHandler(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black45),
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Consumer<CategoryProvider>(
                                      builder:
                                          (context, categoryProvider, child) {
                                        return Flexible(
                                          child: Text(
                                            (categoryProvider
                                                        .getSelectedcategoryObj ==
                                                    null)
                                                ? "Select Category"
                                                : categoryProvider
                                                    .getSelectedcategoryObj!
                                                    .categoryName,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(),
                                          ),
                                        );
                                      },
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      size: 26,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            const SizedBox(
              height: 4,
            ),
            //select clinet
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Constants.borderRadius_6))),
              elevation: 0.5,
              margin: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding_8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding_8 / 2,
                    vertical: Constants.defaultPadding_8 / 2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "party info",
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextField(
                      readOnly: true,
                      onTap: () {
                        firmNameHandler(context);
                      },
                      controller: firmNameController,
                      cursorColor: Colors.black,
                      // style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).hoverColor,
                        suffixIcon: const Icon(
                            Icons.arrow_right), //icon at tail of input
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        labelText: "Firm Name",
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsets.fromLTRB(
                            Constants.defaultPadding_8,
                            0,
                            Constants.defaultPadding_8,
                            0),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 2,
                    // ),
                    (Provider.of<AddPurchaseNewScreenProvider>(context)
                                .getSelectedSupplier ==
                            null)
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AddPurchaseNewScreenProvider>(
                                        context)
                                    .getSelectedSupplier!
                                    .sname,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),

                    (Provider.of<AddPurchaseNewScreenProvider>(context)
                                .getSelectedSupplier ==
                            null)
                        ? Container()
                        : (Provider.of<AddPurchaseNewScreenProvider>(context)
                                    .getIsBill ==
                                true)
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Constants.defaultPadding_6,
                                    vertical: 0),
                                child: Column(
                                  //withbill
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "(WITH BILL)",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Prepayment",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Consumer<AddPurchaseNewScreenProvider>(
                                          builder: (context,
                                              addPurchaseNewScreenProvider,
                                              child) {
                                            return (addPurchaseNewScreenProvider
                                                        .getSelectedSupplier ==
                                                    null)
                                                ? const Text("data")
                                                : Flexible(
                                                    child: Text(
                                                      Utility.convertToIndianCurrency(
                                                          sourceNumber:
                                                              addPurchaseNewScreenProvider
                                                                  .getSelectedSupplier!
                                                                  .advance_amount_with_bill,
                                                          decimalDigits: 2),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Palette
                                                                .greendarkColor,
                                                            // fontWeight:
                                                            //     FontWeight
                                                            //         .w600
                                                          ),
                                                    ),
                                                  );
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Unpaid",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Consumer<AddPurchaseNewScreenProvider>(
                                          builder: (context,
                                              addPurchaseNewScreenProvider,
                                              child) {
                                            return (addPurchaseNewScreenProvider
                                                        .getSelectedSupplier ==
                                                    null)
                                                ? const Text("data")
                                                : Flexible(
                                                    child: Text(
                                                      Utility.convertToIndianCurrency(
                                                          sourceNumber:
                                                              addPurchaseNewScreenProvider
                                                                  .getSelectedSupplier!
                                                                  .outstanding_amount_withbill,
                                                          decimalDigits: 2),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Palette
                                                                .redDarkColor,
                                                          ),
                                                    ),
                                                  );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Constants.defaultPadding_6,
                                    vertical: 0),
                                child: Column(
                                  //chalan
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "(CHALAN)",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Prepayment",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Consumer<AddPurchaseNewScreenProvider>(
                                          builder: (context,
                                              addPurchaseNewScreenProvider,
                                              child) {
                                            return (addPurchaseNewScreenProvider
                                                        .getSelectedSupplier ==
                                                    null)
                                                ? const Text("data")
                                                : Flexible(
                                                    child: Text(
                                                      Utility.convertToIndianCurrency(
                                                          sourceNumber:
                                                              addPurchaseNewScreenProvider
                                                                  .getSelectedSupplier!
                                                                  .advance_amount_without_bill,
                                                          decimalDigits: 2),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Palette
                                                                .greendarkColor,
                                                          ),
                                                    ),
                                                  );
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Unpaid",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Consumer<AddPurchaseNewScreenProvider>(
                                          builder: (context,
                                              addPurchaseNewScreenProvider,
                                              child) {
                                            return (addPurchaseNewScreenProvider
                                                        .getSelectedSupplier ==
                                                    null)
                                                ? Text("data")
                                                : Flexible(
                                                    child: Text(
                                                      Utility.convertToIndianCurrency(
                                                          sourceNumber:
                                                              addPurchaseNewScreenProvider
                                                                  .getSelectedSupplier!
                                                                  .outstanding_amount_without_bill,
                                                          decimalDigits: 2),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: Palette
                                                                .redDarkColor,
                                                          ),
                                                    ),
                                                  );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                  ],
                ),
              ),
            ),
            TextField(
              onChanged: (value) {
                String x = Provider.of<AddPurchaseNewScreenProvider>(context,
                        listen: false)
                    .onChangedInINSTANT_PAYMENT(value: value);
                paidamountController.text = x;
              },
              controller: billamountController,
              cursorColor: Colors.black,
              // style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).hoverColor,
                suffixIcon:
                    const Icon(Icons.arrow_right), //icon at tail of input
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                labelText: "Firm Name",
                labelStyle: Theme.of(context).textTheme.labelMedium,
                contentPadding: const EdgeInsets.fromLTRB(
                    Constants.defaultPadding_8,
                    0,
                    Constants.defaultPadding_8,
                    0),
              ),
            ),
            Container(
                // width: mqwidth * 1,
                child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(children: [
                      Tabs(context),
                    ]))),
            Text(paidamountController.text),
            Text(Provider.of<AddPurchaseNewScreenProvider>(context)
                .getAdvanceAmount),
            Text(Provider.of<AddPurchaseNewScreenProvider>(context)
                .getOutstandingAmount),
          ],
        ),
      ),
    );
  }

  Widget Tabs(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(208, 229, 231, 236)),
      child: TabBar(
        onTap: (value) {
          doEmptyAllController();
          Utility.removeFocus(context: context);
          if (value == 0) {
            c_cr = 0;
            _is_INSTANT_PAYMENT = true;
            _isCREDIT_ADVANCE = false;
          }
          if (value == 1) {
            c_cr = 1;
            _is_INSTANT_PAYMENT = false;
            _isCREDIT_ADVANCE = true;
          }
        },
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.shade500),
        tabs: const [
          Tab(
            child: Text(
              'INSTANT PAYMENT',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Tab(
            child: Text(
              'CREDIT/ADVANCE',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
