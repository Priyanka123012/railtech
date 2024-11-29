class TotalPresentAbsentModel {
  int? statusCode;
  String? status;
  String? statusText;
  EPA? ePA;

  TotalPresentAbsentModel(
      {this.statusCode, this.status, this.statusText, this.ePA});

  TotalPresentAbsentModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    ePA = json['EPA'] != null ? new EPA.fromJson(json['EPA']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.ePA != null) {
      data['EPA'] = this.ePA!.toJson();
    }
    return data;
  }
}

class EPA {
  String? eMPBasicDetailId;
  String? fullName;
  String? eMPKey;
  String? departmentHead;
  String? costCenterName;
  String? totalPresent;
  String? totalAbsent;
  String? month;
  String? year;

  EPA(
      {this.eMPBasicDetailId,
      this.fullName,
      this.eMPKey,
      this.departmentHead,
      this.costCenterName,
      this.totalPresent,
      this.totalAbsent,
      this.month,
      this.year});

  EPA.fromJson(Map<String, dynamic> json) {
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    fullName = json['FullName'];
    eMPKey = json['EMPKey'];
    departmentHead = json['DepartmentHead'];
    costCenterName = json['CostCenterName'];
    totalPresent = json['TotalPresent'];
    totalAbsent = json['TotalAbsent'];
    month = json['Month'];
    year = json['Year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['FullName'] = this.fullName;
    data['EMPKey'] = this.eMPKey;
    data['DepartmentHead'] = this.departmentHead;
    data['CostCenterName'] = this.costCenterName;
    data['TotalPresent'] = this.totalPresent;
    data['TotalAbsent'] = this.totalAbsent;
    data['Month'] = this.month;
    data['Year'] = this.year;
    return data;
  }
}
