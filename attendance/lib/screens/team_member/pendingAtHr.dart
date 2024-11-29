import 'dart:convert';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:faecauth/screens/model/single_team_mem_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:face_liveness/face_liveness.dart';
import 'package:faecauth/screens/team_member/team_attendance_model.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class PendingAtHR extends StatefulWidget {
  const PendingAtHR({super.key});

  @override
  State<PendingAtHR> createState() => _PendingAtHRState();
}

class _PendingAtHRState extends State<PendingAtHR> {
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
   Future<void> _removeFace() async {
    try {
      String? empId = await getEmpBasicDetailId();
      // String? empName = await getEmpName();
      const baseUrl = 'http://rapi.railtech.co.in/api/FaceRegistration/Remove';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, dynamic>{"EMP_BasicDetail_Id": empId, "UserId": empId}),
      );

      if (response.statusCode == 200) {
        // print("object===========>$responseData");
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          setState(() {});
        } else {
          // print("Error: ${responseData['Message']}");
        }
      } else {
        // print("Failed to load profile data");
      }
    } catch (e) {
      // print("Exception caught: $e");
    }
  }
 Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Face Remove "),
          content: Text("Are you sure you want to re-register your face?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
                onPressed: () async {
                  await _removeFace();

                  Navigator.of(context).pop();
                  setState(() {
                    // addFace();
                  });
                },
                child: Text("Retake")),
          ],
        );
      },
    );
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

  // List<TeamMemberListModel> filteredTeamMembers = [];
  TeamMemberDetailsModel? teamAttedanceModel;
    var report = SingleTeamMemberDetailsModel().obs;
  // RegisteredTeamFaceResponseModel? registeredTeamFaceResponseModel;

  bool isLoading = true;
  String? team_empId;
Future<void> gatTeamMemberList() async {
  String? empId = await getEmpBasicDetailId();
  
  if (empId == null) {
    // print("Employee ID is null");
    setState(() {
      isLoading = false;
    });
    return;
  }

  String url = 'http://rapi.railtech.co.in/api/TeamDetails/get';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "EMP_BasicDetail_Id": null,
        "MarkedByUserId": empId
      }),
    );

    // print("Request URL: $url");
    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        teamAttedanceModel = TeamMemberDetailsModel.fromJson(jsonResponse);
        teamAttendanceModel.value = TeamMemberDetailsModel.fromJson(jsonResponse);
        
        // Filter team members based on 'Pending' status and valid face image
        filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
          // Filter only team members with 'Pending' status and a valid face image
          return member.status == "Pending" && 
                 member.faceImage != null &&
                 member.faceImage!.isNotEmpty &&
                 member.faceImage != "https://rapi.railtech.co.in/";
        }).toList() ?? [];
      });
filteredTeamMembers.value.sort((a, b) {
          // Compare the names of members (assuming member has a `name` or `fullName` field)
          return a.fullName?.toLowerCase().compareTo(b.fullName?.toLowerCase() ?? "") ?? 0;
        });
      if (filteredTeamMembers.isNotEmpty) {
        await setTeamEmpBasicId(filteredTeamMembers[0].eMPBasicDetailId.toString());
        await setTeamEmpName(filteredTeamMembers[0].fullName.toString());
      }

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

  // Map<DateTime, bool> attendanceMap = {};
  //   Map<DateTime, bool> getAttendanceStatus(SingleTeamMemberDetailsModel model) {
  //   Map<DateTime, bool> attendanceMap = {};

  //   if (model.ePRE != null) {
  //     for (var ePRE in model.ePRE!) {
  //       if (ePRE.attStatus == 'Present') {
  //         DateTime punchDate = DateFormat("dd/MM/yyyy").parse(ePRE.punchDate!);
  //         attendanceMap[punchDate] = true;
  //       } else {
  //         DateTime punchDate = DateFormat("dd/MM/yyyy").parse(ePRE.punchDate!);
  //         attendanceMap[punchDate] = false;
  //       }
  //     }
  //   }

  //   return attendanceMap;
  // }

  final facematcher = FaceMatcher.instance;

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
  var teamAttendanceModel = TeamMemberDetailsModel().obs;
  void filterTeamMembers(String name) {
  if (name.isEmpty) {
    filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
      return member.status == "Pending" && 
                 member.faceImage != null &&
                 member.faceImage!.isNotEmpty &&
                 member.faceImage != "https://rapi.railtech.co.in/"; 
             
    }).toList() ?? [];
  } else {
    filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) {
    
      bool matchesName = member.fullName
                          ?.toLowerCase()
                          .contains(name.toLowerCase()) ?? false;
      bool matchesOtherConditions =member.status == "Pending" && 
                 member.faceImage != null &&
                 member.faceImage!.isNotEmpty &&
                 member.faceImage != "https://rapi.railtech.co.in/";
      return matchesName && matchesOtherConditions;
    }).toList() ?? [];
  }
}


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
        title: Text('PENDING ',
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
                  : teamAttedanceModel?.status == "Failed"||filteredTeamMembers.every((member) => member.status != "Pending")

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
                                        InkWell(onTap: () {
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
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(),
                                            child: Padding(padding:const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:BoxDecoration(
                                                          borderRadius:BorderRadius.circular(5),
                                                          border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        child: Padding(padding:
                                                                EdgeInsets.all(4.0),
                                                            child: InkWell(
                                                              onTap: () =>
                                                                  _showImageDialog(context,tds.faceImage.toString()),
                                                              child: tds.faceImage!.isNotEmpty &&
                                                                      tds.faceImage !="" &&
                                                                      tds.faceImage !="https://rapi.railtech.co.in/"
                                                                  ? ClipRRect(
                                                                      child: Image.network(
                                                                        (tds.faceImage.toString()),
                                                                        height:90,
                                                                        width:80,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    )
                                                                  : Icon(
                                                                      Icons.person,
                                                                      size: 70,
                                                                      color: Colors.black26,
                                                                    ),
                                                            )),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:CrossAxisAlignment.start,
                                                        mainAxisAlignment:MainAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding:const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "${tds.fullName ?? ""}",
                                                              style: TextStyle(fontWeight:FontWeight.bold),
                                                            ),
                                                          ),
                                                          Padding(padding:const EdgeInsets.only(left: 10),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "${tds.designation ?? "" } ",
                                                                  style: TextStyle(color: Colors.black38),
                                                                ),
                                                                
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                            "Employee Id : ${tds.eMPKey ?? ""}",
                                                            style: TextStyle(color: Colors.black38),
                                                                                                                    ),
                                                          ),
                                                      
                                                          Padding(padding:const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "Mobile No:  ${tds.mobile ?? ""}",
                                                              style: TextStyle(color: Colors.black38),
                                                            ),
                                                          ),
                                                             Padding(padding:const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "Aadhar Number:  ${ ""}",
                                                              style: TextStyle(color: Colors.black38),
                                                            ),
                                                          ),
                                                           Padding(
                                                             padding: const EdgeInsets.only(left: 10),
                                                             child: Text(
                                                                'Joining Date : ${tds.joiningDate ?? ""}',
                                                                style: TextStyle(color: Colors.black38,
                                                                ),
                                                              ),
                                                           ),
                                                          // Padding(padding:EdgeInsets.only(left: 10),
                                                          //   child: Row(
                                                          //     children: [
                                                          //       Text(
                                                          //         "Cost Center : ",
                                                          //         style: TextStyle(color: Colors.black38),
                                                          //       ),
                                                          //       Text(
                                                          //         "",
                                                          //         style: TextStyle(color: Colors.black38),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          // Padding(
                                                          //   padding:
                                                          //       EdgeInsets.only(
                                                          //           left: 10),
                                                          //   child: Row(
                                                          //     children: [
                                                          //       Text(
                                                          //         "Tender Id : ",
                                                          //         style: TextStyle(color: Colors.black38),
                                                          //       ),
                                                          //       Text(
                                                          //         "",
                                                          //         style: TextStyle(color: Colors.black38),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      // Spacer(),
                                                      // Card(
                                                      //   color: Colors.green.shade300,
                                                      //   child: IconButton(
                                                      //     onPressed: () {_makePhoneCall(tds.mobile ??"");
                                                      //     },
                                                      //     icon: Icon(Icons.call,color: Colors.white,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  // Divider(),
                                                  // Row(
                                                  //   children: [Padding(  padding:const EdgeInsets.only(left: 0),
                                                  //       child:
                                                  //        Text(
                                                  //         "Employee Id : ${tds.eMPKey ?? ""}",
                                                  //         style: TextStyle(color: Colors.black38),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                              
                                                  // SizedBox(height: 5),
                                                  // Row(
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                                  //         children: [
                                                  //           // Text(
                                                  //           //   "Working hrs : 09:00 hrs",
                                                  //           //   style: TextStyle(color: Colors.black38,
                                                  //           //   ),
                                                  //           // ),
                                                  //           // SizedBox(height: 5),
                                                  //           // Text(
                                                  //           //   'Joining Date : ${tds.joiningDate ?? ""}',
                                                  //           //   style: TextStyle(color: Colors.black38,
                                                  //           //   ),
                                                  //           // ),
                                                  //           // SizedBox(height: 5),
                                                  //           // Text(
                                                  //           //   'Location : ${tds.companyName ?? ""}',
                                                  //           //   style: TextStyle(color: Colors.black38,
                                                  //           //   ),
                                                  //           // ),
                                                  //           // SizedBox(height: 5),
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //     // 5.heightBox,
                                                  //     // SizedBox(height: 10),
                                                      
                                                  //     // if (tds.faceImage ==
                                                  //     //     "https://rapi.railtech.co.in/")
                                                  //     //   InkWell(
                                                  //     //     // onTap: addFace,
                                                  //     //     onTap: () async {
                                                  //     //       await facematcher.registerFace(
                                                  //     //           teamAttedanceModel!.tDS![index].eMPBasicDetailId.toString(),
                                                  //     //           teamAttedanceModel!.tDS![index].fullName.toString(),
                                                  //     //           teamAttedanceModel!.tDS![index].faceImage !=""?"": teamAttedanceModel!.tDS![index].faceImage!
                                                  //     //           );
                                                  //     //     },
                                                  //     //     child: Container(
                                                  //     //       decoration:BoxDecoration(
                                                  //     //         borderRadius:BorderRadius.circular(5),
                                                  //     //         border:Border.all(
                                                  //     //           color: Colors.green,
                                                  //     //           width: 1.5,
                                                  //     //         ),
                                                  //     //       ),
                                                  //     //       child: Padding(
                                                  //     //         padding: EdgeInsets.symmetric(horizontal:15,
                                                  //     //                 vertical:5),
                                                  //     //         child: Column(
                                                  //     //           children: [
                                                  //     //             Image.asset(
                                                  //     //               "assets/face2.png",
                                                  //     //               height: 40,
                                                  //     //             ),
                                                  //     //             SizedBox(height:5),
                                                  //     //             Text(
                                                  //     //               tds.faceImage =="https://rapi.railtech.co.in/"
                                                  //     //                   ? "Register\nYour Face"
                                                  //     //                   : "Re-register\nYour Face",
                                                  //     //               textAlign:
                                                  //     //                   TextAlign
                                                  //     //                       .center,
                                                  //     //               style: TextStyle(
                                                  //     //                   fontSize:
                                                  //     //                       12,
                                                  //     //                   fontWeight:
                                                  //     //                       FontWeight.bold),
                                                  //     //             )
                                                  //     //           ],
                                                  //     //         ),
                                                  //     //       ),
                                                  //     //     ),
                                                  //     //   ),
                                                   
                                                   
                                                    
                                                  //   ],
                                                 
                                                  // ),
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