import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.customController,
    required this.labeltext,
    required this.hinttext,
    required this.triling_iconname,
    required this.leadding_iconname,
    required this.textinputtype,
    required this.customfocusnode,
    required this.customtextinputaction,
    // required this.customFunction,
  }) : super(key: key);

  final TextEditingController customController;
  final String? labeltext;
  final String? hinttext;
  // final Function? customFunction;
  final IconData? triling_iconname;
  final IconData? leadding_iconname;
  final TextInputType? textinputtype;
  final FocusNode? customfocusnode;
  final TextInputAction? customtextinputaction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      autofocus: true,
      textInputAction:
          (customtextinputaction == null) ? null : customtextinputaction,
      focusNode: customfocusnode,
      controller: customController,
      cursorColor: Colors.black,
      keyboardType: (textinputtype == null) ? null : textinputtype,
      style: const TextStyle(
          // letterSpacing: 1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      decoration: InputDecoration(
        suffixIcon: (triling_iconname == null)
            ? null
            : Icon(triling_iconname), //icon at tail of input
        icon: (leadding_iconname == null) ? null : Icon(leadding_iconname),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        labelText: (labeltext == null) ? null : "$labeltext",
        labelStyle: const TextStyle(letterSpacing: 1, fontSize: 14),
        hintStyle: TextStyle(fontSize: 13),
        hintText: (hinttext == null) ? null : "$hinttext",
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }
}
