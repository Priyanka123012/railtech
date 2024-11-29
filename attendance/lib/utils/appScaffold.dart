import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppScaffold({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child, if (isLoading) const LoadingView()],
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withOpacity(0.5)),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
