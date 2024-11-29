import 'dart:convert';
import 'package:faecauth/IntroScreen.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/common/constant.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/utils/utils.dart';
import 'package:faecauth/common/web_service.dart';
import 'package:faecauth/screens/auth/login_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  bool isLoading = false;
  bool isActive = false;
  bool isClickable = false;
  late SharedPreferences _prefs;

  @override
  void onInit() async {
    _prefs = await SharedPreferences.getInstance();
    super.onInit();
  }

  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  Future<bool> setEmpId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('empId', value);
  }

  Future<bool> setEmpName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('empName', value);
  }

  Future<bool> setEmpType(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('empType', value);
  }

  Future<bool> setmanagerId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('managerId', value);
  }
   Future<bool> SetCostCenterId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('CostCenterId', value);
  }

  // login({required String email, required String password}) async {
  //   if (email.trim().isEmpty) {
  //     Utils.showToast("Please Enter mobile number");
  //     return;
  //   } else if (password.trim().isEmpty) {
  //     Utils.showToast("Please Enter Password");
  //     return;
  //   }
  //   Map<String, dynamic> data = {
  //     'UserName': email,
  //     'Password': password,
  //   };
  //   await callWebApi(ApiUrls.login, data,
  //       onResponse: (http.Response response) async {
  //     LoginResponseModel result =
  //         LoginResponseModel.fromJson(jsonDecode(response.body));
  // Constants.loginResponse.value = result;
  // LoginResponseModel responseJson = LoginResponseModel.fromJson(
  //     json.decode(utf8.decode(response.bodyBytes)));
  // // await _prefs.clear();
  // await setToken(responseJson.accessToken.toString());
  // await setEmpId(responseJson.employee!.eMPBasicDetailId.toString());
  // await setEmpName(responseJson.employee!.fullName.toString());
  // await setEmpType(responseJson.employee!.type.toString());
  // await setmanagerId(responseJson.employee!.managerId.toString());

  // print("url:==${ApiUrls.login}");
  // print("Response:==${response.body}");
  // print("Emp Id:=${responseJson.employee!.managerId}");
  // await _prefs.setString(Constants.isLoggedIn, "1");
  // await _prefs.setString(Constants.logResponseKey, response.body);
  // Constants.loginResponse.value = responseJson;
  //     if (responseJson.statusCode == 1) {
  //       Get.to(() => HomePageScreeen());
  //       "${responseJson.statusText} Successfully".showToast();
  //     } else {
  //       "User Id or password is not matched".showToast();
  //     }
  //   });
  // }

  login({required String email, required String password}) async {
    // Validate input
    if (email.trim().isEmpty) {
      Utils.showToast("Please Enter mobile number");
      return;
    } else if (password.trim().isEmpty) {
      Utils.showToast("Please Enter Password");
      return;
    }

    // Prepare request data
    Map<String, dynamic> data = {
      'UserName': email,
      'Password': password,
    };
    await callWebApi(ApiUrls.login, data,
        onResponse: (http.Response response) async {
      LoginResponseModel result =
          LoginResponseModel.fromJson(jsonDecode(response.body));
      Constants.loginResponse.value = result;
      LoginResponseModel responseJson = LoginResponseModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      if (response.statusCode == 200 && responseJson.status == "Success") {
        Constants.loginResponse.value = result;
        LoginResponseModel responseJson = LoginResponseModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        await setToken(responseJson.accessToken.toString());
        await setEmpId(responseJson.employee!.eMPBasicDetailId.toString());
        await setEmpName(responseJson.employee!.fullName.toString());
        await setEmpType(responseJson.employee!.type.toString());
        await setmanagerId(responseJson.employee!.managerId.toString());
        await SetCostCenterId(responseJson.employee!.costCenterId.toString());

        print("url:==${ApiUrls.login}");
        print("Response:==${response.body}");
        print("Emp Id:=${responseJson.employee!.managerId}");
        await _prefs.setString(Constants.isLoggedIn, "1");
        await _prefs.setString(Constants.logResponseKey, response.body);
        Constants.loginResponse.value = responseJson;
        Get.to(() => IntroScreen());
        "${responseJson.statusText} Successfully".showToast();
      } else if (response.statusCode == 401 ||
          responseJson.status != "Success") {
        "${responseJson.statusText ?? "Username or password is wrong"}"
            .showToast();
      } else {
        "An unexpected error occurred. Please try again.".showToast();
      }
    }).catchError((error) {
      "Something went wrong. Please check your connection.".showToast();
    });
  }
}
