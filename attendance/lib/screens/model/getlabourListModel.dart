class GetLaboursDetailsModel {
  List<TFRV>? tfrv;
  int? statusCode;
  String? status;
  String? statusText;

  GetLaboursDetailsModel({this.tfrv, this.statusCode, this.status, this.statusText});

  GetLaboursDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['TFRV'] != null) {
      tfrv = <TFRV>[];
      json['TFRV'].forEach((v) {
        tfrv!.add(TFRV.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tfrv != null) {
      data['TFRV'] = tfrv!.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = statusCode;
    data['status'] = status;
    data['statusText'] = statusText;
    return data;
  }
}

class TFRV {
  String? faceRegistrationId;
  String? empBasicDetailId;
  String? fullName;
  String? empKey;
  String? faceImage;
  String? location;
  String? markedBy;
  String? markedByUserId;

  TFRV(
      {this.faceRegistrationId,
      this.empBasicDetailId,
      this.fullName,
      this.empKey,
      this.faceImage,
      this.location,
      this.markedBy,
      this.markedByUserId});

  TFRV.fromJson(Map<String, dynamic> json) {
    faceRegistrationId = json['FaceRegistrationId'];
    empBasicDetailId = json['EMP_BasicDetail_Id'];
    fullName = json['FullName'];
    empKey = json['EMPKey'];
    faceImage = json['FaceImage'];
    location = json['Location'];
    markedBy = json['MarkedBy'];
    markedByUserId = json['MarkedByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FaceRegistrationId'] = faceRegistrationId;
    data['EMP_BasicDetail_Id'] = empBasicDetailId;
    data['FullName'] = fullName;
    data['EMPKey'] = empKey;
    data['FaceImage'] = faceImage;
    data['Location'] = location;
    data['MarkedBy'] = markedBy;
    data['MarkedByUserId'] = markedByUserId;
    return data;
  }
}
