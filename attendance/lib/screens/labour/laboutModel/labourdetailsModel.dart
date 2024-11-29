class LabourDetailsResponse {
  int? statusCode;
  String? status;
  String? statusText;
  List<LabourDetails>? epre;

  LabourDetailsResponse({
     this.statusCode,
     this.status,
     this.statusText,
     this.epre,
  });

  factory LabourDetailsResponse.fromJson(Map<String, dynamic> json) {
    return LabourDetailsResponse(
      statusCode: json['StatusCode'],
      status: json['status'],
      statusText: json['statusText'],
      epre: List<LabourDetails>.from(
        json['EPRE'].map((x) => LabourDetails.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'status': status,
      'statusText': statusText,
      'EPRE': List<dynamic>.from(epre!.map((x) => x.toJson())),
    };
  }
}

class LabourDetails {
  String punchId;
  String labourId;
  String empId;
  String fullName;
  String punchDate;
  String firstPunchTime;
  String lastPunchTime;
  String firstLocation;
  String lastLocation;
  String firstImage;
  String lastImage;
  String attStatus;

  LabourDetails({
    required this.punchId,
    required this.labourId,
    required this.empId,
    required this.fullName,
    required this.punchDate,
    required this.firstPunchTime,
    required this.lastPunchTime,
    required this.firstLocation,
    required this.lastLocation,
    required this.firstImage,
    required this.lastImage,
    required this.attStatus,
  });

  factory LabourDetails.fromJson(Map<String, dynamic> json) {
    return LabourDetails(
      punchId: json['PunchId'],
      labourId: json['LabourId'],
      empId: json['EMPId'],
      fullName: json['FullName'],
      punchDate: json['PunchDate'],
      firstPunchTime: json['FirstPunchTime'],
      lastPunchTime: json['LastPunchTime'],
      firstLocation: json['FirstLocation'],
      lastLocation: json['LastLocation'],
      firstImage: json['FirstImage'],
      lastImage: json['LastImage'],
      attStatus: json['AttStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PunchId': punchId,
      'LabourId': labourId,
      'EMPId': empId,
      'FullName': fullName,
      'PunchDate': punchDate,
      'FirstPunchTime': firstPunchTime,
      'LastPunchTime': lastPunchTime,
      'FirstLocation': firstLocation,
      'LastLocation': lastLocation,
      'FirstImage': firstImage,
      'LastImage': lastImage,
      'AttStatus': attStatus,
    };
  }
}
