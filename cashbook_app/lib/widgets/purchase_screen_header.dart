import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/constants.dart';
import '../services/utility.dart';

// class PurchaseScreenHeaderCard extends StatelessWidget {
//   PurchaseScreenHeaderCard({
//     super.key,
//     required this.title1,
//     required this.title2,
//     required this.title1Value,
//     required this.title2Value,
//     required this.title3,
//     required this.title3Value,
//     required this.title4,
//     required this.title4Value,
//   });
//   String title1;
//   String title1Value;
//   String title2;
//   String title2Value;
//   String title3;
//   String title3Value;
//   String title4;
//   String title4Value;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       shape: const RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(Constants.borderRadius_6 / 2))),
//       margin: const EdgeInsets.symmetric(
//           horizontal: (Constants.defaultPadding_8) * 1.5,
//           vertical: Constants.defaultPadding_8),
//       child: Padding(
//         padding:
//             const EdgeInsets.symmetric(vertical: Constants.defaultPadding_6),
//         child: Column(
//           children: [
//             TitleAndTitleValueRow(
//                 title: title1, titleValue: title1Value, color: null),
//             TitleAndTitleValueRow(
//                 title: title2, titleValue: title2Value, color: null),
//             const Divider(),
//             TitleAndTitleValueRow(
//                 title: title3,
//                 titleValue: title3Value,
//                 color: Palette.greendarkColor),
//             TitleAndTitleValueRow(
//               title: title4,
//               titleValue: title4Value,
//               color: Palette.redColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TitleAndTitleValueRow extends StatelessWidget {
  const TitleAndTitleValueRow({
    super.key,
    required this.title,
    required this.titleValue1,
    required this.titleValue2,
    required this.color,
  });

  final String title;
  final String titleValue1;
  final String titleValue2;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding_8 * 2,
          vertical: Constants.defaultPadding_6 / 3),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    // flex: 3,
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: color),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    // flex: 3,
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: titleValue1, decimalDigits: 2)}",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 14,
                          // color: color == null ? null : color
                          color: color),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    // flex: 1,
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: titleValue2, decimalDigits: 2)}",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 14,
                          // color: color == null ? null : color
                          color: color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
