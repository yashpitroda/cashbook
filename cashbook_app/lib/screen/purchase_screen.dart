// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/models/purchase.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/screen/loading_screen.dart';
import 'package:cashbook_app/utill/utility.dart';
import 'package:cashbook_app/widgets/scrollableappbar.dart';

import 'add_update_purchase_screen.dart';

class PurchaseScreen extends StatelessWidget {
  static const routeName = '/PurchaseScreen';
  PurchaseScreen({
    Key? key,
  }) : super(key: key);
  final ScrollController _controller = ScrollController();
  void _scrollup() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          Provider.of<SupplierProvider>(context, listen: false).fatchSupplier(),
          Provider.of<PurchaseProvider>(context, listen: false).fatchPurchase()
        ]),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final purchaselist =
                Provider.of<PurchaseProvider>(context).getPurchaseList;
            return _scaffold(context, purchaselist);
          } else {
            return LoadingScreen();
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
      body: _scf_body(purchaselist, context),
    );
  }

  Stack _scf_body(List<Purchase> purchaselist, BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => Utility.refreshPurchase(context),
          child: Container(
            color: Colors.grey.withOpacity(0.09),
            child: Scrollbar(
              // SingleChildScrollView
              // Column
              child: SingleChildScrollView(
                controller: _controller,
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
                                              .format(purchaselist[index].date),
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
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: bottombuttoncard(context),
        )
      ],
    );
  }

  Container bottombuttoncard(BuildContext context) {
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
                        _scrollup();
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(10, 55),
                        // backgroundColor: Colors.purple
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

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);
  final Purchase purchaseObj;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: Colors.white,
        // height: 120,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchaseObj.firmname + " (${purchaseObj.supplierObj!.sname})",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 16),
                ),
                Text(
                  "at ${Utility.datetime_to_timeAMPM(souceDateTime: purchaseObj.date)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14),
                ),
              ],
            ),
            // SizedBox(
            //   height: 6,
            // ),
            // Divider(
            //   height: 6,
            // ),
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Container(
                      // color: Colors.amber,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IsBillOrWithoutBillCard(
                                    isCustombillvalue: purchaseObj.isbillvalue),
                                SizedBox(
                                  width: 6,
                                ),
                                IsCashBankCard(
                                  isCustomCashBank: purchaseObj.cash_bank,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                IsInstantOrCreditAdvanceCard(
                                  isCustomC_cr: purchaseObj.c_cr,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            // (purchaseObj.remark ==
                            //         "")
                            //     ? Container()
                            //     : Text(
                            //         "${purchaseObj.remark}",
                            //         maxLines: 1,
                            //         overflow: TextOverflow
                            //             .ellipsis,
                            //         style:
                            //             Theme.of(context)
                            //                 .textTheme
                            //                 .caption!
                            //                 .copyWith(
                            //                     fontSize:
                            //                         14),
                            //       ),
                          ]),
                    )),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      // color: Colors.pink.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Bill amt: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        // fontWeight:
                                        //     FontWeight.w500,
                                        fontSize: 14),
                              ),
                              Flexible(
                                child: Text(
                                  Utility.convertToIndianCurrency(
                                      sourceNumber: purchaseObj.bill_amount,
                                      decimalDigits: 2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "paid amt: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        // fontWeight:
                                        //     FontWeight.w500,
                                        fontSize: 14),
                              ),
                              Flexible(
                                child: Text(
                                  Utility.convertToIndianCurrency(
                                      sourceNumber: purchaseObj.paidamount,
                                      decimalDigits: 2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.red[400]),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          (purchaseObj.outstanding_amount == "0" &&
                                  purchaseObj.advance_amount == "0")
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "due & adv: ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              // fontWeight:
                                              //     FontWeight.w500,
                                              fontSize: 14),
                                    ),
                                    Flexible(
                                      child: Text(
                                        Utility.convertToIndianCurrency(
                                            sourceNumber:
                                                purchaseObj.outstanding_amount,
                                            decimalDigits: 2),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      (purchaseObj.outstanding_amount == "0")
                                          ? "adv: "
                                          : "due: ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              // fontWeight:
                                              //     FontWeight.w500,
                                              fontSize: 14),
                                    ),
                                    Flexible(
                                      child: Text(
                                        (purchaseObj.outstanding_amount == "0")
                                            ? Utility.convertToIndianCurrency(
                                                sourceNumber:
                                                    purchaseObj.advance_amount,
                                                decimalDigits: 2)
                                            : Utility.convertToIndianCurrency(
                                                sourceNumber: purchaseObj
                                                    .outstanding_amount,
                                                decimalDigits: 2),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                color: ((purchaseObj
                                                            .outstanding_amount ==
                                                        "0"))
                                                    ? Colors.green.shade900
                                                    : Colors.red.shade900,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ))
              ],
            ),

            Container(
              child: Row(
                children: [
                  (purchaseObj.remark == "")
                      ? Container()
                      : Text(
                          "${purchaseObj.remark}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontSize: 14),
                        ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 6,
            // ),
            Divider(
                // height: 1,
                ),
            Container(
              // height: 30,
              // color: Colors.red,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      // height: 26,
                      // width: 170,
                      decoration: BoxDecoration(
                          // border: Border.all(
                          //     width: 1,
                          //     color: Colors.black45),
                          color: Colors.grey.withOpacity(0.075),
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Cash balance",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  "\u{20B9} ${Utility.convertToIndianCurrency(sourceNumber: purchaseObj.cashBankObj.cash_balance, decimalDigits: 2)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      // height: 26,
                      // width: 170,
                      decoration: BoxDecoration(
                          // border: Border.all(
                          //     width: 1,
                          //     color: Colors.black45),
                          color: Colors.grey.withOpacity(0.075),
                          // color: Colors.red
                          //     .withOpacity(0.084),
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Bank balance",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  "\u{20B9} ${Utility.convertToIndianCurrency(sourceNumber: purchaseObj.cashBankObj.bank_balance, decimalDigits: 2)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class IsInstantOrCreditAdvanceCard extends StatelessWidget {
  const IsInstantOrCreditAdvanceCard({
    Key? key,
    required this.isCustomC_cr,
  }) : super(key: key);
  final String isCustomC_cr;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: (int.parse(isCustomC_cr) == 1) ? 130 : 130,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustomC_cr) == 1)
              ? Colors.teal[50]
              : Colors.brown[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustomC_cr) == 1) ? "CREDIT/ADVANCE" : "INSTANT PAYMENT",
          style: TextStyle(
            fontSize: (int.parse(isCustomC_cr) == 1) ? 12 : 12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustomC_cr) == 1)
                ? Colors.teal[700]
                : Colors.brown[700],
          ),
        ),
      ),
    );
  }
}

class IsBillOrWithoutBillCard extends StatelessWidget {
  const IsBillOrWithoutBillCard({
    Key? key,
    required this.isCustombillvalue,
  }) : super(key: key);
  final String isCustombillvalue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: (int.parse(isCustombillvalue) == 1) ? 54 : 88,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustombillvalue) == 1)
              ? Colors.orange[50]
              : Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustombillvalue) == 1) ? "Bill" : "Without bill",
          style: TextStyle(
            fontSize: (int.parse(isCustombillvalue) == 1) ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustombillvalue) == 1)
                ? Colors.orange[700]
                : Colors.deepPurpleAccent[700],
          ),
        ),
      ),
    );
  }
}

class IsCashBankCard extends StatelessWidget {
  const IsCashBankCard({
    Key? key,
    required this.isCustomCashBank,
  }) : super(key: key);
  final String isCustomCashBank;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 54,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustomCashBank) == 0)
              ? Colors.green[50]
              : Colors.blue[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustomCashBank) == 0) ? "CASH" : "BANK",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustomCashBank) == 0)
                ? Colors.green[700]
                : Colors.blue[700],
          ),
        ),
      ),
    );
  }
}

//   Scaffold _scaffold(
//     BuildContext context,
//     List<Purchase> purchaselist,
//   ) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, isScrolled) {
//           return <Widget>[
//             const SliverAppBar(
//               // expandedHeight: MediaQuery.of(context).size.height * 0.25,
//               // collapsedHeight: 60,
//               centerTitle: true,
//               title: Text("Purchase"),
//               floating: false,
//               // pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                   // collapseMode: CollapseMode.parallax,
//                   // titlePadding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
//                   // background: Column(
//                   //   mainAxisAlignment: MainAxisAlignment.end,
//                   //   children: [
//                   //     Container(
//                   //       child: Divider(),
//                   //     ),
//                   //   ],
//                   // ),
//                   ),
//               // expandedHeight: 200,
//             ),
//           ];
//         },
//         body: Stack(
//           children: [
//             ListView.builder(
//                 // shrinkWrap: true,
//                 // physics: NeverScrollableScrollPhysics(),
//                 // itemCount: purchaselist.length,
//                 itemCount: 30,
//                 itemBuilder: (BuildContext ctxt, int index) {
//                   return
//                       // StickyHeader(
//                       //   header: Container(
//                       //     height: 50.0,
//                       //     color: Colors.blueGrey[700],
//                       //     padding: EdgeInsets.symmetric(horizontal: 16.0),
//                       //     alignment: Alignment.centerLeft,
//                       //     child: Text(
//                       //       'Header #$index',
//                       //       style: const TextStyle(color: Colors.white),
//                       //     ),
//                       //   ),
//                       //   content: Container(
//                       //     height: 300,
//                       //   ),
//                       // );
//                       StickyHeaderBuilder(
//                           builder: (context, stuckAmount) {
//                             print('$index - $stuckAmount');
//                             stuckAmount = stuckAmount.clamp(0.0, 1.0);
//                             return Container(
//                               height: 100.0 - (50 * (1 - stuckAmount)),
//                               color: Color.lerp(
//                                   Colors.blue, Colors.red, stuckAmount),
//                               padding: EdgeInsets.symmetric(horizontal: 16.0),
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 'Title #$index',
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             );
//                           },
//                           content: Container(
//                             height: 200,
//                           ));
//                   // StickyHeader(
//                   //   header:
//    ((index > 0) &&
//           (purchaseObj.date.year ==
//                   purchaselist[index - 1]
//                       .date
//                       .year &&
//               purchaseObj
//                       .date
//                       .month ==
//                   purchaselist[index - 1]
//                       .date
//                       .month &&
//               purchaseObj.date.day ==
//                   purchaselist[index - 1]
//                       .date
//                       .day))
//       ? Container()
//       :
//   Container(
// height: 100,
// child: Row(
//   children: [
//     // Text((purchaseObj.date)
//     //     .toString()),
//     Text((Utility.dateFormat_DDMMYYYY()
//         .format(purchaseObj.date)))
//   ],
// ),
// ),
//                   //   content: Card(
//                   //     child: Column(
//                   //       children: [
//                   //         Row(
//                   //           children: [
//                   //             Text((purchaselist[index].pid).toString()),
//                   //           ],
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // );
//                 }),
//             Align(
//               alignment: AlignmentDirectional.bottomStart,
//               child: bottombuttoncard(context),
//             )
//           ],
//         ),
//       ),
//     );

//     // body: CustomScrollView(
//     //   slivers: [
//     // const SliverAppBar(
//     //   title: Text("title"),

//     //   floating: true,
//     //   flexibleSpace: Placeholder(),
//     //   // expandedHeight: 200,
//     // ),
//     //     SliverList(
//     //       delegate: SliverChildBuilderDelegate(
//     //         // (context, index) => ListTile(title: Text('Item #$index')),
//     //         // childCount: 1000,
//     //       ),
//     //     ),
//     //   ],
//     // ),
//   }

//   Container bottombuttoncard(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: 80,
//       child: Column(
//         children: [
//           const Divider(
//             thickness: 1.3,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               // crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // Expanded(
//                 //   child: ElevatedButton(
//                 //     onPressed: () {
//                 //       Navigator.of(context).pop();
//                 //     },
//                 //     style: ElevatedButton.styleFrom(
//                 //         fixedSize: const Size(10, 55),
//                 //         backgroundColor: Colors.red),
//                 //     child: const Text(
//                 //       'Cancel',
//                 //       style: TextStyle(
//                 //         color: Colors.white,
//                 //         fontFamily: 'Rubik',
//                 //         fontSize: 16,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 // const SizedBox(
//                 //   width: 20,
//                 // ),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context)
//                           .pushNamed(AddUpdatePurchaseScreen.routeName);
//                     },
//                     style: ElevatedButton.styleFrom(
//                         fixedSize: const Size(10, 55),
//                         backgroundColor: Colors.blue),
//                     child: const Text(
//                       'Add purchase',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Rubik',
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Card topArea() => Card(
//         margin: EdgeInsets.all(10.0),
//         elevation: 1.0,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(50.0))),
//         child: Container(
//             decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                     colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
//             padding: EdgeInsets.all(5.0),
//             // color: Color(0xFF015FFF),
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {},
//                     ),
//                     Text("Savings",
//                         style: TextStyle(color: Colors.white, fontSize: 20.0)),
//                     IconButton(
//                       icon: Icon(
//                         Icons.arrow_forward,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {},
//                     )
//                   ],
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(5.0),
//                     child: Text(r"$ " "95,940.00",
//                         style: TextStyle(color: Colors.white, fontSize: 24.0)),
//                   ),
//                 ),
//                 SizedBox(height: 35.0),
//               ],
//             )),
//       );
// }
