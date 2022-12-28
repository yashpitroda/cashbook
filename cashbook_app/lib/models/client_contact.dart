class ClientContact {
  String cid;
  String cname;
  String fermname;
  String? cemail;
  String cmobileno;
  DateTime entrydatetime;

  ClientContact({
    required this.cid,
    required this.cemail,
    required this.fermname,
    required this.cname,
    required this.cmobileno,
    required this.entrydatetime,
  });
}
