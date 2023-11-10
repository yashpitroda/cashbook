import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/provider/supplier_provider.dart';
import 'package:cashbook_app/services/constants.dart';
import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/utility.dart';
import '../widgets/purchase_screen_header.dart';

class PurchaseAnalyticsScreeen extends StatelessWidget {
  static const String routeName = '/PurchaseAnalyticsScreeen';

  const PurchaseAnalyticsScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Insides"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 4,
            ),
            TitleAndThreevalueAndSubtitleCard(
              title: "Invoiced",
              value3: Provider.of<PurchaseProvider>(context).getTotalPurchase,
              subtitle3: "TOTAL",
              value2: Provider.of<PurchaseProvider>(context)
                  .getTotalThisMounthPurchase,
              subtitle2: "THIS MONTH",
              value1: Provider.of<PurchaseProvider>(context)
                  .getTotalLastMounthPurchase,
              subtitle1: "LAST MONTH",
              titleColor: Theme.of(context).primaryColorDark,
              subtitleColor: null,
              valueColor: null,
            ),
            TitleAndThreevalueAndSubtitleCard(
              title: "Unpaid",
              value1: Provider.of<PurchaseProvider>(context).getWithBillDue,
              subtitle1: "(WITH BILL)",
              value2: Provider.of<PurchaseProvider>(context).getChalanDue,
              subtitle2: "(CHALAN)",
              value3: Provider.of<PurchaseProvider>(context).getTotalDue,
              subtitle3: "TOTAL",
              titleColor: Theme.of(context).primaryColorDark,
              subtitleColor: null,
              valueColor: Palette.redDarkColor,
            ),
            TitleAndThreevalueAndSubtitleCard(
              title: "Prepaymaent",
              value1: Provider.of<PurchaseProvider>(context).getWithBillAdvance,
              subtitle1: "(WITH BILL)",
              value2: Provider.of<PurchaseProvider>(context).getChalanAdvance,
              subtitle2: "(CHALAN)",
              value3: Provider.of<PurchaseProvider>(context).getTotalAdvance,
              subtitle3: "TOTAL",
              titleColor: Theme.of(context).primaryColorDark,
              subtitleColor: null,
              valueColor: Palette.greendarkColor,
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              thickness: 1.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Text(
                    "Party List",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  Provider.of<SupplierProvider>(context).supplierList.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 1.4,
                  margin: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding_6 * 2,
                      vertical: Constants.defaultPadding_8 / 2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Theme.of(context).dialogBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Constants.defaultPadding_6 * 2,
                          vertical: Constants.defaultPadding_6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Provider.of<SupplierProvider>(context)
                                        .supplierList[i]
                                        .firmname,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    Provider.of<SupplierProvider>(context)
                                        .supplierList[i]
                                        .sname,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          prepaymentAndUnpaidCard(context, i)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }

  Container prepaymentAndUnpaidCard(BuildContext context, int i) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        children: [
          Expanded(
            child: WithBillLeftPart(
                title: "(WITH BILL)",
                advanceAmount: Provider.of<SupplierProvider>(context)
                    .supplierList[i]
                    .advance_amount_with_bill,
                outstandingAmount: Provider.of<SupplierProvider>(context)
                    .supplierList[i]
                    .outstanding_amount_withbill),
          ),
          const VerticalDivider(),
          Expanded(
            child: WithBillLeftPart(
                title: "(CHALAN)",
                advanceAmount: Provider.of<SupplierProvider>(context)
                    .supplierList[i]
                    .advance_amount_without_bill,
                outstandingAmount: Provider.of<SupplierProvider>(context)
                    .supplierList[i]
                    .outstanding_amount_without_bill),
          ),
        ],
      ),
    );
  }
}

class TitleAndThreevalueAndSubtitleCard extends StatelessWidget {
  const TitleAndThreevalueAndSubtitleCard({
    super.key,
    required this.title,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.valueColor,
    required this.titleColor,
    required this.subtitleColor,
  });
  final String title;

  final Color? valueColor;
  final Color? titleColor;
  final Color? subtitleColor;

  final String value1;
  final String value2;
  final String value3;

  final String subtitle1;
  final String subtitle2;
  final String subtitle3;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Constants.borderRadius_6 / 2))),
      margin: const EdgeInsets.symmetric(
          horizontal: (Constants.defaultPadding_8) * 1.5,
          vertical: (Constants.defaultPadding_8)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Constants.defaultPadding_6),
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding_8 * 2,
              vertical: Constants.defaultPadding_6 / 3),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Expanded(
                    child: ValueAndSubtitleColumn(
                      subTitle: subtitle1,
                      value: value1,
                      subtitleColor: subtitleColor,
                      valueColor: valueColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ValueAndSubtitleColumn(
                      subTitle: subtitle2,
                      value: value2,
                      subtitleColor: subtitleColor,
                      valueColor: valueColor,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ValueAndSubtitleColumn(
                      subTitle: subtitle3,
                      value: value3,
                      subtitleColor: subtitleColor,
                      valueColor: valueColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ValueAndSubtitleColumn extends StatelessWidget {
  const ValueAndSubtitleColumn({
    super.key,
    required this.subTitle,
    required this.value,
    required this.valueColor,
    required this.subtitleColor,
  });
  final String subTitle;
  final String value;

  final Color? valueColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: value, decimalDigits: 2)}",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: valueColor),
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: subtitleColor),
          ),
        ),
      ],
    );
  }
}

class TitleAndSingleTitleValueRow extends StatelessWidget {
  const TitleAndSingleTitleValueRow({
    super.key,
    required this.title,
    required this.titleValue,
    required this.color,
  });
  final String title;
  final String titleValue;
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
                          .labelMedium!
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: titleValue, decimalDigits: 2)}",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontSize: 14, color: color),
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

class WithBillLeftPart extends StatelessWidget {
  const WithBillLeftPart({
    super.key,
    required this.advanceAmount,
    required this.outstandingAmount,
    required this.title,
  });
  final String title;
  final String advanceAmount;
  final String outstandingAmount;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 6,
        ),
        advanceAmount == "0"
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  outstandingAmount == "0" ? "Prepayment & Unpaid" : "Unpaid",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 13,
                      color: outstandingAmount == "0"
                          ? null
                          : Theme.of(context).indicatorColor),
                ),
              )
            : Text(
                "Prepayment",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 13, color: Theme.of(context).indicatorColor),
              ),
        const SizedBox(
          height: 3,
        ),
        Flexible(
            child: advanceAmount == "0"
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: outstandingAmount == "0"
                        ? Text(
                            "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: outstandingAmount, decimalDigits: 2)}",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 14,
                                ),
                          )
                        : Text(
                            "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: outstandingAmount, decimalDigits: 2)}",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontSize: 14, color: Palette.redDarkColor),
                          ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\u{20B9} ${Utill.convertToIndianCurrency(sourceNumber: advanceAmount, decimalDigits: 2)}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Palette.greendarkColor,
                            fontSize: 14,
                          ),
                    ),
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
            )
          ],
        ),
      ],
    );
  }
}
