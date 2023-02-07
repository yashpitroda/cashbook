import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../utill/utility.dart';
import 'IsBillOrWithoutBillCard.dart';
import 'IsCashBankCard.dart';
import 'IsInstantOrCreditAdvanceCard.dart';

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
                Flexible(
                  child: Text(
                    purchaseObj.firmname +
                        " (${purchaseObj.supplierObj!.sname})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 12,
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
            SizedBox(
              height: 4,
            ),
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
