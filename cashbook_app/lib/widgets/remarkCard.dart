import 'package:flutter/material.dart';

import '../models/purchase.dart';

class RemarkCard extends StatelessWidget {
  const RemarkCard({
    Key? key,
    required this.purchaseObj,
  }) : super(key: key);

  final Purchase purchaseObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // (purchaseObj.remark == "")
          //     ? Container()
          //     :
          Flexible(
            child: Text(
              (purchaseObj.remark == "")
                  ? "No remark"
                  : "${purchaseObj.remark}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
