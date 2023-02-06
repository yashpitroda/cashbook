class CashBank {
  String cbid;
  String is_paymentmode;
  DateTime date;
  String cash_debit;
  String bank_debit;
  String cash_credit;
  String bank_credit;
  String cash_balance;
  String bank_balance;
  String particulars;
  String useremail;

  CashBank({
    required this.cbid,
    required this.is_paymentmode,
    required this.cash_balance,
    required this.cash_credit,
    required this.bank_balance,
    required this.bank_credit,
    required this.bank_debit,
    required this.cash_debit,
    required this.date,
    required this.particulars,
    required this.useremail,
  });
}
