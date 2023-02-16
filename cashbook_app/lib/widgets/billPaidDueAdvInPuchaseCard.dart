import "package:flutter/material.dart";

import '../models/purchase.dart';
import '../utill/utility.dart';


class billPaidDueAdvInPuchaseCard extends StatelessWidget {
  const billPaidDueAdvInPuchaseCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);

  final Purchase purchaseObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 2),
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
                    .copyWith(fontSize: 14),
              ),
              Flexible(
                child: Text(
                  Utility.convertToIndianCurrency(
                      sourceNumber: purchaseObj.biilAmount,
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
                      sourceNumber: purchaseObj.paidAmount,
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
          Divider(
            indent: 20,
          ),
          (purchaseObj.outstandingAmount == "0" &&
                  purchaseObj.advanceAmount == "0")
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
                                purchaseObj.outstandingAmount,
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
                      (purchaseObj.outstandingAmount == "0")
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
                        (purchaseObj.outstandingAmount == "0")
                            ? Utility.convertToIndianCurrency(
                                sourceNumber:
                                    purchaseObj.advanceAmount,
                                decimalDigits: 2)
                            : Utility.convertToIndianCurrency(
                                sourceNumber: purchaseObj
                                    .outstandingAmount,
                                decimalDigits: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(
                                color: ((purchaseObj
                                            .outstandingAmount ==
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
    );
  }
}




