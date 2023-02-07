import 'package:flutter/material.dart';

class CardUI1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Yash',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              Chip(
                label: Text(
                  'Paid',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.lightBlue.shade100,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello world aksbc',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                '₹10,000',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            children: [
              Chip(
                label: Text(
                  'Cash',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: Colors.green.shade100,
              ),
              SizedBox(
                width: 10,
              ),
              Chip(
                label: Text(
                  '8:00 pm',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.purple,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: Colors.purple.shade100,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
