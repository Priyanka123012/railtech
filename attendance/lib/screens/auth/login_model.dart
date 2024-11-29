// class LoginResponseModel {
//   Employee? employee;
//   String? accessToken;
//   int? statusCode;
//   String? status;
//   String? statusText;

//   LoginResponseModel(
//       {this.employee,
//       this.accessToken,
//       this.statusCode,
//       this.status,
//       this.statusText});

//   LoginResponseModel.fromJson(Map<String, dynamic> json) {
//     employee = json['Employee'] != null
//         ? new Employee.fromJson(json['Employee'])
//         : null;
//     accessToken = json['access_token'];
//     statusCode = json['StatusCode'];
//     status = json['status'];
//     statusText = json['statusText'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.employee != null) {
//       data['Employee'] = this.employee!.toJson();
//     }
//     data['access_token'] = this.accessToken;
//     data['StatusCode'] = this.statusCode;
//     data['status'] = this.status;
//     data['statusText'] = this.statusText;
//     return data;
//   }
// }

// class Employee {
//   String? eMPBasicDetailId;
//   String? eMPCode;
//   String? fullName;
//   String? email;
//   String? mobile;
//   String? type;
//   String? costCenterId;
//   String? managerId;

//   Employee(
//       {this.eMPBasicDetailId,
//       this.eMPCode,
//       this.fullName,
//       this.email,
//       this.mobile,
//       this.type,
//       this.costCenterId,
//       this.managerId});

//   Employee.fromJson(Map<String, dynamic> json) {
//     eMPBasicDetailId = json['EMP_BasicDetail_Id'];
//     eMPCode = json['EMPCode'];
//     fullName = json['FullName'];
//     email = json['Email'];
//     mobile = json['Mobile'];
//     type = json['Type'];
//     costCenterId = json['CostCenterId'];
//     managerId = json['ManagerId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
//     data['EMPCode'] = this.eMPCode;
//     data['FullName'] = this.fullName;
//     data['Email'] = this.email;
//     data['Mobile'] = this.mobile;
//     data['Type'] = this.type;
//     data['CostCenterId'] = this.costCenterId;
//     data['ManagerId'] = this.managerId;
//     return data;
//   }
// }
class LoginResponseModel {
  Employee? employee;
  String? accessToken;
  int? statusCode;
  String? status;
  String? statusText;

  LoginResponseModel(
      {this.employee,
      this.accessToken,
      this.statusCode,
      this.status,
      this.statusText});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    employee = json['Employee'] != null
        ? new Employee.fromJson(json['Employee'])
        : null;
    accessToken = json['access_token'];
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employee != null) {
      data['Employee'] = this.employee!.toJson();
    }
    data['access_token'] = this.accessToken;
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    return data;
  }
}

class Employee {
  String? eMPBasicDetailId;
  String? eMPCode;
  String? fullName;
  String? email;
  String? mobile;
  String? type;
  String? costCenterId;
  String? managerId;

  Employee(
      {this.eMPBasicDetailId,
      this.eMPCode,
      this.fullName,
      this.email,
      this.mobile,
      this.type,
      this.costCenterId,
      this.managerId});

  Employee.fromJson(Map<String, dynamic> json) {
    eMPBasicDetailId = json['EMP_BasicDetail_Id'];
    eMPCode = json['EMPCode'];
    fullName = json['FullName'];
    email = json['Email'];
    mobile = json['Mobile'];
    type = json['Type'];
    costCenterId = json['CostCenterId'];
    managerId = json['ManagerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_BasicDetail_Id'] = this.eMPBasicDetailId;
    data['EMPCode'] = this.eMPCode;
    data['FullName'] = this.fullName;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['Type'] = this.type;
    data['CostCenterId'] = this.costCenterId;
    data['ManagerId'] = this.managerId;
    return data;
  }
}