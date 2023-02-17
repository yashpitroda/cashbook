import 'package:cashbook_app/models/cashflow.dart';
import 'package:cashbook_app/widgets/remarkCard.dart';
import 'package:cashbook_app/widgets/titleCard.dart';
import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../utill/utility.dart';
import 'IsBillOrWithoutBillCard.dart';
import 'IsCashBankCard.dart';
import 'IsInstantOrCreditAdvanceCard.dart';
import 'accountNameAndBalanceCard.dart';
import 'billPaidDueAdvInPuchaseCard.dart';
import 'onlyTimeCard.dart';

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
                TitleCard(purchaseObj: purchaseObj),
                SizedBox(
                  width: 12,
                ),
                onlyTimeCard(purchaseObj: purchaseObj),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            // Divider(
            //   height: 6,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: Container(
                      // color: Colors.amber,
                      child: Column(
                        children: [
                          RemarkCard(purchaseObj: purchaseObj),
                          const SizedBox(
                            height: 6,
                          ),
                          accountNameAndBalanceCard(
                              cashflowObj: purchaseObj.cashflowObj),

                          // ),
                        ],
                      ),
                    )),
                SizedBox(
                  width: 6,
                ),
                Expanded(
                    flex: 6,
                    child:
                        billPaidDueAdvInPuchaseCard(purchaseObj: purchaseObj))
              ],
            ),
            const Divider(),
            Container(
              child: Row(
                children: [
                  IsBillOrWithoutBillCard(
                      isCustombillvalue: purchaseObj.isBill),
                  const SizedBox(
                    width: 6,
                  ),
                  IsInstantOrCreditAdvanceCard(
                    isCustomC_cr: purchaseObj.cOrCr,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
