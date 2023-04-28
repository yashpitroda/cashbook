import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/material.dart';

import '../models/cashflow.dart';
import '../services/utility.dart';

class accountNameAndBalanceCard extends StatelessWidget {
  const accountNameAndBalanceCard({
    Key? key,
    required this.cashflowObj,
  }) : super(key: key);

  final Cashflow cashflowObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      // height: 26,
      // width: 170,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black45),
          //  color: Colors.grey.withOpacity(0.075),
          //  color: Color.fromARGB(200, 243, 243, 243),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Account: ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(),
              ),
              Flexible(
                child: Text(
                  "${cashflowObj.accountObj!.accountName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      //    fontWeight: FontWeight.w600,
                      ),
                  // style: Theme.of(context).textTheme.caption!.copyWith(
                  //     letterSpacing: 1,
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 14),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  "\u{20B9} ${Utility.convertToIndianCurrency(sourceNumber: cashflowObj.balance!, decimalDigits: 2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Palette.primaryColor
                          // fontWeight: FontWeight.w600,
                          ),
                  // style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  //     letterSpacing: 1,
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
