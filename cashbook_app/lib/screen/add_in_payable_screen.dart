import 'package:cashbook_app/screen/select_client_sreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  String? selectedCname;

  int? _isBillValue = 1;

  DateTime? _selectedDate;
  TimeOfDay? _selectedtime;
  DateTime? finaldateTime;
  Map? selectedClientMap;

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
    print(amountController.text);
    print(descriptionController.text);
    print(_isBillValue);
    // print(currentUser.email!);
    clientNameController.text = "yash";
  }

  @override
  void initState() {
    // TODO: implement initState
    DateTime current_date = DateTime.now();
    finaldateTime = current_date;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

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
        title: const Text("Add Entry In Payable"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          child: Column(
            children: [
              DateTimeSelector(mqwidth),
              SizedBox(
                height: mqhight * 0.02,
              ),
              CustomTextField(
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
                    clientNameController.text = selectedClientMap!["cname"];
                  });
                },
                controller: clientNameController,
                cursorColor: Colors.black,
                style: const TextStyle(
                    // letterSpacing: 1,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.arrow_right), //icon at tail of input
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  labelText: "client name",
                  labelStyle: const TextStyle(letterSpacing: 1, fontSize: 14),
                  hintStyle: TextStyle(fontSize: 13),

                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
              ),

              ElevatedButton(
                  onPressed: _submitHander, child: const Text("btn")),
            ],
          ),
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.customController,
    required this.labeltext,
    required this.hinttext,
    required this.triling_iconname,
    required this.leadding_iconname,
    required this.textinputtype,
  }) : super(key: key);

  final TextEditingController customController;
  final String? labeltext;
  final String? hinttext;
  final IconData? triling_iconname;
  final IconData? leadding_iconname;
  final TextInputType? textinputtype;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
