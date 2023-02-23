import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {
        
      });
    } else {
      print('no image selected');
    }
  }

  Future uploadImage() async {
    final url = Uri.parse(
        'https://ec2-3-0-97-134.ap-southeast-1.compute.amazonaws.com:8080/image');

    final request = http.MultipartRequest('POST', url);
    // request.headers.addAll({'Authorization': 'Bearer Token'});
    request.files.add(await http.MultipartFile.fromPath('file', image!.path, contentType: MediaType('*', '*')));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Image upload failed with status code ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload')),
      body: Center(
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
            onClick: getImage
          )
        ]),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImage();
        },
        child: const Icon(Icons.accessible),
      ),
    );
  }
}


Widget ButtonPickImage({
  required String title,
  required IconData icon,
  required VoidCallback onClick
}){
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