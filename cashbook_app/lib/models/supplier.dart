class Supplier {
  String sid;
  String sname;
  String firmname;
  String? semail;
  String smobileno;
  DateTime entrydatetime;
  String outstanding_amount_withbill;
  String outstanding_amount_without_bill;
  String advance_amount_with_bill;
  String advance_amount_without_bill;

  Supplier({
    required this.sid,
    required this.semail,
    required this.firmname,
    required this.sname,
    required this.smobileno,
    required this.entrydatetime,
    required this.outstanding_amount_withbill,
    required this.outstanding_amount_without_bill,
    required this.advance_amount_with_bill,
    required this.advance_amount_without_bill,
  });
}
