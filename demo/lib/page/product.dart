import 'dart:convert';

import 'package:demo/model/collection_model.dart';
import 'package:demo/model/product_model.dart';
import 'package:demo/page/upload_product.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  final CollectionsProduct collectionP;
  const Product({Key? key, required this.collectionP}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool isLoading = true;

  static List<Products> products = [];
  List<Products> display_Products = List.from(products);

  //Fetch Data Product
  Future<void> getAllProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/product/?idcollection=${widget.collectionP.idcollection}');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Fetch Data successfully!');
      print(response.body);
      final json = jsonDecode(response.body);
      final data = json['data'] as List<dynamic>;
      final dataTransformed = data
          .map((e) {
            if (e['status'] != 0) {
              return Products(
                  idproduct: e['idproduct'],
                  name: e['name'],
                  quantity: e['quantity'],
                  price: double.parse(e['price']),
                  status: e['status'],
                  idcollection: e['idcollection'],
                  image: e['image']);
            }
          })
          .whereType<Products>()
          .toList();

      // set List Themes
      setState(() {
        products = dataTransformed;
      });
      Future.delayed(Duration(seconds: 1)).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
  }

  void putToDisplayProducts() async {
    await getAllProducts();
    display_Products = List.from(products);
  }

  void initState() {
    putToDisplayProducts();
    super.initState();
  }


  void updateListThemes(String value) {
    setState(() {
      display_Products = products
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,

      //   toolbarHeight: 70,
      //   elevation: 0,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.only(
      //             bottomLeft: Radius.circular(24),
      //             bottomRight: Radius.circular(24)),
      //         gradient: LinearGradient(colors: [
      //           Color.fromARGB(255, 176, 106, 231),
      //           Color.fromARGB(255, 166, 112, 232),
      //           Color.fromARGB(255, 131, 123, 232),
      //           Color.fromARGB(255, 104, 132, 231),
      //         ]),
      //         ),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     'PRODUCTS',
      //     style: TextStyle(
      //         color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8),
      //       child: Icon(
      //         FluentIcons.alert_16_regular,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ],
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(85),
      //     child: Column(
      //       children: <Widget>[
      //         Text('Collection Name',
      //             style: TextStyle(
      //                 color: Colors.white70,
      //                 fontSize: 20.0,
      //                 fontWeight: FontWeight.bold)),
      //         SizedBox(height: 5),
      //         Container(
      //           width: 320,
      //           padding: const EdgeInsets.all(10.0),
      //           child: TextField(
      //             onChanged: (value) => updateListThemes(value),
      //             decoration: InputDecoration(
      //                 hintText: "Search...",
      //                 prefixIcon: Icon(
      //                   Icons.search,
      //                   color: Colors.deepPurpleAccent,
      //                 ),
      //                 suffixIcon: Icon(
      //                   Icons.mic,
      //                   color: Colors.deepPurpleAccent,
      //                 ),
      //                 border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(24),
      //                     borderSide: BorderSide.none),
      //                 contentPadding: EdgeInsets.zero,
      //                 filled: true,
      //                 fillColor: Colors.white),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),)),
        replacement: RefreshIndicator(
          onRefresh: () async {
            await putToDisplayProducts;
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.deepPurpleAccent,
                floating: false,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.srcATop,
                  ),
                  child: Image.network('${widget.collectionP.image}',
                      fit: BoxFit.cover),
                ),
                // title: Text(
                //   "Pink Swear",
                //   style: TextStyle(fontSize: 30),
                // ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadProduct(
                                    collectionP: widget.collectionP)));
                      },
                      child: Icon(
                        FluentIcons.add_16_filled,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(85),
                  child: Column(
                    children: <Widget>[
                      Text('${widget.collectionP.name}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Container(
                        width: 320,
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          onChanged: (value) => updateListThemes(value),
                          decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                              suffixIcon: Icon(
                                Icons.mic,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: GridView.builder(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                primary: false,
                shrinkWrap: true,
                itemCount: display_Products.length,
                itemBuilder: (context, index) {
                  final product = display_Products[index];
                  return ProductWidget(
                      imagePath: product.image,
                      price: (product.price).toString(),
                      productName: product.name);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final String imagePath, price, productName;

  const ProductWidget({
    Key? key,
    required this.imagePath,
    required this.price,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        //width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          color: Color(0xfff6f7f9),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x1F000000),
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        imagePath,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                        child: Text(
                          productName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                      child: Text(
                        '$price \$',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
