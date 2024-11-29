class AbsentEmployeeList {
  int? statusCode;
  String? status;
  String? statusText;
  List<Employee>? employees;

  AbsentEmployeeList({this.statusCode, this.status, this.statusText, this.employees});

  // From JSON
  factory AbsentEmployeeList.fromJson(Map<String, dynamic> json) {
    return AbsentEmployeeList(
      statusCode: json['StatusCode'],
      status: json['status'],
      statusText: json['statusText'],
      employees: (json['EP'] as List).map((i) => Employee.fromJson(i)).toList(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'status': status,
      'statusText': statusText,
      'EP': employees?.map((i) => i.toJson()).toList(),
    };
  }
}

class Employee {
  String? fullName;
  String? mobile;
  String? status;

  Employee({this.fullName, this.mobile, this.status});

  // From JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullName: json['FullName'],
      mobile: json['Mobile'],
      status: json['Status'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'FullName': fullName,
      'Mobile': mobile,
      'Status': status,
    };
  }
}
