class TeamPunchInModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<TEP>? teP;

  TeamPunchInModel({this.statusCode, this.status, this.statusText, this.teP});

  TeamPunchInModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['TEP'] != null) {
      teP = <TEP>[];
      json['EP'].forEach((v) {
        teP!.add(new TEP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.teP != null) {
      data['TEP'] = this.teP!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TEP {
  String? punchId;
  String? eMPBasicDetailId;
  String? eMPKey;
  String? fullName;
  String? punchDateTime;
  String? location;
  String? punchImage;
  String? markedByUserId;

  TEP(
      {this.punchId,
      this.eMPBasicDetailId,
      this.eMPKey,
      this.fullName,
      this.punchDateTime,
      this.location,
      this.markedByUserId,
      this.punchImage});

  TEP.fromJson(Map<String, dynamic> json) {
    punchId = json['PunchId'];
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPKey = json['EMPKey'];
    fullName = json['FullName'];
    punchDateTime = json['PunchDateTime'];
    location = json['Location'];
    punchImage = json['PunchImage'];
    markedByUserId = json['MarkedByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PunchId'] = this.punchId;
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPKey'] = this.eMPKey;
    data['FullName'] = this.fullName;
    data['PunchDateTime'] = this.punchDateTime;
    data['Location'] = this.location;
    data['PunchImage'] = this.punchImage;
    data['MarkedByUserId'] = this.markedByUserId;
    return data;
  }
}

class PunchInModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<EP>? eP;

  PunchInModel({this.statusCode, this.status, this.statusText, this.eP});

  PunchInModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['EP'] != null) {
      eP = <EP>[];
      json['EP'].forEach((v) {
        eP!.add(new EP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.eP != null) {
      data['EP'] = this.eP!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EP {
  String? punchId;
  String? eMPBasicDetailId;
  String? eMPKey;
  String? fullName;
  String? punchDateTime;
  String? location;
  String? punchImage;

  EP(
      {this.punchId,
      this.eMPBasicDetailId,
      this.eMPKey,
      this.fullName,
      this.punchDateTime,
      this.location,
      this.punchImage});

  EP.fromJson(Map<String, dynamic> json) {
    punchId = json['PunchId'];
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPKey = json['EMPKey'];
    fullName = json['FullName'];
    punchDateTime = json['PunchDateTime'];
    location = json['Location'];
    punchImage = json['PunchImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PunchId'] = this.punchId;
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPKey'] = this.eMPKey;
    data['FullName'] = this.fullName;
    data['PunchDateTime'] = this.punchDateTime;
    data['Location'] = this.location;
    data['PunchImage'] = this.punchImage;
    return data;
  }
}
class GetLabourPunchinModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<PunchinDetail>? ep;

  GetLabourPunchinModel({
    this.statusCode,
    this.status,
    this.statusText,
    this.ep,
  });

  factory GetLabourPunchinModel.fromJson(Map<String, dynamic> json) {
    return GetLabourPunchinModel(
      statusCode: json['StatusCode'],
      status: json['status'],
      statusText: json['statusText'],
      ep: (json['EP'] as List<dynamic>?)
          ?.map((item) => PunchinDetail.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'status': status,
      'statusText': statusText,
      'EP': ep?.map((item) => item.toJson()).toList(),
    };
  }
}

class PunchinDetail {
  String? punchId;
  String? labourId;
  String? empId;
  String? fullName;
  String? punchDateTime;
  String? location;
  String? punchImage;

  PunchinDetail({
    this.punchId,
    this.labourId,
    this.empId,
    this.fullName,
    this.punchDateTime,
    this.location,
    this.punchImage,
  });

  factory PunchinDetail.fromJson(Map<String, dynamic> json) {
    return PunchinDetail(
      punchId: json['PunchId'],
      labourId: json['LabourId'],
      empId: json['EMPId'],
      fullName: json['FullName'],
      punchDateTime: json['PunchDateTime'],
      location: json['Location'],
      punchImage: json['PunchImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PunchId': punchId,
      'LabourId': labourId,
      'EMPId': empId,
      'FullName': fullName,
      'PunchDateTime': punchDateTime,
      'Location': location,
      'PunchImage': punchImage,
    };
  }
}

