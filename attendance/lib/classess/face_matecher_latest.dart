// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:faecauth/screens/home_page.dart';
// import 'package:faecauth/screens/model/punch_in_model.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:face_liveness/face_liveness.dart';
// import 'package:face_liveness/models/multi_face_input.dart';
// import 'package:faecauth/common/api_collections.dart';
// import 'package:faecauth/extension/string_ext.dart';
// import 'package:faecauth/screens/model/registered_face_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

// class FaceMatcher {
//   FaceMatcher._();

//   static final FaceMatcher _instance = FaceMatcher._();

//   static FaceMatcher get instance => _instance;

//   FaceLiveness faceLiveness = FaceLiveness();

//   Future<void> init() async {
//     await faceLiveness.initAnalyzer();
//   }

//   Future<String?> getEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }

//   Future<String?> getTeamEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('team_empId');
//   }

//   Future<String?> getTeamEmpName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('team_empName');
//   }

//   Future<String?> getEmpName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empName');
//   }

//   Future<void> registerFace(String? id, String? name) async {
//     String? empId = await getEmpBasicDetailId();
//     if (empId == null) {
//       "EMP_BasicDetail_Id not found".showToast();
//       return;
//     }

//     try {
//       MultiFaceInput? faceData = await addFace(id!, name);
//       if (faceData != null) {
//         await faceregisterapi(faceData.imageBase64, id);
//       } else {
//         print("Face is not matched");
//       }
//     } catch (e) {
//       print("Error in registerFace: $e");
//     }
//   }

//   Future<void> faceregisterapi(String imageData, String id) async {
//     String url = ApiUrls.faceregister;
//     String? empId = await getEmpBasicDetailId();
//     Map<String, dynamic> data = {
//       "FaceRegistrationId": "",
//       "EMP_BasicDetail_Id": id,
//       "Location": location,
//       "EMPKey": "",
//       "UserId": empId,
//       "FaceImage": imageData,
//       "MarkedByUserId": empId
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         RegisteredFaceResponseModel responseModel =
//             RegisteredFaceResponseModel.fromJson(jsonResponse);

//         if (responseModel.statusCode == 1 &&
//             responseModel.fRV != null &&
//             responseModel.fRV!.isNotEmpty) {
//           FRV frv = responseModel.fRV!.first;
//           MultiFaceInput faceInput = MultiFaceInput(
//               imageName: frv.fullName ?? "unknown",
//               imageBase64: frv.faceImage ?? "",
//               empid: id,
//               markUser: empId);

//           allFaces.add(faceInput);
//           print("Face added: ${responseModel.statusCode}");
//           print("Total faces registered: ${allFaces.length}");
//         } else {
//           print("Failed to match face: ${jsonResponse}");
//         }

//         Get.offAll(() => HomePageScreeen());
//         "${responseModel.statusText}".showToast(duration: 10);
//         print("Results: ${responseModel.fRV}");
//       } else {
//         print("Failed to register face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         "No Internet Connection".showToast(duration: 10);
//       } else {
//         print("Error during face registration: $e");
//       }
//     }
//   }

//   Future<MultiFaceInput?> addFace(String id, String? name) async {
//     String? empId = await getEmpBasicDetailId();

//     try {
//       final response = await faceLiveness.caputeFaceLiveness();

//       if (response != null && response.isLive && response.imageBase64 != null) {
//         MultiFaceInput data = MultiFaceInput(
//           imageName: name ?? "unknown",
//           imageBase64: response.imageBase64!,
//           empid: id,
//           markUser: empId,
//         );
//         final imagePath = await saveImageToLocalDirectory(
//             response.imageBase64!, name ?? "unknown", id, empId ?? "unknown");
//         print("Image and metadata saved at: $imagePath");

//         allFaces.add(data);
//         print("Added face: ${data.imageName}, total faces: ${data.empid}");
//         return data;
//       } else {
//         print("Face capture failed or face not live.");
//       }
//     } catch (e) {
//       print("Error in addFace: $e");
//     }
//     return null;
//   }

//   Future<String> saveImageToLocalDirectory(String base64Image, String imageName,
//       String id, String markedByUserId) async {
//     Uint8List imageBytes = base64Decode(base64Image);
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = '${directory.path}/$imageName.jpg';
//     final metadataPath = '${directory.path}/$imageName.json';
//     final imageFile = File(imagePath);
//     await imageFile.writeAsBytes(imageBytes);
//     final metadataFile = File(metadataPath);
//     final metadata = {
//       'name': imageName,
//       'id': id,
//       'markedByUserId': markedByUserId,
//       'imagePath': imagePath
//     };
//     await metadataFile.writeAsString(jsonEncode(metadata));

//     return imagePath;
//   }

//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<List<MultiFaceInput>> getSavedFacesFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? savedFaces = prefs.getStringList('saved_faces');

//     if (savedFaces == null || savedFaces.isEmpty) {
//       print("No faces found in SharedPreferences.");
//       return [];
//     }

//     List<MultiFaceInput> faces = savedFaces
//         .map((jsonString) => MultiFaceInput.fromJson(jsonDecode(jsonString)))
//         .toList();

//     print("Loaded ${faces.length} faces from SharedPreferences.");
//     return faces;
//   }

//   Future<void> matchFace(String id) async {
//     final response = await faceLiveness.caputeFaceLiveness();

//     if (response == null || !response.isLive || response.imageBase64 == null) {
//       "Face is not matched".showToast();
//       return;
//     }

//     List<MultiFaceInput> savedFaces =
//         await getSavedFacesFromSharedPreferences();

//     if (savedFaces.isEmpty) {
//       "No registered face found".showToast(duration: 10);
//       return;
//     }

//     print("Attempting to match face...");
//     final matchedFaces = await faceLiveness.matchMultiFaces(
//       primaryBase64Img: response.imageBase64!,
//       threshold: 0.7,
//       multifaceInput: savedFaces,
//       checkAll: false,
//     );

//     print("Matched Faces: ${matchedFaces}");

//     if (matchedFaces.isNotEmpty) {
//       final match = matchedFaces[0];
//       if (match.similarity >= 0.70) {
//         print("Length of matched faces: ${matchedFaces.length}");
//         print("Matched face: ${match.imageName}");
//         await matchRegisteredFace(response.imageBase64!, id);
//       } else {
//         "Face is not matched with sufficient similarity!"
//             .showToast(duration: 10);
//         print("No match found with sufficient similarity.");
//       }
//     } else {
//       "Face is not matched with sufficient similarity!".showToast(duration: 10);
//     }
//   }

//   Future<void> matchRegisteredFace(String imageData, String id) async {
//     String? empId = await getEmpBasicDetailId();
//     String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";

//     try {
//       Position? position = await getCurrentLocation();
//       if (position == false) {
//         print('Failed to get current location');
//         return;
//       }

//       String lat = "${position.latitude}";
//       String long = "${position.longitude}";

//       Map<String, dynamic> data = {
//         "PunchId": "",
//         "EMP_BasicDetail_Id": id,
//         "Location": location,
//         "EMPKey": "",
//         "UserId": empId,
//         "FaceImage": imageData,
//         "MarkedByUserId": empId,
//         "Latitude": lat,
//         "Longitude": long
//       };

//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         PunchInModel punchInModel = PunchInModel.fromJson(jsonResponse);

//         if (punchInModel.statusCode == 1) {
//           print("Punch in successful: ${punchInModel.statusText}");
//         } else {
//           print("Punch in failed: ${punchInModel.statusText}");
//         }
//       } else {
//         print("Failed to punch in: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error during punch in: $e");
//     }
//   }
// }

//-=-=-=-=-=-=-=--03/08/24=-=-=-=-=---=-==///

// import 'dart:convert';
// import 'dart:io';
// import 'package:face_liveness/models/multi_face_input.dart';
// import 'package:faecauth/common/api_collections.dart';
// import 'package:faecauth/extension/string_ext.dart';
// import 'package:faecauth/screens/home_page.dart';
// import 'package:faecauth/screens/model/punch_in_model.dart';
// import 'package:faecauth/screens/model/registered_face_model.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:face_liveness/face_liveness.dart';

// class FaceMatcher {
//   FaceMatcher._();

//   static final FaceMatcher _instance = FaceMatcher._();

//   static FaceMatcher get instance => _instance;

//   FaceLiveness faceLiveness = FaceLiveness();

//   Future<void> init() async {
//     await faceLiveness.initAnalyzer();
//   }

//   Future<String?> getEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }

//   // Future<void> registerFace(String? id, String? name) async {
//   //   String? empId = await getEmpBasicDetailId();
//   //   if (empId == null) {
//   //     "EMP_BasicDetail_Id not found".showToast();
//   //     return;
//   //   }

//   //   try {
//   //     MultiFaceInput? faceData = await addFace(id!, name);
//   //     if (faceData != null) {
//   //       await faceregisterapi(faceData.imageBase64, id);
//   //       await saveFaceDataToPreferences(faceData);
//   //     } else {
//   //       print("Face is not matched");
//   //     }
//   //   } catch (e) {
//   //     print("Error in registerFace: $e");
//   //   }
//   // }

//   Future<void> registerFace(String? id, String name, String img) async {
//     String? empId = await getEmpBasicDetailId();
//     if (empId == null) {
//       "EMP_BasicDetail_Id not found".showToast();
//       return;
//     }

//     try {
//       MultiFaceInput? faceData = await addFace(id!, name);
//       if (faceData != null) {
//         if (img.isNotEmpty &&
//             img != "" &&
//             img != "https://rapi.railtech.co.in/") {
//           await updateFaceData(faceData.imageBase64, id);
//         } else {
//           await faceregisterapi(faceData.imageBase64, id);
//           await saveFaceDataToPreferences(faceData);
//         }
//       } else {
//         print("Face is not matched");
//       }
//     } catch (e) {
//       print("Error in registerFace: $e");
//     }

//     // try {
//     //   MultiFaceInput? faceData = await addFace(id!, name);
//     //   //   if (faceData != null) {
//     //   //     await faceregisterapi(faceData.imageBase64, id);
//     //   //     await saveFaceDataToPreferences(faceData);
//     //   //   } else {
//     //   //     print("Face is not matched");
//     //   //   }
//     //   // } catch (e) {
//     //   //   print("Error in registerFace: $e");
//     //   // }
//     //   if (faceData != null) {
//     //     if (await isFaceRegistered(id)) {
//     //      await updateFaceData(faceData.imageBase64, id);
//     //     } else {
//     //       await faceregisterapi(faceData.imageBase64, id);
//     //     }
//     //     await saveFaceDataToPreferences(faceData);
//     //   } else {
//     //     print("Face is not matched");
//     //   }
//     // } catch (e) {
//     //   print("Error in registerFace: $e");
//     // }
//   }

//   Future<bool> isFaceRegistered(String id) async {
//     return allFaces.any((face) => face.empid == id);
//   }

//   Future<void> saveFaceDataToPreferences(MultiFaceInput data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> savedFaces = prefs.getStringList('saved_faces') ?? [];
//     String jsonData = jsonEncode(data.toJson());
//     savedFaces.removeWhere((face) {
//       MultiFaceInput savedFace = MultiFaceInput.fromJson(jsonDecode(face));
//       return savedFace.empid == data.empid;
//     });
//     savedFaces.add(jsonData);
//     await prefs.setStringList('saved_faces', savedFaces);
//   }

//   Future<void> updateFaceData(String imageData, String id) async {
//     String url = "http://rapi.railtech.co.in/api/FaceRegistration/update";
//     String? empId = await getEmpBasicDetailId();

//     try {
//       Map<String, dynamic> data = {
//         "FaceRegistrationId": "",
//         "EMP_BasicDetail_Id": id,
//         "Location": location,
//         "EMPKey": "",
//         "UserId": empId,
//         "FaceImage": imageData,
//         "MarkedByUserId": empId
//       };
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         RegisteredFaceResponseModel responseModel =
//             RegisteredFaceResponseModel.fromJson(jsonResponse);

//         if (responseModel.statusCode == 1 &&
//             responseModel.fRV != null &&
//             responseModel.fRV!.isNotEmpty) {
//           FRV frv = responseModel.fRV!.first;
//           MultiFaceInput faceInput = MultiFaceInput(
//             imageName: frv.fullName ?? "unknown",
//             imageBase64: frv.faceImage ?? "",
//             empid: id,
//             markUser: empId,
//           );
//           allFaces.removeWhere((face) => face.empid == id);
//           allFaces.add(faceInput);

//           print("Face updated: ${responseModel.statusCode}");
//           print("Total faces registered: ${allFaces.length}");
//         } else {
//           print("Failed to update face: ${jsonResponse}");
//         }

//         Get.offAll(() => HomePageScreeen());
//         "${responseModel.statusText}".showToast(duration: 10);
//         print("Results: ${responseModel.fRV}");
//       } else {
//         print("Failed to update face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         "No Internet Connection".showToast(duration: 10);
//       } else {
//         print("Error during face update: $e");
//       }
//     }
//   }

//   Future<void> faceregisterapi(String imageData, String id) async {
//     String url = ApiUrls.faceregister;
//     String? empId = await getEmpBasicDetailId();
//     Map<String, dynamic> data = {
//       "FaceRegistrationId": "",
//       "EMP_BasicDetail_Id": id,
//       "Location": location,
//       "EMPKey": "",
//       "UserId": empId,
//       "FaceImage": imageData,
//       "MarkedByUserId": empId
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         RegisteredFaceResponseModel responseModel =
//             RegisteredFaceResponseModel.fromJson(jsonResponse);

//         if (responseModel.statusCode == 1 &&
//             responseModel.fRV != null &&
//             responseModel.fRV!.isNotEmpty) {
//           FRV frv = responseModel.fRV!.first;
//           MultiFaceInput faceInput = MultiFaceInput(
//             imageName: frv.fullName ?? "unknown",
//             imageBase64: frv.faceImage ?? "",
//             empid: id,
//             markUser: empId,
//           );

//           allFaces.add(faceInput);
//           print("Face added: ${responseModel.statusCode}");
//           print("Total faces registered: ${allFaces.length}");
//         } else {
//           print("Failed to match face: ${jsonResponse}");
//         }
//         Get.offAll(() => HomePageScreeen());

//         "${responseModel.statusText}".showToast(duration: 10);
//         print("Results: ${responseModel.fRV}");
//       } else {
//         print("Failed to register face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         // final database = await DatabaseHelper().database;
//         // final registrationDao = RegistrationDao(database);
//         // await registrationDao
//         //     .insertRegistration(Registration(0, empId.toString(), imageData));
//         "Face registered Done (Offline)".showToast(duration: 10);
//       } else {
//         print("Error during face registration: $e");
//       }
//     }
//   }

//   Future<MultiFaceInput?> addFace(String id, String? name) async {
//     String? empId = await getEmpBasicDetailId();

//     try {
//       final response = await faceLiveness.caputeFaceLiveness();

//       if (response != null && response.isLive && response.imageBase64 != null) {
//         MultiFaceInput data = MultiFaceInput(
//           imageName: name ?? "unknown",
//           imageBase64: response.imageBase64!,
//           empid: id,
//           markUser: empId,
//         );
//         allFaces.add(data);
//         await saveFaceDataToPreferences(data);
//         Get.offAll(() => HomePageScreeen());
//         print("Added face: ${data.imageName}, total faces: ${data.empid}");
//         return data;
//       }
//     } catch (e) {
//       print("Error in addFace: $e");
//     }

//     return null;
//   }

//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<List<MultiFaceInput>> getSavedFacesFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? savedFaces = prefs.getStringList('saved_faces');

//     if (savedFaces == null || savedFaces.isEmpty) {
//       return [];
//     }

//     return savedFaces
//         .map((jsonString) => MultiFaceInput.fromJson(jsonDecode(jsonString)))
//         .toList();
//   }

//   Future<void> matchFace(String id) async {
//     final response = await faceLiveness.caputeFaceLiveness();

//     if (response == null || !response.isLive || response.imageBase64 == null) {
//       "Face is not matched".showToast();
//       return;
//     }

//     List<MultiFaceInput> savedFaces =
//         await getSavedFacesFromSharedPreferences();
//     final filteredFaces = savedFaces.where((face) => face.empid == id).toList();

//     if (filteredFaces.isEmpty) {
//       "Please Re-register Your face".showToast(duration: 10);
//       return;
//     }

//     final matchedFaces = await faceLiveness.matchMultiFaces(
//       primaryBase64Img: response.imageBase64!,
//       threshold: 0.7,
//       multifaceInput: filteredFaces,
//       checkAll: false,
//     );

//     print("Matched Faces: ${matchedFaces}");

//     if (matchedFaces.isNotEmpty) {
//       final match = matchedFaces[0];
//       if (match.similarity >= 0.70) {
//         print("Length of matched faces: ${matchedFaces.length}");
//         print("Matched face: ${match.imageName}");
//         await matchRegisteredFace(response.imageBase64!, id);
//         Get.offAll(() => HomePageScreeen());
//       } else {
//         "Face is not matched with sufficient similarity!"
//             .showToast(duration: 10);
//         print("No match found with sufficient similarity.");
//       }
//     } else {
//       "Face is not matched with sufficient similarity!".showToast(duration: 10);
//     }
//   }

// // Future<void> saveAttendanceDataOffline(
// //     DailyAttendanceReportModel reportModel) async {
// //   final database =
// //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();
// //   final epreDao = database.epreDao;

// //   for (var epre in reportModel.ePRE!) {
// //     await epreDao.insertEPRE(epre);
// //   }
// //   print("Data saved locally");
// // }

//   Future<void> matchRegisteredFace(String imageData, String id) async {
//     String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
//     String? empId = await getEmpBasicDetailId();

//     try {
//       Position position = await getCurrentLocation();
//       String lat = "${position.latitude}";
//       String long = "${position.longitude}";
//       Map<String, dynamic> data = {
//         "PunchId": null,
//         "EMP_BasicDetail_Id": id,
//         "Location": location,
//         "PunchImage": imageData,
//         "Latitude": lat,
//         "Longitude": long,
//         "UserId": empId,
//         "MarkedByUserId": empId,
//       };

//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         if (jsonResponse['StatusCode'] == 1 &&
//             jsonResponse['FRV'] != null &&
//             jsonResponse['FRV'].isNotEmpty) {
//           final frv = jsonResponse['FRV'][0];
//           String empBasicDetailId = frv['EMP_BasicDetail_Id'];
//           String fullName = frv['FullName'];
//           String faceImage = frv['FaceImage'];
//           String location = frv['Location'];

//           print("EMP Basic Detail ID: $empBasicDetailId");
//           print("Full Name: $fullName");
//           print("Face Image: $faceImage");
//           print("Location: $location");

//           PunchInModel model = PunchInModel.fromJson(jsonResponse);
//           if (model.statusCode == 1) {
//             Get.offAll(() => HomePageScreeen());
//             "${model.statusText}".showToast(duration: 10);
//           } else {
//             print("Please Re-register Your Face: $id");
//           }
//         } else {
//           print("Failed to match face: ${jsonResponse}");
//           "${jsonResponse["statusText"]}".showToast(duration: 10);
//         }
//       } else {
//         print("Failed to match face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         // DailyAttendanceReportModel reportModel = DailyAttendanceReportModel(
//         //   statusCode: 1,
//         //   status: "Offline",
//         //   statusText: "No Internet Connection",
//         //   ePRE: [
//         //     EPRE(
//         //       punchId: null,
//         //       eMPBasicDetailId: id,
//         //       eMPKey: empId,
//         //       fullName: "Unknown",
//         //       punchDate: DateTime.now().toString(),
//         //       firstPunchTime: DateTime.now().toString(),
//         //       lastPunchTime: DateTime.now().toString(),
//         //       firstLocation: "",
//         //       lastLocation: "",
//         //       firstImage: imageData,
//         //       lastImage: imageData,
//         //       attStatus: "Offline",
//         //     ),
//         //   ],
//         // );
//         // await saveAttendanceDataOffline(reportModel);
//         // "No Internet Connection. Data saved locally.".showToast(duration: 10);
//       } else {
//         print("Error during face matching: $e");
//       }
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:face_liveness/models/multi_face_input.dart';
// import 'package:faecauth/common/api_collections.dart';
// import 'package:faecauth/extension/string_ext.dart';
// import 'package:faecauth/screens/home_page.dart';
// import 'package:faecauth/screens/model/punch_in_model.dart';
// import 'package:faecauth/screens/model/registered_face_model.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:face_liveness/face_liveness.dart';

// class FaceMatcher {
//   FaceMatcher._();

//   static final FaceMatcher _instance = FaceMatcher._();

//   static FaceMatcher get instance => _instance;

//   FaceLiveness faceLiveness = FaceLiveness();

//   Future<void> init() async {
//     await faceLiveness.initAnalyzer();
//   }

//   Future<String?> getEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }

//   // Future<void> registerFace(String? id, String? name) async {
//   //   String? empId = await getEmpBasicDetailId();
//   //   if (empId == null) {
//   //     "EMP_BasicDetail_Id not found".showToast();
//   //     return;
//   //   }

//   //   try {
//   //     MultiFaceInput? faceData = await addFace(id!, name);
//   //     if (faceData != null) {
//   //       await faceregisterapi(faceData.imageBase64, id);
//   //       await saveFaceDataToPreferences(faceData);
//   //     } else {
//   //       print("Face is not matched");
//   //     }
//   //   } catch (e) {
//   //     print("Error in registerFace: $e");
//   //   }
//   // }

//   Future<void> registerFace(String? id, String name, String img) async {
//     String? empId = await getEmpBasicDetailId();
//     if (empId == null) {
//       "EMP_BasicDetail_Id not found".showToast();
//       return;
//     }

//     try {
//       MultiFaceInput? faceData = await addFace(id!, name);
//       if (faceData != null) {
//         if (img.isNotEmpty &&
//             img != "" &&
//             img != "https://rapi.railtech.co.in/") {
//           await updateFaceData(faceData.imageBase64, id);
//         } else {
//           await faceregisterapi(faceData.imageBase64, id);
//           await saveFaceDataToPreferences(faceData);
//         }
//       } else {
//         print("Face is not matched");
//       }
//     } catch (e) {
//       print("Error in registerFace: $e");
//     }

//     // try {
//     //   MultiFaceInput? faceData = await addFace(id!, name);
//     //   //   if (faceData != null) {
//     //   //     await faceregisterapi(faceData.imageBase64, id);
//     //   //     await saveFaceDataToPreferences(faceData);
//     //   //   } else {
//     //   //     print("Face is not matched");
//     //   //   }
//     //   // } catch (e) {
//     //   //   print("Error in registerFace: $e");
//     //   // }
//     //   if (faceData != null) {
//     //     if (await isFaceRegistered(id)) {
//     //      await updateFaceData(faceData.imageBase64, id);
//     //     } else {
//     //       await faceregisterapi(faceData.imageBase64, id);
//     //     }
//     //     await saveFaceDataToPreferences(faceData);
//     //   } else {
//     //     print("Face is not matched");
//     //   }
//     // } catch (e) {
//     //   print("Error in registerFace: $e");
//     // }
//   }

//   Future<bool> isFaceRegistered(String id) async {
//     return allFaces.any((face) => face.empid == id);
//   }

//   Future<void> saveFaceDataToPreferences(MultiFaceInput data) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> savedFaces = prefs.getStringList('saved_faces') ?? [];
//     String jsonData = jsonEncode(data.toJson());
//     savedFaces.removeWhere((face) {
//       MultiFaceInput savedFace = MultiFaceInput.fromJson(jsonDecode(face));
//       return savedFace.empid == data.empid;
//     });
//     savedFaces.add(jsonData);
//     await prefs.setStringList('saved_faces', savedFaces);
//   }

//   Future<void> updateFaceData(String imageData, String id) async {
//     String url = "http://rapi.railtech.co.in/api/FaceRegistration/update";
//     String? empId = await getEmpBasicDetailId();

//     try {
//       Map<String, dynamic> data = {
//         "FaceRegistrationId": "",
//         "EMP_BasicDetail_Id": id,
//         "Location": location,
//         "EMPKey": "",
//         "UserId": empId,
//         "FaceImage": imageData,
//         "MarkedByUserId": empId
//       };
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         RegisteredFaceResponseModel responseModel =
//             RegisteredFaceResponseModel.fromJson(jsonResponse);

//         if (responseModel.statusCode == 1 &&
//             responseModel.fRV != null &&
//             responseModel.fRV!.isNotEmpty) {
//           FRV frv = responseModel.fRV!.first;
//           MultiFaceInput faceInput = MultiFaceInput(
//             imageName: frv.fullName ?? "unknown",
//             imageBase64: frv.faceImage ?? "",
//             empid: id,
//             markUser: empId,
//           );
//           allFaces.removeWhere((face) => face.empid == id);
//           allFaces.add(faceInput);

//           print("Face updated: ${responseModel.statusCode}");
//           print("Total faces registered: ${allFaces.length}");
//         } else {
//           print("Failed to update face: ${jsonResponse}");
//         }

//         Get.offAll(() => HomePageScreeen());
//         "${responseModel.statusText}".showToast(duration: 10);
//         print("Results: ${responseModel.fRV}");
//       } else {
//         print("Failed to update face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         "No Internet Connection".showToast(duration: 10);
//       } else {
//         print("Error during face update: $e");
//       }
//     }
//   }

//   Future<void> faceregisterapi(String imageData, String id) async {
//     String url = ApiUrls.faceregister;
//     String? empId = await getEmpBasicDetailId();
//     Map<String, dynamic> data = {
//       "FaceRegistrationId": "",
//       "EMP_BasicDetail_Id": id,
//       "Location": location,
//       "EMPKey": "",
//       "UserId": empId,
//       "FaceImage": imageData,
//       "MarkedByUserId": empId
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         RegisteredFaceResponseModel responseModel =
//             RegisteredFaceResponseModel.fromJson(jsonResponse);

//         if (responseModel.statusCode == 1 &&
//             responseModel.fRV != null &&
//             responseModel.fRV!.isNotEmpty) {
//           FRV frv = responseModel.fRV!.first;
//           MultiFaceInput faceInput = MultiFaceInput(
//             imageName: frv.fullName ?? "unknown",
//             imageBase64: frv.faceImage ?? "",
//             empid: id,
//             markUser: empId,
//           );

//           allFaces.add(faceInput);
//           print("Face added: ${responseModel.statusCode}");
//           print("Total faces registered: ${allFaces.length}");
//         } else {
//           print("Failed to match face: ${jsonResponse}");
//         }
//         Get.offAll(() => HomePageScreeen());

//         "${responseModel.statusText}".showToast(duration: 10);
//         print("Results: ${responseModel.fRV}");
//       } else {
//         print("Failed to register face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         // final database = await DatabaseHelper().database;
//         // final registrationDao = RegistrationDao(database);
//         // await registrationDao
//         //     .insertRegistration(Registration(0, empId.toString(), imageData));
//         "Face registered Done (Offline)".showToast(duration: 10);
//       } else {
//         print("Error during face registration: $e");
//       }
//     }
//   }

//   Future<MultiFaceInput?> addFace(String id, String? name) async {
//     String? empId = await getEmpBasicDetailId();

//     try {
//       final response = await faceLiveness.caputeFaceLiveness();

//       if (response != null && response.isLive && response.imageBase64 != null) {
//         MultiFaceInput data = MultiFaceInput(
//           imageName: name ?? "unknown",
//           imageBase64: response.imageBase64!,
//           empid: id,
//           markUser: empId,
//         );
//         allFaces.add(data);
//         await saveFaceDataToPreferences(data);
//         Get.offAll(() => HomePageScreeen());
//         print("Added face: ${data.imageName}, total faces: ${data.empid}");
//         return data;
//       }
//     } catch (e) {
//       print("Error in addFace: $e");
//     }

//     return null;
//   }

//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<List<MultiFaceInput>> getSavedFacesFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? savedFaces = prefs.getStringList('saved_faces');

//     if (savedFaces == null || savedFaces.isEmpty) {
//       return [];
//     }

//     return savedFaces
//         .map((jsonString) => MultiFaceInput.fromJson(jsonDecode(jsonString)))
//         .toList();
//   }

//   Future<void> matchFace(String id) async {
//     final response = await faceLiveness.caputeFaceLiveness();

//     if (response == null || !response.isLive || response.imageBase64 == null) {
//       "Face is not matched".showToast();
//       return;
//     }

//     // Fetch registered faces from API
//     final registeredFacesResponse = await fetchRegisteredFaces();

//     if (registeredFacesResponse == null ||
//         registeredFacesResponse.fRV == null) {
//       "Please Re-register Your face".showToast(duration: 10);
//       return;
//     }

//     // Filter faces by employee ID
//     final filteredFaces = registeredFacesResponse.fRV!
//         .where((face) => face.eMPBasicDetailId == id)
//         .toList();

//     if (filteredFaces.isEmpty) {
//       "Please Re-register Your face".showToast(duration: 10);
//       return;
//     }

//     // Convert filtered faces to MultiFaceInput list
//     List<MultiFaceInput> multiFaceInputs = filteredFaces.map((face) {
//       return MultiFaceInput(
//         empid: face.eMPBasicDetailId!,
//         imageBase64: face.faceImage!,
//         imageName: face.fullName!,
//       );
//     }).toList();

//     final matchedFaces = await faceLiveness.matchMultiFaces(
//       primaryBase64Img: response.imageBase64!,
//       threshold: 0.7,
//       multifaceInput: multiFaceInputs,
//       checkAll: false,
//     );

//     print("Matched Faces: ${matchedFaces}");

//     if (matchedFaces.isNotEmpty) {
//       final match = matchedFaces[0];
//       if (match.similarity >= 0.70) {
//         print("Length of matched faces: ${matchedFaces.length}");
//         print("Matched face: ${match.imageName}");
//         await matchRegisteredFace(response.imageBase64!, id);
//         Get.offAll(() => HomePageScreeen());
//       } else {
//         "Face is not matched with sufficient similarity!"
//             .showToast(duration: 10);
//         print("No match found with sufficient similarity.");
//       }
//     } else {
//       "Face is not matched with sufficient similarity!".showToast(duration: 10);
//     }
//   }

//   Future<RegisteredFaceResponseModel?> fetchRegisteredFaces() async {
//     final response = await http.post(
//       Uri.parse('http://rapi.railtech.co.in/api/FaceRegistration/get'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "FaceRegistrationId": "",
//         "EMP_BasicDetail_Id": "75",
//         "FullName": "",
//         "EMPKey": "",
//         "FaceImage": null,
//         "Location": "",
//         "Status": "",
//         "MarkedByUserId": "75"
//       }),
//     );

//     if (response.statusCode == 200) {
//       return RegisteredFaceResponseModel.fromJson(jsonDecode(response.body));
//     } else {
//       print('Failed to load registered faces');
//       return null;
//     }
//   }

// // Future<void> saveAttendanceDataOffline(
// //     DailyAttendanceReportModel reportModel) async {
// //   final database =
// //       await $FloorAppDatabase.databaseBuilder('app_database.db').build();
// //   final epreDao = database.epreDao;
// //   for (var epre in reportModel.ePRE!) {
// //     await epreDao.insertEPRE(epre);
// //   }
// //   print("Data saved locally");
// // }

//   Future<void> matchRegisteredFace(String imageData, String id) async {
//     String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
//     String? empId = await getEmpBasicDetailId();

//     try {
//       Position position = await getCurrentLocation();
//       String lat = "${position.latitude}";
//       String long = "${position.longitude}";
//       Map<String, dynamic> data = {
//         "PunchId": null,
//         "EMP_BasicDetail_Id": id,
//         "Location": location,
//         "PunchImage": imageData,
//         "Latitude": lat,
//         "Longitude": long,
//         "UserId": empId,
//         "MarkedByUserId": empId,
//       };

//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         if (jsonResponse['StatusCode'] == 1 &&
//             jsonResponse['FRV'] != null &&
//             jsonResponse['FRV'].isNotEmpty) {
//           final frv = jsonResponse['FRV'][0];
//           String empBasicDetailId = frv['EMP_BasicDetail_Id'];
//           String fullName = frv['FullName'];
//           String faceImage = frv['FaceImage'];
//           String location = frv['Location'];

//           print("EMP Basic Detail ID: $empBasicDetailId");
//           print("Full Name: $fullName");
//           print("Face Image: $faceImage");
//           print("Location: $location");

//           PunchInModel model = PunchInModel.fromJson(jsonResponse);
//           if (model.statusCode == 1) {
//             Get.offAll(() => HomePageScreeen());
//             "${model.statusText}".showToast(duration: 10);
//           } else {
//             print("Please Re-register Your Face: $id");
//           }
//         } else {
//           print("Failed to match face: ${jsonResponse}");
//           "${jsonResponse["statusText"]}".showToast(duration: 10);
//         }
//       } else {
//         print("Failed to match face: ${response.statusCode}");
//       }
//     } catch (e) {
//       if (e is SocketException) {
//         // DailyAttendanceReportModel reportModel = DailyAttendanceReportModel(
//         //   statusCode: 1,
//         //   status: "Offline",
//         //   statusText: "No Internet Connection",
//         //   ePRE: [
//         //     EPRE(
//         //       punchId: null,
//         //       eMPBasicDetailId: id,
//         //       eMPKey: empId,
//         //       fullName: "Unknown",
//         //       punchDate: DateTime.now().toString(),
//         //       firstPunchTime: DateTime.now().toString(),
//         //       lastPunchTime: DateTime.now().toString(),
//         //       firstLocation: "",
//         //       lastLocation: "",
//         //       firstImage: imageData,
//         //       lastImage: imageData,
//         //       attStatus: "Offline",
//         //     ),
//         //   ],
//         // );
//         // await saveAttendanceDataOffline(reportModel);
//         // "No Internet Connection. Data saved locally.".showToast(duration: 10);
//       } else {
//         print("Error during face matching: $e");
//       }
//     }
//   }
// }
