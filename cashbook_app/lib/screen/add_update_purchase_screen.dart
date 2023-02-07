import 'dart:math';

import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/screen/select_supplier_screen.dart';
import 'package:cashbook_app/utill/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/customtextfield.dart';

class AddUpdatePurchaseScreen extends StatefulWidget {
  const AddUpdatePurchaseScreen({super.key});
  static const routeName = '/AddUpdatePurchaseScreen';

  @override
  State<AddUpdatePurchaseScreen> createState() =>
      _AddUpdatePurchaseScreenState();
}

class _AddUpdatePurchaseScreenState extends State<AddUpdatePurchaseScreen> {
  bool _is_INSTANT_PAYMENT = true;
  bool _isCREDIT_ADVANCE = false;

  double padvalue = 110;
  // final currentUser = FirebaseAuth.instance.currentUser!;
  FocusNode? billamountFocusNode;
  FocusNode? paidamountFocusNode;
  FocusNode? descriptionFocusNode;
  TextEditingController billamountController = TextEditingController();
  TextEditingController paidamountController = TextEditingController();
  TextEditingController updatedadvanceamountController =
      TextEditingController();
  TextEditingController updatedoutstandingamountController =
      TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierMobilenoController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();

  int? _isBillValue = 1;
  int? _iscashBankValue = 0;

  DateTime? _selectedDate;
  TimeOfDay? _selectedtime;
  DateTime? finaldateTime;
  Supplier? selectedSupplierobj;

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    finaldateTime = currentDate;
    billamountFocusNode = FocusNode();
    paidamountFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    billamountFocusNode!.dispose();
    paidamountFocusNode!.dispose();
    descriptionFocusNode!.dispose();
    super.dispose();
  }

  void doEmptyController() {
    billamountController.text = "";
    paidamountController.text = "";
    updatedadvanceamountController.text = "";
    updatedoutstandingamountController.text = "";
    // if (_isPAID) {
    // } else {
    //   updatedoutstandingamountController.text = "";
    //   setState(() {});
    // }

    // if (is_payOnlyOutstanding && _isCREDIT_ADVANCE) {
    //   billamountController.text = "0";
    // } else {
    //   billamountController.text = "";
    // }
  }

  void onChangedInINSTANT_PAYMENT({required String value}) {
    if (value.isEmpty) {
      paidamountController.text = "";
      updatedadvanceamountController.text = "";
      updatedoutstandingamountController.text = "";
    }
    if (value == "") {
      paidamountController.text = "";
      updatedadvanceamountController.text = "";
      updatedoutstandingamountController.text = "";
    }

    if (_isBillValue == 1) {
      updatedoutstandingamountController.text =
          selectedSupplierobj!.outstanding_amount_withbill;
      if ((int.parse(value) >
          int.parse((selectedSupplierobj!.advance_amount_with_bill)))) {
        paidamountController.text = (int.parse(value) -
                int.parse((selectedSupplierobj!.advance_amount_with_bill)))
            .toString();
        updatedadvanceamountController.text = "0";
      } else {
        updatedadvanceamountController.text = (-(int.parse(value) -
                int.parse((selectedSupplierobj!.advance_amount_with_bill))))
            .toString();
        paidamountController.text = "0";
      }
    } else {
      updatedoutstandingamountController.text =
          selectedSupplierobj!.outstanding_amount_without_bill;
      if ((int.parse(value) >
          int.parse((selectedSupplierobj!.advance_amount_without_bill)))) {
        paidamountController.text = (int.parse(value) -
                int.parse((selectedSupplierobj!.advance_amount_without_bill)))
            .toString();
        updatedadvanceamountController.text = "0";
      } else {
        updatedadvanceamountController.text = (-(int.parse(value) -
                int.parse((selectedSupplierobj!.advance_amount_without_bill))))
            .toString();
        paidamountController.text = "0";
      }
    }
  }

  void onChangedInCREDIT({required String value}) {
    if (is_payOnlyOutstanding) {
      billamountController.text = "0";
    }
    if (value.isEmpty) {
      updatedoutstandingamountController.text = "";
      updatedadvanceamountController.text = "";
    }
    String currentOutstandingAmount =
        (int.parse(billamountController.text) - int.parse((value))).toString();
    String totalOutstandingAmount_withbill =
        (int.parse(currentOutstandingAmount) +
                int.parse((selectedSupplierobj!.outstanding_amount_withbill)))
            .toString();
    String totalOutstandingAmount_withoutbill = (int.parse(
                currentOutstandingAmount) +
            int.parse((selectedSupplierobj!.outstanding_amount_without_bill)))
        .toString();
    if (_isBillValue == 1) {
      if ((int.parse(totalOutstandingAmount_withbill) >
          int.parse((selectedSupplierobj!.advance_amount_with_bill)))) {
        updatedadvanceamountController.text = "0";
        updatedoutstandingamountController.text =
            (int.parse(totalOutstandingAmount_withbill) -
                    int.parse((selectedSupplierobj!.advance_amount_with_bill)))
                .toString();
      } else {
        updatedoutstandingamountController.text = "0";
        updatedadvanceamountController.text =
            (-(int.parse(totalOutstandingAmount_withbill) -
                    int.parse((selectedSupplierobj!.advance_amount_with_bill))))
                .toString();
      }
    } else {
      if ((int.parse(totalOutstandingAmount_withoutbill) >
          int.parse((selectedSupplierobj!.advance_amount_without_bill)))) {
        updatedadvanceamountController.text = "0";
        updatedoutstandingamountController
            .text = (int.parse(totalOutstandingAmount_withoutbill) -
                int.parse((selectedSupplierobj!.advance_amount_without_bill)))
            .toString();
      } else {
        updatedoutstandingamountController.text = "0";
        updatedadvanceamountController
            .text = (-(int.parse(totalOutstandingAmount_withoutbill) -
                int.parse((selectedSupplierobj!.advance_amount_without_bill))))
            .toString();
      }
    }
  }

  void onTapOn_onlyOutstanding() {
    setState(() {
      is_payOnlyOutstanding = !(is_payOnlyOutstanding);

      if (is_payOnlyOutstanding == true) {
        billamountController.text = "0";
      }
    });
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
      selectedSupplierobj = value as Supplier?;
      if (selectedSupplierobj != null) {
        firmNameController.text = selectedSupplierobj!.firmname;
        supplierNameController.text = selectedSupplierobj!.sname;
        supplierMobilenoController.text = selectedSupplierobj!.smobileno;
      }
      setState(() {
        doEmptyController();
      });
    });
  }

  bool is_payOnlyOutstanding = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.black;
  }

  int c_cr = 0;
  Future<void> _submitHander(BuildContext context) async {
    // print(billamountController.text);
    // print(descriptionController.text);
    // print(_isBillValue);
    // print(finaldateTime.toString());
    // print(firmNameController.text);
    // print(supplierNameController.text);
    // print(supplierMobilenoController.text);
    // print(currentUser.email!);

    // if (_is_INSTANT_PAYMENT) {
    //   c_cr = 0;
    // }
    // if (_isCREDIT_ADVANCE) {
    //   c_cr = 1;
    // }

    Provider.of<PurchaseProvider>(context, listen: false)
        .submit_IN_Purchase(
            isBillValue: _isBillValue!,
            c_cr: c_cr,
            cash_bank: _iscashBankValue!,
            selectedSupplierobj: selectedSupplierobj!,
            billAmount: int.parse(billamountController.text),
            paidAmount: int.parse(paidamountController.text),
            updatedAdavanceAmount:
                int.parse(updatedadvanceamountController.text),
            updatedOutstandingAmount:
                int.parse(updatedoutstandingamountController.text),
            remark: descriptionController.text,
            finaldateTime: finaldateTime!)
        .then((value) {
      if (value == "success") {
        print("done");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add purchase",
          style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Utility.removeFocus(context: context);
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
                        const Divider(
                          thickness: 1.2,
                        ),
                        billWithOrWithoutOption(mqwidth),
                        cashBankOption(mqwidth),
                        // SizedBox(
                        //   height: mqhight * 0.02,
                        // ),
                        const Divider(
                          thickness: 1.2,
                        ),

                        Column(
                          children: [
                            SizedBox(
                              height: mqhight * 0.007,
                            ),
                            firmnameTextField(),
                            SizedBox(
                              height: mqhight * 0.015,
                            ),
                            Row(
                              children: [
                                Expanded(child: clientNameTextField()),
                                SizedBox(
                                  width: mqwidth * 0.02,
                                ),
                                Expanded(child: clientPhoneTextField()),
                              ],
                            ),
                            SizedBox(
                              height: mqhight * 0.007,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (selectedSupplierobj == null)
                                  ? []
                                  : [
                                      Text(
                                          "outstanding-bill : ${selectedSupplierobj!.outstanding_amount_withbill}"),
                                      Text(
                                          "outstanding-withoutbill : ${selectedSupplierobj!.outstanding_amount_without_bill}"),
                                      Text(
                                          "advance-bill : ${selectedSupplierobj!.advance_amount_with_bill}"),
                                      Text(
                                          "advance-withoutbill : ${selectedSupplierobj!.advance_amount_without_bill}"),
                                    ],
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: mqhight * 0.01,
                        // ),
                        const Divider(
                          thickness: 1.2,
                        ),

                        SizedBox(
                          height: mqhight * 0.007,
                        ),
                        (selectedSupplierobj == null)
                            ? Container()
                            : Center(
                                child: Container(
                                  // width: mqwidth * 1,
                                  child: DefaultTabController(
                                    length: 2,
                                    initialIndex: 0,
                                    child: Column(children: [
                                      Tabs(context),
                                      Container(
                                          // color: Colors.pink,
                                          height: 197,
                                          child: TabBarView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                INSTANT_PAYMENTtabView(
                                                    mqhight, mqwidth),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: mqhight * 0.015,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          (is_payOnlyOutstanding)
                                                              ? MainAxisAlignment
                                                                  .end
                                                              : MainAxisAlignment
                                                                  .start,
                                                      children: [
                                                        (is_payOnlyOutstanding ==
                                                                true)
                                                            ? Container()
                                                            : Expanded(
                                                                child:
                                                                    TextField(
                                                                  //no on change
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value
                                                                        .isEmpty) {
                                                                      updatedadvanceamountController
                                                                          .text = "";
                                                                      updatedoutstandingamountController
                                                                          .text = "";
                                                                    }
                                                                    if (paidamountController
                                                                        .text
                                                                        .isEmpty) {
                                                                      return;
                                                                    } else {
                                                                      onChangedInCREDIT(
                                                                          value:
                                                                              paidamountController.text);
                                                                    }
                                                                  },
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  controller:
                                                                      billamountController,
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          16),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            208,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                    ),
                                                                    labelText:
                                                                        "Bill Amount",
                                                                    labelStyle: TextStyle(
                                                                        letterSpacing:
                                                                            1,
                                                                        fontSize:
                                                                            14),
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                    contentPadding:
                                                                        EdgeInsets.fromLTRB(
                                                                            20.0,
                                                                            15.0,
                                                                            20.0,
                                                                            15.0),
                                                                  ),
                                                                ),
                                                              ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColor),
                                                              value:
                                                                  is_payOnlyOutstanding,
                                                              onChanged: (bool?
                                                                  value) {
                                                                // setState(() {
                                                                //   is_payOnlyOutstanding =
                                                                //       value!;
                                                                //   if (is_payOnlyOutstanding ==
                                                                //       true) {
                                                                //     billamountController
                                                                //             .text =
                                                                //         "0";
                                                                //   }
                                                                // });
                                                                onTapOn_onlyOutstanding();
                                                              },
                                                            ),
                                                            // SizedBox(
                                                            //   width:
                                                            //       mqwidth * 0.004,
                                                            // ),
                                                            InkWell(
                                                              onTap: () {
                                                                onTapOn_onlyOutstanding();
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            3),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: const [
                                                                    Text(
                                                                      "pay only",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 1,
                                                                    ),
                                                                    Text(
                                                                      "outstanding",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: mqhight * 0.015,
                                                    ),
                                                    TextField(
                                                      // enabled: false,
                                                      // readOnly: true,
                                                      onChanged: (value) {
                                                        onChangedInCREDIT(
                                                            value: value);
                                                      },
                                                      controller:
                                                          paidamountController,
                                                      cursorColor: Colors.black,
                                                      style: const TextStyle(
                                                          // letterSpacing: 1,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                      decoration:
                                                          const InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                        labelText:
                                                            "paid Amount",
                                                        labelStyle: TextStyle(
                                                            letterSpacing: 1,
                                                            fontSize: 14),
                                                        hintStyle: TextStyle(
                                                            fontSize: 13),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20.0,
                                                                15.0,
                                                                20.0,
                                                                15.0),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: mqhight * 0.015,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextField(
                                                            enabled: false,
                                                            // readOnly: true,
                                                            controller:
                                                                updatedoutstandingamountController,
                                                            cursorColor:
                                                                Colors.black,
                                                            style: const TextStyle(
                                                                // letterSpacing: 1,
                                                                color: Colors.black,
                                                                // fontWeight:
                                                                //     FontWeight
                                                                //         .w500,
                                                                fontSize: 16),
                                                            decoration:
                                                                const InputDecoration(
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      208,
                                                                      235,
                                                                      238,
                                                                      244),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                              ),
                                                              labelText:
                                                                  "Now Outstanding Amount",
                                                              labelStyle: TextStyle(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 14),
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          13),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20.0,
                                                                          15.0,
                                                                          20.0,
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: mqwidth * 0.02,
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            enabled: false,
                                                            // readOnly: true,
                                                            controller:
                                                                updatedadvanceamountController,
                                                            cursorColor:
                                                                Colors.black,
                                                            style: const TextStyle(
                                                                // letterSpacing: 1,
                                                                color: Colors.black,
                                                                // fontWeight:
                                                                //     FontWeight
                                                                //         .w500,
                                                                fontSize: 16),
                                                            decoration:
                                                                const InputDecoration(
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      208,
                                                                      235,
                                                                      238,
                                                                      244),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                              ),
                                                              labelText:
                                                                  "Now Advance Amount",
                                                              labelStyle: TextStyle(
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 14),
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          13),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20.0,
                                                                          15.0,
                                                                          20.0,
                                                                          15.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // SizedBox(
                                                    //   height: mqhight * 0.015,
                                                    // ),
                                                    SizedBox(
                                                      height: mqhight * 0.015,
                                                    ),
                                                  ],
                                                ),
                                              ])),
                                      CustomTextField(
                                        customtextinputaction:
                                            TextInputAction.done,
                                        customfocusnode: descriptionFocusNode,
                                        textinputtype: TextInputType.name,
                                        labeltext: "remark",
                                        customController: descriptionController,
                                        hinttext: "product name",
                                        leadding_iconname: null,
                                        triling_iconname: null,
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
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

  Column INSTANT_PAYMENTtabView(double mqhight, double mqwidth) {
    return Column(
      children: [
        SizedBox(
          height: mqhight * 0.015,
        ),
        TextField(
          onChanged: (value) {
            onChangedInINSTANT_PAYMENT(value: value);
          },
          keyboardType: TextInputType.number,
          controller: billamountController,
          cursorColor: Colors.black,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(208, 255, 255, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            labelText: "Bill Amount",
            labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
            hintStyle: TextStyle(fontSize: 13),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
        ),
        SizedBox(
          height: mqhight * 0.015,
        ),
        TextField(
          enabled: false,
          // readOnly: true,
          controller: paidamountController,
          cursorColor: Colors.black,
          style: const TextStyle(
              // letterSpacing: 1,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(208, 235, 238, 244),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            labelText: "paid Amount",
            labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
            hintStyle: TextStyle(fontSize: 13),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
        ),
        SizedBox(
          height: mqhight * 0.015,
        ),
        // TextField(
        //   enabled: false,
        //   // readOnly: true,
        //   controller: updatedadvanceamountController,
        //   cursorColor: Colors.black,
        //   style: const TextStyle(
        //       // letterSpacing: 1,
        //       color: Colors.black,
        //       fontWeight: FontWeight.w500,
        //       fontSize: 16),
        //   decoration: const InputDecoration(
        //     filled: true,
        //     fillColor: Color.fromARGB(208, 235, 238, 244),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(4)),
        //     ),
        //     labelText: "updated advance Amount",
        //     labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        //     hintStyle: TextStyle(fontSize: 13),
        //     contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //   ),
        // ),
        // SizedBox(
        //   height: mqhight * 0.015,
        // ),
        // TextField(
        //   enabled: false,
        //   // readOnly: true,
        //   controller: updatedoutstandingamountController,
        //   cursorColor: Colors.black,
        //   style: const TextStyle(
        //       // letterSpacing: 1,
        //       color: Colors.black,
        //       fontWeight: FontWeight.w500,
        //       fontSize: 16),
        //   decoration: const InputDecoration(
        //     filled: true,
        //     fillColor: Color.fromARGB(208, 235, 238, 244),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(4)),
        //     ),
        //     labelText: "updated outstanding Amount",
        //     labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
        //     hintStyle: TextStyle(fontSize: 13),
        //     contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //   ),
        // ),
        Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                // readOnly: true,
                controller: updatedoutstandingamountController,
                cursorColor: Colors.black,
                style: const TextStyle(
                    // letterSpacing: 1,
                    color: Colors.black,
                    // fontWeight:
                    //     FontWeight
                    //         .w500,
                    fontSize: 16),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(208, 235, 238, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  labelText: "Now Outstanding Amount",
                  labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
                  hintStyle: TextStyle(fontSize: 13),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
              ),
            ),
            SizedBox(
              width: mqwidth * 0.02,
            ),
            Expanded(
              child: TextField(
                enabled: false,
                // readOnly: true,
                controller: updatedadvanceamountController,
                cursorColor: Colors.black,
                style: const TextStyle(
                    // letterSpacing: 1,
                    color: Colors.black,
                    // fontWeight:
                    //     FontWeight
                    //         .w500,
                    fontSize: 16),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(208, 235, 238, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  labelText: "Now Advance Amount",
                  labelStyle: TextStyle(letterSpacing: 1, fontSize: 14),
                  hintStyle: TextStyle(fontSize: 13),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: mqhight * 0.015,
        ),
      ],
    );
  }

  // ------------------------------TABS-----------------------------------
  Widget Tabs(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(208, 229, 231, 236)),
      child: TabBar(
        onTap: (value) {
          doEmptyController();
          Utility.removeFocus(context: context);
          if (value == 0) {
            c_cr = 0;
            _is_INSTANT_PAYMENT = true;
            _isCREDIT_ADVANCE = false;
          }
          if (value == 1) {
            c_cr = 1;
            _is_INSTANT_PAYMENT = false;
            _isCREDIT_ADVANCE = true;
            // if (_isBillValue == 1) {
            //   updatedoutstandingamountController.text =
            //       selectedSupplierobj!.outstanding_amount_withbill;
            // } else {
            //   updatedoutstandingamountController.text =
            //       selectedSupplierobj!.outstanding_amount_without_bill;
            // }
          }
          // print(_isPAID);
          // print(_isCREDIT_ADVANCE);
          // if (value == 2) {
          //   _isPAID = false;
          //   _isCREDIT = false;
          //   _isADVANCE = true;
          // }
          // print("--");
          // print(_isPAID);
          // print("--");
          // print(_isCREDIT);
          // print("--");
          // print(_isADVANCE);
        },
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green.shade500),
        tabs: const [
          Tab(
            child: Text(
              'INSTANT PAYMENT',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Tab(
            child: Text(
              'CREDIT/ADVANCE',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          // Tab(
          //   child: Text(
          //     'ADVANCE',
          //     style: TextStyle(fontWeight: FontWeight.w700),
          //   ),
          // ),
        ],
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
                onPressed: () {
                  _submitHander(context);
                },
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
              doEmptyController();
              Utility.removeFocus(context: context);
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
              doEmptyController();
              Utility.removeFocus(context: context);
            });
          },
        ),
      ],
    );
  }

  Row cashBankOption(double mqwidth) {
    return Row(
      children: [
        ChoiceChip(
          backgroundColor: const Color.fromARGB(255, 192, 200, 216),
          selectedColor: const Color.fromARGB(255, 104, 167, 255),
          label: const Text('CASH'),
          selected: _iscashBankValue == 0,
          onSelected: (bool selected) {
            setState(() {
              _iscashBankValue = selected ? 0 : null;
            });
          },
        ),
        SizedBox(
          width: mqwidth * 0.03,
        ),
        ChoiceChip(
          backgroundColor: const Color.fromARGB(255, 192, 200, 216),
          selectedColor: const Color.fromARGB(255, 104, 167, 255),
          label: const Text('Bank'),
          selected: _iscashBankValue == 1,
          onSelected: (bool selected) {
            setState(() {
              _iscashBankValue = selected ? 1 : null;
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
