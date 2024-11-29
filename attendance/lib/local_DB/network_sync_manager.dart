// import 'dart:io';
// import 'package:faecauth/local_DB/models/attendance_entity.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:workmanager/workmanager.dart';

// class NetworkSyncManager {
//   // final DatabaseHelper _databaseHelper = DatabaseHelper();

//   // Future<void> syncPunchIns() async {
//   //   final db = await _databaseHelper.database;
//   //   final punchInDao = PunchInDao(db);
//   //   try {
//   //     List<PunchIn> punchIns = await punchInDao.getAllPunchIns();

//   //     for (PunchIn punchIn in punchIns) {
//   //       await syncPunchIn(punchIn);
//   //     }
//   //     await punchInDao.deleteAllPunchIns();
//   //     "All pending Punch In have been synced".showToast();
//   //   } catch (e) {
//   //     if (e is SocketException) {
//   //       "No internet connection ".showToast();
//   //     } else {
//   //       print("Error during syncing: $e");
//   //     }
//   //   }
//   // }

//   // Future<void> syncPunchIn(PunchIn punchIn) async {
//   //   String url = ApiUrls.punchInapi;

//   //   Map<String, dynamic> data = {
//   //     "PunchId": null,
//   //     "EMP_BasicDetail_Id": punchIn.empId,
//   //     "Location": "Lucknow",
//   //     "PunchImage": punchIn.punchImage,
//   //     "Latitude": punchIn.latitude,
//   //     "Longitude": punchIn.longitude,
//   //     "UserId": punchIn.empId
//   //   };

//   //   final response = await http.post(
//   //     Uri.parse(url),
//   //     headers: <String, String>{
//   //       'Content-Type': 'application/json; charset=UTF-8',
//   //     },
//   //     body: jsonEncode(data),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final jsonResponse = jsonDecode(response.body);
//   //     PunchInModel model = PunchInModel.fromJson(jsonResponse);
//   //     if (model.statusCode == 1) {
//   //     } else {
//   //       print("Failed to sync punch-in for EMP ID: ${punchIn.empId}");
//   //     }
//   //   } else {
//   //     print("Failed to sync punch-in: ${response.statusCode}");
//   //   }
//   // }

//   Future<void> syncAttendanceData() async {
//     final database =
//         await $FloorAppDatabase.databaseBuilder('app_database.db').build();
//     final epreDao = database.epreDao;

//     List<EPRE> offlineData = await epreDao.getAllEPRE();

//     if (offlineData.isEmpty) {
//       print("No offline data to sync");
//       return;
//     }

//     String url = "http://rapi.railtech.co.in/api/TeamEMPPunch/Add";
//     for (var epre in offlineData) {
//       Map<String, dynamic> data = epre.toJson();
//       try {
//         final response = await http.post(
//           Uri.parse(url),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: jsonEncode(data),
//         );

//         if (response.statusCode == 200) {
//           final jsonResponse = jsonDecode(response.body);
//           if (jsonResponse['StatusCode'] == 1) {
//             print("Data synced successfully: ${epre.punchId}");
//             await epreDao.deleteEPRE(epre);
//           } else {
//             print("Failed to sync data: ${jsonResponse["statusText"]}");
//           }
//         } else {
//           print("Failed to sync data: ${response.statusCode}");
//         }
//       } catch (e) {
//         if (e is SocketException) {
//           print("No internet connection, data not synced: ${e.toString()}");
//           return;
//         } else {
//           print("Error during data syncing: $e");
//         }
//       }
//     }
//   }

//   void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//       await syncAttendanceData();
//       return Future.value(true);
//     });
//   }
// }
