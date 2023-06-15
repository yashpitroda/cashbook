import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/services/utility.dart';

import '../services/date_time_utill.dart';
import '../services/provider_utill.dart';
import '../services/widget_component_utill.dart';
import '../widgets/purchase_card.dart';
import '../widgets/purchase_screen_header.dart';
import 'add_update_purchase_screen.dart';

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
        title: const Text("purchase"),
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
                  await ProviderUtill.refreshSupplier(context).then((_) async {
                    await ProviderUtill.refreshPurchase(context);
                  });
                },
                child: Stack(
                  children: [
                    Scrollbar(
                      child: SingleChildScrollView(
                        controller: _scrollcontroller,
                        child: Column(
                          children: [
                            // Padding(
                            // padding: const EdgeInsets.symmetric(
                            //     vertical: Constants.defaultPadding_6),
                            // child:
                            // Card(
                            //   margin: const EdgeInsets.symmetric(
                            //       horizontal:
                            //           Constants.defaultPadding_6 / 3,
                            //       vertical: 0),
                            //   elevation: 2,
                            //   shape: const RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.only(
                            //           bottomRight: Radius.circular(
                            //               Constants.borderRadius_6 * 2),
                            //           bottomLeft: Radius.circular(
                            //               Constants.borderRadius_6 * 2))),
                            //   child: Column(
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal:
                            //                 Constants.defaultPadding_8 *
                            //                     2,
                            //             vertical:
                            //                 Constants.defaultPadding_6),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               "Outstanding",
                            //               maxLines: 1,
                            //               overflow: TextOverflow.ellipsis,
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .labelMedium!
                            //                   .copyWith(
                            //                     fontSize: 16,
                            //                     // color: Colors.red
                            //                   ),
                            //             ),
                            //             Flexible(
                            //               child: Text(
                            //                 "\u{20B9} ${Utility.convertToIndianCurrency(sourceNumber: Provider.of<PurchaseProvider>(context).totalDue, decimalDigits: 2)}",
                            //                 maxLines: 1,
                            //                 overflow:
                            //                     TextOverflow.ellipsis,
                            //                 style: Theme.of(context)
                            //                     .textTheme
                            //                     .labelLarge!
                            //                     .copyWith(
                            //                         color: Colors
                            //                             .red.shade700,
                            //                         fontSize: 14,
                            //                         fontWeight:
                            //                             FontWeight.w600),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // // ),
                            // const SizedBox(
                            //   height: Constants.defaultPadding_6,
                            // ),
                            // WidgetComponentUtill.divider(1.4),
                            PurchaseScreenHeaderCard(
                              title1: "Purchase",
                              title2: "paid",
                              title1Value:
                                  Provider.of<PurchaseProvider>(context)
                                      .totalPurchase,
                              title2Value:
                                  Provider.of<PurchaseProvider>(context)
                                      .totalPaid,
                            ),
                            Consumer<PurchaseProvider>(
                              builder: (context, purchaseProvider, child) {
                                print("fgfg");
                                print(purchaseProvider.getPurchaseList == null);
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
                                                      (DateTimeUtill.checkIsSameDay(
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
                                                            DateTimeUtill.returnDateMounthAndYear(
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
              return WidgetComponentUtill.loadingIndicator();
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
                        Utility.scrollUp(
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
                          .pushNamed(AddUpdatePurchaseScreen.routeName);
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
