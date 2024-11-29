import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:faecauth/utils/appHelper/app_fontfamily.dart';
import 'package:faecauth/utils/appHelper/app_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AppHelperFunction {
  void appPrint({required String val}) {
    if (kDebugMode) {
      print(val);
    }
  }

  void showGoodSnackBar({required String message}) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: AppFontFamily().roboto.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(Get.context!).scaffoldBackgroundColor),
      ),
      backgroundColor: Theme.of(Get.context!).hoverColor,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      snackPosition: SnackPosition.TOP,
      borderRadius: AppDimensions().h30,
      maxWidth: Get.width / 1.3,
    ));
  }

  void showErrorSnackBar({required String message}) {
    /// Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: AppFontFamily().roboto.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(Get.context!).scaffoldBackgroundColor),
      ),
      backgroundColor: Theme.of(Get.context!).cardColor,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      snackPosition: SnackPosition.TOP,
      borderRadius: AppDimensions().h30,
      maxWidth: Get.width / 1.3,
    ));
  }

  void hideKeyBoard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');

  // Future<File?> pickImage({
  //   required ImageSource img,
  // }) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: img, imageQuality: 50);
  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   } else {
  //     ScaffoldMessenger.of(Get.context!)
  //         .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
  //   }
  //   return null;
  // }

  List<BoxShadow> boxShadow(
          {Color? color,
          double spreadRadius = 5,
          double blurRadius = 30,
          Offset offset = const Offset(0, 3)}) =>
      [
        BoxShadow(
          color: const Color(0xff0000001A).withOpacity(0.05),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
          offset: offset,
        )
      ];

  static Future<String> downloadImageByUrl(String urlPath) async {
    try {
      final fileName = urlPath.split("/").last;
      final dir = (await getApplicationDocumentsDirectory()).path;
      final file = File("$dir/$fileName");
      print(("downloadImageByUrl", urlPath, file.path));
      if (!await file.exists()) {
        final resp = await Dio().download(urlPath, file.path);
        print(("resp", resp.statusCode));
      }

      return base64Encode(await file.readAsBytes());
    } catch (e) {
      return "";
    }
  }
}
