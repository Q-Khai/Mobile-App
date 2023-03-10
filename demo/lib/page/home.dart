import 'dart:convert';

import 'package:demo/get_fcm.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    List<dynamic> agencys = [];

    
   void testAuthor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse('https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/agency/');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        elevation: 0,
        leading: Icon(FluentIcons.board_16_filled),
        flexibleSpace: Container(
          decoration: BoxDecoration(
                         
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight:Radius.circular(24)),
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
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
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),

            agencys.length == 0
            ? Text(
              'List Agency',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            )
            : Expanded(
              child: ListView.builder(
                itemCount: agencys.length,
                itemBuilder: (context, index){
                  final agency = agencys[index];
                  int idagency = agency['idagency'];
                  final nameagency = agency['name'];
                  return ListTile(
                    title: Text(nameagency),
                    leading: Text(idagency.toString()),
                  );
              }),
            ),
             Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                'LOG OUT',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                AuthService().signOut();
              },
            ),
            MaterialButton(
              onPressed: () {
                getFCMKey();
              },
              child: Text('Get Firebase Cloud Messaging'),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                testAuthor();
              },
              child: Text('Test Authorization'),
            ),
          ],
        ),
      ),
    );
  }
}
