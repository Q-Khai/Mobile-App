import 'dart:convert';
import 'package:demo/model/order_model.dart';
import 'package:demo/model/orderdetail_model.dart';
import 'package:demo/model/theme_model.dart';
import 'package:demo/page/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  final Orders orderP;

  const OrderDetails({Key? key, required this.orderP}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrdersDetail? orderDetail;
  Customer? customer;
  static List<OrderCartDetails> details = [];

  Future<void> getAllThemes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? uid = prefs.getString("uid");
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/orderdetail/${uid}/${widget.orderP.idorder}');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Fetch Data successfully!');
      print(response.body);
      final json = jsonDecode(response.body);
      final data = json['data'];
      final dataDetail = json['data']['OrderCartDetails'] as List<dynamic>;
      final dataOrdersDetail = OrdersDetail(
        idorder: data['idorder'],
        datetime: data['datetime'],
        totalmoney: data['totalmoneyCreator'],
        tracking: data['tracking'],
        status: data['status'],
      );
      final dataCustomer = Customer(
        idcustomer: data['Customer']['idcustomer'],
        name: data['Customer']['name'],
        email: data['Customer']['email'],
      );

      final dataTransformedDetail = dataDetail
          .map((e) {
            final product = Product(
                idproduct: e['Product']['idproduct'],
                name: e['Product']['name'],
                image: e['Product']['image']);
            return OrderCartDetails(
              idorderdetail: e['idorderdetail'],
              quantity: e['quantity'],
              totalprice: e['totalprice'],
              product: product,
            );
          })
          .whereType<OrderCartDetails>()
          .toList();

      // set List Themes
      setState(() {
        orderDetail = dataOrdersDetail;
        details = dataTransformedDetail;
        customer = dataCustomer;
      });
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
  }

  @override
  void initState() {
    getAllThemes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 176, 106, 231),
                Color.fromARGB(255, 166, 112, 232),
                Color.fromARGB(255, 131, 123, 232),
                Color.fromARGB(255, 104, 132, 231),
              ])),
        ),
        centerTitle: true,
        title: Text(
          'ORDER DETAILS',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              FluentIcons.clipboard_text_32_filled,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            // color: Color.fromARGB(255, 234, 235, 238),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 234, 235, 238),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F000000),
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Column(children: [
              Container(
                height: 400,
                // color: Color.fromARGB(255, 225, 225, 228),
                margin: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Scrollbar(
                  radius: Radius.circular(10),
                  thumbVisibility: true,
                  thickness: 6,
                  child: SingleChildScrollView(
                      child: Column(
                    children: details
                        .map((e) => Container(
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 1),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    e.product.image,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  e.product.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Quantity: ${e.quantity}"),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                trailing: Text(
                                  "${e.totalprice} \$",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurpleAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                        .toList(),
                  )),
                ),
              ),

              Container(
                margin: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                    ),
                  ),
                  title: Text(
                    "${customer?.name}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Customer",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              //  Padding(
              //    padding: const EdgeInsets.only(bottom: 30),
              //    child: Text(
              //          "Total: 1200 \$",
              //          style: TextStyle(
              //              fontSize: 18, fontWeight: FontWeight.bold),
              //        ),
              //  ),
              Container(
                margin: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: ListTile(
                  trailing: Text(
                    "Total: ${widget.orderP.totalmoney} \$",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
