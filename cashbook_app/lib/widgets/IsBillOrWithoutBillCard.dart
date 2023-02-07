import 'package:flutter/material.dart';

class IsBillOrWithoutBillCard extends StatelessWidget {
  const IsBillOrWithoutBillCard({
    Key? key,
    required this.isCustombillvalue,
  }) : super(key: key);
  final String isCustombillvalue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: (int.parse(isCustombillvalue) == 1) ? 54 : 88,
      decoration: BoxDecoration(
          // border: Border.all(
          //     width: 1,
          //     color: Colors.black45),
          color: (int.parse(isCustombillvalue) == 1)
              ? Colors.orange[50]
              : Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          (int.parse(isCustombillvalue) == 1) ? "Bill" : "Without bill",
          style: TextStyle(
            fontSize: (int.parse(isCustombillvalue) == 1) ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: (int.parse(isCustombillvalue) == 1)
                ? Colors.orange[700]
                : Colors.deepPurpleAccent[700],
          ),
        ),
      ),
    );
  }
}
