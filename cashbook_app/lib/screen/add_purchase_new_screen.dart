import 'package:cashbook_app/provider/account_provider.dart';
import 'package:cashbook_app/provider/category_provider.dart';
import 'package:cashbook_app/screen_provider/add_purchase_new_screen_provider.dart';
import 'package:cashbook_app/services/constants.dart';
import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/supplier.dart';
import '../provider/purchase_provider.dart';
import '../provider/supplier_provider.dart';
import '../widgets/dashed_line_painter.dart';
import '../services/utility.dart';
import '../services/widget_component_utill.dart';
import 'selectAccountScreen.dart';
import 'select_supplier_screen.dart';

class AddPurchaseNewScreen extends StatelessWidget {
  static const routeName = '/AddPurchaseNewScreen';
  static const oprationType = "purchase";

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  TextEditingController billamountController = TextEditingController();
  TextEditingController paidamountController = TextEditingController();

  AddPurchaseNewScreen({Key? key}) : super(key: key);

  Future<void> sumbitHandler(BuildContext context) async {
    Utill.removeFocus(context: context);

    //check
    if (Provider.of<AccountProvider>(context, listen: false)
            .getSelectedAccountObj ==
        null) {
      UtillComponent.displaysnackbar(
          context: context, message: "Select account");
      return;
    }
    if (Provider.of<CategoryProvider>(context, listen: false)
            .getSelectedcategoryObj ==
        null) {
      UtillComponent.displaysnackbar(
          context: context, message: "Select category");
      return;
    }
    if (Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getSelectedSupplier ==
        null) {
      UtillComponent.displaysnackbar(
          context: context, message: "Select supplier");
      return;
    }
    if (firmNameController.text.isEmpty) {
      UtillComponent.displaysnackbar(
          context: context, message: "Select firm first");
      return;
    }
    if (billamountController.text.isEmpty) {
      UtillComponent.displaysnackbar(
          context: context, message: "Enter bill-amount first");
      return;
    }
    if (Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getIsCreditAdvance &&
        paidamountController.text.isEmpty) {
      UtillComponent.displaysnackbar(
          context: context, message: "Enter paid-amount first");
      return;
    }
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .changeIsLoadingOnSubmit(newIsLoadingOnSubmit: true);
    //gather data
    Supplier supplierobj =
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getSelectedSupplier!;
    int cCr = Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .getIsC_cr;
    int isBillValue =
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .getIsBill
            ? 1
            : 0;

    String advanceAmount =
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getAdvanceAmount;
    String outstandingAmount =
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getOutstandingAmount;
    String categoryid = Provider.of<CategoryProvider>(context, listen: false)
        .getSelectedcategoryObj!
        .categoryId;
    String accountid = Provider.of<AccountProvider>(context, listen: false)
        .getSelectedAccountObj!
        .accountId
        .toString();

    //request
    try {
      await Provider.of<PurchaseProvider>(context, listen: false)
          .submit_IN_Purchase(
              categoryId: categoryid,
              isBill: isBillValue,
              cOrCr: cCr,
              accountId: accountid,
              selectedSupplierobj: supplierobj,
              billAmount: int.parse(billamountController.text),
              paidAmount: int.parse(paidamountController.text),
              updatedAdavanceAmount: int.parse(advanceAmount),
              updatedOutstandingAmount: int.parse(outstandingAmount),
              remark: remarkController.text,
              finaldateTime: DateTime.now())
          .then((_) {
        Navigator.of(context).pop();
        resetProvider(context);
        doEmptyAllController(context);
        Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .changeIsLoadingOnSubmit(newIsLoadingOnSubmit: false);
      });
    } catch (e) {
      print(e);
      await showDialog(
          // showDialog is also future fuction
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text('A error occurred!'),
              content: Text('somethings wents wrong.($e)'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Okey"),
                ),
              ],
            );
          });
    }
  }

  void doEmptyAllController(BuildContext context) {
    billamountController.text = "";
    paidamountController.text = "";
    if (Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
            .getIsOnlySettle ==
        true) {
      billamountController.text = "0";
    }
  }

  void onTapOn_onlyOutstanding(BuildContext context) {
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .changeIsOnlySettle();
    doEmptyAllController(context);
  }

  void resetProvider(BuildContext context) {
    //tap on back btn
    print("resetProvider call");
    Provider.of<AccountProvider>(context, listen: false)
        .setSelectedAccountObj(accountObj: null);
    Provider.of<CategoryProvider>(context, listen: false)
        .setSelectedCategoryObj(categoryObj: null);
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .changeIsBill(newIsBill: true);
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .addSelectSupplier(supplierobj: null);
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .resetIsOnlySettle();
    // Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
    //     .changeIsLoadingOnSubmit(newIsLoadingOnSubmit: false);
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

      doEmptyAllController(context);
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

  Future<void> onWillPopHandler(BuildContext context) async {
    Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
        .changeIsLoadingOnSubmit(newIsLoadingOnSubmit: true);
    await Provider.of<SupplierProvider>(context, listen: false)
        .fatchSupplier()
        .then((_) {
      Provider.of<PurchaseProvider>(context, listen: false).fatchPurchase();
    }).then((_) {
      doEmptyAllController(context);
      resetProvider(context);
      Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
          .changeIsLoadingOnSubmit(newIsLoadingOnSubmit: false);
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await onWillPopHandler(context);
        return false;
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
        appBar: AppBar(
          title: const Text("Add Purchase"),
        ),
        body: Column(
          children: [
            Expanded(
              child: (Provider.of<AddPurchaseNewScreenProvider>(context)
                      .getIsLoadingOnSubmit)
                  ? UtillComponent.loadingIndicator()
                  : bodyContent(context),
            ),
            // Align(
            //     alignment: AlignmentDirectional.bottomEnd,
            //     child: bottombuttoncard(context))
            // ,
            bottombuttoncard(context)
          ],
        ),
      ),
    );
  }

  SingleChildScrollView bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          invoiceTypeHeader(context),
          const SizedBox(
            height: 8,
          ),
          accountAndCategoryCard(context),
          const SizedBox(
            height: 8,
          ),
          selectSuppilerCard(context),
          const SizedBox(
            height: 8,
          ),
          Container(
            color: Theme.of(context).dialogBackgroundColor,
            child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding_6 * 2),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Tabs(context),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 110,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          instantPaymentTabView(context),
                          creditAdvanceTabView(context),
                        ],
                      ),
                    ),
                  ]),
                )),
          ),
          const SizedBox(
            height: 8,
          ),
          reamrkCard(context),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Container reamrkCard(BuildContext context) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding_8,
            vertical: Constants.defaultPadding_8),
        // padding: EdgeInsets.only(
        //     left: 10,
        //     right: 10,
        //     top: 10,
        //     bottom: MediaQuery.of(context).viewInsets.bottom +
        //         20 //for device keybord title and amount will show
        //     ),
        child: TextField(
          controller: remarkController,
          cursorColor: Colors.black,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).dialogBackgroundColor,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            labelText: "Remark",
            labelStyle: Theme.of(context).textTheme.labelMedium,
            contentPadding: const EdgeInsets.fromLTRB(
                Constants.defaultPadding_8, 0, Constants.defaultPadding_8, 0),
          ),
        ),
      ),
    );
  }

  Card selectSuppilerCard(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Constants.borderRadius_6))),
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding_6 * 2),
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
              height: 8,
            ),
            TextField(
              readOnly: true,
              onTap: () {
                firmNameHandler(context);
              },
              controller: firmNameController,
              cursorColor: Colors.black,
              style: Theme.of(context).textTheme.bodyMedium,
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
            const SizedBox(
              height: 1,
            ),
            (Provider.of<AddPurchaseNewScreenProvider>(context)
                        .getSelectedSupplier ==
                    null)
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<AddPurchaseNewScreenProvider>(context)
                            .getSelectedSupplier!
                            .sname,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
            const Divider(),
            (Provider.of<AddPurchaseNewScreenProvider>(context)
                        .getSelectedSupplier ==
                    null)
                ? Container()
                : Consumer<AddPurchaseNewScreenProvider>(
                    builder: (context, addPurchaseNewScreenProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding_6,
                            vertical: 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  addPurchaseNewScreenProvider.getIsBill == true
                                      ? "(WITH BILL)"
                                      : "(CHALAN)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                )
                              ],
                            ),
                            //prepayment
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prepayment",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Flexible(
                                  child: Text(
                                    Utill.convertToIndianCurrency(
                                        sourceNumber:
                                            addPurchaseNewScreenProvider
                                                .getAdvanceAmount,
                                        decimalDigits: 2),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Palette.greendarkColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            //unpaid
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Unpaid",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Flexible(
                                  child: Text(
                                    Utill.convertToIndianCurrency(
                                        sourceNumber:
                                            addPurchaseNewScreenProvider
                                                .getOutstandingAmount,
                                        decimalDigits: 2),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Palette.redDarkColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }

  Container accountAndCategoryCard(BuildContext context) {
    return Container(
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
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(),
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
                            border: Border.all(width: 1, color: Colors.black45),
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<AccountProvider>(
                              builder: (context, accountProvider, child) {
                                return Flexible(
                                  child: Text(
                                    (accountProvider.getSelectedAccountObj ==
                                            null)
                                        ? "Select Account"
                                        : accountProvider
                                            .getSelectedAccountObj!.accountName
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
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(),
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
                            border: Border.all(width: 1, color: Colors.black45),
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer<CategoryProvider>(
                              builder: (context, categoryProvider, child) {
                                return Flexible(
                                  child: Text(
                                    (categoryProvider.getSelectedcategoryObj ==
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
    );
  }

  Container invoiceTypeHeader(BuildContext context) {
    return Container(
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
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.76),
                      label: Text(
                        'WITH BILL',
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(),
                      ),
                      selected: addPurchaseNewScreenProvider.getIsBill == true,
                      onSelected: (bool selected) {
                        addPurchaseNewScreenProvider.changeIsBill(
                            newIsBill: true);
                        doEmptyAllController(context);
                        Utill.removeFocus(context: context);
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ChoiceChip(
                      backgroundColor: Theme.of(context).focusColor,
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.76),
                      label: Text(
                        'CHALAN',
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(),
                      ),
                      selected: addPurchaseNewScreenProvider.getIsBill == false,
                      onSelected: (bool selected) {
                        addPurchaseNewScreenProvider.changeIsBill(
                            newIsBill: false);
                        doEmptyAllController(context);
                        Utill.removeFocus(context: context);
                      },
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Column creditAdvanceTabView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(flex: 9, child: Container()),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      checkColor: Colors.white,
                      value: Provider.of<AddPurchaseNewScreenProvider>(
                        context,
                      ).getIsOnlySettle,
                      onChanged: (bool? value) {
                        onTapOn_onlyOutstanding(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      onTapOn_onlyOutstanding(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Settle Up Past Due",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
                flex: 9,
                child: Text(
                  "Bill Amount",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Expanded(
              flex: 6,
              child: CustomPaint(
                painter:
                    DashedLinePainter(color: Theme.of(context).primaryColor),
                child: TextField(
                  enabled: !Provider.of<AddPurchaseNewScreenProvider>(
                    context,
                  ).getIsOnlySettle,
                  onChanged: (value) {
                    Provider.of<AddPurchaseNewScreenProvider>(context,
                            listen: false)
                        .onChangedInCREDIT(
                            billAmount: billamountController.text,
                            paidAmount: paidamountController.text);
                  },
                  keyboardType: TextInputType.phone,
                  controller: billamountController,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.right,
                  cursorHeight: 16,
                  cursorWidth: 1.4,
                  style: Theme.of(context).textTheme.labelLarge,
                  decoration: InputDecoration(
                    border:
                        InputBorder.none, // Remove the default underline border
                    isCollapsed: true,
                    filled: true,
                    fillColor: Theme.of(context).dialogBackgroundColor,
                    prefixIconConstraints:
                        BoxConstraints.tight(const Size(18, 18)),
                    prefixIcon: const Icon(
                      Icons.currency_rupee_rounded,
                      size: 17,
                    ),
                    // border: const OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(
                    //       Radius.circular(4)),
                    // ),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.defaultPadding_8 / 4,
                        2,
                        Constants.defaultPadding_8 / 4,
                        2),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                flex: 9,
                child: Text(
                  "Paid Amount",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Expanded(
              flex: 6,
              child: CustomPaint(
                painter:
                    DashedLinePainter(color: Theme.of(context).primaryColor),
                child: TextField(
                  onChanged: (value) {
                    if (Provider.of<AddPurchaseNewScreenProvider>(context,
                                listen: false)
                            .getIsOnlySettle ==
                        true) {
                      billamountController.text = "0";
                    }
                    Provider.of<AddPurchaseNewScreenProvider>(context,
                            listen: false)
                        .onChangedInCREDIT(
                            billAmount: billamountController.text,
                            paidAmount: paidamountController.text);
                  },
                  keyboardType: TextInputType.phone,
                  controller: paidamountController,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.right,
                  cursorHeight: 16,
                  cursorWidth: 1.4,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).indicatorColor,
                      ),
                  decoration: InputDecoration(
                    border:
                        InputBorder.none, // Remove the default underline border
                    isCollapsed: true,
                    filled: true,
                    fillColor: Theme.of(context).dialogBackgroundColor,
                    prefixIconConstraints:
                        BoxConstraints.tight(const Size(18, 18)),
                    prefixIcon: Icon(
                      Icons.currency_rupee_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 17,
                    ),
                    // border: const OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(
                    //       Radius.circular(4)),
                    // ),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.defaultPadding_8 / 4,
                        2,
                        Constants.defaultPadding_8 / 4,
                        2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column instantPaymentTabView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
                flex: 9,
                child: Text(
                  "Bill Amount",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Expanded(
              flex: 6,
              child: CustomPaint(
                painter:
                    DashedLinePainter(color: Theme.of(context).primaryColor),
                child: TextField(
                  onChanged: (value) {
                    String x = Provider.of<AddPurchaseNewScreenProvider>(
                            context,
                            listen: false)
                        .onChangedInINSTANT_PAYMENT(value: value);
                    paidamountController.text = x;
                  },
                  keyboardType: TextInputType.phone,
                  controller: billamountController,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.right,
                  cursorHeight: 16,
                  cursorWidth: 1.4,
                  style: Theme.of(context).textTheme.labelLarge,
                  decoration: InputDecoration(
                    border:
                        InputBorder.none, // Remove the default underline border
                    isCollapsed: true,
                    filled: true,
                    fillColor: Theme.of(context).dialogBackgroundColor,
                    prefixIconConstraints:
                        BoxConstraints.tight(const Size(18, 18)),
                    prefixIcon: const Icon(
                      Icons.currency_rupee_rounded,
                      size: 17,
                    ),
                    // border: const OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(
                    //       Radius.circular(4)),
                    // ),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.defaultPadding_8 / 4,
                        2,
                        Constants.defaultPadding_8 / 4,
                        2),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
                flex: 9,
                child: Text(
                  "Paid Amount",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Expanded(
              flex: 6,
              child: CustomPaint(
                painter: DashedLinePainter(color: Theme.of(context).focusColor),
                child: TextField(
                  enabled: false,
                  keyboardType: TextInputType.phone,
                  controller: paidamountController,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.right,
                  cursorHeight: 16,
                  cursorWidth: 1.4,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).indicatorColor,
                      ),
                  decoration: InputDecoration(
                    border:
                        InputBorder.none, // Remove the default underline border
                    isCollapsed: true,
                    filled: true,
                    fillColor: Theme.of(context).dialogBackgroundColor,
                    prefixIconConstraints:
                        BoxConstraints.tight(const Size(18, 18)),
                    prefixIcon: Icon(
                      Icons.currency_rupee_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 17,
                    ),
                    // border: const OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(
                    //       Radius.circular(4)),
                    // ),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    contentPadding: const EdgeInsets.fromLTRB(
                        Constants.defaultPadding_8 / 4,
                        2,
                        Constants.defaultPadding_8 / 4,
                        2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container bottombuttoncard(
    BuildContext context,
  ) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding_6 * 2, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              thickness: 1.3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        (Provider.of<AddPurchaseNewScreenProvider>(context)
                                .getIsLoadingOnSubmit)
                            ? null
                            : () async {
                                await onWillPopHandler(context);
                              },
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(10, 55),
                      backgroundColor: Palette.redColor,
                      disabledBackgroundColor: Theme.of(context).disabledColor,
                    ),
                    child: Text('Cancel',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).dialogBackgroundColor)
                        // style:
                        ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        (Provider.of<AddPurchaseNewScreenProvider>(context)
                                .getIsLoadingOnSubmit)
                            ? null
                            : () async {
                                await sumbitHandler(
                                  context,
                                );
                              },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(10, 55),
                      disabledBackgroundColor: Theme.of(context).disabledColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Save',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .dialogBackgroundColor)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget Tabs(BuildContext context) {
    return Container(
      width: 320,
      height: 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(208, 229, 231, 236)),
      child: TabBar(
        onTap: (value) {
          Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
              .resetIsOnlySettle();
          doEmptyAllController(context);
          Utill.removeFocus(context: context);
          if (value == 0) {
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .updateOutAdv();
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsC_Cr(newIsC_Cr: 0);
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsCreditAdvance(newIsCreditAdvance: false);
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsInstantPayment(newIsInstantPayment: true);
          }
          if (value == 1) {
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .updateOutAdv();
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsC_Cr(newIsC_Cr: 1);
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsCreditAdvance(newIsCreditAdvance: true);
            Provider.of<AddPurchaseNewScreenProvider>(context, listen: false)
                .changeIsInstantPayment(newIsInstantPayment: false);
          }
        },
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).primaryColor.withOpacity(0.85)),
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
