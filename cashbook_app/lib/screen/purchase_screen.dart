import 'package:cashbook_app/screen/add_purchase_new_screen.dart';
import 'package:cashbook_app/screen/purchase_analitics_screeen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/services/utility.dart';

import '../services/constants.dart';
import '../services/date_time_utill.dart';
import '../services/provider_utill.dart';
import '../services/widget_component_utill.dart';
import '../widgets/purchase_card.dart';
import '../widgets/purchase_screen_header.dart';

class PurchaseScreen extends StatelessWidget {
  static const routeName = '/PurchaseScreen';
  final ScrollController _scrollcontroller = ScrollController();
  PurchaseScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchases"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(PurchaseAnalyticsScreeen.routeName);
            },
            icon: Icon(Icons.menu_book_outlined),
          )
        ],
      ),
      body: FutureBuilder(
          future: Future.wait([
            Provider.of<SupplierProvider>(context, listen: false)
                .fatchSupplier()
                .then((_) async {
              await Provider.of<PurchaseProvider>(context, listen: false)
                  .fatchPurchase();
            }),
          ]),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Provider.of<PurchaseProvider>(context, listen: false);

              return RefreshIndicator(
                onRefresh: () async {
                  await UtillProvider.refreshSupplier(context).then((_) async {
                    await UtillProvider.refreshPurchase(context);
                  });
                },
                child: Stack(
                  children: [
                    Scrollbar(
                      child: SingleChildScrollView(
                        controller: _scrollcontroller,
                        child: Column(
                          children: [
                            Card(
                              elevation: 1.5,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Constants.borderRadius_6 / 2))),
                              margin: const EdgeInsets.symmetric(
                                  horizontal:
                                      (Constants.defaultPadding_8) * 1.5,
                                  vertical: Constants.defaultPadding_8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Constants.defaultPadding_6),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Constants.defaultPadding_8 * 2,
                                          vertical:
                                              Constants.defaultPadding_6 / 3),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 4, child: Container()),
                                          Expanded(
                                            flex: 8,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "(WITH BILL)",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark),
                                                ),
                                                Text(
                                                  "(CHALAN)",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColorDark),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 6,
                                    ),
                                    TitleAndTitleValueRow(
                                        title: "Invoiced",
                                        titleValue1:
                                            Provider.of<PurchaseProvider>(
                                                    context)
                                                .getWithBillPurchase,
                                        titleValue2:
                                            Provider.of<PurchaseProvider>(
                                                    context)
                                                .getChalanPurchase,
                                        color: null),
                                    TitleAndTitleValueRow(
                                        title: "Paid",
                                        titleValue1:
                                            Provider.of<PurchaseProvider>(
                                                    context)
                                                .getWithBillPaid,
                                        titleValue2:
                                            Provider.of<PurchaseProvider>(
                                                    context)
                                                .getChalanPaid,
                                        color: null),
                                  ],
                                ),
                              ),
                            ),
                            Consumer<PurchaseProvider>(
                              builder: (context, purchaseProvider, child) {
                                return (purchaseProvider.getPurchaseList ==
                                        null)
                                    ? const Center(
                                        child: Text(
                                            "Press Add purchase to add new purchase"),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: purchaseProvider
                                            .getPurchaseList!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              (((index > 0) &&
                                                      (UtillDatetime.checkIsSameDay(
                                                          souceDateTime_1:
                                                              purchaseProvider
                                                                  .getPurchaseList![
                                                                      index]
                                                                  .date,
                                                          souceDateTime_2:
                                                              purchaseProvider
                                                                  .getPurchaseList![
                                                                      index - 1]
                                                                  .date))))
                                                  ? const SizedBox(
                                                      height: 8,
                                                    )
                                                  : Container(
                                                      color: Colors.transparent,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              bottom: 4),
                                                      height: 34,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            UtillDatetime.returnDateMounthAndYear(
                                                                souceDateTime:
                                                                    purchaseProvider
                                                                        .getPurchaseList![
                                                                            index]
                                                                        .date),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption!
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ],
                                                      )),
                                              PurchaseCard(
                                                purchaseObj: purchaseProvider
                                                    .getPurchaseList![index],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              },
                            ),
                            const SizedBox(
                              height: 86,
                            )
                          ],
                        ),
                      ),

                      // child: StickyGroupedListView<Purchase, DateTime>(
                      //   // physics: NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   elements: purchaselist,
                      //   groupBy: (element) {
                      //     return DateUtils.dateOnly(element.date);
                      //   },
                      //   groupSeparatorBuilder: (value) =>
                      //       Text(Utility.dateFormat_DDMMYYYY().format(value.date)),
                      //   itemBuilder: (context, dynamic element) =>
                      //       Container(height: 200, child: Card(child: Text(element.pid))),
                      //   // itemComparator: (e1, e2) => e1['name'].compareTo(e2['name']), // optional
                      //   // elementIdentifier: (element) => element.name // optional - see below for usage
                      //   // itemScrollController: itemScrollController, // optional
                      //   // order: StickyGroupedListOrder.ASC, // optional
                      // ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: bottomButtonCard(context),
                    )
                  ],
                ),
              );
            } else {
              return UtillComponent.loadingIndicator();
            }
          })),
    );
  }

  Container bottomButtonCard(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      child: Column(
        children: [
          const Divider(
            thickness: 1.3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                      onPressed: () {
                        Utill.scrollUp(
                            customScrollController: _scrollcontroller);
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(10, 55),
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.black,
                      )),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddPurchaseNewScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(10, 55),
                    ),
                    child: Text(
                      'Add purchase',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
