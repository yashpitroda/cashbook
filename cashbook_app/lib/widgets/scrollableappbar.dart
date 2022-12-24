import 'package:flutter/material.dart';

class scrollableAppbar extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height*0.4,
      floating: false,
      pinned: true,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          child: Row(
            children: [
              const Flexible(
                fit: FlexFit.tight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child:  Text(
                   'Cashbook',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(
                    Icons.favorite_border_outlined,
                    size: 18,
                  ))
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
        background: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.transparent],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: Image.network(
            'abc',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
