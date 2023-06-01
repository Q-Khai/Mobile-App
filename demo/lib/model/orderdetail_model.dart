class OrdersDetail {
  final String idorder;
  final String datetime;
  final String totalmoney;
  final bool status;
  final String tracking;
  OrdersDetail({
    required this.idorder,
    required this.datetime,
    required this.totalmoney,
    required this.status,
    required this.tracking,
  });
}

class OrderCartDetails {
  final String idorderdetail;
  final int quantity;
  final String totalprice;
  final Product product;

  OrderCartDetails({
    required this.idorderdetail,
    required this.quantity,
    required this.totalprice,
    required this.product,
  });
}

class Customer {
  final String idcustomer;
  final String name;
  final String email;
  Customer({
    required this.idcustomer,
    required this.name,
    required this.email,
  });
}

class Product {
  final String idproduct;
  final String name;
  final String image;
  Product({
    required this.idproduct,
    required this.name,
    required this.image,
  });
}
