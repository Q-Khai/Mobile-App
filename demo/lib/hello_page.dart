import 'dart:convert';

import 'package:demo/get_fcm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'page/upload_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
List<dynamic> agencys = [];


// Test Authorize
  void testAuthor() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse('https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/agency/test');
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
