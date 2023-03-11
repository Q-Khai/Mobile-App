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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.purple,
          Colors.blue,
          Colors.white
          // Color.fromARGB(255, 176, 106, 231),
          // Color.fromARGB(255, 166, 112, 232),
          // Color.fromARGB(255, 131, 123, 232),
          // Color.fromARGB(255, 104, 132, 231),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 40,
                    color: Colors.white,
                  ),
                  Text(
                    "For Creators",
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Color.fromRGBO(124, 77, 255, 1),
                            //       blurRadius: 20,
                            //       offset: Offset(0, 10))
                            // ]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Email or Phone number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                    obscureText: true),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.deepPurpleAccent),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 50,
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            // width: size.width,
                            // height: size.height,
                            // padding: EdgeInsets.only(
                            //     left: 20,
                            //     right: 20,
                            //     top: size.height * 0.2,
                            //     bottom: size.height * 0.5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              Center(
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    AuthService().sigInWithGoogle();
                                  },
                                  label: const Text('Sign in with Google'),
                                  icon: Image.asset(
                                    'assets/google_logo.png',
                                    height: 32,
                                    width: 32,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      // width: size.width,
      // height: size.height,
      // padding: EdgeInsets.only(
      //     left: 20,
      //     right: 20,
      //     top: size.height * 0.2,
      //     bottom: size.height * 0.5),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Center(
      //       child: FloatingActionButton.extended(
      //         onPressed: () {
      //           AuthService().sigInWithGoogle();
      //         },
      //         label: const Text('Sign in with Google'),
      //         icon: Image.asset(
      //           'assets/google_logo.png',
      //           height: 32,
      //           width: 32,
      //         ),
      //         backgroundColor: Colors.white,
      //         foregroundColor: Colors.black,
      //       ),
      //     ),
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
