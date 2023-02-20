// import 'dart:html';
import 'package:demo/auth_service.dart';
import 'package:demo/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final usernameController = TextEditingController();
final passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: size.height * 0.2,
            bottom: size.height * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: FloatingActionButton.extended(
                onPressed: () {
                   AuthService().sigInWithGoogle();
                },
                label: const Text('Sign in with Google'),
                icon: Image.asset('assets/google_logo.png',
                height: 32,
                width: 32,),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),

            // const Text("Hello, \nGoogle Sign in",
            //     style: TextStyle(fontSize: 30)),
            // GestureDetector(
            //     onTap: () {
            //       AuthService().sigInWithGoogle();
            //     },
            //     child: const Image(
            //         width: 100, image: AssetImage('assets/google.png'))=
            //     // child: IconButton(
            //     //   // style: ElevatedButton.styleFrom(
            //     //   //   primary: Colors.white,
            //     //   //   onPrimary: Colors.black,
            //     //   //   minimumSize: Size(double.infinity, 50),
            //     //   // ),
            //     //   icon: FaIcon(
            //     //     FontAwesomeIcons.google,
            //     //     color: Colors.red,
            //     //   ),
            //     //   // label: Text('Sign Up with Google'),
            //     //   onPressed: () {},
            //     // )
            //     ),
          ],
        ),
      ),
    );
  }
}

// text editing controllers
// final usernameController = TextEditingController();
// final passwordController = TextEditingController();

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.grey[300],
//     body: SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(height: 50),
//           //logo
//           const Icon(
//             Icons.lock,
//             size: 100,
//           ),

//           const SizedBox(height: 50),
//           //welcome back, you've been miss
//           Text(
//             'Welcome back you\'ve been missed!',
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontSize: 16,
//             ),
//           ),

//           const SizedBox(height: 25),

//           //username texfield
//           MyTextField(
//             controller: usernameController,
//             hintText: 'Username',
//             obscureText: false,
//           ),

//           const SizedBox(height: 10),

//           //password texfield
//           MyTextField(
//             controller: passwordController,
//             hintText: 'Password',
//             obscureText: true,
//           ),
//           const SizedBox(height: 25),
//           //forgot password
// // Text('Forgot Password?'),

//           //sign in button

//           //or continue with

//           //google
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               primary: Colors.white,
//               onPrimary: Colors.black,
//               minimumSize: Size(double.infinity, 50),
//             ),
//             icon: FaIcon(
//               FontAwesomeIcons.google,
//               color: Colors.red,
//             ),
//             label: Text('Sign Up with Google'),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     ),
//   );
// }
