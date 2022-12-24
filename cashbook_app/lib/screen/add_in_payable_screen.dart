import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AddInPayableScreen extends StatefulWidget {
  const AddInPayableScreen({super.key});
  static const routeName = '/AddInPayableScreen';

  @override
  State<AddInPayableScreen> createState() => _AddInPayableScreenState();
}

class _AddInPayableScreenState extends State<AddInPayableScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? selectedCname;
  final List<String> cNameList = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  Future<void> _submitHander() async {
    print(selectedCname);
  }

  @override
  Widget build(BuildContext context) {
    var mqhight=MediaQuery.of(context).size.height;
    var mqwidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("add in payable"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          child: Column(
            children: [
              Text("data"),
              DropdownButtonHideUnderline(
                child: Center(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        // Icon(
                        //   Icons.list,
                        //   size: 16,
                        //   color: Colors.black,
                        // ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Select Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: cNameList
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedCname = value as String;
                      });
                    },
                    value: selectedCname,
                    icon: const Icon(
                      Icons.arrow_drop_down_outlined,
                    ),
                    iconSize: 23,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.white,
                    buttonHeight: 50,
                    buttonWidth: 400,
                    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.white,
                    ),
                    buttonElevation: 0,
                    itemHeight: 48,
                    // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 250,
                    dropdownWidth: 383,
                    dropdownPadding: null,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    dropdownElevation: 2,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    // offset: const Offset(-20, 0),
                  ),
                ),
              ),
              ElevatedButton(onPressed: _submitHander, child: Text("btn"))
            ],
          ),
        ),
      ),
    );
  }
}
