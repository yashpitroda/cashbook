import 'dart:async';
import 'dart:math';

import 'package:cashbook_app/models/account.dart';
import 'package:cashbook_app/models/supplier.dart';
import 'package:cashbook_app/provider/account_provider.dart';
import 'package:cashbook_app/provider/purchase_provider.dart';
import 'package:cashbook_app/screen/select_supplier_screen.dart';
import 'package:cashbook_app/utill/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/supplier_provider.dart';
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
  int c_cr = 0;

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

  var _isInit = true;
  var _isloading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<accountProvider>(context).fetchAccount().then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
    // print("qq1");
    // print(c_cr);
    // print("qq2");
    // print(_isBillValue);
    // print("qq3");
    // print(_iscashBankValue);
    if (selectedAccountObj == null) {
      Utility.displaysnackbar(context: context, message: "Select account");
      return;
    }
    if (firmNameController.text.isEmpty) {
      Utility.displaysnackbar(context: context, message: "Select firm first");
      return;
    }
    if (billamountController.text.isEmpty) {
      Utility.displaysnackbar(
          context: context, message: "Enter bill-amount first");
      return;
    }
    if (_isCREDIT_ADVANCE && paidamountController.text.isEmpty) {
      print("object");
      Utility.displaysnackbar(
          context: context, message: "Enter paid-amount first");
      return;
    }
    setState(() {
      _isloading = true;
    });
    // print("done");
    // if (firmnameController.text.isEmpty) {
    //   FocusScope.of(context).requestFocus(firmnameFocusNode);
    //   return;
    // }
    // if (smobilenoController.text.isEmpty) {
    //   FocusScope.of(context).requestFocus(smobilenoFocusNode);
    //   return;
    // }
    Utility.removeFocus(context: context);
    try {
      await Provider.of<PurchaseProvider>(context, listen: false)
          .submit_IN_Purchase(
              isBill: _isBillValue!,
              cOrCr: c_cr,
              accountId: selectedAccountObj!.accountId.toString(),
              selectedSupplierobj: selectedSupplierobj!,
              billAmount: int.parse(billamountController.text),
              paidAmount: int.parse(paidamountController.text),
              updatedAdavanceAmount:
                  int.parse(updatedadvanceamountController.text),
              updatedOutstandingAmount:
                  int.parse(updatedoutstandingamountController.text),
              remark: descriptionController.text,
              finaldateTime: finaldateTime!)
          .then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    } catch (e) {
      await showDialog(
          // showDialog is also future fuction
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('A error occurred!'),
              content: Text('somethings wents wrong.${e}'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("okey"),
                ),
              ],
            );
          });
    }
  }

  Future<void> addNewAccount() async {
    TextEditingController accountNameController = TextEditingController();
    TextEditingController intialAmountController = TextEditingController();
    await showCupertinoDialog(
        // showDialog is also future fuction
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Center(child: const Text('Add new account')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                    customController: accountNameController,
                    labeltext: "Account name",
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.name,
                    customfocusnode: null,
                    customtextinputaction: null),
                SizedBox(
                  height: 6,
                ),
                CustomTextField(
                    customController: intialAmountController,
                    labeltext: "Intial Amount",
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.number,
                    customfocusnode: null,
                    customtextinputaction: null)
              ],
            ),
            actions: [
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.of(ctx).pop();
              //   },
              //   child: Text("Done"),
              // ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.grey.withOpacity(0.3))),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue.withOpacity(0.9))),
                child: (_isloading)
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () async {
                  setState(() {
                    _isloading = true;
                  });
                  try {
                    await Provider.of<accountProvider>(context, listen: false)
                        .submit_In_add_New_account(
                            accountName: accountNameController.text,
                            date: DateTime.now(),
                            initialAmount: intialAmountController.text)
                        .then((_) async {
                      await Provider.of<accountProvider>(context, listen: false)
                          .fetchAccount()
                          .then((_) {
                        setState(() {
                          _isloading = false;
                        });
                        Navigator.of(ctx).pop();
                      });
                    });
                  } catch (e) {
                    await showDialog(
                        // showDialog is also future fuction
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text('A error occurred!'),
                            content: Text('somethings wents wrong.${e}'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("okey"),
                              ),
                            ],
                          );
                        });
                  }
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Account? selectedAccountObj;

  Future<void> selectAccount(BuildContext ctx
      //  List<Account> list
      ) async {
    // await Provider.of<accountProvider>(ctx, listen: false).fetchAccount();

    await showModalBottomSheet(
        context: ctx,
        builder: (_) {
          List<Account> accountlist =
              Provider.of<accountProvider>(ctx).getAccountList;
          return Container(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // itemCount: list.length,
                    itemCount: accountlist.length,
                    itemBuilder: (context, index) {
                      return
                          // ListTile(
                          //   title: Text(list[index].accountName!),
                          //   subtitle: Text(list[index].balance!),
                          // );
                          Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        color: Colors.white,
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${accountlist[index].accountName!}",
                                // "${list[index].accountName!}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Rubik"),
                              ),
                              Text(
                                Utility.dateFormat_DD_MonthName_YYYY()
                                    .format(accountlist[index].date!),
                                // .format(list[index].date!),
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: "Rubik"),
                              ),
                            ],
                          ),

                          // "${items[index].cname} AND cid=${items[index].cid}"

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${accountlist[index].balance!}",
                                // "",
                                style: const TextStyle(fontFamily: "Rubik"),
                              ),
                            ],
                          ),
                          // subtitle: Text(" ${items[index].entrydatetime}"),
                          value: accountlist[index],
                          groupValue: selectedAccountObj,
                          // toggleable: true,
                          onChanged: (value) {
                            setState(() {
                              selectedAccountObj = value;
                            });
                            // print(selectedSuppilerObj);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await addNewAccount();
                    },
                    child: Text("add new account"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var mqhight = MediaQuery.of(context).size.height;
    var mqwidth = MediaQuery.of(context).size.width;
    // List<Account> accountlist =
    //     Provider.of<accountProvider>(context).getAccountList;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add purchase",
          // style: TextStyle(fontFamily: "Rubik"),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Utility.removeFocus(context: context);
        },
        child: (_isloading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                // color: Colors.grey.withOpacity(0.09),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await addNewAccount();
                              //   },
                              //   child: Text("add new account"),
                              // ),
                              // const Divider(
                              //   thickness: 1.2,
                              // ),

                              DateTimeSelector(mqwidth),
                              const Divider(
                                thickness: 1.2,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await selectAccount(context);
                                  print(selectedAccountObj!.accountName);
                                },
                                child: Text("select account"),
                              ),

                              billWithOrWithoutOption(mqwidth),
                              // cashBankOption(mqwidth),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                            height:
                                                                mqhight * 0.015,
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
                                                                            updatedadvanceamountController.text =
                                                                                "";
                                                                            updatedoutstandingamountController.text =
                                                                                "";
                                                                          }
                                                                          if (paidamountController
                                                                              .text
                                                                              .isEmpty) {
                                                                            return;
                                                                          } else {
                                                                            onChangedInCREDIT(value: paidamountController.text);
                                                                          }
                                                                        },
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        controller:
                                                                            billamountController,
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 16),
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          filled:
                                                                              true,
                                                                          fillColor: Color.fromARGB(
                                                                              208,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(4)),
                                                                          ),
                                                                          labelText:
                                                                              "Bill Amount",
                                                                          labelStyle: TextStyle(
                                                                              letterSpacing: 1,
                                                                              fontSize: 14),
                                                                          hintStyle:
                                                                              TextStyle(fontSize: 13),
                                                                          contentPadding: EdgeInsets.fromLTRB(
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
                                                                        Colors
                                                                            .white,
                                                                    fillColor: MaterialStateProperty
                                                                        .resolveWith(
                                                                            getColor),
                                                                    value:
                                                                        is_payOnlyOutstanding,
                                                                    onChanged:
                                                                        (bool?
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
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              3),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: const [
                                                                          Text(
                                                                            "pay only",
                                                                            style:
                                                                                TextStyle(fontSize: 14),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                1,
                                                                          ),
                                                                          Text(
                                                                            "outstanding",
                                                                            style:
                                                                                TextStyle(fontSize: 15),
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
                                                            height:
                                                                mqhight * 0.015,
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
                                                            cursorColor:
                                                                Colors.black,
                                                            style:
                                                                const TextStyle(
                                                                    // letterSpacing: 1,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16),
                                                            decoration:
                                                                const InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors.white,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                              ),
                                                              labelText:
                                                                  "paid Amount",
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
                                                          SizedBox(
                                                            height:
                                                                mqhight * 0.015,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  enabled:
                                                                      false,
                                                                  // readOnly: true,
                                                                  controller:
                                                                      updatedoutstandingamountController,
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  style: const TextStyle(
                                                                      // letterSpacing: 1,
                                                                      color: Colors.black,
                                                                      // fontWeight:
                                                                      //     FontWeight
                                                                      //         .w500,
                                                                      fontSize: 16),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            208,
                                                                            235,
                                                                            238,
                                                                            244),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                    ),
                                                                    labelText:
                                                                        "Now Outstanding Amount",
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
                                                              SizedBox(
                                                                width: mqwidth *
                                                                    0.02,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  enabled:
                                                                      false,
                                                                  // readOnly: true,
                                                                  controller:
                                                                      updatedadvanceamountController,
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,
                                                                  style: const TextStyle(
                                                                      // letterSpacing: 1,
                                                                      color: Colors.black,
                                                                      // fontWeight:
                                                                      //     FontWeight
                                                                      //         .w500,
                                                                      fontSize: 16),
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            208,
                                                                            235,
                                                                            238,
                                                                            244),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                    ),
                                                                    labelText:
                                                                        "Now Advance Amount",
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
                                                            ],
                                                          ),
                                                          // SizedBox(
                                                          //   height: mqhight * 0.015,
                                                          // ),
                                                          SizedBox(
                                                            height:
                                                                mqhight * 0.015,
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                            CustomTextField(
                                              customtextinputaction:
                                                  TextInputAction.done,
                                              customfocusnode:
                                                  descriptionFocusNode,
                                              textinputtype: TextInputType.name,
                                              labeltext: "remark",
                                              customController:
                                                  descriptionController,
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
                onPressed: () async {
                  setState(() {
                    _isloading = true;
                  });
                  await Provider.of<SupplierProvider>(context, listen: false)
                      .fatchSupplier()
                      .then((_) async {
                    await Provider.of<PurchaseProvider>(context, listen: false)
                        .fatchPurchase();
                  }).then((_) {
                    setState(() {
                      _isloading = false;
                    });
                    Navigator.of(context).pop();
                  });
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
                onPressed: (_isloading)
                    ? null
                    : () {
                        _submitHander(context);
                      },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(10, 55),
                    backgroundColor: Colors.blue),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // (_isloading)
                    //     ? CircularProgressIndicator(
                    //         color: Colors.white,
                    //       )
                    //     :
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Rubik',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Card billWithOrWithoutOption(double mqwidth) {
    return Card(
      elevation: 0,
      child: Container(
        // color:
        decoration: BoxDecoration(
            // border: Border.all(
            //     width: 1,
            //     color: Colors.black45),
            color: Color.fromRGBO(242, 239, 239, 0.98),
            borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Invoice type",
                style: Theme.of(context).textTheme.caption!.copyWith(
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
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
                        // _isBillValue = selected ? 1 : null;
                        _isBillValue = 1;
                        doEmptyController();
                        Utility.removeFocus(context: context);
                      });
                    },
                  ),
                  SizedBox(
                    width: mqwidth * 0.02,
                  ),
                  ChoiceChip(
                    backgroundColor: const Color.fromARGB(255, 192, 200, 216),
                    selectedColor: const Color.fromARGB(255, 104, 167, 255),
                    label: const Text('WITHOUT BILL'),
                    selected: _isBillValue == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        // _isBillValue = selected ? 0 : null;
                        _isBillValue = 0;
                        doEmptyController();
                        Utility.removeFocus(context: context);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Row cashBankOption(double mqwidth) {
  //   return Row(
  //     children: [
  //       ChoiceChip(
  //         backgroundColor: const Color.fromARGB(255, 192, 200, 216),
  //         selectedColor: const Color.fromARGB(255, 104, 167, 255),
  //         label: const Text('CASH'),
  //         selected: _iscashBankValue == 0,
  //         onSelected: (bool selected) {
  //           setState(() {
  //             // _iscashBankValue = selected ? 0 : null;
  //             _iscashBankValue = 0;
  //           });
  //         },
  //       ),
  //       SizedBox(
  //         width: mqwidth * 0.03,
  //       ),
  //       ChoiceChip(
  //         backgroundColor: const Color.fromARGB(255, 192, 200, 216),
  //         selectedColor: const Color.fromARGB(255, 104, 167, 255),
  //         label: const Text('BANK'),
  //         selected: _iscashBankValue == 1,
  //         onSelected: (bool selected) {
  //           setState(() {
  //             // _iscashBankValue = selected ? 1 : null;
  //             _iscashBankValue = 1;
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }

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
              Text(Utility.dateFormat_DDMMYYYY().format(finaldateTime!)),
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
              Text(Utility.datetime_to_timeAMPM(souceDateTime: finaldateTime!)),
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
