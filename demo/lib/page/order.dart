import 'dart:convert';
import 'package:demo/model/order_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> with TickerProviderStateMixin {
  static List<Orders> themes = [];
  List<Orders> display_Themes = List.from(themes);

  Future<void> getAllThemes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/order/agency/1');
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
            if (e['status'] == 0 && e['tracking']=='Pending') {
              return Orders(
                idorder: e['idorder'],
                datetime: e['datetime'],
                totalmoney: e['totalmoney'],
                idcustomer: e['idcustomer'],
                idagency: e['idagency'],
                status: e['status'],
                tracking: e['tracking']
              );
            }
          })
          .whereType<Orders>()
          .toList();

      // set List Themes
      setState(() {
        themes = dataTransformed;
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
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        elevation: 0,
        leading: Icon(FluentIcons.clipboard_16_filled),
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
          'ORDERS',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              FluentIcons.alert_16_regular,
              color: Colors.white,
            ),
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(80),
        //   child: Column(
        //     children: <Widget>[
        //       // Text('Themes',
        //       //     style: TextStyle(
        //       //         color: Colors.deepPurpleAccent,
        //       //         fontSize: 20.0,
        //       //         fontWeight: FontWeight.bold)),
        //       SizedBox(height: 5),
        //       Container(
        //         width: 320,
        //         padding: const EdgeInsets.all(10.0),
        //         child: TextField(
        //           onChanged: (value) => updateListThemes(value),
        //           decoration: InputDecoration(
        //               hintText: "Search...",
        //               prefixIcon: Icon(
        //                 Icons.search,
        //                 color: Colors.deepPurpleAccent,
        //               ),
        //               suffixIcon: Icon(
        //                 Icons.mic,
        //                 color: Colors.deepPurpleAccent,
        //               ),
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(24),
        //                   borderSide: BorderSide.none),
        //               contentPadding: EdgeInsets.zero,
        //               filled: true,
        //               fillColor: Colors.white),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      // body: Center(
      //   child: Text('Order Screen', style: TextStyle(fontSize: 40)),
      // ),
      body: Column(
        children: <Widget>[
          Column(
            children: [
              TabBar(
                  controller: tabController,
                  indicatorColor: Colors.deepPurpleAccent,
                  tabs: [
                    Tab(
                        icon: Text(
                      "Processing",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    )),
                    Tab(
                        icon: Text(
                      "Completed",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    )),
                    Tab(
                        icon: Text(
                      "Cancelled",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    )),
                  ]),
            ],
          ),
          Expanded(
              // height: MediaQuery.of(context).size.height,
              child: TabBarView(
            controller: tabController,
            children: [
              ListView(
                  children: themes
                      .map(
                        (e) => InkWell(
                          onTap: () {},
                          child: Container(
                            margin:
                                EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Color(0x1F000000),
                                  offset: Offset(0, 1),
                                )
                              ],
                            ),
                            child: ListTile(
                              // leading: ClipRRect(
                              //   borderRadius: BorderRadius.circular(5),
                              //   child: Image.network(
                              //     'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                              //     width: 70,
                              //     height: 70,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              leading: Icon(
                                FluentIcons.clipboard_16_regular,
                                size: 35,
                                color: Colors.deepPurpleAccent,
                              ),
                              title: Text(
                                '${e.totalmoney} \$',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(e.datetime),
                                  SizedBox(height: 10),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [];
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
              ListView(children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x1F000000),
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    child: ListTile(
                      // leading: ClipRRect(
                      //   borderRadius: BorderRadius.circular(5),
                      //   child: Image.network(
                      //     'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                      //     width: 70,
                      //     height: 70,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      leading: Icon(
                        FluentIcons.clipboard_16_regular,
                        size: 35,
                        color: Colors.deepPurpleAccent,
                      ),
                      title: Text(
                        "haha",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Yesterday, 12:47 PM"),
                          SizedBox(height: 10),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [];
                        },
                      ),
                    ),
                  ),
                ),
              ]),
              Center(child: Text("Nothing !")),
            ],
          )),
          // Expanded(
          //   child: TabBarView(
          //     controller: tabController,
          //     children: [
          //       ListView.builder(
          //         itemCount: 10,
          //         itemBuilder: (context, index) => ListTile(
          //           title: Text('Item $index'),
          //         ),
          //       ),
          //       ListView.builder(
          //         itemCount: 5,
          //         itemBuilder: (context, index) => ListTile(
          //           title: Text('Item $index'),
          //         ),
          //       ),
          //       ListView.builder(
          //         itemCount: 2,
          //         itemBuilder: (context, index) => ListTile(
          //           title: Text('Item $index'),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
