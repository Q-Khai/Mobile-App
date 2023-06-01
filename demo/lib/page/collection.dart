import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:demo/model/collection_model.dart';
import 'package:demo/model/theme_model.dart';
import 'package:demo/page/product.dart';
import 'package:demo/page/upload_product.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Collection extends StatefulWidget {
  final ThemesProduct themeP;
  const Collection({Key? key, required this.themeP}) : super(key: key);

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  TextEditingController nameController = TextEditingController();
  static List<CollectionsProduct> collections = [];

  List<CollectionsProduct> display_Collections = List.from(collections);
  File? image;
  final picker = ImagePicker();
  //Get Collection from API
  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {});
    } else {
      print('no image selected');
    }
  }
Future submitCollection() async {
    //lấy dữ liệu từ text Field,

    final name = nameController.text;
    print(name);
    print('${widget.themeP.idtheme}');
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/collection/create');

    var request = http.MultipartRequest('POST', url);
    // request.headers.addAll({'Authorization': 'Bearer Token'});
 
    request.files.add(await http.MultipartFile.fromPath('image', image!.path,
        contentType: MediaType('*', '*')));
    
    final body = {
      'name': name,
      'idtheme': '${widget.themeP.idtheme}'
    };
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    request.fields.addAll(body);

    final response = await request.send();

    if (response.statusCode == 200) {
      
      setState(() {
        image = null;
         nameController.text = '';
      });

      print('Uploaded successfully!');
    } else {
      print('Upload failed with status code ${response.statusCode}');
    }
  }


  Future<void> getAllCollections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/collection/?idtheme=${widget.themeP.idtheme}');
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Fetch Data successfully!');
      print(response.body);
      final json = jsonDecode(response.body);
      final data = json['data'] as List<dynamic>;
      final dataTransformed = data
          .map((e) {
            if (e['status'] != 0) {
              return CollectionsProduct(
                  idcollection: e['idcollection'],
                  name: e['name'],
                  image: e['image'],
                  status: e['status'],
                  idtheme: e['idtheme']);
            }
          })
          .whereType<CollectionsProduct>()
          .toList();

      // set List Themes
      setState(() {
        collections = dataTransformed;
      });
    } else {
      print('fetch data failed with status code ${response.statusCode}');
    }
  }

   Future<void> putToDisplayCollections() async {
    await getAllCollections();
    display_Collections = List.from(collections);
  }

  void initState() {
    putToDisplayCollections();
    super.initState();
  }

  void updateListThemes(String value) {
    setState(() {
      display_Collections = collections
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
          '${widget.themeP.name}',
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(85),
          child: Column(
            children: <Widget>[
              Text('Collections',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Container(
                width: 320,
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) => updateListThemes(value),
                  decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.deepPurpleAccent,
                      ),
                      suffixIcon: Icon(
                        Icons.mic,
                        color: Colors.deepPurpleAccent,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh:
          putToDisplayCollections,
        
        child: ListView(
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: display_Collections
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Product(collectionP: e)));
                        },
                        child: CollectionContainer(
                          title: e.name,
                          imagePath: e.image,
                        ),
                      ),
                    )
                    .toList())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text(
                    'New Collection',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                  content: Container(
                    height: 250,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (() async {
                            final pickedImage = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (pickedImage != null) {
                              setState(() {
                                image = File(pickedImage.path);
                              });
                            } else {
                              print('no image selected');
                            }
                          }),
                          child: Container(
                            child: image == null
                                ? Center(
                                    child: Image.asset(
                                      'assets/image_notfound.jpg',
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(image!.path).absolute,
                                        height: 150,
                                        width: 230,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Collection Name',
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.deepPurpleAccent),
                              ),
                              suffixIcon: Icon(
                                FluentIcons.text_whole_word_20_regular,
                                color: Colors.deepPurpleAccent,
                              ),
                            )),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        submitCollection();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
            },
          );
        },
        label: Text('New Collection',
            style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        icon: const Icon(FluentIcons.note_add_16_filled,
            color: Colors.deepPurpleAccent),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class CollectionContainer extends StatelessWidget {
  final String title, imagePath;

  const CollectionContainer({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.srcATop,
              ),
              child: Image.network(
                imagePath,
                height: height * 0.8 / 4,
                width: width - 64,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 48,
            right: 48,
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
