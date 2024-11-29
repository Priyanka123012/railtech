// import 'dart:async';

// import 'package:floor/floor.dart';
// import 'package:sqflite/sqflite.dart' as sqflite;
// part 'attendance_entity.g.dart';

// @Entity(tableName: 'epre')
// class DailyAttendanceReportModel {
//   int? statusCode;
//   String? status;
//   String? statusText;
//   List<EPRE>? ePRE;

//   DailyAttendanceReportModel(
//       {this.statusCode, this.status, this.statusText, this.ePRE});

//   DailyAttendanceReportModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['StatusCode'];
//     status = json['status'];
//     statusText = json['statusText'];
//     if (json['EPRE'] != null) {
//       ePRE = <EPRE>[];
//       json['EPRE'].forEach((v) {
//         ePRE!.add(new EPRE.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['StatusCode'] = this.statusCode;
//     data['status'] = this.status;
//     data['statusText'] = this.statusText;
//     if (this.ePRE != null) {
//       data['EPRE'] = this.ePRE!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class EPRE {
//   @PrimaryKey(autoGenerate: true)
//   int? id;
//   String? punchId;
//   String? eMPBasicDetailId;
//   String? eMPKey;
//   String? fullName;
//   String? punchDate;
//   String? firstPunchTime;
//   String? lastPunchTime;
//   String? firstLocation;
//   String? lastLocation;
//   String? firstImage;
//   String? lastImage;
//   String? attStatus;

//   EPRE(
//       {this.id = 0,
//       this.punchId,
//       this.eMPBasicDetailId,
//       this.eMPKey,
//       this.fullName,
//       this.punchDate,
//       this.firstPunchTime,
//       this.lastPunchTime,
//       this.firstLocation,
//       this.lastLocation,
//       this.firstImage,
//       this.attStatus,
//       this.lastImage});

//   EPRE.fromJson(Map<String, dynamic> json) {
//     punchId = json['PunchId'];
//     eMPBasicDetailId = json['EMP_BasicDetail_Id'];
//     eMPKey = json['EMPKey'];
//     fullName = json['FullName'];
//     punchDate = json['PunchDate'];
//     firstPunchTime = json['FirstPunchTime'];
//     lastPunchTime = json['LastPunchTime'];
//     firstLocation = json['FirstLocation'];
//     lastLocation = json['LastLocation'];
//     firstImage = json['FirstImage'];
//     lastImage = json['LastImage'];
//     attStatus = json['AttStatus'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['PunchId'] = this.punchId;
//     data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
//     data['EMPKey'] = this.eMPKey;
//     data['FullName'] = this.fullName;
//     data['PunchDate'] = this.punchDate;
//     data['FirstPunchTime'] = this.firstPunchTime;
//     data['LastPunchTime'] = this.lastPunchTime;
//     data['FirstLocation'] = this.firstLocation;
//     data['LastLocation'] = this.lastLocation;
//     data['FirstImage'] = this.firstImage;
//     data['LastImage'] = this.lastImage;
//     data['AttStatus'] = this.attStatus;
//     return data;
//   }
// }

// @dao
// abstract class EPREDao {
//   @insert
//   Future<void> insertEPRE(DailyAttendanceReportModel epre);

//   @Query('SELECT * FROM epre')
//   Future<List<DailyAttendanceReportModel>> getAllEPRE();

//   @delete
//   Future<void> deleteEPRE(DailyAttendanceReportModel epre);
// }

// @Database(version: 1, entities: [DailyAttendanceReportModel])
// abstract class AppDatabase extends FloorDatabase {
//   EPREDao get epreDao;
// }
