import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension CustomAppBarStyles on AppBar {
  AppBar gradientBackground({bool withActions = true}) => AppBar(
        foregroundColor: Colors.white,
        toolbarHeight: Get.height * 0.07,
        title: this.title,
        actions: withActions ? this.actions : null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.teal.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      );

  AppBar customGradientBackground(Gradient gradient,
          {bool withActions = true}) =>
      AppBar(
        title: this.title,
        actions: withActions ? this.actions : null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradient,
          ),
        ),
        centerTitle: this.centerTitle,
      );
}
