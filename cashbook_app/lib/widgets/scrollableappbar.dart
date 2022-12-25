import 'package:flutter/material.dart';

class scrollableAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      collapsedHeight: 60,
      floating: false,
      pinned: true,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: const Color(0xff582cd8),
      actions: [
        Align(
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.fromLTRB(0, 10, 14, 0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: IconButton(
                onPressed: () => {},
                icon: const Icon(
                  Icons.manage_accounts,
                  size: 22,
                )),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding:const EdgeInsets.fromLTRB(40, 0, 0, 0),
        background: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₹10,000',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                'Total Debt',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.white60,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          color: Color(0xff582cd8),
        ),
      ),
    );
  }
}
