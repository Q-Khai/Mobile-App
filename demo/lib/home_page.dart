// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:demo/auth_service.dart';
import 'package:demo/page/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
import 'page/product.dart';
import 'page/setting.dart';
import 'page/order.dart';
import 'page/home.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screen = [
    HomePage(),
    Product(),
    Order(),
    Setting(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Product();

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("FPT"),
        ),
      ),
      body: Center(
        child: screen[currentTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: currentTab,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_bookmark_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_bookmark_filled),
              label: "Product"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_add_circle_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_add_filled),
              label: "Order"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_settings_dev_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_settings_filled),
              label: "Setting"),
        ],
      ),
    );
  }
}
