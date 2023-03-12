import 'package:flutter/material.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    Key? key,
    required this.customController,
    required this.labeltext,
    required this.hinttext,
    required this.textinputtype,
    required this.customfocusnode,
    required this.customOnChangedFuction,
    required this.customClearSearchFuction,
  }) : super(key: key);

  final TextEditingController customController;
  final String? labeltext;
  final String? hinttext;
  final Function customOnChangedFuction;
  final Function customClearSearchFuction;
  final TextInputType? textinputtype;
  final FocusNode? customfocusnode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        customOnChangedFuction(value, context);
      },
      textInputAction: TextInputAction.search,
      focusNode: customfocusnode,
      controller: customController,
      cursorColor: Colors.black,
      keyboardType: (textinputtype == null) ? null : textinputtype,
      decoration: InputDecoration(
        suffixIcon: customfocusnode!.hasFocus
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  customClearSearchFuction();
                },
              )
            : null,
        prefixIcon: Icon(Icons.search_rounded),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        labelText: (labeltext == null) ? null : "$labeltext",
        labelStyle: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(letterSpacing: 0.3, fontSize: 14),
        hintStyle: const TextStyle(fontSize: 13),
        hintText: (hinttext == null) ? null : "$hinttext",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }
}
