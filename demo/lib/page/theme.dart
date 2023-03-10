import 'dart:convert';
import 'package:demo/model/theme_model.dart';
import 'package:demo/page/collection.dart';
import 'package:demo/page/upload_product.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Themes extends StatefulWidget {
  const Themes({Key? key}) : super(key: key);

  @override
  State<Themes> createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  static List<ThemesProduct> themes = [];

  List<ThemesProduct> display_Themes = List.from(themes);

  Future<void> getAllThemes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? uid = prefs.getString("uid");
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/theme/?idcreator=${uid}');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Fetch Data successfully!');
      print(response.body);
      final json = jsonDecode(response.body);
      final data = json['data'] as List<dynamic>;
      final dataTransformed = data.map((e) {
         if (e['status'] != 0) {
        return ThemesProduct(
          idtheme: e['idtheme'],
          name: e['name'],
          status: e['status'],
        );
         }
      }).whereType<ThemesProduct>().toList();

      // set List Themes 
      setState(() {
        themes = dataTransformed;
      });
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
  }

  @override
  void initState() {
    getAllThemes();
    display_Themes = List.from(themes);
    super.initState();
  }

  void updateListThemes(String value) {
    setState(() {
      display_Themes = themes
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6f7f9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        elevation: 0,
        leading: Icon(FluentIcons.box_16_filled),
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
          'THEMES',
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
      body: ListView(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          //   height: 50,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       'Featured item',
          //       'Most recent',
          //       'Item 1',
          //       'Item 2',
          //       'Item 3',
          //       'Etc...'
          //     ]
          //         .map((e) => Container(
          //               margin: EdgeInsets.symmetric(
          //                   vertical: 8.0, horizontal: 8.0),
          //               child: OutlinedButton(
          //                 onPressed: () {},
          //                 shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(30)),
          //                 child: Text(e),
          //               ),
          //             ))
          //         .toList(),
          //   ),
          // ),
          Column(
              children: themes
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        Navigator.push(context,                           
                            MaterialPageRoute(
                                builder: (context) => Collection(themeP: e)));
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x1F000000),
                              offset: Offset(0, 1),
                            )
                          ],
                        ),
                        child: ListTile(
                          // leading: ClipRRect(
                          //   borderRadius: BorderRadius.circular(5),
                          //   child: Image.network(
                          //     'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                          //     width: 70,
                          //     height: 70,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          leading: Icon(
                            FluentIcons.box_16_regular,
                            size: 35,
                            color: Colors.deepPurpleAccent,
                          ),
                          title: Text(
                            e.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Yesterday, 12:47 PM"),                           
                              SizedBox(height: 10),
                              // Container(
                              //   height: 40,
                              //   child: Stack(
                              //     children: <Widget>[
                              //       Positioned(
                              //           left: 20,
                              //           bottom: 0,
                              //           child: CircleAvatar(
                              //               backgroundColor: Colors.green,
                              //               child: Image.network(
                              //                   'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRxHTyqjCdnZsEM-EkMvn3FDBkDADcaEZ3GN1YEdWFToAJm83nX&usqp=CAU'))),
                              //       Positioned(
                              //         left: 0,
                              //         bottom: 0,
                              //         child: CircleAvatar(child: Text('a')),
                              //       )
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                          trailing: Text(
                            "Edit",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList())
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
        },
        label: Text('Create Theme'),
        icon: const Icon(FluentIcons.box_arrow_up_20_filled),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
