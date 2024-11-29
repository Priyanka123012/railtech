import 'package:faecauth/screens/auth/login_model.dart';
import 'package:get/get.dart';

class Constants {
  static const String isLoggedIn = 'isLoggedIn';
  static const String logResponseKey = 'logResponseKey';
  static const String token = 'token';
  static Rx<LoginResponseModel> loginResponse = LoginResponseModel().obs;
}
