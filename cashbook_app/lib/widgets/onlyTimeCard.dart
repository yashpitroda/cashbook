import 'package:flutter/material.dart';

import '../models/purchase.dart';
import '../utill/utility.dart';

class onlyTimeCard extends StatelessWidget {
  const onlyTimeCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);

  final Purchase purchaseObj;

  @override
  Widget build(BuildContext context) {
    return Text(
      "at ${Utility.datetime_to_timeAMPM(souceDateTime: purchaseObj.date)}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .caption!
          .copyWith(fontSize: 14),
    );
  }
}

