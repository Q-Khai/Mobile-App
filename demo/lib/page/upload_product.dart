import 'dart:io';
import 'package:demo/model/collection_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class UploadProduct extends StatefulWidget {
  final CollectionsProduct collectionP;
  const UploadProduct({Key? key, required this.collectionP}) : super(key: key);

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {});
    } else {
      print('no image selected');
    }
  }

  Future submitProduct() async {
    //lấy dữ liệu từ text Field,

    final name = nameController.text;
    final price = priceController.text;
    final quantity = quantityController.text;
    print(name);
    print(price);
    print(quantity);

    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/product/create');

    var request = http.MultipartRequest('POST', url);
    // request.headers.addAll({'Authorization': 'Bearer Token'});
    request.files.add(await http.MultipartFile.fromPath('image', image!.path,
        contentType: MediaType('*', '*')));
    request.fields['name'] = name;

    final body = {
      'name': name,
      'quantity': quantity,
      'price': price,
      'idproductcategory': '1',
      'idcollection': '${widget.collectionP.idcollection}'
    };
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    request.fields.addAll(body);

    // request.fields['data'] = jsonEncode(body);
    // request.fields['name'] = name;
    // request.fields['quantity'] = quantity;
    // request.fields['price'] = price;
    // request.fields['idproductcategory'] = '1';
    // request.fields['idcollection'] = '1';

    print(request.fields);
    print(request.files.length);

    final response = await request.send();

    if (response.statusCode == 200) {
      nameController.text = '';
      quantityController.text = '';
      priceController.text = '';
      print('Uploaded successfully!');
    } else {
      print('Upload failed with status code ${response.statusCode}');
    }
  }
//   jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
//     for (var key in data.keys) {
//       request.fields[key] = data[key].toString();
//     }
//     return request;
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'NEW PRODUCT',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      body: ListView(padding: EdgeInsets.all(30), children: [
        Center(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
     Container(
                    
                    child: image == null ?
                    Center(
                      child: Image.network(
                       "https://aeroclub-issoire.fr/wp-content/uploads/2020/05/image-not-found.jpg",
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ) :
                    Center(
                      child: Image.file(
                        File(image!.path).absolute,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            ButtonPickImage(
                title: 'Pick From Gallery',
                icon: Icons.image_outlined,
                onClick: getImage),
          ]),
        ),
        SizedBox(
          height: 40,
        ),
        Form(
            child: Column(
          children: [
            TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Product Name',
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  
                  ),
                  suffixIcon: Icon(FluentIcons.text_whole_word_20_regular, color: Colors.deepPurpleAccent,),
                )),
                SizedBox(
          height: 15,
        ),
                TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: 'Product Quantity',
                  labelText: 'Quantity',
                  labelStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  
                  ),
                  suffixIcon: Icon(FluentIcons.box_16_regular, color: Colors.deepPurpleAccent,),
                )),
                 SizedBox(
          height: 15,
        ),
                TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Product Price',
                  labelText: 'Price',
                  labelStyle: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  
                  ),
                  suffixIcon: Icon(FluentIcons.currency_dollar_euro_24_regular, color: Colors.deepPurpleAccent,),
                )),
          ],
        )),
        TextField(
          decoration: InputDecoration(hintText: 'ProductCategory'),
        ),
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
            onPressed: () {
              submitProduct();
            },
            child: Text('CREATE PRODUCT'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent))
      ]),
    );
  }
}

Widget ButtonPickImage(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return Container(
    width: 250,
    child: ElevatedButton(
        onPressed: onClick,
        style:
            ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(title)
          ],
        )),
  );
}
