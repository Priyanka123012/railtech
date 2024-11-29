class LabourListModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<TDS>? tDS;

  LabourListModel({this.statusCode, this.status, this.statusText, this.tDS});

  LabourListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['TDS'] != null) {
      tDS = <TDS>[];
      json['TDS'].forEach((v) {
        tDS!.add(new TDS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.tDS != null) {
      data['TDS'] = this.tDS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TDS {
  String? labourId;
  String? fullName;
  String? aadharNumber;
  String? eMPId;
  String? skillHead;
  String? gender;
  String? joiningDate;
  String? fatherName;
  String? faceImage;
  String? status;
  String? faceImage64;

  TDS(
      {this.labourId,
      this.fullName,
      this.aadharNumber,
      this.eMPId,
      this.skillHead,
      this.gender,
      this.joiningDate,
      this.fatherName,
      this.faceImage,
      this.status,
      this.faceImage64,

      });

  TDS.fromJson(Map<String, dynamic> json) {
    labourId = json['LabourId'];
    fullName = json['FullName'];
    aadharNumber = json['AadharNumber'];
    eMPId = json['EMPId'];
    skillHead = json['SkillHead'];
    gender = json['Gender'];
    joiningDate = json['JoiningDate'];
    fatherName = json['FatherName'];
    faceImage = json['FaceImage'];
    status = json['Status'];
    faceImage64 = json['FaceImage64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LabourId'] = this.labourId;
    data['FullName'] = this.fullName;
    data['AadharNumber'] = this.aadharNumber;
    data['EMPId'] = this.eMPId;
    data['SkillHead'] = this.skillHead;
    data['Gender'] = this.gender;
    data['JoiningDate'] = this.joiningDate;
    data['FatherName'] = this.fatherName;
    data['FaceImage'] = this.faceImage;
    data['Status'] = this.status;
    data['FaceImage64'] = this.faceImage64;
    return data;
  }
}