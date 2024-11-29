class RegisteredFaceResponseModel {
  List<FRV>? fRV;
  int? statusCode;
  String? status;
  String? statusText;

  RegisteredFaceResponseModel(
      {this.fRV, this.statusCode, this.status, this.statusText});

  RegisteredFaceResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['FRV'] != null) {
      fRV = <FRV>[];
      json['FRV'].forEach((v) {
        fRV!.add(FRV.fromJson(v));
      });
    }
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.fRV != null) {
      data['FRV'] = this.fRV!.map((v) => v.toJson()).toList();
    }
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    return data;
  }
}

class FRV {
  dynamic faceRegistrationId;
  String? eMPBasicDetailId;
  String? fullName;
  String? eMPKey;
  String? faceImage;
  String? location;

  FRV({
    this.faceRegistrationId,
    this.eMPBasicDetailId,
    this.fullName,
    this.eMPKey,
    this.faceImage,
    this.location,
  });

  FRV.fromJson(Map<String, dynamic> json) {
    faceRegistrationId = json['FaceRegistrationId'];
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    fullName = json['FullName'];
    eMPKey = json['EMPKey'];
    faceImage = json['FaceImage'];
    location = json['Location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['FaceRegistrationId'] = this.faceRegistrationId;
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['FullName'] = this.fullName;
    data['EMPKey'] = this.eMPKey;
    data['FaceImage'] = this.faceImage;
    data['Location'] = this.location;
    return data;
  }
}
