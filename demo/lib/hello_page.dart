import 'package:demo/get_fcm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  void incrementCounter() async {
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
              color: Colors.green,
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
                incrementCounter();
              },
              child: Text('Get Firebase Cloud Messaging'),
            )
          ],
        ),
      ),
    );
  }
}