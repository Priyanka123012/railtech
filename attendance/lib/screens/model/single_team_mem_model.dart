// class SingleTeamMemberResponseModel {
//   int? statusCode;
//   String? status;
//   String? statusText;
//   List<EP>? eP;

//   SingleTeamMemberResponseModel(
//       {this.statusCode, this.status, this.statusText, this.eP});

//   SingleTeamMemberResponseModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['StatusCode'];
//     status = json['status'];
//     statusText = json['statusText'];
//     if (json['EP'] != null) {
//       eP = <EP>[];
//       json['EP'].forEach((v) {
//         eP!.add(new EP.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['StatusCode'] = this.statusCode;
//     data['status'] = this.status;
//     data['statusText'] = this.statusText;
//     if (this.eP != null) {
//       data['EP'] = this.eP!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class EP {
//   Null punchId;
//   String? eMPBasicDetailId;
//   String? eMPKey;
//   String? fullName;
//   String? punchDateTime;
//   String? location;
//   String? punchImage;
//   String? markedByUserId;
//   String? markedByUserName;

//   EP(
//       {this.punchId,
//       this.eMPBasicDetailId,
//       this.eMPKey,
//       this.fullName,
//       this.punchDateTime,
//       this.location,
//       this.punchImage,
//       this.markedByUserId,
//       this.markedByUserName});

//   EP.fromJson(Map<String, dynamic> json) {
//     punchId = json['PunchId'];
//     eMPBasicDetailId = json['EMP_BasicDetail_Id'];
//     eMPKey = json['EMPKey'];
//     fullName = json['FullName'];
//     punchDateTime = json['PunchDateTime'];
//     location = json['Location'];
//     punchImage = json['PunchImage'];
//     markedByUserId = json['MarkedByUserId'];
//     markedByUserName = json['MarkedByUserName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['PunchId'] = this.punchId;
//     data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
//     data['EMPKey'] = this.eMPKey;
//     data['FullName'] = this.fullName;
//     data['PunchDateTime'] = this.punchDateTime;
//     data['Location'] = this.location;
//     data['PunchImage'] = this.punchImage;
//     data['MarkedByUserId'] = this.markedByUserId;
//     data['MarkedByUserName'] = this.markedByUserName;
//     return data;
//   }
// }

class SingleTeamMemberDetailsModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<EPRE>? ePRE;

  SingleTeamMemberDetailsModel(
      {this.statusCode, this.status, this.statusText, this.ePRE});

  SingleTeamMemberDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['EPRE'] != null) {
      ePRE = <EPRE>[];
      json['EPRE'].forEach((v) {
        ePRE!.add(new EPRE.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.ePRE != null) {
      data['EPRE'] = this.ePRE!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EPRE {
  Null punchId;
  String? eMPBasicDetailId;
  String? eMPKey;
  String? fullName;
  String? punchDate;
  String? firstPunchTime;
  String? lastPunchTime;
  String? firstLocation;
  String? lastLocation;
  String? firstImage;
  String? lastImage;
  String? attStatus;
  String? markedByUserId;
  String? markedByUserName;
  String? workDuration;
  String? afterFirstPunch;

  EPRE(
      {this.punchId,
      this.eMPBasicDetailId,
      this.eMPKey,
      this.fullName,
      this.punchDate,
      this.firstPunchTime,
      this.lastPunchTime,
      this.firstLocation,
      this.lastLocation,
      this.firstImage,
      this.lastImage,
      this.attStatus,
      this.markedByUserId,
      this.markedByUserName,
      this.workDuration,
      this.afterFirstPunch
      });

  EPRE.fromJson(Map<String, dynamic> json) {
    punchId = json['PunchId'];
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPKey = json['EMPKey'];
    fullName = json['FullName'];
    punchDate = json['PunchDate'];
    firstPunchTime = json['FirstPunchTime'];
    lastPunchTime = json['LastPunchTime'];
    firstLocation = json['FirstLocation'];
    lastLocation = json['LastLocation'];
    firstImage = json['FirstImage'];
    lastImage = json['LastImage'];
    attStatus = json['AttStatus'];
    markedByUserId = json['MarkedByUserId'];
    markedByUserName = json['MarkedByUserName'];
    workDuration = json['WorkDuration'];
    afterFirstPunch = json['AfterFirstPunch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PunchId'] = this.punchId;
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPKey'] = this.eMPKey;
    data['FullName'] = this.fullName;
    data['PunchDate'] = this.punchDate;
    data['FirstPunchTime'] = this.firstPunchTime;
    data['LastPunchTime'] = this.lastPunchTime;
    data['FirstLocation'] = this.firstLocation;
    data['LastLocation'] = this.lastLocation;
    data['FirstImage'] = this.firstImage;
    data['LastImage'] = this.lastImage;
    data['AttStatus'] = this.attStatus;
    data['MarkedByUserId'] = this.markedByUserId;
    data['MarkedByUserName'] = this.markedByUserName;
    data['WorkDuration'] = this.workDuration;
    data['AfterFirstPunch'] = this.afterFirstPunch;
    return data;
  }
}
