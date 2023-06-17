import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../services/date_time_utill.dart';
import '../services/utility.dart';

class onlyTimeCard extends StatelessWidget {
  const onlyTimeCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);

  final Purchase purchaseObj;

  @override
  Widget build(BuildContext context) {
    return Text(
        "at ${UtillDatetime.datetimeToTimeAmPm(souceDateTime: purchaseObj.date)}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall!
        // .copyWith(fontSize: 14),
        );
  }
}
