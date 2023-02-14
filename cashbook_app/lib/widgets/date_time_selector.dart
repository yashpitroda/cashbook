import "package:flutter/material.dart";

import '../utill/utility.dart';

class DateTimeSelector extends StatefulWidget {
  const DateTimeSelector({Key? key, required this.customFinalDatetime})
      : super(key: key);
  final DateTime? customFinalDatetime;
  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedtime;
  //  void customTimePicker() {
  //   showTimePicker(context: context, initialTime: TimeOfDay.now())
  //       .then((pickedtime) {
  //     if (pickedtime == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedtime = pickedtime;
  //       final hourr = _selectedtime!.hour;
  //       final minitt = _selectedtime!.minute;
  //       widget.customFinalDatetime = DateTime(finaldateTime!.year, finaldateTime!.month,
  //           finaldateTime!.day, hourr, minitt);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          // onTap: customDatePicker,
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded),
              SizedBox(
                width: 6,
              ),
              Text(Utility.dateFormat_DDMMYYYY()
                  .format(widget.customFinalDatetime!)),
              const Icon(
                Icons.arrow_drop_down,
                size: 26,
              )
            ],
          ),
        ),
        InkWell(
          // onTap: customTimePicker,
          child: Row(
            children: [
              const Icon(Icons.alarm),
              SizedBox(
                width: 6,
              ),
              Text(Utility.datetime_to_timeAMPM(
                  souceDateTime: widget.customFinalDatetime!)),
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
