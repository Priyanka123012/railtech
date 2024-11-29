

class LabourGetFaceModel {
  List<TFRV>? tFRV;
  int? statusCode;
  String? status;
  String? statusText;

  LabourGetFaceModel(
      {this.tFRV, this.statusCode, this.status, this.statusText});

  LabourGetFaceModel.fromJson(Map<String, dynamic> json) {
    if (json['TFRV'] != null) {
      tFRV = <TFRV>[];
      json['TFRV'].forEach((v) {
        tFRV!.add(new TFRV.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tFRV != null) {
      data['TFRV'] = this.tFRV!.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    return data;
  }
}

class TFRV {
  String? faceRegistrationId; // Changed Null to String?
  String? labourId;
  String? fullName;
  String? eMPId;
  String? faceImage;
  String? location;
  String? markedBy; // Changed Null to String?
  String? markedByUserId; // Changed Null to String?

  TFRV(
      {this.faceRegistrationId,
      this.labourId,
      this.fullName,
      this.eMPId,
      this.faceImage,
      this.location,
      this.markedBy,
      this.markedByUserId});

  TFRV.fromJson(Map<String, dynamic> json) {
    faceRegistrationId = json['FaceRegistrationId'];
    labourId = json['LabourId'];
    fullName = json['FullName'];
    eMPId = json['EMPId'];
    faceImage = json['FaceImage'];
    location = json['Location'];
    markedBy = json['MarkedBy'];
    markedByUserId = json['MarkedByUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FaceRegistrationId'] = this.faceRegistrationId;
    data['LabourId'] = this.labourId;
    data['FullName'] = this.fullName;
    data['EMPId'] = this.eMPId;
    data['FaceImage'] = this.faceImage;
    data['Location'] = this.location;
    data['MarkedBy'] = this.markedBy;
    data['MarkedByUserId'] = this.markedByUserId;
    return data;
  }
}
