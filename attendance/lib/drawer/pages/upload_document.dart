import 'dart:io';

import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageFiles.add(selectedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Upload Documents',
            // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
            ),
      ).gradientBackground(withActions: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: InkWell(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                      height: 200,
                      width: Get.width * 0.92,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: _imageFiles.isEmpty
                          ? Center(
                              child: Text(
                              // textAlign: TextAlign.center,
                              "Select Aadhar Card\n(Front Side)",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black26),
                            ))
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.file(
                                File(_imageFiles.first.path),
                                fit: BoxFit.fill,
                              ),
                            )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: InkWell(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Container(
                      height: 200,
                      width: Get.width * 0.92,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: _imageFiles.isEmpty
                          ? Center(
                              child: Text(
                              // textAlign: TextAlign.center,
                              "Select Aadhar Card\n(Front Side)",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black26),
                            ))
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.file(
                                File(_imageFiles.last.path),
                                fit: BoxFit.fill,
                              ),
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
