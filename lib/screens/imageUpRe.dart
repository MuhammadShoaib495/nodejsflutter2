import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class imageUpRe extends StatefulWidget {
  const imageUpRe({super.key});

  @override
  State<imageUpRe> createState() => _imageUpReState();
}

class _imageUpReState extends State<imageUpRe> {

  // Create future function to pick and upload image
  File? _image;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Pick an image (works for web, mobile, and desktop)
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // For web, read as bytes to upload
      Uint8List fileBytes = await pickedFile.readAsBytes();
      String fileName = pickedFile.name;

      // Create a FormData equivalent using html package for web
      final request = http.MultipartRequest("POST", Uri.parse("http://localhost:3600/upload"));

      // Attach the file (using MultipartFile.fromBytes instead of fromPath for web)
      request.files.add(http.MultipartFile.fromBytes('image', fileBytes, filename: fileName));

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        print("Image uploaded successfully");
      } else {
        print("Image upload failed");
      }
    } else {
      print("No image selected.");
    }
  }


  Future<void> uploadImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://your-server-url/upload'));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!)
                : Text("No image selected"),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pick Image from Gallery"),
            ),
            Center(child: Image.network('http://localhost:3600/image/1')),
          ],
        ),
      ),
    );
  }
}
