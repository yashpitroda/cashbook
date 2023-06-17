import 'package:flutter/material.dart';

class UtillComponent {
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
      elevation: 1.5,
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            // color: Colors.white
            ),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
    ));
  }
}
