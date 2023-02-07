import 'package:flutter/material.dart';

class IsCashBankCard extends StatelessWidget {
  const IsCashBankCard({
    Key? key,
    required this.isCustomCashBank,
  }) : super(key: key);
  final String isCustomCashBank;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 54,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustomCashBank) == 0)
              ? Colors.green[50]
              : Colors.blue[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustomCashBank) == 0) ? "CASH" : "BANK",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustomCashBank) == 0)
                ? Colors.green[700]
                : Colors.blue[700],
          ),
        ),
      ),
    );
  }
}
