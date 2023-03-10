// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';



import 'package:demo/page/upload_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page/setting.dart';
import 'page/home.dart';
import 'page/order.dart';
import 'page/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screen = [
    HomePage(),
    Themes(),
    Order(),
    Setting(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Themes();

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(
      //     child: Text("FPT"),
      //   ),
      // ),
      body: Center(
        child: screen[currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: currentTab,
        elevation: 20,
        iconSize: 32,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.deepPurpleAccent,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor:  Colors.deepPurpleAccent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentIcons.home_16_regular),
              activeIcon: Icon(FluentIcons.home_12_filled),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FluentIcons.box_24_regular),
              activeIcon: Icon(FluentIcons.box_16_filled),
              label: "Product"),
          BottomNavigationBarItem(
              icon: Icon(FluentIcons.clipboard_16_regular),
              activeIcon: Icon(FluentIcons.clipboard_16_filled),
              label: "Order"),
          BottomNavigationBarItem(
              icon: Icon(FluentIcons.settings_16_regular),
              activeIcon: Icon(FluentIcons.settings_16_filled),
              label: "Setting"),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => UploadImage()));
      //   },
      //   label: Text('Create Theme'),
      //   icon: const Icon(Icons.add_a_photo),
      //   backgroundColor: Colors.deepPurpleAccent,
      // ),
    );
  }
}
