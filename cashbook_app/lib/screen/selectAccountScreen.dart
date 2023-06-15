import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cashbook_app/models/category.dart';
import 'package:cashbook_app/provider/category_provider.dart';

import '../models/account.dart';
import '../provider/account_provider.dart';

import '../services/utility.dart';
import '../services/widget_component_utill.dart';
import '../widgets/customtextfield.dart';

class SelectAccountScreen extends StatelessWidget {
  static const String routeName = '/SelectAccountScreen';
  final bool isAccount;
  final String type;

  const SelectAccountScreen(
    this.isAccount,
    this.type,
  );

  Future<void> addNewCategory(BuildContext context) async {
    TextEditingController categoryNameController = TextEditingController();
    FocusNode categoryNameFocusNode = FocusNode();
    await showCupertinoDialog(
        // showDialog is also future fuction
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Add new category',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    // fontFamily: "Rubik",
                    // color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                    customController: categoryNameController,
                    labeltext: "category name",
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.name,
                    customfocusnode: categoryNameFocusNode,
                    customtextinputaction: TextInputAction.done),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 8, horizontal: 14)),
                  ),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          // fontFamily: "Rubik",
                          color: Colors.blue,
                          fontSize: 14,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w500,
                        ),
                  )),

              // ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 14)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue.withOpacity(0.8))),
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        // fontFamily: "Rubik",
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                onPressed: () async {
                  if (categoryNameController.text.isEmpty) {
                    WidgetComponentUtill.displaysnackbar(
                        context: context, message: "Fill account name");
                    return;
                  }

                  try {
                    await Provider.of<CategoryProvider>(context, listen: false)
                        .addNewCategory(
                            categorytName: categoryNameController.text,
                            type: type,
                            date: DateTime.now())
                        .then((_) {
                      Navigator.of(ctx).pop();
                      // Provider.of<accountProvider>(context, listen: false)
                      //     .fetchAccount()
                      //     .then((_) {
                      //   _isloading = false;
                      //   // setState(() {
                      //   // });
                      //   Navigator.of(ctx).pop();
                      // });
                    });
                  } catch (e) {
                    await showDialog(
                        // showDialog is also future fuction
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: const Text('A error occurred!'),
                            content: Text('somethings wents wrong.($e)'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text("Okey"),
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

  Future<void> addNewAccount(BuildContext context) async {
    TextEditingController accountNameController = TextEditingController();
    FocusNode accountNameFocusNode = FocusNode();
    FocusNode intialAmountFocusNoder = FocusNode();
    TextEditingController intialAmountController = TextEditingController();
    await showCupertinoDialog(
        // showDialog is also future fuction
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Add new account',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    // fontFamily: "Rubik",
                    // color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
            ),
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
                    customfocusnode: accountNameFocusNode,
                    customtextinputaction: TextInputAction.next),
                const SizedBox(
                  height: 6,
                ),
                CustomTextField(
                    customController: intialAmountController,
                    labeltext: "Intial amount",
                    hinttext: null,
                    triling_iconname: null,
                    leadding_iconname: null,
                    textinputtype: TextInputType.number,
                    customfocusnode: intialAmountFocusNoder,
                    customtextinputaction: TextInputAction.done)
              ],
            ),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  style: ButtonStyle(
                    // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(30.0))),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 8, horizontal: 14)),
                  ),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          // fontFamily: "Rubik",
                          color: Colors.blue,
                          fontSize: 14,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w500,
                        ),
                  )),
              // TextButton(
              //   style: ButtonStyle(
              //       padding: MaterialStateProperty.all(
              //           EdgeInsets.symmetric(vertical: 12, horizontal: 14)),
              //       backgroundColor: MaterialStateProperty.all(
              //           Colors.grey.withOpacity(0.3))),
              //   child: const Text('Cancel'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
              TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 14)),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue.withOpacity(0.8))),
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        // fontFamily: "Rubik",
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                onPressed: () async {
                  if (accountNameController.text.isEmpty) {
                    print("object");
                    WidgetComponentUtill.displaysnackbar(
                        context: context, message: "Fill account name");
                    return;
                  }
                  if (intialAmountController.text.isEmpty) {
                    WidgetComponentUtill.displaysnackbar(
                        context: context, message: "Fill intial amount");
                    return;
                  }
                  // _isloading = true;
                  // setState(() {
                  // });
                  try {
                    await Provider.of<AccountProvider>(context, listen: false)
                        .submit_In_add_New_account(
                            accountName: accountNameController.text,
                            date: DateTime.now(),
                            initialAmount: intialAmountController.text)
                        .then((_) {
                      Navigator.of(ctx).pop();
                      // Provider.of<accountProvider>(context, listen: false)
                      //     .fetchAccount()
                      //     .then((_) {
                      //   _isloading = false;
                      //   // setState(() {
                      //   // });
                      //   Navigator.of(ctx).pop();
                      // });
                    });
                  } catch (e) {
                    await showDialog(
                        // showDialog is also future fuction
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: const Text('A error occurred!'),
                            content: Text('somethings wents wrong.($e)'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text("Okey"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<AccountProvider>(context, listen: false).fetchAccount(),
          Provider.of<CategoryProvider>(context, listen: false)
              .fetchCategory(type: type),
        ]),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            List<Account> accountList = Provider.of<AccountProvider>(
              context,
            ).getAccountList;
            List<Category_> categotyList = Provider.of<CategoryProvider>(
              context,
            ).getCategoryList;
            return _body(context, accountList, categotyList, isAccount);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Container _body(BuildContext context, List<Account> accountList,
      List<Category_> categotyList, bool isAccount) {
    return Container(
      height: 450,
      color: Colors.grey.withOpacity(0.09),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 1,
              ),
              Container(
                // color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (isAccount)
                            ? "Select an account"
                            : "Select an category",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              // fontFamily: "Rubik",
                              // color: Colors.green.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      OutlinedButton(
                          onPressed: (isAccount)
                              ? () async {
                                  await addNewAccount(context);
                                }
                              : () async {
                                  await addNewCategory(context);
                                },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.add,
                                size: 28,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                (isAccount) ? "Add account" : "Add category",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      // fontFamily: "Rubik",
                                      color: Colors.blue,
                                      fontSize: 16,
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Visibility(
                visible: isAccount,
                child: (accountList.isEmpty)
                    ? const Center(
                        child: Text("Empty List"),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: accountList.length,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              accountobj: accountList[index],
                            );
                          },
                        ),
                      ),
                replacement: (accountList.isEmpty)
                    ? const Center(
                        child: Text("Empty List"),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categotyList.length,
                          itemBuilder: (context, index) {
                            return ItemCard2(
                              categoryobj: categotyList[index],
                            );
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  Account accountobj;
  ItemCard({
    Key? key,
    required this.accountobj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: RadioListTile(
        contentPadding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "${accountobj.accountName!}",
                // "${list[index].accountName!}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      // fontFamily: "Rubik",
                      // color: Colors.green.shade600,
                      fontSize: 16,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Flexible(
              child: Text(
                "\u{20B9} ${Utility.convertToIndianCurrency(sourceNumber: accountobj.balance!, decimalDigits: 2)} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontFamily: "Rubik",
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
          ],
        ),

        // "${items[index].cname} AND cid=${items[index].cid}"

        // subtitle: Column(
        //   crossAxisAlignment:
        //       CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       "${accountlist[index].balance!}",
        //       // "",
        //       style: const TextStyle(
        //           fontFamily: "Rubik"),
        //     ),
        //   ],
        // ),
        // subtitle: Text(" ${items[index].entrydatetime}"),
        value: accountobj.accountId,
        groupValue:
            (Provider.of<AccountProvider>(context).getSelectedAccountObj ==
                    null)
                ? null
                : Provider.of<AccountProvider>(context)
                    .getSelectedAccountObj!
                    .accountId,
        onChanged: (value) {
          Account _accountobj =
              Provider.of<AccountProvider>(context, listen: false)
                  .findAccountByAccountId(accountId: value!);
          Provider.of<AccountProvider>(context, listen: false)
              .setSelectedAccountObj(accountObj: _accountobj);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class ItemCard2 extends StatelessWidget {
  Category_ categoryobj;
  ItemCard2({
    Key? key,
    required this.categoryobj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: RadioListTile(
        contentPadding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                categoryobj.categoryName,
                // "${list[index].accountName!}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      // fontFamily: "Rubik",
                      // color: Colors.green.shade600,
                      fontSize: 16,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            // Flexible(
            //   child: Text(
            //     "\u{20B9} ${Utility.dateFormat_DD_MonthName_YYYY().format(categoryobj.date)} ",
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //     style: Theme.of(context).textTheme.labelSmall!.copyWith(
            //         fontFamily: "Rubik",
            //         color: Colors.green.shade700,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16),
            //   ),
            // ),
          ],
        ),

        // "${items[index].cname} AND cid=${items[index].cid}"

        // subtitle: Column(
        //   crossAxisAlignment:
        //       CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       "${accountlist[index].balance!}",
        //       // "",
        //       style: const TextStyle(
        //           fontFamily: "Rubik"),
        //     ),
        //   ],
        // ),
        // subtitle: Text(" ${items[index].entrydatetime}"),
        value: categoryobj.categoryId,
        groupValue:
            (Provider.of<CategoryProvider>(context).getSelectedcategoryObj ==
                    null)
                ? null
                : Provider.of<CategoryProvider>(context)
                    .getSelectedcategoryObj!
                    .categoryId,
        onChanged: (value) {
          Category_ _categoryobj =
              Provider.of<CategoryProvider>(context, listen: false)
                  .findCategoryByCategoryId(categoryId: value!);
          Provider.of<CategoryProvider>(context, listen: false)
              .setSelectedCategoryObj(categoryObj: _categoryobj);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
