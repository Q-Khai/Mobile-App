class Orders {
  final String idorder;
  final String datetime;
  final String totalmoney;
  final String idcustomer;
  final String idagency;
  final int status;
  final String tracking;
  Orders(
      {required this.idorder,
      required this.datetime,
      required this.totalmoney,
      required this.idcustomer,
      required this.idagency,
      required this.status,
      required this.tracking
      });
}