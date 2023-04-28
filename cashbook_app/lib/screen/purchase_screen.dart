import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/services/utility.dart';

import '../services/date_time_utill.dart';
import '../services/provider_utill.dart';
import '../services/widget_component_utill.dart';
import '../widgets/purchase_card.dart';
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
              final purchaselist =
                  Provider.of<PurchaseProvider>(context).getPurchaseList;
              return RefreshIndicator(
                onRefresh: () async {
                  await ProviderUtill.refreshSupplier(context).then((_) async {
                    await ProviderUtill.refreshPurchase(context);
                  });
                },
                child: Stack(
                  children: [
                    (purchaselist.isEmpty)
                        ? const Center(
                            child: Text("Empty List"),
                          )
                        : Scrollbar(
                            child: SingleChildScrollView(
                              controller: _scrollcontroller,
                              child: Column(
                                children: [
                                  Container(
                                    height: 300,
                                    color: Colors.pink,
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: purchaselist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          // (((index > 0) &&
                                          //         (purchaselist[index].date.year ==
                                          //                 purchaselist[index - 1].date.year &&
                                          //             purchaselist[index].date.month ==
                                          //                 purchaselist[index - 1].date.month &&
                                          //             purchaselist[index].date.day ==
                                          //                 purchaselist[index - 1].date.day)))
                                          // (((index > 0) &&
                                          //         (Utility.convertDatetimeToDateOnly(
                                          //                 souceDateTime:
                                          //                     purchaselist[index].date) ==
                                          //             Utility.convertDatetimeToDateOnly(
                                          //                 souceDateTime:
                                          //                     purchaselist[index - 1].date))))

                                          (((index > 0) &&
                                                  (DateTimeUtill.checkIsSameDay(
                                                      souceDateTime_1:
                                                          purchaselist[index]
                                                              .date,
                                                      souceDateTime_2:
                                                          purchaselist[
                                                                  index - 1]
                                                              .date))))
                                              ? const SizedBox(
                                                  height: 8,
                                                )
                                              : Container(
                                                  // color: Colors.amber,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16, bottom: 4),
                                                  height: 34,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        DateTimeUtill.returnDateMounthAndYear(
                                                            souceDateTime:
                                                                purchaselist[
                                                                        index]
                                                                    .date),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                    ],
                                                  )),
                                          PurchaseCard(
                                            purchaseObj: purchaselist[index],
                                          ),
                                        ],
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
