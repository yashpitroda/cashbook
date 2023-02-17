
import "package:flutter/material.dart";

import '../models/purchase.dart';
//supplier title card
class TitleCard extends StatelessWidget {
  const TitleCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);

  final Purchase purchaseObj;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        purchaseObj.supplierObj!.firmname +
            " (${purchaseObj.supplierObj!.sname})",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontSize: 16),
      ),
    );
  }
}
