import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        elevation: 0,
        leading: Icon(FluentIcons.settings_16_filled),
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
          'SETTINGS',
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
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(80),
        //   child: Column(
        //     children: <Widget>[
        //       // Text('Themes',
        //       //     style: TextStyle(
        //       //         color: Colors.deepPurpleAccent,
        //       //         fontSize: 20.0,
        //       //         fontWeight: FontWeight.bold)),
        //       SizedBox(height: 5),
        //       Container(
        //         width: 320,
        //         padding: const EdgeInsets.all(10.0),
        //         child: TextField(
        //           onChanged: (value) => updateListThemes(value),
        //           decoration: InputDecoration(
        //               hintText: "Search...",
        //               prefixIcon: Icon(
        //                 Icons.search,
        //                 color: Colors.deepPurpleAccent,
        //               ),
        //               suffixIcon: Icon(
        //                 Icons.mic,
        //                 color: Colors.deepPurpleAccent,
        //               ),
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(24),
        //                   borderSide: BorderSide.none),
        //               contentPadding: EdgeInsets.zero,
        //               filled: true,
        //               fillColor: Colors.white),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: Center(
        child: Text('Setting Screen', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}
