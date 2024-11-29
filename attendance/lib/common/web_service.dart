import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:faecauth/screens/auth/login_with_email.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'app_exception.dart';
import '../utils/utils.dart';

Future<dynamic> callWebApi(String url, Map data,
    {required Function onResponse,
    Function? onError,
    String token = "",
    bool showLoader = true,
    bool hideLoader = true}) async {
  if (showLoader) Utils.showLoaderDialog();
  try {
    Utils.print('request url: ' + url);
    Utils.print('request data: ' + json.encode(data).toString());

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers.addIf(token.isNotEmpty, "Authorization", "Bearer " + token);
    Utils.print('headers: ' + json.encode(headers));
    //     Utils.hideLoader();
    // return;
    final http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(data));

    return _returnResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (_) {
    Utils.print(_.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');
    Utils.hideLoader();
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    Utils.hideLoader();
  }
}

_returnResponse(http.Response response, Function onResponse, Function? onError,
    bool hideLoader) async {
  Utils.print('response code:' + response.statusCode.toString());
  Utils.print('response :' + response.body.toString());
  Map? responseJson = {};
  try {
    responseJson = jsonDecode(response.body);
  } catch (exception) {
    responseJson!['message'] = "Something went wrong";
    if (hideLoader) Utils.hideLoader();

    Utils.print(exception.toString());
  }
  switch (response.statusCode) {
    case 200:
      if (hideLoader) Utils.hideLoader();
      onResponse(response);
      return 'responseJson';
    case 400:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();

      Utils.showToast(responseJson!['message']);

      throw BadRequestException(response.body.toString());
    case 404:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast(responseJson!['message']);

      throw InvalidInputException(response.body.toString());
    case 401:
    case 403:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast('Your session has expired, please login again!');

      Get.offUntil(CupertinoPageRoute(builder: (context) => LoginView()),
          (route) => false);

      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      Utils.showToast(responseJson!['message']);

      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

Future<dynamic> callWebApiGet(String url,
    {required Function onResponse,
    Function? onError,
    String token = "",
    bool showLoader = true,
    bool hideLoader = true}) async {
  if (showLoader) Utils.showLoaderDialog();
  try {
    Utils.print('request url: ' + url);
    Utils.print('request token: ' + token);

    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers.addIf(token.isNotEmpty, "Authorization", "Bearer " + token);
    Utils.print('headers: ' + json.encode(headers));
    //     Utils.hideLoader();
    // return;
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return _returnResponseGet(response, onResponse, onError, hideLoader);
  } on SocketException catch (_) {
    Utils.print(_.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');
    Utils.hideLoader();
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    Utils.hideLoader();
  }
}

_returnResponseGet(http.Response response, Function onResponse,
    Function? onError, bool hideLoader) async {
  Utils.print('response code:' + response.statusCode.toString());
  Utils.print('response :' + response.body.toString());
  Map? responseJson = {};
  try {
    responseJson = jsonDecode(response.body);
  } catch (exception) {
    responseJson!['message'] = "Something went wrong";
    if (hideLoader) Utils.hideLoader();

    Utils.print(exception.toString());
  }
  switch (response.statusCode) {
    case 200:
      if (hideLoader) Utils.hideLoader();
      onResponse(response);
      return 'responseJson';
    case 400:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();

      Utils.showToast(responseJson!['message']);

      throw BadRequestException(response.body.toString());
    case 404:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast(responseJson!['message']);

      throw InvalidInputException(response.body.toString());
    case 401:
    case 403:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast('Your session has expired, please login again!');

      Get.offUntil(CupertinoPageRoute(builder: (context) => LoginView()),
          (route) => false);

      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      Utils.showToast(responseJson!['message']);

      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

Future<dynamic> callMultipartWebApi(
    String url, Map data, List<http.MultipartFile> files,
    {required Function onResponse,
    Function? onError,
    required String token,
    bool showLoader = true,
    bool hideLoader = true}) async {
  if (showLoader) Utils.showLoaderDialog();

  var request = http.MultipartRequest("POST", Uri.parse(url));

  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + token
  };
  Utils.print('request url: ' + url);
  Utils.print('request data: ' + json.encode(data));
  Utils.print('headers: ' + json.encode(headers));

  request.headers.addAll(headers);

  try {
    request.fields.addAll(data as Map<String, String>);
    for (http.MultipartFile file in files) {
      request.files.add(file);
      Utils.print('request file: ' + file.filename!);
    }
  } catch (e) {
    Utils.print("Error adding request : " + e.toString());
    Utils.hideLoader();
  }

  try {
    var response = await request.send();
    return returnMutipartResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (_) {
    Utils.print(_.toString());
    if (onError != null) {
      onError();
    }
    Utils.showToast('No Internet Connection');

    Utils.hideLoader();
    return;
  } catch (e) {
    if (onError != null) {
      onError();
    }
    Utils.print(e.toString());
    Utils.showToast('Something went wrong');
    Utils.hideLoader();
  }
}

returnMutipartResponse(http.StreamedResponse response, Function onResponse,
    Function? onError, bool hideLoader) async {
  Utils.print('response code:' + response.statusCode.toString());
  Map? responseJson = {};
  String resp = await response.stream.bytesToString();
  log('response :' + resp);
  try {
    responseJson = json.decode(resp);
  } catch (exception) {
    responseJson!['message'] = "Something went wrong";
    Utils.print(exception.toString());
  }
  switch (response.statusCode) {
    case 200:
      // responseJson = json.decode(await response.stream.bytesToString());
      if (hideLoader) Utils.hideLoader();
      onResponse(responseJson);
      return 'responseJson';
    case 400:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast(responseJson!['message']);
      throw BadRequestException(responseJson.toString());
    case 404:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      Utils.showToast(responseJson!['message']);
      throw InvalidInputException(responseJson.toString());
    case 401:
    case 403:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();

      Utils.showToast('Your session has expired, please login again!');

      Get.offUntil(CupertinoPageRoute(builder: (context) => LoginView()),
          (route) => false);

      throw UnauthorisedException(responseJson.toString());
    case 500:
    default:
      Utils.showToast(responseJson!['message']);
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
