class Profile {
  final String fullName;
  final String mobile;
  final String empKey;
  final String joiningDate;
  final String companyName;
  final String departmentHead;
  final String designation;
  final String state;
  final String imagePath;
  final String tenderUid;
  final String costCenterName;
  final String reportingManager;
  final String FatherName;
  final String AadharNumber;

  Profile({
    required this.fullName,
    required this.mobile,
    required this.empKey,
    required this.joiningDate,
    required this.companyName,
    required this.departmentHead,
    required this.designation,
    required this.state,
    required this.imagePath,
    required this.tenderUid,
    required this.costCenterName,
    required this.reportingManager,
    required this.FatherName,
    required this.AadharNumber,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      fullName: json['FullName'] ?? "",
      mobile: json['Mobile'] ?? "",
      empKey: json['EMPKey'] ?? "",
      joiningDate: json['JoiningDate'] ?? "",
      companyName: json['CompanyName'] ?? "",
      departmentHead: json['DepartmentHead'] ?? "",
      designation: json['Designation'] ?? "",
      state: json['State'] ?? "",
      imagePath: json['ImagePath'] ?? "",
      tenderUid: json['TenderUid'] ?? "",
      costCenterName: json['CostCenterName'] ?? "",
      reportingManager: json['ReportingManager'] ?? "",
      FatherName: json['FatherName'] ?? "",
      AadharNumber: json['AadharNumber'] ?? "",
    );
  }
}
