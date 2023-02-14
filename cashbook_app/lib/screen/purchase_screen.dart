// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/models/purchase.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/screen/loading_screen.dart';
import 'package:cashbook_app/utill/utility.dart';

import '../widgets/purchase_card.dart';
import 'add_update_purchase_screen.dart';

class PurchaseScreen extends StatelessWidget {
  static const routeName = '/PurchaseScreen';
  PurchaseScreen({
    Key? key,
  }) : super(key: key);
  final ScrollController _scrollcontroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            return _scaffold(context, purchaselist);
          } else {
            return Utility.loadingIndicator();
          }
        }));
  }

  Scaffold _scaffold(
    BuildContext context,
    List<Purchase> purchaselist,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("purchase"),
        // bottom: PreferredSize(
        //     preferredSize: Size.fromHeight(8.0),
        //     child: Row(
        //       children: [
        //         Text("fsta"),
        //       ],
        //     )),
      ),
      body: Stack(
        children: [
          Container(
            child:
                //  (purchaselist.isEmpty)
                //     ? Container(child: Center(child: Text("Empty...")))
                //     :
                Container(
              color: Colors.grey.withOpacity(0.09),
              child: RefreshIndicator(
                onRefresh: () async {
                  await Utility.refreshSupplier(context).then((_) async {
                    await Utility.refreshPurchase(context);
                  });
                },
                child: Scrollbar(
                  // SingleChildScrollView
                  // Column
                  child: SingleChildScrollView(
                    controller: _scrollcontroller,
                    // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.values,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          color: Colors.pink,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: purchaselist.length,
                          itemBuilder: (BuildContext context, int index) {
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
                                        (Utility.check_is_A_sameday(
                                            souceDateTime_1:
                                                purchaselist[index].date,
                                            souceDateTime_2:
                                                purchaselist[index - 1].date))))
                                    ? const SizedBox(
                                        height: 8,
                                      )
                                    : Container(
                                        // color: Colors.amber,
                                        padding: const EdgeInsets.only(
                                            left: 16, bottom: 4),
                                        height: 34,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              Utility.dateFormat_DD_MonthName_YYYY()
                                                  .format(
                                                      purchaselist[index].date),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(fontSize: 14),
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
                        SizedBox(
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
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: bottomButtonCard(context),
          )
        ],
      ),
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
              // crossAxisAlignment: CrossAxisAlignment.end,
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
                      child: Icon(Icons.arrow_upward_rounded)),
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
                        backgroundColor: Colors.blue),
                    child: const Text(
                      'Add purchase',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Rubik',
                        fontSize: 16,
                      ),
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
