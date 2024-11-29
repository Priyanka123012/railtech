class GetAllRegisteredFaceModel {
  List<FRV>? fRV;
  int? statusCode;
  String? status;
  String? statusText;

  GetAllRegisteredFaceModel(
      {this.fRV, this.statusCode, this.status, this.statusText});

  GetAllRegisteredFaceModel.fromJson(Map<String, dynamic> json) {
    if (json['FRV'] != null) {
      fRV = <FRV>[];
      json['FRV'].forEach((v) {
        fRV!.add(new FRV.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fRV != null) {
      data['FRV'] = this.fRV!.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    return data;
  }

  String? print(String s) {}
}

class FRV {
  String? faceRegistrationId;
  String? eMPBasicDetailId;
  String? fullName;
  String? eMPKey;
  String? faceImage;
  String? location;
  String? markedByUserId;
  String? status;
  String? faceImage64;

  FRV(
      {this.faceRegistrationId,
      this.eMPBasicDetailId,
      this.fullName,
      this.eMPKey,
      this.faceImage,
      this.location,
      this.markedByUserId,
      this.status,
      this.faceImage64});

  FRV.fromJson(Map<String, dynamic> json) {
    faceRegistrationId = json['FaceRegistrationId'];
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    fullName = json['FullName'];
    eMPKey = json['EMPKey'];
    faceImage = json['FaceImage'];
    location = json['Location'];
    markedByUserId = json['MarkedByUserId'];
    status = json['Status'];
    faceImage64 = json['FaceImage64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FaceRegistrationId'] = this.faceRegistrationId;
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['FullName'] = this.fullName;
    data['EMPKey'] = this.eMPKey;
    data['FaceImage'] = this.faceImage;
    data['Location'] = this.location;
    data['MarkedByUserId'] = this.markedByUserId;
    data['Status'] = this.status;
    data['FaceImage64'] = this.faceImage64;
    return data;
  }
}
