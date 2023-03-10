import 'dart:io';
import 'package:demo/model/collection_model.dart';
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
      nameController.text ='';
      quantityController.text ='';
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
        title: Text('Upload Product in ${widget.collectionP.name}'),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(padding: EdgeInsets.all(30), children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Product Name'),
        ),
        TextField(
          controller: quantityController,
          decoration: InputDecoration(hintText: 'Quantity'),
        ),
        TextField(
          controller: priceController,
          decoration: InputDecoration(hintText: 'Price'),
        ),
        TextField(
          decoration: InputDecoration(hintText: 'ProductCategory'),
        ),
        Center(
          child: Column(children: [
            SizedBox(
              height: 40,
            ),
            image == null
                ? Center(
                    child: Text('No Image'),
                  )
                : Container(
                    child: Center(
                      child: Image.file(
                        File(image!.path).absolute,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: 40,
            ),
            ButtonPickImage(
                title: 'Pick from Gallery',
                icon: Icons.image_outlined,
                onClick: getImage),
          ]),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          submitProduct();
        },
        child: const Icon(Icons.accessible),
      ),
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
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Text(title)
          ],
        )),
  );
}
