class ApiUrls {
  static const String baseUrl = 'http://rapi.railtech.co.in';
  static const String apiUrl = baseUrl + '/api/';
  static const String login = apiUrl + 'Login';
  static const String faceregister = apiUrl + 'FaceRegistration/Add';
  static const String matchRegisteredFace = apiUrl + 'FaceRegistration/get';
  static const String punchInapi = apiUrl + 'EMPPunch/Add';
  //----------------------------------------Team Member Register Api----
  static const String teamMemberFaceRegister = apiUrl + 'TeamEMPPunch/Add';
  static const String getTeamMemberList = apiUrl + 'TeamEMPPunch/get';
  static const String getTeamMemTotalPresentAbsent =apiUrl + 'TeamEMPPunch/getTotalPresentAbsent';
  static const String getTeamMemPunchReportEmployee =apiUrl + 'TeamEMPPunch/getPunchReportEmployee';


  //----------------------------Labour Api-------------
   static const String labourmemberFaceRegister = apiUrl + 'LabourPunch/Add';
   static const String getLabourList = apiUrl + 'LabourPunch/get';
   static const String getLabourTotalPresentAbsent = apiUrl + 'LabourPunch/getTotalPresentAbsent';
   static const String getLabourPunchReportEmplyee = apiUrl + 'EMPPunch/getPunchReortEmployee';
}
