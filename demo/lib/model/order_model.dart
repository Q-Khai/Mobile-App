class Orders {
  final String idorder;
  final String datetime;
  final String totalmoney;
  final bool status;
  final String tracking;
  final DateTime date;
  Orders(
      {required this.idorder,
      required this.datetime,
      required this.totalmoney,
      required this.status,
      required this.tracking,
      required this.date,
      });
}