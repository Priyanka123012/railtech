class TeamMemberDetailsModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<TDS>? tDS;

  TeamMemberDetailsModel(
      {this.statusCode, this.status, this.statusText, this.tDS});
  TeamMemberDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? eMPBasicDetailId;
  Null eMPCode;
  String? fullName;
  Null email;
  String? mobile;
  String? eMPKey;
  String? joiningDate;
  String? companyName;
  String? departmentHead;
  String? designation;
  String? state;
  String? faceImage;
  String? status;
  String? adharNumber;
  String? fathername;

  TDS(
      {this.eMPBasicDetailId,
      this.eMPCode,
      this.fullName,
      this.email,
      this.mobile,
      this.eMPKey,
      this.joiningDate,
      this.companyName,
      this.departmentHead,
      this.designation,
      this.faceImage,
      this.state,
      this.status,
      this.adharNumber,
      this.fathername,
      });

  TDS.fromJson(Map<String, dynamic> json) {
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPCode = json['EMPCode'];
    fullName = json['FullName'];
    email = json['Email'];
    mobile = json['Mobile'];
    eMPKey = json['EMPKey'];
    joiningDate = json['JoiningDate'];
    companyName = json['CompanyName'];
    departmentHead = json['DepartmentHead'];
    designation = json['Designation'];
    state = json['State'];
    faceImage = json['FaceImage'];
    status = json['Status'];
    adharNumber = json['AadharNumber'];
    fathername = json['FatherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPCode'] = this.eMPCode;
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['EMPKey'] = this.eMPKey;
    data['JoiningDate'] = this.joiningDate;
    data['CompanyName'] = this.companyName;
    data['DepartmentHead'] = this.departmentHead;
    data['Designation'] = this.designation;
    data['State'] = this.state;
    data['FaceImage'] = this.faceImage;
    data['Status'] = this.status;
    data['AadharNumber'] = this.adharNumber;
    data['FatherName'] = this.fathername;
    return data;
  }
}
