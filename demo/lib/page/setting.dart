import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import '../auth_service.dart';
import 'package:demo/get_fcm.dart';



class Setting extends StatefulWidget {
  const Setting({super.key});
  // final String lookerStudioUrl = 'https://lookerstudio.google.com/embed/u/0/reporting/09ae41b5-98a0-48cf-9a79-0aa37a3d795a/page/6ngJD?fbclid=IwAR2dkW_L4gWWy3bveRTJRNlSMn5P6vyaaUeGWehHBVLFl7n7qZf0y6G68XA';

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
      // body: Center(
      //   child: Text('Setting Screen', style: TextStyle(fontSize: 40)),
      // ),
      // body: SafeArea(
      //   child: WebView(
      //     initialUrl: widget.lookerStudioUrl,
      //     javascriptMode: JavascriptMode.unrestricted,
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),

             Text(
              'CREATOR',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
              
            ),
            const SizedBox(
              height:20,
            ),
             Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              padding: const EdgeInsets.all(10),
              color: Colors.deepPurpleAccent,
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
          ],
        ),
      ),
    );
  }
}
