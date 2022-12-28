import 'package:cashbook_app/screen/select_client_sreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextfield.dart';

class AddInPayableScreen extends StatefulWidget {
  const AddInPayableScreen({super.key});
  static const routeName = '/AddInPayableScreen';

  @override
  State<AddInPayableScreen> createState() => _AddInPayableScreenState();
}

class _AddInPayableScreenState extends State<AddInPayableScreen> {
  // final currentUser = FirebaseAuth.instance.currentUser!;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();

  int? _isBillValue = 1;

  DateTime? _selectedDate;
  TimeOfDay? _selectedtime;
  DateTime? finaldateTime;
  Map? selectedClientMap;

  Future<void> _submitHander() async {
    print(amountController.text);
    print(descriptionController.text);
    print(_isBillValue);
    print(finaldateTime.toString());
    print(selectedClientMap);
    // print(currentUser.email!);
  }

  @override
  void initState() {
    DateTime current_date = DateTime.now();
    finaldateTime = current_date;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Add Entry In Payable",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DateTimeSelector(mqwidth),
                    SizedBox(
                      height: mqhight * 0.02,
                    ),

                    CustomTextField(
                      customfocusnode: null,
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
                      customfocusnode: null,
                      textinputtype: TextInputType.name,
                      labeltext: "Description",
                      customController: descriptionController,
                      hinttext: "product name",
                      leadding_iconname: null,
                      triling_iconname: null,
                    ),
                    SizedBox(
                      height: mqhight * 0.02,
                    ),
                    Row(
                      children: [
                        ChoiceChip(
                          backgroundColor:
                              const Color.fromARGB(255, 192, 200, 216),
                          selectedColor:
                              const Color.fromARGB(255, 104, 167, 255),
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
                          backgroundColor:
                              const Color.fromARGB(255, 192, 200, 216),
                          selectedColor:
                              const Color.fromARGB(255, 104, 167, 255),
                          label: const Text('WITHOUT BILL'),
                          selected: _isBillValue == 0,
                          onSelected: (bool selected) {
                            setState(() {
                              _isBillValue = selected ? 0 : null;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mqhight * 0.02,
                    ),
                    // CustomTextField(
                    //   // textinputtype: TextInputType.number,
                    //   textinputtype: null,
                    //   labeltext: "Client name",
                    //   customController: descriptionController,
                    //   hinttext: null,
                    //   leadding_iconname: null,
                    //   triling_iconname: Icons.arrow_right,
                    // ),
                    TextField(
                      readOnly: true,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SelectClintScreen.routeName)
                            .then((value) {
                          selectedClientMap = value as Map;
                          print(selectedClientMap);
                          clientNameController.text =
                              selectedClientMap!["cname"];
                        });
                      },
                      controller: clientNameController,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          // letterSpacing: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.arrow_right), //icon at tail of input
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        labelText: "client name",
                        labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
                        hintStyle: TextStyle(fontSize: 13),

                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      ),
                    ),

                    // ElevatedButton(
                    //     onPressed: _submitHander, child: const Text("btn")),
                  ],
                ),
              ),
            ),
            Container(
              // color: Colors.amber,
              child: Column(
                children: [
                  Divider(
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
                              fixedSize: const Size(10, 55),
                              backgroundColor: Colors.red),
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
              ),
            ),
          ],
        ),
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
              Text(finaldateTime.toString().split(' ')[1].split('.')[0]),
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
