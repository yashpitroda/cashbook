import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/scrollableappbar.dart';

class ClientScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          scrollableAppbar(),
        ];
      },
      body: LayoutBuilder(builder: (context, constraint) {
        return Container(
          height: constraint.maxHeight,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Container(
                height: constraint.maxHeight * 0.2,
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ],
                ),
              ),
              
            ],
          ),
        );
      }))
    );
  }
}