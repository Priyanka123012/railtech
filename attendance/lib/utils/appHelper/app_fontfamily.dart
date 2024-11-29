import 'package:faecauth/utils/appHelper/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFontFamily {
  final roboto = TextStyle(
    fontFamily: "Roboto",
    fontSize: AppDimensions().h05,
    fontWeight: FontWeight.w500,
    color: Theme.of(Get.context!).primaryColor,
  );

//thin ==w300
//light ==w400
//regular ==w500
//medium ==w600
//bold ==w700
}
