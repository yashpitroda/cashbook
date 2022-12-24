import 'package:flutter/material.dart';

class SignupCard extends StatelessWidget {
  double mxheight;
  double mxwidth;
  String title;
  String imagepath;
  SignupCard(
      {required this.mxheight,
      required this.title,
      required this.imagepath,
      required this.mxwidth});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
            width: mxwidth / 1.8,
            height: mxheight / 18,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(),
                color: Color.fromARGB(255, 0, 0, 0)),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imagepath), fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ))),
      ),
    );
  }
}
