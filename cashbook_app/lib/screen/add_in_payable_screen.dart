import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/screen/select_supplier_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextfield.dart';
import '../services/date_time_utill.dart';

class AddInPayableScreen extends StatefulWidget {
  const AddInPayableScreen({super.key});
  static const routeName = '/AddInPayableScreen';

  @override
  State<AddInPayableScreen> createState() => _AddInPayableScreenState();
}

class _AddInPayableScreenState extends State<AddInPayableScreen> {
  // final currentUser = FirebaseAuth.instance.currentUser!;
  FocusNode? amountFocusNode;
  FocusNode? descriptionFocusNode;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierMobilenoController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();

  int? _isBillValue = 1;

  DateTime? _selectedDate;
  TimeOfDay? _selectedtime;
  DateTime? finaldateTime;
  Supplier? selectedSupplierobj;

  Future<void> _submitHander() async {
    print(amountController.text);
    print(descriptionController.text);
    print(_isBillValue);
    print(finaldateTime.toString());
    print(firmNameController.text);
    print(supplierNameController.text);
    print(supplierMobilenoController.text);
    // print(currentUser.email!);
  }

  @override
  void initState() {
    DateTime current_date = DateTime.now();
    finaldateTime = current_date;
    amountFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    amountFocusNode!.dispose();
    descriptionFocusNode!.dispose();
    super.dispose();
  }

  void customDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickdedDate) {
      if (pickdedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickdedDate;
        final day = _selectedDate!.day;
        final mounth = _selectedDate!.month;
        final year = _selectedDate!.year;
        finaldateTime = DateTime(
            year, mounth, day, finaldateTime!.hour, finaldateTime!.minute);
      });
    });
  }

  void customTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((pickedtime) {
      if (pickedtime == null) {
        return;
      }
      setState(() {
        _selectedtime = pickedtime;
        final hourr = _selectedtime!.hour;
        final minitt = _selectedtime!.minute;
        finaldateTime = DateTime(finaldateTime!.year, finaldateTime!.month,
            finaldateTime!.day, hourr, minitt);
      });
    });
  }

  void _gotoSelectClintScreen() {
    Navigator.of(context)
        .pushNamed(SelectSupplierScreen.routeName)
        .then((value) {
      selectedSupplierobj = value as Supplier;
      firmNameController.text = selectedSupplierobj!.firmname;
      supplierNameController.text = selectedSupplierobj!.sname;
      supplierMobilenoController.text = selectedSupplierobj!.smobileno;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Entry In Payable",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          amountFocusNode!.unfocus();
          descriptionFocusNode!.unfocus();
        },
        child: Container(
          // color: Colors.grey.withOpacity(0.09),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateTimeSelector(mqwidth),
                        SizedBox(
                          height: mqhight * 0.02,
                        ),
                        Column(
                          children: [
                            firmnameTextField(),
                            SizedBox(
                              height: mqhight * 0.02,
                            ),
                            clientNameTextField(),
                            SizedBox(
                              height: mqhight * 0.02,
                            ),
                            clientPhoneTextField(),
                          ],
                        ),
                        SizedBox(
                          height: mqhight * 0.01,
                        ),
                        const Divider(
                          thickness: 1.2,
                        ),
                        SizedBox(
                          height: mqhight * 0.01,
                        ),
                        CustomTextField(
                          customtextinputaction: TextInputAction.next,
                          customfocusnode: amountFocusNode,
                          textinputtype: TextInputType.number,
                          labeltext: "Amount",
                          customController: amountController,
                          hinttext: null,
                          leadding_iconname: null,
                          triling_iconname: null,
                        ),
                        SizedBox(
                          height: mqhight * 0.02,
                        ),
                        CustomTextField(
                          customtextinputaction: TextInputAction.done,
                          customfocusnode: descriptionFocusNode,
                          textinputtype: TextInputType.name,
                          labeltext: "remark",
                          customController: descriptionController,
                          hinttext: "product name",
                          leadding_iconname: null,
                          triling_iconname: null,
                        ),
                        SizedBox(
                          height: mqhight * 0.015,
                        ),
                        billWithOrWithoutOption(mqwidth),
                      ],
                    ),
                  ),
                ),
                bottombuttoncard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column bottombuttoncard(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1.3,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(10, 55), backgroundColor: Colors.red),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Rubik',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitHander,
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(10, 55),
                    backgroundColor: Colors.blue),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Rubik',
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Row billWithOrWithoutOption(double mqwidth) {
    return Row(
      children: [
        ChoiceChip(
          backgroundColor: const Color.fromARGB(255, 192, 200, 216),
          selectedColor: const Color.fromARGB(255, 104, 167, 255),
          label: const Text('WITH BILL'),
          selected: _isBillValue == 1,
          onSelected: (bool selected) {
            setState(() {
              _isBillValue = selected ? 1 : null;
            });
          },
        ),
        SizedBox(
          width: mqwidth * 0.03,
        ),
        ChoiceChip(
          backgroundColor: const Color.fromARGB(255, 192, 200, 216),
          selectedColor: const Color.fromARGB(255, 104, 167, 255),
          label: const Text('WITHOUT BILL'),
          selected: _isBillValue == 0,
          onSelected: (bool selected) {
            setState(() {
              _isBillValue = selected ? 0 : null;
            });
          },
        ),
      ],
    );
  }

  TextField clientPhoneTextField() {
    return TextField(
      enabled: false,
      readOnly: true,
      controller: supplierMobilenoController,
      cursorColor: Colors.black,
      style: const TextStyle(
          // letterSpacing: 1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(208, 235, 238, 244),

        // suffixIcon: Icon(
        //     Icons.arrow_right), //icon at tail of input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        labelText: "Phone",
        // prefixText: "Client phone:  ",
        // hintText: "Client phone:  ",
        labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        hintStyle: TextStyle(fontSize: 13),

        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }

  TextField clientNameTextField() {
    return TextField(
      enabled: false,
      readOnly: true,
      controller: supplierNameController,
      cursorColor: Colors.black,
      style: const TextStyle(
          // letterSpacing: 1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(208, 235, 238, 244),
        // suffixIcon: Icon(
        //     Icons.arrow_right), //icon at tail of input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        // labelText: "client",
        labelText: "Name",
        labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        hintStyle: TextStyle(fontSize: 13),

        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }

  TextField firmnameTextField() {
    return TextField(
      readOnly: true,
      onTap: () {
        _gotoSelectClintScreen();
      },
      controller: firmNameController,
      cursorColor: Colors.black,
      style: const TextStyle(
          // letterSpacing: 1,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.arrow_right), //icon at tail of input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        // labelText: "client",
        labelText: "Firm Name",
        labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        hintStyle: TextStyle(fontSize: 13),

        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );
  }

  Row DateTimeSelector(double mqwidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: customDatePicker,
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded),
              SizedBox(
                width: mqwidth * 0.013,
              ),
              Text(finaldateTime.toString().split(' ')[0]),
              const Icon(
                Icons.arrow_drop_down,
                size: 26,
              )
            ],
          ),
        ),
        InkWell(
          onTap: customTimePicker,
          child: Row(
            children: [
              const Icon(Icons.alarm),
              SizedBox(
                width: mqwidth * 0.013,
              ),
              Text(DateTimeUtill.datetimeToTimeAmPm(
                  souceDateTime: finaldateTime!)),
              const Icon(
                Icons.arrow_drop_down,
                size: 26,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
