import 'package:demo/auth_service.dart';
import 'package:demo/page/login.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// void main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   // const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       //   visualDensity: VisualDensity.adaptivePlatformDensity,
//       // ),
//       // home: BottomBar(),
//       themeMode: ThemeMode.system,
//       home: AuthService().handleAuthState(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuthState(),
      // home: LoginPage(),
    );
  }
}
