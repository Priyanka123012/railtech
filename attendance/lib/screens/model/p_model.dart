class PriyankaMamProfileModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<CDS>? cDS;

  PriyankaMamProfileModel(
      {this.statusCode, this.status, this.statusText, this.cDS});

  PriyankaMamProfileModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['CDS'] != null) {
      cDS = <CDS>[];
      json['CDS'].forEach((v) {
        cDS!.add(new CDS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.cDS != null) {
      data['CDS'] = this.cDS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CDS {
  String? eMPBasicDetailId;
  String? eMPCode;
  String? fullName;
  String? email;
  String? mobile;
  String? eMPKey;
  String? sAPNo;
  String? joiningDate;
  String? companyName;
  String? departmentHead;
  String? designation;

  CDS(
      {this.eMPBasicDetailId,
      this.eMPCode,
      this.fullName,
      this.email,
      this.mobile,
      this.eMPKey,
      this.sAPNo,
      this.joiningDate,
      this.companyName,
      this.departmentHead,
      this.designation});

  CDS.fromJson(Map<String, dynamic> json) {
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPCode = json['EMPCode'];
    fullName = json['FullName'];
    email = json['Email'];
    mobile = json['Mobile'];
    eMPKey = json['EMPKey'];
    sAPNo = json['SAPNo'];
    joiningDate = json['JoiningDate'];
    companyName = json['CompanyName'];
    departmentHead = json['DepartmentHead'];
    designation = json['Designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPCode'] = this.eMPCode;
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['EMPKey'] = this.eMPKey;
    data['SAPNo'] = this.sAPNo;
    data['JoiningDate'] = this.joiningDate;
    data['CompanyName'] = this.companyName;
    data['DepartmentHead'] = this.departmentHead;
    data['Designation'] = this.designation;
    return data;
  }
}
