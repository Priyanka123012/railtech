import 'package:faecauth/utils/appHelper/app_fontfamily.dart';
import 'package:faecauth/utils/appHelper/app_helper.dart';
import 'package:faecauth/utils/appHelper/app_helper_function.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final Function onStartNowClick;
  final String buttonText;
  Color textColor;
  Color startColor;
  Color endColor;
  final double height;
  final double width;

  CustomButton({
    Key? key,
    required this.onStartNowClick(),
    this.buttonText = "Continue",
    this.height = 50,
    this.width = double.infinity,
    required this.textColor,
    required this.startColor,
    required this.endColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppHelperFunction().hideKeyBoard();
        onStartNowClick();
      },
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppHelperFunction().boxShadow(),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Text(
          buttonText,
          style: AppFontFamily().roboto.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
              fontSize: AppDimensions().h20),
        ),
      ),
    );
  }
}

void checkGeofence() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double? storedLatitude = prefs.getDouble('storedLatitude');
  double? storedLongitude = prefs.getDouble('storedLongitude');

  Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  double distance = Geolocator.distanceBetween(
    storedLatitude!,
    storedLongitude!,
    currentPosition.latitude,
    currentPosition.longitude,
  );

  if (distance <= 2000) {
    print("Inside Geofence");
  } else {
    print("Outside Geofence");
  }
}
