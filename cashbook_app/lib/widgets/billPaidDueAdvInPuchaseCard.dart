import 'package:cashbook_app/services/palette.dart';
import "package:flutter/material.dart";

import '../models/purchase.dart';
import '../services/utility.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bill amount  ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              Flexible(
                child: Text(
                  Utility.convertToIndianCurrency(
                      sourceNumber: purchaseObj.biilAmount, decimalDigits: 2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "paid amount  ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
              Flexible(
                child: Text(
                  Utility.convertToIndianCurrency(
                      sourceNumber: purchaseObj.paidAmount, decimalDigits: 2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        // color: Palette.redColor
                      ),
                ),
              ),
            ],
          ),
          Divider(
            height: 4,
            indent: 94,
            thickness: 1.4,
            // indent: 20,
          ),
          (purchaseObj.outstandingAmount == "0" &&
                  purchaseObj.advanceAmount == "0")
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "due & adv  ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                    Flexible(
                      child: Text(
                        Utility.convertToIndianCurrency(
                            sourceNumber: purchaseObj.outstandingAmount,
                            decimalDigits: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (purchaseObj.outstandingAmount == "0")
                          ? "adv  "
                          : "due  ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                    Flexible(
                      child: Text(
                        (purchaseObj.outstandingAmount == "0")
                            ? Utility.convertToIndianCurrency(
                                sourceNumber: purchaseObj.advanceAmount,
                                decimalDigits: 2)
                            : Utility.convertToIndianCurrency(
                                sourceNumber: purchaseObj.outstandingAmount,
                                decimalDigits: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ((purchaseObj.outstandingAmount == "0"))
                                  ? Palette.greenColor
                                  : Palette.redColor,
                            ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
