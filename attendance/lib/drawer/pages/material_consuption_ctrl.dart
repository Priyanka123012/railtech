import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialConsumptionController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // State variables
  var selectedDate = Rxn<DateTime>();
  var selectedMaterial = Rxn<String>();
  var selectedFile = Rxn<File>();

  final List<String> materials = ['Material A', 'Material B', 'Material C'];

  // Function to show date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      print('Form Submitted');
      print('Selected Date: ${selectedDate.value}');
      print('Selected Material: ${selectedMaterial.value}');
      print('Selected File: ${selectedFile.value?.path}');
    }
  }
}
