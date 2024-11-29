import 'dart:convert';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:face_liveness/face_liveness.dart';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class FaceLabpurRegister extends StatefulWidget {
  const FaceLabpurRegister({super.key});

  @override
  State<FaceLabpurRegister> createState() => _FaceLabpurRegisterState();
}

class _FaceLabpurRegisterState extends State<FaceLabpurRegister> {
  final currentDate = DateTime.now();
  FaceLiveness faceLiveness = FaceLiveness();

  // List<MultiFaceInput> allteamFaces = [];

  final TextEditingController searchController = TextEditingController();

  // void _makePhoneCall(String number) async {
  //   String url = 'tel:$number';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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

  String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "LabourId": null,
        "MarkedByUserId": null,
        "CostCenterId": costCenterId,
      }),
    );

    // print("Request URL: $url");
    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        teamAttedanceModel = LabourListModel.fromJson(jsonResponse);
        teamAttendanceModel.value = LabourListModel.fromJson(jsonResponse);
        
        // Filter only team members with a registered face image
        filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) =>
          member.faceImage != null &&
          member.faceImage!.isNotEmpty &&
          member.faceImage != "https://rapi.railtech.co.in/" &&
          member.status == "Approved" // Assuming 'status' is the field indicating approval
        ).toList() ?? [];

        // Sort filtered team members alphabetically by name (A to Z)
        filteredTeamMembers.value.sort((a, b) {
          // Compare the names of members (assuming member has a `name` or `fullName` field)
          return a.fullName?.toLowerCase().compareTo(b.fullName?.toLowerCase() ?? "") ?? 0;
        });
      });

      isLoading = false;
      // print("Successfully fetched: ${response.statusCode}");
    } else {
      // print("Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    // print("Error during fetching attendance report: $e");
    setState(() {
      isLoading = false;
    });
  }
}

//   Future<void> gatTeamMemberList() async {
//   String? empId = await getEmpBasicDetailId(); 
//     String? costCenterId = await setCostCenterId();
  
//   if (empId == null) {
//     print("Employee ID is null");
//     setState(() {
//       isLoading = false;
//     });
//     return;
//   }

//   String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>
//       {
    
//    "LabourId": null,
//            "MarkedByUserId": null,
//        "CostCenterId": costCenterId,

//       }),
//     );

//     print("Request URL: $url");
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${response.body}");

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       setState(() {
//         teamAttedanceModel = LabourListModel.fromJson(jsonResponse);
//         teamAttendanceModel.value = LabourListModel.fromJson(jsonResponse);
        
//         // Filter only team members with a registered face image
//      filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) =>
//     member.faceImage != null &&
//     member.faceImage!.isNotEmpty &&
//     member.faceImage != "https://rapi.railtech.co.in/" &&
//     member.status == "Approved" // Assuming 'status' is the field indicating approval
//   ).toList() ?? [];
//       });

      

//       isLoading = false;
//       print("Successfully fetched: ${response.statusCode}");
//     } else {
//       print("Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   } catch (e) {
//     print("Error during fetching attendance report: $e");
//     setState(() {
//       isLoading = false;
//     });
//   }
// }

  final facematcher = FaceMatcher.instance;

  // Future<void>
  //     matchFace() async {
  //   String?
  //       empId =
  //       await grtTeamEmpBasicId();
  //   await facematcher.matchFace(empId!);
  // }
TDS?tds;
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
      return member.faceImage != null &&
             member.faceImage!.isNotEmpty &&
             member.faceImage != "https://rapi.railtech.co.in/" &&
             member.status == "Approved";
             
    }).toList() ?? [];
  } else {
    filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
    
      bool matchesName = member.fullName
                          ?.toLowerCase()
                          .contains(name.toLowerCase()) ?? false;
      bool matchesOtherConditions = member.faceImage != null &&
                                    member.faceImage!.isNotEmpty &&
                                    member.faceImage != "https://rapi.railtech.co.in/" &&
                                    member.status == "Approved";
      return matchesName && matchesOtherConditions;
    }).toList() ?? [];
  }
}
@override
void initState() {
  super.initState();
  // Use async calls inside initState
  _initializeData();
}

Future<void> _initializeData() async {
  setState(() {
    isLoading = true;
  });
  await gatTeamMemberList();
  await displayFaceImage();
  setState(() {
    isLoading = false;
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
        title: Text('REGISTERED LABOUR  ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ).gradientBackground(withActions: true),
      body: SingleChildScrollView(
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
                : teamAttedanceModel?.status == "Failed"||filteredTeamMembers.every((member) => member.status != "Approved")
      
                    ? Column(
                        children: [
                          Image.asset("assets/nodataa.png"),
                          // Text(
                          //   "No any Team\nassigned for YOU",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black38),
                          // )
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
                                        // onTap: () {
                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => SingleEmpDetails(onedata: filteredTeamMembers[index])));
                                        //   // if (tds.faceImage!.isNotEmpty && tds.faceImage != "" && tds.faceImage != "https://rapi.railtech.co.in/") {
                                        //   // } else {
                                        //   //   "Please Register your face first".showToast();
                                        //   // }
                                        // },
      
                                        onTap: () {
                                          if (tds.faceImage!.isNotEmpty &&
                                              tds.faceImage != "" &&
                                              tds.faceImage !=
                                                  "https://rapi.railtech.co.in/") {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             SingleEmpDetails(
                                            //                 onedata:
                                            //                     filteredTeamMembers[
                                            //                         index],),),);
                                          } else {
                                            "Please Register your face first"
                                                .showToast();
                                          }
                                        },
                                        child: Card(
                                          shadowColor: teamAttedanceModel
                                                      ?.tDS?[index]
                                                      .fullName !=
                                                  ""
                                              ? Colors.green
                                              : Colors.red,
                                          // elevation: 3,
                                          shape: RoundedRectangleBorder(),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                          color: Colors.green,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  4.0),
                                                          child: InkWell(
                                                            onTap: () =>
                                                                _showImageDialog(
                                                                    context,
                                                                    tds.faceImage
                                                                        .toString()),
                                                            child: tds
                                                                        .faceImage!
                                                                        .isNotEmpty &&
                                                                    tds.faceImage !=
                                                                        "" &&
                                                                    tds.faceImage !=
                                                                        "https://rapi.railtech.co.in/"
                                                                ? ClipRRect(
                                                                    child: Image
                                                                        .network(
                                                                      (tds.faceImage
                                                                          .toString()),
                                                                      height:80,
                                                                      width:80,
                                                                      fit: BoxFit.fill,
                                                                    ),
                                                                  )
                                                                : Icon(
                                                                    Icons.person,
                                                                    size: 80,
                                                                    color: Colors.black26,
                                                                  ),
                                                          )),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(
                                                            "${tds.fullName ?? ""}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(
                                                            "EMP Id : ${tds.eMPId ?? ""}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38),
                                                          ),
                                                        ),
                                                          Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(left: 10),
                                                      child: Text(
                                                        "Father Name : ${tds.fatherName ?? ""}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black38),
                                                      ),
                                                    ),
                                                        Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(left: 10),
                                                      child: Text(
                                                        "Aadhar Number : ${tds.aadharNumber ?? ""}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black38),
                                                      ),
                                                    ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(left: 10),
                                                      //   child: Text(
                                                      //         'Joining Date : ${tds.joiningDate ?? ""}',
                                                      //         style: TextStyle(
                                                      //           color: Colors
                                                      //               .black38,
                                                      //         ),
                                                      //       ),
                                                      // )
                                                        
                                                     
                                                      ],
                                                    ),
                                                   
                                                  
                                                  ],
                                                ),
                                                // Divider(),
                                                Row(
                                                  children: [
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets
                                                    //           .only(left: 0),
                                                    //   child: Text(
                                                    //     "Adhar Number : ${tds.aadharNumber ?? ""}",
                                                    //     style: TextStyle(
                                                    //         color: Colors
                                                    //             .black38),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   "Working hrs : 09:00 hrs",
                                                          //   style: TextStyle(
                                                          //     color: Colors
                                                          //         .black38,
                                                          //   ),
                                                          // ),
                                                          SizedBox(height: 5),
                                                          // Text(
                                                          //   'Joining Date : ${tds.joiningDate ?? ""}',
                                                          //   style: TextStyle(
                                                          //     color: Colors
                                                          //         .black38,
                                                          //   ),
                                                          // ),
                                                          // SizedBox(height: 5),
                                                          
                                                          // SizedBox(height: 5),
                                                        ],
                                                      ),
                                                    ),
                                                    // 5.heightBox,
                                                    // SizedBox(height: 10),
                                                    
                                                    // if (tds.faceImage ==
                                                    //     "https://rapi.railtech.co.in/")
                                                    //   InkWell(
                                                    //     // onTap: addFace,
                                                    //     onTap: () async {
                                                    //       await facematcher.registerFace(
                                                    //           teamAttedanceModel!
                                                    //               .tDS![index]
                                                    //               .labourId
                                                    //               .toString(),
                                                    //           teamAttedanceModel!
                                                    //               .tDS![index]
                                                    //               .fullName
                                                    //               .toString(),
                                                    //           teamAttedanceModel!
                                                    //                       .tDS![
                                                    //                           index]
                                                    //                       .faceImage !=
                                                    //                   ""
                                                    //               ? ""
                                                    //               : teamAttedanceModel!
                                                    //                   .tDS![
                                                    //                       index]
                                                    //                   .faceImage!);
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
    );
  }
}
