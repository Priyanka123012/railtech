import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';

import 'package:faecauth/screens/model/punch_in_model.dart';
import 'package:faecauth/screens/model/registered_face_model.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:face_liveness/face_liveness.dart';

class FaceMatcher {
  final controller = Get.put(HonmePageController());
  final controller1 = Get.put(HonmePageController());
  FaceMatcher._();

  static final FaceMatcher _instance = FaceMatcher._();

  static FaceMatcher get instance => _instance;

  FaceLiveness faceLiveness = FaceLiveness();
 

  Future<void> init() async {
    await faceLiveness.initAnalyzer();
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<String?> getCostCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CostCenterId');
  }

  Future<void> registerFace(String? id, String name, String img) async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      "EMP_BasicDetail_Id not found".showToast();
      return;
    }
    try {
      // await Future.delayed(Duration(seconds: 7));
      MultiFaceInput? faceData = await addFace(id!, name);
      if (faceData != null) {
        if (img != "") {
          await updateFaceData(faceData.imageBase64, id);
        } else {
        await faceregisterapi(faceData.imageBase64, id);
        }
      } else {
        print("Face is not matched");
      }
    } catch (e) {
      // print("Error in registerFace: $e");
    }
  }

  Future<void> updateFaceData(String imageData, String id) async {
    String url = "http://rapi.railtech.co.in/api/FaceRegistration/update";
    String? empId = await getEmpBasicDetailId();
    try {
         print("6666666666666666666666666667777=ASDSA=>>  $empId    $id");
      Map<String, dynamic> data = {
        "FaceRegistrationId": "",
        "EMP_BasicDetail_Id": id,
        "Location": location,
        "EMPKey": "",
        "UserId": id,
        "FaceImage": imageData,
        "MarkedByUserId": empId
      };
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print("empId===${empId}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        RegisteredFaceResponseModel responseModel =
            RegisteredFaceResponseModel.fromJson(jsonResponse);
        if (responseModel.statusCode == 1) {
          for (var one in responseModel.fRV!) {
            MultiFaceInput faceInput = MultiFaceInput(
              imageName: one.fullName ?? "unknown",
              imageBase64: one.faceImage ?? "",
              empid: id,
              markUser: empId,
            );
            // print("faceInput${faceInput.imageName}");
            // print("jsonResponsettt${jsonResponse}");
          }
          Get.offAll(() => HomePageScreeen());
          "${jsonResponse["statusText"]}".showToast(duration: 10);
          // print("Results: ${responseModel.fRV}");
        } else {
          // print("Failed to update face: ${jsonResponse}");
        }
      } else {
        // print("Failed to update face: ${response.statusCode}");
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face update: $e");
      }
    }
  }

  Future<void> faceregisterapi(String imageData, String id) async {
     controller1.loder.value = true;
    String url = ApiUrls.faceregister;
    String? empId = await getEmpBasicDetailId();
    Position position = await getCurrentLocation();
    String lat = "${position.latitude}";
    String long = "${position.longitude}";
    // print("6666666666666666666666666667777==>>  $empId    $long");
    Map<String, dynamic> data = {
      "FaceRegistrationId": "",
      "EMP_BasicDetail_Id": id,
      "Location": location,
      "EMPKey": "",
      "UserId": id,
      "FaceImage": imageData,
      "MarkedByUserId": empId,
      "Longitude": lat,
      "Latitude": long,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
          controller.loder.value = false;
        final jsonResponse = jsonDecode(response.body);
        RegisteredFaceResponseModel responseModel =
            RegisteredFaceResponseModel.fromJson(jsonResponse);
        if (responseModel.statusCode == 1) {
          FRV frv = responseModel.fRV!.first;
          MultiFaceInput faceInput = MultiFaceInput(
            imageName: frv.fullName ?? "unknown",
            imageBase64: frv.faceImage ?? "",
            empid: id,
            markUser: empId,
          );
          allFacess.add(faceInput);
          Get.offAll(() => HomePageScreeen());
          
          "${jsonResponse["statusText"]}".showToast(duration: 10);
          // print("Results: ${responseModel.fRV}");
          
        } else {
           controller1.loder.value = false;
          // print("Failed to match face: ${jsonResponse}");
        }
      } else {
          controller1.loder.value = false;
        // print("Failed to register face: ${response.statusCode}");
      }
    } catch (e) {
        controller1.loder.value = false;

      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face registration: $e");
      }
    }
  }

  Future<MultiFaceInput?> addFace(String id, String? name) async {
    String? empId = await getEmpBasicDetailId();
      await Future.delayed(Duration(seconds: 5));

    try {
      
      // await Future.delayed(Duration(seconds: 7));
      final response = await faceLiveness.caputeFaceLiveness();

      if (response != null && response.isLive && response.imageBase64 != null) {
        MultiFaceInput data = MultiFaceInput(
          imageName: name ?? "unknown",
          imageBase64: response.imageBase64!,
          empid: id,
          markUser: empId,
        );
        allFacess.add(data);
        Get.offAll(() => HomePageScreeen());
        // print(
            // "Added face: ${data.imageName}, total faces: ${response.imageBase64}");
        return data;
      }
    } catch (e) {
      // print("Error in addFace: $e");
    }
    return null;
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> matchFace(String id, String ststus) async {
     await Future.delayed(Duration(seconds: 5));
    final response = await faceLiveness.caputeFaceLiveness();
    if (response == null || !response.isLive || response.imageBase64 == null) {
      "Face is not matched".showToast();
      return;
    }

    // print("kldfhgkdfj===${ststus}");
    // log("${ststus}");
    final filteredFaces  = allFaces.where((face) => face.imageBase64 == faceImag).toList();
    final filteredFacess = allFaces.where((face) => face.imageBase64 == ststus).toList();
    final matchedFaces = await faceLiveness.matchMultiFaces(
      primaryBase64Img: response.imageBase64!,
      threshold: 0.75,
      multifaceInput: ststus == "" ? filteredFaces : filteredFacess,
      checkAll: false,
    );
    // print("Matched Faces: ${matchedFaces}");

    if (matchedFaces.isNotEmpty) {
      final match = matchedFaces[0];
      if (match.similarity >= 0.75) {
        // print("Length of matched faces: ${matchedFaces.length}");
        // print("Matched face: ${match.imageName}");

        await matchRegisteredFace(response.imageBase64!, id);
        if (ststus == "") {
          Get.back();
        } else {
          Get.offAll(() => HomePageScreeen());
        }
      } else {
        "Face is not matched with sufficient similarity!"
            .showToast(duration: 10);
      }
    } else {
      "Face is not matched with sufficient similarity!".showToast(duration: 10);
    }
  }


  // Future<void> matchRegisteredFace(String imageData, String id) async {
  //   String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
  //   String? empId = await getEmpBasicDetailId();

  //   try {
  //     Position position = await getCurrentLocation();
  //     String lat = "${position.latitude}";
  //     String long = "${position.longitude}";
  //     Map<String, dynamic> data = {
  //       "PunchId": null,
  //       "EMP_BasicDetail_Id": id,
  //       "Location": location,
  //       "PunchImage": imageData,
  //       "Latitude": lat,
  //       "Longitude": long,
  //       "UserId": id,
  //       "MarkedByUserId": empId,
  //     };

  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(data),
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['StatusCode'] == 1 &&
  //           jsonResponse['FRV'] != null &&
  //           jsonResponse['FRV'].isNotEmpty) {
  //         final frv = jsonResponse['FRV'][0];
  //         String empBasicDetailId = frv['EMP_BasicDetail_Id'];
  //         String fullName = frv['FullName'];
  //         String faceImage = frv['FaceImage'];
  //         String location = frv['Location'];

  //         print("EMP Basic Detail ID: $empBasicDetailId");
  //         print("Full Name: $fullName");
  //         print("Face Image: $faceImage");
  //         print("Location: $location");

  //         PunchInModel model = PunchInModel.fromJson(jsonResponse);
  //         if (model.statusCode == 1) {
  //           Get.offAll(() => HomePageScreeen());
  //           "${model.statusText}".showToast(duration: 10);
  //         } else {
  //           print("Please Re-register Your Face: $id");
  //         }
  //       } else {
  //         print("Failed to match face: ${jsonResponse}");
  //         "${jsonResponse["statusText"]}".showToast(duration: 10);
  //       }
  //     } else {
  //       "Try Again".showToast(duration: 10);
  //     }
  //   } catch (e) {
  //     if (e is SocketException) {
  //       "$e".showToast(duration: 10);
  //     } else {
  //       print("Error during face matching: $e");
  //     }
  //   }
  // }

  Future<void> matchRegisteredFace(String imageData, String id) async {
    controller.loder.value = true;
    String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
    String? empId = await getEmpBasicDetailId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";
      if (location!.isEmpty) {
        // print("Location not detected. Unable to punch in.");
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }
      // print("666666666666666666666666666==>>  $lat    $long  $location ");

      Map<String, dynamic> data = {
        "PunchId": null,
        "EMP_BasicDetail_Id": id,
        "Location": location,
        "PunchImage": imageData,
        "Latitude": lat,
        "Longitude": long,
        "UserId": id,
        "MarkedByUserId": empId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        controller.loder.value = false;
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          String empBasicDetailId = frv['EMP_BasicDetail_Id'];
          String fullName = frv['FullName'];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("EMP Basic Detail ID: $empBasicDetailId");
          // print("Full Name: $fullName");
          // print("Face Image: $faceImage");
          // print("Location: $location");

          PunchInModel model = PunchInModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            Get.offAll(() => HomePageScreeen());
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $id");
          }
        } else {
          controller.loder.value = false;
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        controller.loder.value = false;
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      controller.loder.value = false;
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }
  }

/////////////////----------------------for labour-----------------------//////////
  Future<void> updateFaceDataLabour(
      String imageData, String id, String labelId) async {
    String url = "http://rapi.railtech.co.in/api/LabourFaceRegistration/update";
    String? empId = await getEmpBasicDetailId();
    try {
      Map<String, dynamic> data = {
        "FaceRegistrationId": null,
        "LabourId": labelId,
        // "EMP_BasicDetail_Id": id,
        "Location": location,
        "EMPId": null,
        "UserId": id,
        "FaceImage": imageData,
        "MarkedByUserId": empId.toString()
      };
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print("empId===${empId}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        RegisteredFaceResponseModel responseModel =
            RegisteredFaceResponseModel.fromJson(jsonResponse);
        if (responseModel.statusCode == 1) {
          for (var one in responseModel.fRV!) {
            MultiFaceInput faceInput = MultiFaceInput(
              imageName: one.fullName ?? "unknown",
              imageBase64: one.faceImage ?? "",
              empid: id,
              markUser: empId,
            );
            // print("faceInput${faceInput.imageName}");
            // print("jsonResponsettt${jsonResponse}");
          }

          "${jsonResponse["statusText"]}".showToast(duration: 10);
          // print("Results: ${responseModel.fRV}");
        } else {
          // print("Failed to update face: ${jsonResponse}");
        }
      } else {
        // print("Failed to update face: ${response.statusCode}");
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face update: $e");
      }
    }
  }

  Future<void> LabourFaceRegistration(
      String imageData, String id, String labourId) async {
    String url = "http://rapi.railtech.co.in/api/LabourFaceRegistration/Add";
    String? empId = await getEmpBasicDetailId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";

      if (location == null || location!.isEmpty) {
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }

      Map<String, dynamic> data = {
        "FaceRegistrationId": null,
        "LabourId": labourId,
        "Location": location ?? "Unknown",
        "EMPId": null,
        "FaceImage": imageData ?? "",
        "UserId": labourId,
        "MarkedByUserId": empId
      };
      // print("Sending data: $data");

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("Face Image: $faceImage");
          // print("Location: $location");

          PunchInModel model = PunchInModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $labourId");
          }
        } else {
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }
  }

  Future<void> matchFaceLabourReg(String imageData,String id,
  ) async {
    String url = "http://rapi.railtech.co.in/api/LabourPunch/Add";
    String? empId = await getEmpBasicDetailId();
    String? costCenterId = await getCostCenterId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";
      if (location!.isEmpty) {
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }

      Map<String, dynamic> data = {
        "PunchId": null,
        "LabourId": id,
        "CostCenterId": costCenterId,
        "TPartcicipationId": empId.toString(),
        "Location": location,
        "PunchImage": imageData,
        "Latitude": lat,
        "Longitude": long,
        "UserId": id,
        "MarkedByUserId": empId.toString()

        // "PunchId": null,
        // "EMP_BasicDetail_Id": id,
        // "Location": location,
        // "PunchImage": imageData,
        // "Latitude": lat,
        // "Longitude": long,
        // "UserId": id,
        // "MarkedByUserId": empId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          // String empBasicDetailId = frv['EMP_BasicDetail_Id'];
          String fullName = frv['FullName'];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("EMP Basic Detail ID: $empBasicDetailId");
          // print("Full Name: $fullName");
          // print("Face Image: $faceImage");
          // print("Location: $location");

          GetLabourPunchinModel model = GetLabourPunchinModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            Get.back();
            // Get.offAll(() => HomePageScreeen());
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $id");
          }
        } else {
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }
  }

// Future<void> LabourFaceRegistration(String  imageData, String id,String labelId, ) async {
//   String url = "http://rapi.railtech.co.in/api/LabourFaceRegistration/Add";
//   // String? labourId = await getLabourId();
//     String? empId = await getEmpBasicDetailId();

//   try {
//     Position position = await getCurrentLocation();
//     String lat = "${position.latitude}";
//     String long = "${position.longitude}";
//     if (location!.isEmpty) {
//       "Location not detected. Unable to punch in.".showToast(duration: 5);
//       return;
//     }

//     Map<String, dynamic> data = {

//   "FaceRegistrationId": null,
//   "LabourId": labelId,
//   "Location": location,
//   "EMPId":null ,
//   "FaceImage": imageData,
//   "UserId": labelId,
//   "MarkedByUserId": empId.toString()

//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(data),
//     );

//     if (response.statusCode == 200) {
//       print('-----------------------------------------------------------------------------hello------------------------------------');
//       final jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['StatusCode'] == 1 &&
//           jsonResponse['FRV'] != null &&
//           jsonResponse['FRV'].isNotEmpty) {
//       print('-----------------------------------------------------------------------------hello------------------------------------');
//         final frv = jsonResponse['FRV'][0];
//         // String empBasicDetailId = frv['EMP_BasicDetail_Id'];
//         // String fullName = frv['FullName'];
//         String faceImage = frv['FaceImage'];
//         String location = frv['Location'];

//         // print("EMP Basic Detail ID: $empBasicDetailId");
//         // print("Full Name: $fullName");
//         print("Face Image: $faceImage");
//         print("Location: $location");

//         PunchInModel model = PunchInModel.fromJson(jsonResponse);
//         if (model.statusCode == 1) {
//           // Get.offAll(() => HomePageScreeen());
//           "${model.statusText}".showToast(duration: 10);
//         } else {
//           print("Please Re-register Your Face: $id");
//         }
//       } else {
//         print("Failed to match face: ${jsonResponse}");
//         "${jsonResponse["statusText"]}".showToast(duration: 10);
//       }
//     } else {
//       "Try Again".showToast(duration: 10);
//     }
//   } catch (e) {
//     if (e is SocketException) {
//       "$e".showToast(duration: 10);
//     } else {
//       print("Error during face matching: $e");
//     }
//   }
// }

  Future<void> registerFaceLabour(
      String? empId, String? name, String img) async {
    if (empId == null) {
      "LabourId Not Found".showToast();
      return;
    }
    try {
      MultiFaceInput? faceData = await addFacelabour(empId, name);
      if (faceData != null) {
        if (img != "") {
          await updateFaceDataLabour(faceData.imageBase64, empId, empId);
        } else {
          await LabourFaceRegistration(faceData.imageBase64, empId, empId);
        }
      } else {
        // print("Face is not matched");
      }
    } catch (e) {
      // print("Error in registerFace: $e");
    }
  }

  // Future<void> matchFaceLabour(String id, String ststus) async {
  //    await Future.delayed(Duration(seconds: 5));
  //   final response = await faceLiveness.caputeFaceLiveness();
  //   if (response == null || !response.isLive || response.imageBase64 == null) {
  //     "Face is not matched".showToast();
  //     return;
  //   }

  //   print("kldfhgkdfj===${ststus}");
  //   final filteredFaces =
  //       allFaces.where((face) => face.imageBase64 == faceImag).toList();
  //   final filteredFacess =
  //       allFaces.where((face) => face.imageBase64 == ststus).toList();
  //   final matchedFaces = await faceLiveness.matchMultiFaces(
  //     primaryBase64Img: response.imageBase64!,
  //     threshold: 0.75,
  //     multifaceInput: ststus == "" ? filteredFaces : filteredFacess,
  //     checkAll: false,
  //   );
  //   print("Matched Faces: ${matchedFaces}");
  //   if (matchedFaces.isNotEmpty) {
  //     final match = matchedFaces[0];
  //     if (match.similarity >= 0.75) {
  //       print("Length of matched faces: ${matchedFaces.length}");
  //       print("Matched face: ${match.imageName}");
  //       await matchFaceLabourReg(response.imageBase64!, id);
  //       if (ststus == "") {
  //         Get.back();  
  //       } else {
  //         // Get.offAll(() => HomePageScreeen());
  //       }
  //     } else {
  //       "Face is not matched with sufficient similarity!"
  //           .showToast(duration: 10);
  //     }
  //   } else {
  //     "Face is not matched with sufficient similarity!".showToast(duration: 10);
  //   }
  // }
    Future<void> matchFaceLabour(String id, String ststus) async {
     await Future.delayed(Duration(seconds: 5));
    final response = await faceLiveness.caputeFaceLiveness();
    if (response == null || !response.isLive || response.imageBase64 == null) {
      "Face is not matched".showToast();
      return;
    }
// print("hsduiashdsa=>$id");
    // print("kldfhgkdfj===${ststus}");
    // print("jsndbjsadsjkdsakhds=>$faceImage64");
    // log("================????? ${ststus}");
    final filteredFaces =
        allFaces.where((face) => face.imageBase64 == faceImag).toList();
    final filteredFacess =
        allFaces.where((face) => face.imageBase64 == ststus).toList();
    final matchedFaces = await faceLiveness.matchMultiFaces(
      primaryBase64Img: response.imageBase64!,
      threshold: 0.75,
      multifaceInput: ststus == "" ? filteredFaces : filteredFacess,
      checkAll: false,
    );
    // print("Matched Faces: ${matchedFaces}");

    if (matchedFaces.isNotEmpty) {
      final match = matchedFaces[0];
      if (match.similarity >= 0.75) {
        // print("Length of matched faces: ${matchedFaces.length}");
        // print("Matched face: ${match.imageName}");

        await matchFaceLabourReg(response.imageBase64!, id);
        if (ststus == "") {
          Get.back();
        } else {
          // Get.offAll(() => HomePageScreeen());
        }
      } else {
        "Face is not matched with sufficient similarity!"
            .showToast(duration: 10);
      }
    } else {
      "Face is not matched with sufficient similarity!".showToast(duration: 10);
    }
  }


  Future<MultiFaceInput?> addFacelabour(String id, String? fullName) async {
    String? empId = await getEmpBasicDetailId();
     await Future.delayed(Duration(seconds: 5));
    try {
      final response = await faceLiveness.caputeFaceLiveness();
      if (response != null && response.isLive && response.imageBase64 != null) {
        MultiFaceInput data = MultiFaceInput(
          imageName: fullName ?? "unknown",
          imageBase64: response.imageBase64!,
          empid: id,
          markUser: empId,
        );
        allFacess.add(data);
        // Get.offAll(() => HomePageScreeen());
        // print(
            // "Added face: ${data.imageName}, total faces: ${response.imageBase64}");
        return data;
      }
    } catch (e) {
      // print("Error in addFace: $e");
    }
    return null;
  }

  //---------------------team face register ------------------\
  Future<void> registerFaceTeam(String? empId, String? name, String img) async {
    if (empId == null) {
      "TeamEmployeeId Not Found".showToast();
      return;
    }
    try {
      MultiFaceInput? faceData = await addFaceTeam(empId, name);
      if (faceData != null) {
        if (img != "") {
          await updateFaceDataTeam(faceData.imageBase64, empId,);
        } else {
          await TeamFaceRegistration(faceData.imageBase64, empId, );
        }
      } else {
        // print("Face is not matched");
      }
    } catch (e) {
      // print("Error in registerFace: $e");
    }
  }

  Future<MultiFaceInput?> addFaceTeam(String id, String? fullName) async {
    String? empId = await getEmpBasicDetailId();
     await Future.delayed(Duration(seconds: 5));
    try {
      final response = await faceLiveness.caputeFaceLiveness();
      if (response != null && response.isLive && response.imageBase64 != null) {
        MultiFaceInput data = MultiFaceInput(
          imageName: fullName ?? "unknown",
          imageBase64: response.imageBase64!,
          empid: id,
          markUser: empId,
        );
        allFacess.add(data);
        // Get.offAll(() => HomePageScreeen());
        // print(
            // "Added face: ${data.imageName}, total faces: ${response.imageBase64}");
        return data;
      }
    } catch (e) {
      // print("Error in addFace: $e");
    }
    return null;
  }

  Future<void> TeamFaceRegistration(
      String imageData, String id, ) async {
    String url = "http://rapi.railtech.co.in/api/TeamFaceRegistration/Add";
    String? empId = await getEmpBasicDetailId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";

      if (location == null || location!.isEmpty) {
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }
//  print("===============================nsgdsa==> $id   $empId  $lat  $long");
      Map<String, dynamic> data = {
        // "FaceRegistrationId": null,
        // "LabourId": labourId,
        // "Location": location ?? "Unknown",
        // "EMPId": null,
        // "FaceImage": imageData ?? "",
        // "UserId": labourId,
        // "MarkedByUserId": empId

        "FaceRegistrationId": null,
        "EMP_BasicDetail_Id": id,
        "Location": location,
        "EMPKey": null,
        "FaceImage": imageData ??"",
        "UserId": id,
        "MarkedByUserId": empId,
        "Longitude": lat,
        "Latitude": long,
      };
      // print("Sending data: $data");

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("Face Image: $faceImage");
          // print("Location: $location");

          PunchInModel model = PunchInModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $id");
          }
        } else {
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }
  }

  Future<void> matchFaceTeam(String id, String ststus) async {
     await Future.delayed(Duration(seconds: 5));
    final response = await faceLiveness.caputeFaceLiveness();
    if (response == null || !response.isLive || response.imageBase64 == null) {
      "Face is not matched".showToast();
      return;
    }

    // print("kldfhgkdfj===${ststus}");
    final filteredFaces =
        allFaces.where((face) => face.imageBase64 == faceImage64).toList();
    final filteredFacess =
        allFaces.where((face) => face.imageBase64 == ststus).toList();
    final matchedFaces = await faceLiveness.matchMultiFaces(
      primaryBase64Img: response.imageBase64!,
      threshold: 0.75,
      multifaceInput: ststus == "" ? filteredFaces : filteredFacess,
      checkAll: false,
    );
    // print("Matched Faces: ${matchedFaces}");
    if (matchedFaces.isNotEmpty) {
      final match = matchedFaces[0];
      if (match.similarity >= 0.75) {
        // print("Length of matched faces: ${matchedFaces.length}");
        // print("Matched face: ${match.imageName}");
        await matchFaceTeamreg(response.imageBase64!, id);
        if (ststus == "") {
          Get.back();
        } else {
          // Get.offAll(() => HomePageScreeen());
        }
      } else {
        "Face is not matched with sufficient similarity!"
            .showToast(duration: 10);
      }
    } else {
      "Face is not matched with sufficient similarity!".showToast(duration: 10);
    }
  }

  Future<void> matchFaceTeamreg(
    String imageData,
    String id,
  ) async {
    String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
    String? empId = await getEmpBasicDetailId();
    String? costCenterId = await getCostCenterId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";
      if (location!.isEmpty) {
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }

      Map<String, dynamic> data = {
        
        // "PunchId": id,
        // "LabourId": id,
        // "CostCenterId": costCenterId,
        // "TPartcicipationId": empId.toString(),
        // "Location": location,
        // "PunchImage": imageData,
        // "Latitude": lat,
        // "Longitude": long,
        // "UserId": id,
        // "MarkedByUserId": empId.toString()

        "PunchId": id,
        "EMP_BasicDetail_Id": empId,
        "Location": location,
        "PunchImage": imageData,
        "Latitude": lat,
        "Longitude": long,
        "UserId": id,
        "MarkedByUserId": empId,
        "CostCenterId": costCenterId,
        "TPartcicipationId": empId,
        "CompanyId": null,
        "ComBranchId": null,

        // "PunchId": null,
        // "EMP_BasicDetail_Id": id,
        // "Location": location,
        // "PunchImage": imageData,
        // "Latitude": lat,
        // "Longitude": long,
        // "UserId": id,
        // "MarkedByUserId": empId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          // String empBasicDetailId = frv['EMP_BasicDetail_Id']; 
          String fullName = frv['FullName'];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("EMP Basic Detail ID: $empBasicDetailId");
          // print("Full Name: $fullName");
          // print("Face Image: $faceImage");
          // print("Location: $location"); 

          PunchInModel model = PunchInModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            // Get.offAll(() => HomePageScreeen());
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $id");
          }
        } else {
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }
  }

  Future<void> updateFaceDataTeam(
      String imageData, String id, ) async {
    String url = "http://rapi.railtech.co.in/api/TeamFaceRegistration/update";
    String? empId = await getEmpBasicDetailId();
    try {
      Map<String, dynamic> data = {
        "FaceRegistrationId": "",
        "EMP_BasicDetail_Id": empId,
        "Location": location,
        "EMPId": null,
        "UserId": id,
        "FaceImage": imageData,
        "MarkedByUserId": empId
      };
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print("empId===${empId}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        RegisteredFaceResponseModel responseModel =
            RegisteredFaceResponseModel.fromJson(jsonResponse);
        if (responseModel.statusCode == 1) {
          for (var one in responseModel.fRV!) {
            MultiFaceInput faceInput = MultiFaceInput(
              imageName: one.fullName ?? "unknown",
              imageBase64: one.faceImage ?? "",
              empid: id,
              markUser: empId,
            );
            // print("faceInput${faceInput.imageName}");
            // print("jsonResponsettt${jsonResponse}");
          }

          "${jsonResponse["statusText"]}".showToast(duration: 10);
          // print("Results: ${responseModel.fRV}");
        } else {
          // print("Failed to update face: ${jsonResponse}");
        }
      } else {
        // print("Failed to update face: ${response.statusCode}");
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face update: $e");
      }
    }
  }

  Future<void> matchFaceDirect(List<String> ststus,String id) async {
    //  await Future.delayed(Duration(seconds: 5));
    final response = await faceLiveness.caputeFaceLiveness();
    if (response == null || !response.isLive || response.imageBase64 == null) {
      "Face is not matched".showToast();
      return;
    }

    print("kldfhgkdfj===${ststus}");
    final filteredFaces =allFaces.where((face) => face.imageBase64 == faceImag).toList();
    final filteredFacess  =allFaces.where((face) => face.imageBase64 == ststus).toList();
   
    final matchedFaces = await faceLiveness.matchMultiFaces(
      primaryBase64Img: response.imageBase64!,
      threshold: 0.75,
      multifaceInput: ststus == "" ? filteredFaces : filteredFacess,
      checkAll: false,
    );
    print("Matched Faces: ${matchedFaces}");
    if (matchedFaces.isNotEmpty) {
      final match = matchedFaces[0];
      if (match.similarity >= 0.75) {
        print("Length of matched faces: ${matchedFaces.length}");
        print("Matched face: ${match.imageName}");
        await matchFaceTeamDirect(response.imageBase64!,);
        if (ststus == "") {
          Get.back();
        } else {
          // Get.offAll(() => HomePageScreeen());
        }
      } else {
        "Face is not matched with sufficient similarity!".showToast(duration: 10);
      }
    } else {
      "Face is not matched with sufficient ==================similarity!".showToast(duration: 10);
    }
  }

  Future<void>  matchFaceTeamDirect(String imageData,) async {
    String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
    String? empId = await getEmpBasicDetailId();
    String? costCenterId = await getCostCenterId();

    try {
      Position position = await getCurrentLocation();
      String lat = "${position.latitude}";
      String long = "${position.longitude}";
      if (location!.isEmpty) {
        "Location not detected. Unable to punch in.".showToast(duration: 5);
        return;
      }

      Map<String, dynamic> data = {
        // "PunchId": id,
        // "LabourId": id,
        // "CostCenterId": costCenterId,
        // "TPartcicipationId": empId.toString(),
        // "Location": location,
        // "PunchImage": imageData,
        // "Latitude": lat,
        // "Longitude": long,
        // "UserId": id,
        // "MarkedByUserId": empId.toString()

        "PunchId": null,
        "EMP_BasicDetail_Id": null,
        "Location": location,
        "PunchImage": imageData,
        "Latitude": lat,
        "Longitude": long,
        "UserId": null,
        "MarkedByUserId": empId,
        "CostCenterId": costCenterId,
        "TPartcicipationId": empId,
        "CompanyId": null,
        "ComBranchId": null,

        // "PunchId": null,
        // "EMP_BasicDetail_Id": id,
        // "Location": location,
        // "PunchImage": imageData,
        // "Latitude": lat,
        // "Longitude": long,
        // "UserId": id,
        // "MarkedByUserId": empId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['StatusCode'] == 1 &&
            jsonResponse['FRV'] != null &&
            jsonResponse['FRV'].isNotEmpty) {
          final frv = jsonResponse['FRV'][0];
          // String empBasicDetailId = frv['EMP_BasicDetail_Id'];
          String fullName = frv['FullName'];
          String faceImage = frv['FaceImage'];
          String location = frv['Location'];

          // print("EMP Basic Detail ID: $empBasicDetailId");
          // print("Full Name: $fullName");
          // print("Face Image: $faceImage");
          // print("Location: $location");

          PunchInModel model = PunchInModel.fromJson(jsonResponse);
          if (model.statusCode == 1) {
            // Get.offAll(() => HomePageScreeen());
            "${model.statusText}".showToast(duration: 10);
          } else {
            // print("Please Re-register Your Face: $id");
          }
        } else {
          // print("Failed to match face: ${jsonResponse}");
          "${jsonResponse["statusText"]}".showToast(duration: 10);
        }
      } else {
        "Try Again".showToast(duration: 10);
      }
    } catch (e) {
      if (e is SocketException) {
        "$e".showToast(duration: 10);
      } else {
        // print("Error during face matching: $e");
      }
    }

  }



}
