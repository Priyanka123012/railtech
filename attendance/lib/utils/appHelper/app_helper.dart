import 'package:flutter/material.dart';

class AppDimensions {
  double h05 = 5;
  double h10 = 10;
  double h15 = 15;
  double h20 = 20;
  double h25 = 25;
  double h30 = 30;
  double h40 = 40;
  double h45 = 45;

  Widget vSpace5() => const SizedBox(
        height: 5,
      );

  Widget vSpace10() => const SizedBox(
        height: 10,
      );

  Widget vSpace15() => const SizedBox(
        height: 15,
      );

  Widget vSpace20() => const SizedBox(
        height: 20,
      );

  Widget vSpace25() => const SizedBox(
        height: 25,
      );

  Widget vSpace30() => const SizedBox(
        height: 30,
      );

  Widget hSpace5() => const SizedBox(
        width: 5,
      );

  Widget hSpace10() => const SizedBox(
        width: 10,
      );

  Widget hSpace15() => const SizedBox(
        width: 15,
      );

  Widget hSpace20() => const SizedBox(
        width: 20,
      );

  Widget hSpace25() => const SizedBox(
        width: 25,
      );

  Widget hSpace30() => const SizedBox(
        width: 30,
      );

  Widget preventBottomHide() => const SizedBox(
        height: 70,
      );
}
