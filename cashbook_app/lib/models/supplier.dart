class Supplier {
  String sid;
  String sname;
  String firmname;
  String? semail;
  String smobileno;
  DateTime entrydatetime;

  Supplier({
    required this.sid,
    required this.semail,
    required this.firmname,
    required this.sname,
    required this.smobileno,
    required this.entrydatetime,
  });
}
