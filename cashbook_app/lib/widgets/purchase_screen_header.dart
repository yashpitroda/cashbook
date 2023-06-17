import 'package:flutter/material.dart';

import '../services/constants.dart';
import '../services/utility.dart';

class PurchaseScreenHeaderCard extends StatelessWidget {
  PurchaseScreenHeaderCard({
    super.key,
    required this.title1,
    required this.title2,
    required this.title1Value,
    required this.title2Value,
  });
  String title1;
  String title1Value;
  String title2;
  String title2Value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Constants.borderRadius_6 / 2))),
      margin: const EdgeInsets.symmetric(
          horizontal: (Constants.defaultPadding_8) * 1.5,
          vertical: Constants.defaultPadding_8),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Constants.defaultPadding_6),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding_8 * 2,
                  vertical: Constants.defaultPadding_6 / 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // "Purchase",
                    title1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontSize: 16),
                  ),
                  Flexible(
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: title1Value, decimalDigits: 2)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(
            //     horizontal:
            //         (Constants.defaultPadding_8) *
            //             1.6,
            //   ),
            //   child:
            //       WidgetComponentUtill.divider(1),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding_8 * 2,
                  vertical: Constants.defaultPadding_6 / 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontSize: 16),
                  ),
                  Flexible(
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: title2Value, decimalDigits: 2)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
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
}
