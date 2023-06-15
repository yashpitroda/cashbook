import 'package:cashbook_app/services/palette.dart';
import 'package:flutter/material.dart';

class WidgetComponentUtill {
  static Widget loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget divider(double thickness) {
    return Divider(
      thickness: thickness,
      height: 6,
    );
  }

  static void displaysnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            // color: Colors.white
            ),
      ),
      // backgroundColor: Palette.blackColor,
    ));
  }
}
