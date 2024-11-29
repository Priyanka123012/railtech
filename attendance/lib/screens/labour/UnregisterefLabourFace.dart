// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:face_liveness/models/multi_face_input.dart';
// import 'package:faecauth/extension/appbar_ext.dart';
// import 'package:faecauth/main.dart';
// import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';

// import 'package:faecauth/screens/labour/laboutModel/laboutgetModel.dart';
// import 'package:faecauth/screens/labour/singleLabourList.dart';
// import 'package:faecauth/screens/team_atte_per_emp.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;


// class Labour extends StatefulWidget {
//   const Labour({super.key});

//   @override
//   State<Labour> createState() => _LabourState();
// }

// class _LabourState extends State<Labour> {
//   Uint8List? imageData;
//   List<dynamic> labourData = [];
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> filteredLabourData = [];
// var teamAttendanceModel = LabourListModel().obs;
//   TFRV?tfrv;
//   String? EmployeeId;
//   String? fullName;
//   String? labourId;

//   Future<String?> setCostCenterId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('CostCenterId');
//   }

//   Future<void> _fetchLabourList() async {
//     try {
//       String? costCenterId = await setCostCenterId();
//       const baseUrl = 'http://rapi.railtech.co.in/api/LabourDetails/get';

//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "LabourId": null,
//           "MarkedByUserId": null,
//           "CostCenterId": costCenterId,
//         }),
//       );

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);

//         if (responseData['StatusCode'] == 1) {
//           setState(() {
//             labourData = responseData['TDS'];
//             filteredLabourData = labourData;

//             // Assuming TDS is a list and you want the first entry
//             if (labourData.isNotEmpty) {
//               final firstLabour = labourData[1];
//               labourId = firstLabour['LabourId'] ?? "Default ID"; // or null
//               fullName = firstLabour['FullName'] ?? "Default Name"; // or null
//               print("Labour ID: $labourId");
//               print("Full Name: $fullName");
//             }
//           });
//         } else {
//           print("Error: ${responseData['Message']}");
//         }
//       } else {
//         print("Failed to load labour data");
//       }
//     } catch (e) {
//       print("Exception caught: $e");
//     }
//   }
//     Future<void> displayFaceImage() async {
//     MultiFaceInput? faceData = await getFaceDataByEmpId();

//     if (faceData != null) {
//       imageWidget = Image.memory(
//         base64Decode(faceData.imageBase64),
//         height: 70,
//         width: 70,
//         fit: BoxFit.fill,
//       );
//     } else {
//       imageWidget = Icon(
//         Icons.person,
//         size: 70,
//         color: Colors.black38,
//       );
//     }

//     setState(() {});
//   }


//   // Future<void> _showImageDialog(BuildContext context) async {
//   //   // print("=============>>>>  $faceImag");
//   //   log("${faceImag}");
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return Dialog(
//   //         shape: RoundedRectangleBorder(),
//   //         child: Container(
//   //           padding: EdgeInsets.all(10),
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               Container(
//   //                 height: MediaQuery.of(context).size.height * 0.5,
//   //                 width: MediaQuery.of(context).size.width,
//   //                 // child: imageWidget,
//   //                 child: faceImag != ""
//   //                     ?
//   //                     // Image.network(faceImag??"", height: 70,width: 70,)
//   //                     Image.memory(
//   //                         base64Decode(faceImag ?? ""),
//   //                         height: 70,
//   //                         width: 70,
//   //                         fit: BoxFit.fill,
//   //                       )
//   //                     : Icon(Icons.person),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//     Future<void> _showImageDialog(BuildContext context, String img) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(),
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 img.isNotEmpty &&
//                         img != "" &&
//                         img != "https://rapi.railtech.co.in/"
//                     ? Container(
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         width: MediaQuery.of(context).size.width,
//                         child: ClipRRect(
//                           child: Image.network(
//                             (img),
//                             height: 70,
//                             width: 70,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       )
//                     : Container(
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         width: MediaQuery.of(context).size.width,
//                         child: Icon(
//                           Icons.person,
//                           size: 100,
//                           color: Colors.black26,
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   @override
//   void initState() {
//     super.initState();
//     _fetchLabourList();
 
//   }

// @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         title: Text('View Labour ',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//       ).gradientBackground(withActions: true),
//       body: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Column(
//           children: [
//             Card(
//               elevation: 5,
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   labelText: "Search by Name",
//                   contentPadding: EdgeInsets.all(10),
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: filteredLabourData.isEmpty
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: filteredLabourData.length,
//                       itemBuilder: (context, index) {
//                         final labour = filteredLabourData[index];
//                         // String faceImag = registeredFaceResponseModel.value.fRV![0].faceImage ?? "";

//                         return InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => LaboursDetails(
//                                   lobourId: labour['LabourId'] ?? "",
//                                   fullname: labour['FullName'] ?? "",
//                                   EmployeeId: labour['EMPId'] ?? "",
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             elevation: 5,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 16),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Card(
//                                         elevation: 3,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: InkWell(
//                                                 _showImageDialog(context,
//                                                                       labour.faceImage.toString()),
//                                                               child: labour.faceImage!.isNotEmpty &&
//                                                                       lobour.faceImage !="" &&
//                                                                       lobour.faceImage !="https://rapi.railtech.co.in/"
//                                                                   ? ClipRRect(
//                                                                       child: Image.network(
//                                                                         (tds.faceImage  .toString()),
//                                                                         height:70,
//                                                                         width:70,
//                                                                         fit: BoxFit.fill,
//                                                                       ),
//                                                                     )
//                                                                   : Icon(
//                                                                       Icons.person,
//                                                                       size: 70,
//                                                                       color: Colors.black26,
//                                                                     ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 16),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Name: ${labour['FullName']}",
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             Text(
//                                                 "Employee ID: ${labour['EMPId']}"),
//                                             Text(
//                                                 "Joining Date: ${labour['JoiningDate']}"),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Divider(),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 "Aadhar Number: ${labour['AadharNumber']}"),
//                                             Text(
//                                                 "Skill: ${labour['SkillHead']}"),
//                                             // Text("Gender: ${labour['Gender']}"),
//                                             Text(
//                                                 "Father's Name: ${labour['FatherName']}"),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(width: 16),
//                                       //  if (filteredLabourData ==
//                                       //                     "https://rapi.railtech.co.in/")
//                                       FaceRegister(
//                                         LabourId: labour['LabourId'] ?? "",
//                                         FullName: labour['FullName'] ?? "",
//                                         EmployeeId: labour['EMPId'] ?? "",
//                                       )
//                                     ],
//                                   ),
//                                   SizedBox(height: 10),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FaceRegister extends StatefulWidget {
//   String? LabourId;

//   String? FullName;
//   String? EmployeeId;

//   FaceRegister({super.key, this.FullName, this.LabourId, this.EmployeeId});

//   @override
//   State<FaceRegister> createState() => _FaceRegisterState();
// }

// class _FaceRegisterState extends State<FaceRegister> {
//   Future<void> addFace() async {
//     await facematcher.registerFaceLabour(
//         widget.LabourId ?? "",
//         widget.FullName ?? "",
//         registeredFaceResponseModel.value.statusCode == 0
//             ? ""
//             : registeredFaceResponseModel.value.fRV![0].faceImage ?? "");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: addFace,
//       child: Container(
//         child: Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//             child: Column(
//               children: [
//                 Image.asset(
//                   "assets/face2.png",
//                   height: 50,
//                 ),
//                 Text("Add Face"),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:face_liveness/face_liveness.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class UnRegisteredLabourFace extends StatefulWidget {
  const UnRegisteredLabourFace({super.key});

  @override
  State<UnRegisteredLabourFace> createState() => _UnRegisteredLabourFaceState();
}

class _UnRegisteredLabourFaceState extends State<UnRegisteredLabourFace> {
  final currentDate = DateTime.now();
  FaceLiveness faceLiveness = FaceLiveness();

  // List<MultiFaceInput> allteamFaces = [];

  final TextEditingController searchController = TextEditingController();

  void _makePhoneCall(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<void> _showImageDialog(BuildContext context, String img) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                img.isNotEmpty &&
                        img != "" &&
                        img != "https://rapi.railtech.co.in/"
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          child: Image.network(
                            (img),
                            height: 70,
                            width: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.black26,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> setTeamEmpBasicId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('team_empId', value);
  }

  Future<bool> setTeamEmpName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('team_empName', value);
  }

  Future<String?> grtTeamEmpBasicId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('team_empId');
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }
  Future<String?> setCostCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CostCenterId');
  }
  // List<TeamMemberListModel> filteredTeamMembers = [];
  LabourListModel? teamAttedanceModel;
  // RegisteredTeamFaceResponseModel? registeredTeamFaceResponseModel;

  bool isLoading = true;
  String? team_empId;


Future<void> gatTeamMemberList() async {
  String? empId = await getEmpBasicDetailId();
  String? costCenterId = await setCostCenterId();

  if (empId == null) {
    print("Employee ID is null");
    setState(() {
      isLoading = false;
    });
    return;
  }

  const String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        "LabourId": null,
        "MarkedByUserId": null,
        "CostCenterId": costCenterId,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final model = LabourListModel.fromJson(jsonResponse);

      final filteredList = model.tDS
              ?.where((member) =>
                  member.status == null ||
                  member.status == "Rejected" ||
                  member.faceImage == "https://rapi.railtech.co.in/")
              .toList() ??
          [];

      filteredList.sort((a, b) => a.fullName?.toLowerCase().compareTo(b.fullName?.toLowerCase() ?? "") ?? 0);

      setState(() {
        teamAttendanceModel.value = model;
        filteredTeamMembers.value = filteredList;
        isLoading = false;
      });
    } else {
      print("Failed to fetch data: ${response.statusCode}");
      setState(() => isLoading = false);
    }
  } catch (e) {
    print("Error fetching data: $e");
    setState(() => isLoading = false);
  }
}


  final facematcher = FaceMatcher.instance;

  // Future<void>
  //     matchFace() async {
  //   String?
  //       empId =
  //       await grtTeamEmpBasicId();
  //   await facematcher.matchFace(empId!);
  // }

  Future<MultiFaceInput?> getFaceDataByEmpId() async {
    String? empId = await grtTeamEmpBasicId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFaces = prefs.getStringList('saved_team_faces');
    if (savedFaces == null || savedFaces.isEmpty) {
      return null;
    }

    for (String jsonString in savedFaces) {
      MultiFaceInput faceData = MultiFaceInput.fromJson(jsonDecode(jsonString));
      if (faceData.empid == empId) {
        return faceData;
      }
    }

    return null;
  }

  Widget? imageWidget;

  Future<void> displayFaceImage() async {
    MultiFaceInput? faceData = await getFaceDataByEmpId();

    if (faceData != null) {
      imageWidget = Image.memory(
        base64Decode(faceData.imageBase64),
        height: 70,
        width: 70,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = Icon(
        Icons.person,
        size: 70,
        color: Colors.black38,
      );
    }

    setState(() {});
  }

  var filteredTeamMembers = <TDS>[].obs;
  var teamAttendanceModel = LabourListModel().obs;

  // void filterTeamMembers(String name) {
  //   if (name.isEmpty) {
  //     filteredTeamMembers.value = teamAttendanceModel.value.tDS ?? [];
  //   } else {
  //     filteredTeamMembers.value =
  //         teamAttendanceModel.value.tDS?.where((member) {
  //               return member.fullName
  //                       ?.toLowerCase()
  //                       .contains(name.toLowerCase()) ??
  //                   false;
  //             }).toList() ??
  //             [];
  //   }
  // }
  void filterTeamMembers(String name) {
  if (name.isEmpty) {
    filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
      return  member.status == null ||
          member.status=="Rejected"||
    member.faceImage == "https://rapi.railtech.co.in/";
             
    }).toList() ?? [];
  } else {
    filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
    
      bool matchesName = member.fullName
                          ?.toLowerCase()
                          .contains(name.toLowerCase()) ?? false;
      bool matchesOtherConditions =  member.status == null ||
          member.status=="Rejected"||
    member.faceImage == "https://rapi.railtech.co.in/";
      return matchesName && matchesOtherConditions;
    }).toList() ?? [];
  }
}

Future<void> showCountdownDialog(BuildContext context, int seconds) async {
  int countdown = seconds;
  Timer? timer;
      
    
  // Function to start and update the countdown
  void startTimer(VoidCallback updateDialog) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        Navigator.of(context).pop();
        // Close the dialog box when countdown reaches 0
      } else {
        countdown--;
        updateDialog(); 
      }
    });
  }
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (timer == null) {
            startTimer(() => setState(() {}));
          }
          return AlertDialog(
            title: Text('Align your face'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Wait $countdown seconds.',style: TextStyle(fontSize:25),),
                SizedBox(height: 20),
              ],
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       timer?.cancel();
            //       Navigator.of(context).pop();
            //     },
            //     child: Text('Cancel'),
            //   ),
            // ],
          );
        },
      );
    },
  );

  // Ensure the timer is canceled when the dialog is closed
  timer?.cancel();
}


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await gatTeamMemberList();
      await displayFaceImage();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text('UNREGISTERED LABOUR ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ).gradientBackground(withActions: true),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  elevation: 5,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterTeamMembers(value);
                    },
                    decoration: InputDecoration(
                      labelText: "Search by Name",
                      labelStyle: TextStyle(color: Colors.green),
                      contentPadding: EdgeInsets.all(10),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              isLoading == true
                  ? CircularProgressIndicator()
                  : teamAttedanceModel?.status == "Failed"
                      ? Column(
                          children: [
                            Image.asset("assets/nodataa.png"),
                            Text(
                              "No any Team\nassigned for YOU",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            5.heightBox,
                            Divider(),
                            Container(
                              height: Get.height * 0.8,
                              child: Obx(
                                () => ListView.builder(
                                  itemCount: filteredTeamMembers.length,
                                  itemBuilder: (BuildContext context, index) {
                                    final tds = filteredTeamMembers[index];
                                    return Column(
                                      children: [
                                        InkWell(
                                         onTap: () {
                                            if (tds.faceImage!.isNotEmpty &&
                                                tds.faceImage != "" &&
                                                tds.faceImage !="https://rapi.railtech.co.in/") {
                                              // Navigator.push(context,MaterialPageRoute(builder: (context) =>SingleEmpDetails(onedata:filteredTeamMembers[index])));
                                            } else {
                                              "Please Register your face first".showToast();
                                            }
                                          },
                                          child: Card(
                                            shadowColor: teamAttedanceModel?.tDS?[index].fullName !=""
                                                ? Colors.green
                                                : Colors.red,
                                            // elevation: 3,
                                            shape: RoundedRectangleBorder(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(  horizontal: 5,  vertical: 5),
                                              child: Column(
                                                children: [
                                                  Row(children: [  Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(5),
                                                  // border: Border.all(
                                                  //           color: Colors.green,
                                                  //           width: 1.5,
                                                  //         ),
                                                        ),
                                                        child: Padding(padding:EdgeInsets.all(4.0),child: InkWell(
                                                              onTap: () =>
                                                                  _showImageDialog(
                                                                      context,
                                                                      tds.faceImage.toString()),
                                                              child: tds.faceImage!.isNotEmpty &&
                                                                      tds.faceImage !="" &&
                                                                    tds.status!="Rejected"&&
                                                                      tds.faceImage !="https://rapi.railtech.co.in/"||tds.faceImage==""
                                                                  ? ClipRRect(
                                                                      child: Image.network(
                                                                        (tds.faceImage  .toString()),
                                                                        height:50,
                                                                        width:50,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    )
                                                                  :  
                                                          //         if (tds.faceImage ==
                                                          // "https://rapi.railtech.co.in/")
                                                        InkWell(
                                                          // onTap: addFace,
                                                           
                                                          onTap: () async {
                                                             showCountdownDialog(context, 5);
                                                            //  print("=====================?? ${filteredTeamMembers.length}   ${teamAttedanceModel!.tDS!.length}");
                                                            await facematcher.registerFaceLabour(
                                                                // teamAttedanceModel!
                                                                //     .tDS![index]
                                                                //     .labourId
                                                                //     .toString(),

                                                                filteredTeamMembers[index].labourId,
                                                                filteredTeamMembers[index].fullName.toString(),
                                                                // teamAttedanceModel!
                                                                //     .tDS![index]
                                                                //     .fullName
                                                                //     .toString(),

                                                                filteredTeamMembers[index].faceImage! != "" ? "" : filteredTeamMembers[index].faceImage!,
                                                                // teamAttedanceModel!
                                                                //             .tDS![
                                                                //                 index]
                                                                //             .faceImage !=
                                                                //         ""
                                                                //     ? ""
                                                                //     : teamAttedanceModel!
                                                                //         .tDS![
                                                                //             index]
                                                                //         .faceImage!
                                                                        
                                                            // await facematcher.registerFaceLabour(
                                                            //     teamAttedanceModel!
                                                            //         .tDS![index]
                                                            //         .labourId,
                                                                   
                                                            //     teamAttedanceModel!
                                                            //         .tDS![index]
                                                            //         .fullName
                                                            //         .toString(),
                                                            //     teamAttedanceModel!
                                                            //                 .tDS![index]
                                                            //                 .faceImage !=
                                                            //             ""
                                                            //         ? ""
                                                            //         : teamAttedanceModel!
                                                            //             .tDS![index]
                                                            //             .faceImage!
                                                                        );
                                                          
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          5),
                                                              child: Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/face2.png",
                                                                    height: 40,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    tds.faceImage ==
                                                                            "https://rapi.railtech.co.in/"
                                                                        ? "Register\nYour Face"
                                                                        : "Re-register\nYour Face",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                   
                                                   
                                                                  // Icon(
                                                                  //     Icons.person,
                                                                  //     size: 70,
                                                                  //     color: Colors.black26,
                                                                  //   ),
                                                            )),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "${tds.fullName ?? ""}",
                                                              style: TextStyle(fontWeight:  FontWeight.bold),
                                                            ),
                                                          ),
                                                            Padding(padding:const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "EMP Id :${tds.eMPId ?? ""}",
                                                              style: TextStyle(
                                                                  color: Colors.black38),
                                                            ),
                                                          ),
                                                           Padding(
                                                          padding: const EdgeInsets.only(left: 10),
                                                          child: Text(
                                                                'Father name : ${tds.fatherName ?? ""}',
                                                                style: TextStyle(color: Colors.black38,
                                                                ),
                                                              ),
                                                        ),
                                                         
                                                          // Padding(padding:const EdgeInsets.only(left: 10),
                                                          //   child: Text(
                                                          //     "Employee Id :${tds.eMPId ?? ""}",
                                                          //     style: TextStyle(
                                                          //         color: Colors.black38),
                                                          //   ),
                                                          // ),
                                                             Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          "Aadhar Number:${tds.aadharNumber ?? ""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                        ),
                                                        
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(left: 10),
                                                      //   child: Text(
                                                      //           'Joining Date : ${tds.joiningDate ?? ""}',
                                                      //           style: TextStyle(color: Colors.black38,
                                                      //           ),
                                                      //         ),
                                                      // ),
                                                       
                                                       
                                                        ],
                                                      ),
                                                      // Expanded(child: child)
                                                  
                                                    
                                                    ],
                                                  ),
                                                  // Divider(),
                                               
                                                  
                                                  Row(
                                                    children: [
                                                
                                              
                                                     
                                                      
                                                      // if (tds.faceImage ==
                                                      //     "https://rapi.railtech.co.in/")
                                                      //   InkWell(
                                                      //     // onTap: addFace,
                                                      //     onTap: () async { print("=====================?? ${filteredTeamMembers.length}   ${teamAttedanceModel!.tDS!.length}");
                                                      //       await facematcher.registerFaceLabour(
                                                      //           // teamAttedanceModel!
                                                      //           //     .tDS![index]
                                                      //           //     .labourId
                                                      //           //     .toString(),

                                                      //           filteredTeamMembers[index].labourId,
                                                      //           filteredTeamMembers[index].fullName.toString(),
                                                      //           // teamAttedanceModel!
                                                      //           //     .tDS![index]
                                                      //           //     .fullName
                                                      //           //     .toString(),

                                                      //           filteredTeamMembers[index].faceImage! != "" ? "" : filteredTeamMembers[index].faceImage!,
                                                      //           // teamAttedanceModel!
                                                      //           //             .tDS![
                                                      //           //                 index]
                                                      //           //             .faceImage !=
                                                      //           //         ""
                                                      //           //     ? ""
                                                      //           //     : teamAttedanceModel!
                                                      //           //         .tDS![
                                                      //           //             index]
                                                      //           //         .faceImage!
                                                                        
                                                      //       // await facematcher.registerFaceLabour(
                                                      //       //     teamAttedanceModel!
                                                      //       //         .tDS![index]
                                                      //       //         .labourId,
                                                                   
                                                      //       //     teamAttedanceModel!
                                                      //       //         .tDS![index]
                                                      //       //         .fullName
                                                      //       //         .toString(),
                                                      //       //     teamAttedanceModel!
                                                      //       //                 .tDS![index]
                                                      //       //                 .faceImage !=
                                                      //       //             ""
                                                      //       //         ? ""
                                                      //       //         : teamAttedanceModel!
                                                      //       //             .tDS![index]
                                                      //       //             .faceImage!
                                                      //                   );
                                                          
                                                      //     },
                                                      //     child: Container(
                                                      //       decoration:
                                                      //           BoxDecoration(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     5),
                                                      //         border:
                                                      //             Border.all(
                                                      //           color: Colors
                                                      //               .green,
                                                      //           width: 1.5,
                                                      //         ),
                                                      //       ),
                                                      //       child: Padding(
                                                      //         padding: EdgeInsets
                                                      //             .symmetric(
                                                      //                 horizontal:
                                                      //                     15,
                                                      //                 vertical:
                                                      //                     5),
                                                      //         child: Column(
                                                      //           children: [
                                                      //             Image.asset(
                                                      //               "assets/face2.png",
                                                      //               height: 40,
                                                      //             ),
                                                      //             SizedBox(
                                                      //                 height:
                                                      //                     5),
                                                      //             Text(
                                                      //               tds.faceImage ==
                                                      //                       "https://rapi.railtech.co.in/"
                                                      //                   ? "Register\nYour Face"
                                                      //                   : "Re-register\nYour Face",
                                                      //               textAlign:
                                                      //                   TextAlign
                                                      //                       .center,
                                                      //               style: TextStyle(
                                                      //                   fontSize:
                                                      //                       12,
                                                      //                   fontWeight:
                                                      //                       FontWeight.bold),
                                                      //             )
                                                      //           ],
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                   
                                                   
                                                    
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Divider()
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        )
            ],
          ),
        ),
      ),
    );
  }
}
