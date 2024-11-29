import 'dart:async';
import 'dart:convert';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/extension/string_ext.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:face_liveness/face_liveness.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/team_member/team_attendance_model.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class TeamUnRegisterFace extends StatefulWidget {
  const TeamUnRegisterFace({super.key});

  @override
  State<TeamUnRegisterFace> createState() => _TeamUnRegisterFaceState();
}

class _TeamUnRegisterFaceState extends State<TeamUnRegisterFace> {
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
                  filteredTeamMembers
                        .every((member) => member.status != "Rejected")
                    ? (img.isNotEmpty &&
                            img != "" &&
                            img != "https://rapi.railtech.co.in/")
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                img,
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
                // img.isNotEmpty &&
                //         img != "" &&
                //         img != "https://rapi.railtech.co.in/"
                //     ? Container(
                //         height: MediaQuery.of(context).size.height * 0.5,
                //         width: MediaQuery.of(context).size.width,
                //         child: ClipRRect(
                //           child: Image.network(
                //             (img),
                //             height: 70,
                //             width: 70,
                //             fit: BoxFit.fill,
                //           ),
                //         ),
                //       )
                //     : Container(
                //         height: MediaQuery.of(context).size.height * 0.5,
                //         width: MediaQuery.of(context).size.width,
                //         child: Icon(
                //           Icons.person,
                //           size: 100,
                //           color: Colors.black26,
                //         ),
                //       ),
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
  // RegisteredTeamFaceResponseModel? registeredTeamFaceResponseModel;

  bool isLoading = true;
  String? team_empId;


Future<void> gatTeamMemberList() async {
  String? empId = await getEmpBasicDetailId();

  if (empId == null) {
    print("Employee ID is null");
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
      body: jsonEncode(<String, dynamic>
      {
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
        
        // Filter only team members without a registered face image
        filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) =>
          member.status == null ||
          member.status=="Rejected"||
          
          member.faceImage == "https://rapi.railtech.co.in/").toList() ?? [];
      });
filteredTeamMembers.value.sort((a, b) {
          // Compare the names of members (assuming member has a `name` or `fullName` field)
          return a.fullName?.toLowerCase().compareTo(b.fullName?.toLowerCase() ?? "") ?? 0;
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

  // Future<void> displayFaceImage() async {
  //   MultiFaceInput? faceData = await getFaceDataByEmpId();

  //   if (faceData != null) {
  //     imageWidget = Image.memory(
  //       base64Decode(faceData.imageBase64),
  //       height: 70,
  //       width: 70,
  //       fit: BoxFit.fill,
  //     );
  //   } else {
  //     imageWidget = Icon(
  //       Icons.person,
  //       size: 70,
  //       color: Colors.black38,
  //     );
  //   }

  //   setState(() {});
  // }

  var filteredTeamMembers = <TDS>[].obs;
  var teamAttendanceModel = TeamMemberDetailsModel().obs;

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
            actions: [
              TextButton(
                onPressed: () {
                  timer?.cancel();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
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
      // await displayFaceImage();
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
        title: Text('UNREGISTERED STAFF',
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
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 5,  vertical: 5),
                                              child: Column(
                                                children: [
                                                  Row(children: [  Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(5),
                                                  // border: Border.all(
                                                  //           color: Colors.green,
                                                  //           width: 1.5,
                                                  //         ),
                                                        ),
                                                        child: Padding(padding:EdgeInsets.all(2.0),child: InkWell(
                                                              onTap: () =>
                                                                  _showImageDialog(
                                                                      context,
                                                                      tds.faceImage.toString()),
                                                              child: tds.faceImage!.isNotEmpty &&
                                                                      tds.faceImage !="" &&
                                                                      tds.faceImage !="https://rapi.railtech.co.in/"&& tds.status!="Rejected"||tds.faceImage==""
                                                                  ? ClipRRect(
                                                                      child: Image.network(
                                                                        (tds.faceImage  .toString()),
                                                                        height:80,
                                                                        width:80,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    )
                                                                  :   InkWell(
                                                          // onTap: addFace,
                                                          onTap: () async {
                                                             showCountdownDialog(context, 5);
                                                            //  print("=====================?? ${filteredTeamMembers.length}   ${teamAttedanceModel!.tDS!.length}");
                                                              showCountdownDialog(context, 5);
                                                            await facematcher.registerFaceTeam(
                                                                
                                              
                                                                filteredTeamMembers[index].eMPBasicDetailId,
                                                                filteredTeamMembers[index].fullName.toString(),
                                                                
                                                                filteredTeamMembers[index].faceImage! != "" ? "" : filteredTeamMembers[index].faceImage!,
                                                            );
                                                                
                                                            // await facematcher.registerFaceTeam(
                                                            //     teamAttedanceModel!
                                                            //         .tDS![index]
                                                            //         .eMPBasicDetailId,
                                                                   
                                                            //     teamAttedanceModel!
                                                            //         .tDS![index]
                                                            //         .fullName
                                                            //         .toString(),
                                                            //     teamAttedanceModel!
                                                            //                 .tDS![
                                                            //                     index]
                                                            //                 .faceImage !=
                                                            //             ""
                                                            //         ? ""
                                                            //         : teamAttedanceModel!
                                                            //             .tDS![  index]
                                                            //             .faceImage!
                                                            //             );
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
                                                                    height: 75,
                                                                    width: 70,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
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
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        children: [
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
                                                               Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          "EMP ID: ${tds.eMPKey ?? ""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                        ),
                                                      ),
                                                        Padding(padding:const EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              "${tds.designation ?? ""}",
                                                              style: TextStyle(
                                                                  color: Colors.black38),
                                                            ),
                                                          ),
                                                            
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Text(
                                                              "Mobile No:  ${tds.mobile ?? ""}",
                                                              style: TextStyle(
                                                                  color: Colors.black38),
                                                            ),
                                                          ),
                                                          
                                                           Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Text(
                                                              "Father Name:  ${ tds.fathername??""}",
                                                              style: TextStyle(
                                                                  color: Colors.black38),
                                                            ),
                                                          ),
                                                            Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Text(
                                                              "Aadhar Number:  ${ tds.adharNumber??""}",
                                                              style: TextStyle(
                                                                  color: Colors.black38),
                                                            ),
                                                          ),
                                                            Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left:10),
                                                        child: Text(
                                                          "Joining Date : ${tds.joiningDate ?? ""}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                        ),
                                                      ),
                                                            ],
                                                          ),
                                                            
                                                          
                                                        
                                                        
                                                          
                                                         
                                                                                                           
                                                          // Padding(
                                                          //   padding:
                                                          //       EdgeInsets.only(
                                                          //           left: 10),
                                                          //   child: Row(
                                                          //     children: [
                                                          //       Text(
                                                          //         "Cost Center : ",
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .black38),
                                                          //       ),
                                                          //       Text(
                                                          //         "",
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .black38),
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
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .black38),
                                                          //       ),
                                                          //       Text(
                                                          //         "",
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .black38),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          SizedBox(width: 10,),
                                                          Card(
                                                          color: Colors
                                                              .green.shade300,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              _makePhoneCall(
                                                                  tds.mobile ??
                                                                      "");
                                                            },
                                                            icon: Icon(
                                                              Icons.call,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                                                                           ],
                                                        
                                                      ),
                                                      // Spacer(),
                                                      //   if (tds.faceImage ==
                                                      //     "https://rapi.railtech.co.in/")
                                                      //   InkWell(
                                                      //     // onTap: addFace,
                                                      //     onTap: () async {
                                                      //        print("=====================?? ${filteredTeamMembers.length}   ${teamAttedanceModel!.tDS!.length}");
                                                      //       await facematcher.registerFaceTeam(
                                                                
                                              
                                                      //           filteredTeamMembers[index].eMPBasicDetailId,
                                                      //           filteredTeamMembers[index].fullName.toString(),
                                                                
                                                      //           filteredTeamMembers[index].faceImage! != "" ? "" : filteredTeamMembers[index].faceImage!,
                                                      //       );
                                                                
                                                      //       // await facematcher.registerFaceTeam(
                                                      //       //     teamAttedanceModel!
                                                      //       //         .tDS![index]
                                                      //       //         .eMPBasicDetailId,
                                                                   
                                                      //       //     teamAttedanceModel!
                                                      //       //         .tDS![index]
                                                      //       //         .fullName
                                                      //       //         .toString(),
                                                      //       //     teamAttedanceModel!
                                                      //       //                 .tDS![
                                                      //       //                     index]
                                                      //       //                 .faceImage !=
                                                      //       //             ""
                                                      //       //         ? ""
                                                      //       //         : teamAttedanceModel!
                                                      //       //             .tDS![  index]
                                                      //       //             .faceImage!
                                                      //       //             );
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
                                                   
                                                   
                                                    
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(left: 0),
                                                      //   child: Card(
                                                      //     color: Colors
                                                      //         .green.shade300,
                                                      //     child: IconButton(
                                                      //       onPressed: () {
                                                      //         _makePhoneCall(
                                                      //             tds.mobile ??
                                                      //                 "");
                                                      //       },
                                                      //       icon: Icon(
                                                      //         Icons.call,
                                                      //         color: Colors.white,
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  // Divider(),
                                                  // Row(
                                                  //   children: [
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 0),
                                                  //       child: Text(
                                                  //         "Employee Id : ${tds.eMPKey ?? ""}",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .black38),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  //   Row(
                                                  //   children: [
                                                  //     Padding(
                                                  //       padding:
                                                  //           const EdgeInsets
                                                  //               .only(left: 0),
                                                  //       child: Text(
                                                  //         "Joining Date : ${tds.joiningDate ?? ""}",
                                                  //         style: TextStyle(
                                                  //             color: Colors
                                                  //                 .black38),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  SizedBox(height: 5),
                                                  // Row(
                                                  //   children: [
                                                  //     Expanded(
                                                  //       flex: 3,
                                                  //       child: Column(
                                                  //         crossAxisAlignment:
                                                  //             CrossAxisAlignment
                                                  //                 .start,
                                                  //         children: [
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
                                                  //     5.heightBox,
                                                  //     SizedBox(height: 10),
                                                      
                                                  //     // if (tds.faceImage ==
                                                  //     //     "https://rapi.railtech.co.in/")
                                                  //     //   InkWell(
                                                  //     //     // onTap: addFace,
                                                  //     //     onTap: () async {
                                                  //     //        print("=====================?? ${filteredTeamMembers.length}   ${teamAttedanceModel!.tDS!.length}");
                                                  //     //       await facematcher.registerFaceTeam(
                                                                
                                              
                                                  //     //           filteredTeamMembers[index].eMPBasicDetailId,
                                                  //     //           filteredTeamMembers[index].fullName.toString(),
                                                                
                                                  //     //           filteredTeamMembers[index].faceImage! != "" ? "" : filteredTeamMembers[index].faceImage!,
                                                  //     //       );
                                                                
                                                  //     //       // await facematcher.registerFaceTeam(
                                                  //     //       //     teamAttedanceModel!
                                                  //     //       //         .tDS![index]
                                                  //     //       //         .eMPBasicDetailId,
                                                                   
                                                  //     //       //     teamAttedanceModel!
                                                  //     //       //         .tDS![index]
                                                  //     //       //         .fullName
                                                  //     //       //         .toString(),
                                                  //     //       //     teamAttedanceModel!
                                                  //     //       //                 .tDS![
                                                  //     //       //                     index]
                                                  //     //       //                 .faceImage !=
                                                  //     //       //             ""
                                                  //     //       //         ? ""
                                                  //     //       //         : teamAttedanceModel!
                                                  //     //       //             .tDS![  index]
                                                  //     //       //             .faceImage!
                                                  //     //       //             );
                                                  //     //     },
                                                  //     //     child: Container(
                                                  //     //       decoration:
                                                  //     //           BoxDecoration(
                                                  //     //         borderRadius:
                                                  //     //             BorderRadius
                                                  //     //                 .circular(
                                                  //     //                     5),
                                                  //     //         border:
                                                  //     //             Border.all(
                                                  //     //           color: Colors
                                                  //     //               .green,
                                                  //     //           width: 1.5,
                                                  //     //         ),
                                                  //     //       ),
                                                  //     //       child: Padding(
                                                  //     //         padding: EdgeInsets
                                                  //     //             .symmetric(
                                                  //     //                 horizontal:
                                                  //     //                     15,
                                                  //     //                 vertical:
                                                  //     //                     5),
                                                  //     //         child: Column(
                                                  //     //           children: [
                                                  //     //             Image.asset(
                                                  //     //               "assets/face2.png",
                                                  //     //               height: 40,
                                                  //     //             ),
                                                  //     //             SizedBox(
                                                  //     //                 height:
                                                  //     //                     5),
                                                  //     //             Text(
                                                  //     //               tds.faceImage ==
                                                  //     //                       "https://rapi.railtech.co.in/"
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
                                        Divider()
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
