import 'dart:convert';
import 'package:demo/hello_page.dart';
import 'package:demo/home_page.dart';
import 'package:demo/page/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HelloPage();
          } else {
            return LoginPage();
          }
        });
  }

  sigInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn(); // GoogleSignIn

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.getIdToken().then((value) => print(value)));

    var accessToken = userCredential.user?.getIdToken().then((value) => sendToken(value));
    
    //Gửi token cho server
    sendToken(accessToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  sendToken(accessToken) async {
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/login');
    var response = await http.post(
      url,
      body: jsonEncode({'idToken': accessToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Access successfully!');
      print(response.body);
    } else {
      print('Access failed with status code ${response.statusCode}');
    }
    
    // Nhận tokens trả về từ server
      final json = jsonDecode(response.body);
      print(json['accessToken']);
      print(json['refreshToken']);

    // Lưu accessToken và refreshToken trả về từ server vào storage;
     setTokenToStorage(json['accessToken'],json['refreshToken']);
  }

  // Lưu accessToken trả về từ server vào storage;
  setTokenToStorage(accessToken, refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<void> signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    prefs.clear();
  }
}
