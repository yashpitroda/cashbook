import 'package:flutter/material.dart';

class IsInstantOrCreditAdvanceCard extends StatelessWidget {
  const IsInstantOrCreditAdvanceCard({
    Key? key,
    required this.isCustomC_cr,
  }) : super(key: key);
  final String isCustomC_cr;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 130,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustomC_cr) == 1)
              ? Colors.teal[50]
              : Colors.brown[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustomC_cr) == 1) ? "CREDIT/ADVANCE" : "INSTANT PAYMENT",
          style: TextStyle(
            fontSize:  12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustomC_cr) == 1)
                ? Colors.teal[700]
                : Colors.brown[700],
          ),
        ),
      ),
    );
  }
}
