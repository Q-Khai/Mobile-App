import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:demo/get_fcm.dart';
import 'package:demo/model/order_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  final String lookerStudioUrl =
      'https://lookerstudio.google.com/embed/u/0/reporting/09ae41b5-98a0-48cf-9a79-0aa37a3d795a/page/6ngJD?fbclid=IwAR2dkW_L4gWWy3bveRTJRNlSMn5P6vyaaUeGWehHBVLFl7n7qZf0y6G68XA';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<dynamic> agencys = [];
  String totalOrder = '';
  String totalSell = '';
  String revenue = '';
  String totalCustomer = '';
  Future<void> getDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? uid = prefs.getString("uid");

    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/order/creator/${uid}');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Fetch Data successfully!');
      print(response.body);
      final json = jsonDecode(response.body);
      final data = json['data'] as List<dynamic>;

      int totalO = 0;
      int totalS = 0;
      double revenueO = 0;
      List<String> customerIds = [];
      int uniqueCustomerCount = 0;
      data.map((e) {
        if (e['status'] == false) {
          totalO++;
          if (e['tracking'] == 'Completed') {
            totalS++;
            revenueO += double.parse(e['totalmoneyCreator']);
          }
        }

        String customerId = e['Customer']['idcustomer'];
        if (!customerIds.contains(customerId)) {
          customerIds.add(customerId);
          uniqueCustomerCount++;
        }
        print(customerIds);
      }).toList();

      // set List Themes
      setState(() {
        totalOrder = totalO.toString();
        totalSell = totalS.toString();
        revenue = revenueO.toString();
        totalCustomer = uniqueCustomerCount.toString();
      });
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
  }

  void testAuthor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/agency/');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('fetch Data successfully!');
      print(response.body);
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
    final json = jsonDecode(response.body);
    setState(() {
      agencys = json['data'];
    });
  }

// Get token device
  void getFCMKey() async {
    String? fcmKey = await getFcmToken();
    print('FCM Key : $fcmKey');
  }

  @override
  void initState() {
    getFCMKey();
    getDashboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Items item1 = new Items(
        title: "Total Orders",
        subtitle: "March, Wednesday",
        event: totalOrder + ' Orders',
        icon: Icon(FluentIcons.document_bullet_list_multiple_20_regular,
            color: Colors.white, size: 45));
    Items item2 = new Items(
      title: "Revenue",
      subtitle: "Bocali, Apple",
      event: revenue + " \$",
      icon: Icon(FluentIcons.arrow_trending_lines_20_regular,
          color: Colors.white, size: 45),
    );
    Items item3 = new Items(
      title: "Sold Orders",
      subtitle: "Lucy Mao going to Office",
      event: totalSell + ' Orders',
      icon: Icon(FluentIcons.clipboard_bullet_list_ltr_16_regular,
          color: Colors.white, size: 45),
    );
    Items item4 = new Items(
      title: "Customer",
      subtitle: "Rose favirited your Post",
      event: totalCustomer + " Customers",
      icon: Icon(FluentIcons.people_16_regular, color: Colors.white, size: 45),
    );
    TabController tabController = TabController(length: 3, vsync: this);
    List<Items> myList = [item1, item2, item3, item4];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
          elevation: 0,
          leading: Icon(FluentIcons.board_16_filled),
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
            'DASHBOARD',
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
        ),
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
                        "Statistics",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      )),
                      Tab(
                          icon: Text(
                        "Reports",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      )),
                      Tab(
                          icon: Text(
                        "Vaults",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      )),
                    ]),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
                // height: MediaQuery.of(context).size.height,
                child: TabBarView(
              controller: tabController,
              children: [
                Flexible(
                  child: GridView.count(
                    childAspectRatio: 1.2,
                    padding: EdgeInsets.only(left: 16, right: 16),
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    children: myList.map((data) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 131, 123, 232),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Image.network(data.img, width: 42,),
                            data.icon,
                            SizedBox(height: 14),
                            Text(
                              data.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              data.event,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SafeArea(
                  child: WebView(
                    initialUrl: widget.lookerStudioUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                Center(child: Text("Nothing !")),
              ],
            )),
          ],
        ));
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  Icon icon;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.icon});
}
