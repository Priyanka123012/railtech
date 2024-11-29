// import 'dart:convert';
// import 'package:face_liveness/face_liveness.dart';
// import 'package:face_liveness/models/multi_face_input.dart';
// import 'package:faecauth/classess/face_matcher.dart';
// import 'package:faecauth/common/api_collections.dart';
// import 'package:faecauth/screens/home_page_screen.dart';
// import 'package:faecauth/screens/image_viewer.dart';
// import 'package:faecauth/screens/model/get_all_registered_faces.dart';
// import 'package:faecauth/screens/model/single_team_mem_model.dart';
// import 'package:faecauth/screens/model/total_present_absent_model.dart';
// import 'package:faecauth/screens/view_calendar_team_member.dart';
// import 'package:faecauth/utils/appHelper/app_helper_function.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart'
//     as http;
// import 'package:faecauth/extension/appbar_ext.dart';
// import 'package:faecauth/screens/team_member/team_attendance_model.dart';

// class SingleEmpDetails
//     extends StatefulWidget {
// final TDS
//     onedata;
//   const SingleEmpDetails(
//       {Key? key,
//       required this.onedata})
//       : super(key: key);

//   @override
//   State<SingleEmpDetails> createState() =>
//       _SingleEmpDetailsState();
// }

// class _SingleEmpDetailsState
//     extends State<SingleEmpDetails> {
//   final currentDate =
//       DateTime.now();
//   FaceLiveness
//       faceLiveness =
//       FaceLiveness();

//   List<MultiFaceInput>
//       allteamFaces =
//       [];

//   final TextEditingController
//       searchController =
//       TextEditingController();
//   bool
//       isLoading =
//       true;

//   Future<void>
//       init() async {
//     await faceLiveness.initAnalyzer();
//   }

//   Future<MultiFaceInput?>
//       addFace() async {
//     final response =
//         await faceLiveness.caputeFaceLiveness();
//     if (response != null &&
//         response.isLive &&
//         response.imageBase64 != null) {
//       MultiFaceInput data = MultiFaceInput(
//         imageName: "person_${allteamFaces.length + 1}",
//         imageBase64: response.imageBase64!,
//       );
//       allteamFaces.add(data);
//       return data;
//     }
//     return null;
//   }

//   final facematcher =
//       FaceMatcher.instance;

//   Future<String?>
//       getEmpName() async {
//     final prefs =
//         await SharedPreferences.getInstance();
//     return prefs.getString('empName');
//   }

//   Future<void>
//       matchFace() async {
//     facematcher.matchFace(widget.onedata.eMPBasicDetailId!);
//   }

//   Future<MultiFaceInput?>
//       getFaceDataByImageUrl(dynamic json) async {
//     // managerId =
//     //     await getManagerId();
//     String?
//         empId =
//         await getEmpBasicDetailId();
//     String?
//         empName =
//         await getEmpName();
//     if (json
//         is! Map<String, dynamic>)
//       return null;
//     setState(() {
//       faceImage64 = json['FaceImage64'];
//     });
//     String
//         faceImageURL =
//         json['FaceImage'];
//     if ((faceImage64 == null || faceImage64!.isEmpty) &&
//         faceImageURL.isNotEmpty) {
//       faceImage64 = await AppHelperFunction.downloadImageByUrl(faceImageURL);
//     } else {
//       faceImage64 = await AppHelperFunction.downloadImageByUrl("assets/face2.png");
//     }
//     if (faceImage64 == null ||
//         faceImage64!.isEmpty) {
//       return null;
//     }
//     // json['imageName'] = faceImageURL.split("/").last;
//     json['imageName'] =
//         empName;
//     json['imageBase64'] =
//         faceImage64;
//     // json['empId'] = json['EMPKey'];
//     json['empId'] =
//         widget.onedata.eMPBasicDetailId!;
//     return MultiFaceInput.fromJson(json);
//   }

//   Future<void>
//       getregisteredface() async {
//     String?
//         empId =
//         await getEmpBasicDetailId();
//     if (empId ==
//         null) {
//       print("EMP_BasicDetail_Id not found");
//       return;
//     }
//     String
//         url =
//         ApiUrls.matchRegisteredFace;
//     Map<String, dynamic>
//         data =
//         {
//       "FaceRegistrationId": "",
//       "EMP_BasicDetail_Id": widget.onedata.eMPBasicDetailId!,
//       "FullName": null,
//       "EMPKey": null,
//       "FaceImage": null,
//       "Location": null,
//       "Status": null,
//       "MarkedByUserId": empId
//     };
//     //     {
//     //   "FaceRegistrationId": null,
//     //   "EMP_BasicDetail_Id": empId,
//     //   "FullName": null,
//     //   "EMPKey": null,
//     //   "FaceImage": null,
//     //   "Location": null,
//     // };
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(data),
//       );
//       print({
//         "response.body",
//         response.body
//       });

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         print("jsonResponseskjdhksjhs${jsonResponse}");

//         setState(() {
//           registeredFaceResponseModel.value = GetAllRegisteredFaceModel.fromJson(jsonResponse);
//           print("jsonResponseskjdhksjhs${registeredFaceResponseModel.value}");
//         });

//         if (jsonResponse['FRV'] != null && jsonResponse['FRV'] is List) {
//           List<dynamic> frvList = jsonResponse['FRV'] ?? [];

//           final allFutures = frvList.map((e) => getFaceDataByImageUrl(e));
//           final result = await Future.wait(allFutures);
//           for (var x in result) {
//             setState(() {
//               if (x != null && !allFaces.contains(x)) {
//                 allFaces.add(x);
//               }
//             });
//           }
//         } else {
//           print("No faces found in the response.");
//         }
//       } else {
//         print("Failed to fetch faces: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching faces: $e");
//     }
//   }

//   void _makePhoneCall(
//       String number) async {
//     String
//         url =
//         'tel:$number';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<String?>
//       getEmpBasicDetailId() async {
//     final prefs =
//         await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }

//   Future<String?>
//       getTeamEmpBasicDetailId() async {
//     final prefs =
//         await SharedPreferences.getInstance();
//     return prefs.getString('team_empId');
//   }

//   TotalPresentAbsentModel?
//       totalPresentAbsent;

//   Future<void>
//       getTotalPresentAbsent() async {
//     String?
//         empId =
//         await getEmpBasicDetailId();
//     if (empId ==
//         null) {
//       print("Employee ID is null");
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     String
//         url =
//         'http://rapi.railtech.co.in/api/TeamEMPPunch/getTotalPresentAbsent';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "EMP_BasicDetail_Id": widget.onedata.eMPBasicDetailId,
//           "FullName": null,
//           "EMPKey": null,
//           "DepartmentHead": null,
//           "CostCenterName": null,
//           "TotalPresent": null,
//           "TotalAbsent": null,
//           "Month": "07",
//           "Year": "2024",
//           "MarkedByUserId": empId
//         }),
//       );

//       print("Request URL: $url");
//       print("Response status: ${response.statusCode}");
//       print("Response bonnnndy: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         setState(() {
//           totalPresentAbsent = TotalPresentAbsentModel.fromJson(jsonResponse);
//           isLoading = false;
//           print("Successfully fetched: ${totalPresentAbsent!.ePA!.totalAbsent} absent");
//         });
//       } else {
//         print("Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error during fetching attendance report: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _showImageDialog(
//       BuildContext context,
//       String img) async {
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
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.5,
//                   width: MediaQuery.of(context).size.width,
//                   child: ClipRRect(
//                     child: Image.network(
//                       (img),
//                       height: 70,
//                       width: 70,
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<String?>
//       grtTeamEmpBasicId() async {
//     final SharedPreferences
//         prefs =
//         await SharedPreferences.getInstance();
//     return prefs.getString('team_empId');
//   }

//   SingleTeamMemberDetailsModel?
//       report;

//   Future<void>
//       fetchTeamAttendanceReport() async {
//     String?
//         empId =
//         await grtTeamEmpBasicId();
//     if (empId ==
//         null) {
//       print("Employee ID is null");
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     String
//         url =
//         'http://rapi.railtech.co.in/api/TeamEMPPunch/getPunchReportEmployee';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "EMP_BasicDetail_Id": widget.onedata.eMPBasicDetailId,
//           "MarkedByUserId": null,
//           "PunchDateTime": null
//         }),
//       );

//       print("Request URL: $url");
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);

//         setState(() {
//           report = SingleTeamMemberDetailsModel.fromJson(jsonResponse);
//           isLoading = false;
//           print("Successfully fetched: ${report!.ePRE![0].eMPBasicDetailId}");
//         });
//       } else {
//         print("Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error during fetching attendance report: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void
//       initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) async {
//       await getregisteredface();
//       await getTotalPresentAbsent();
//       await fetchTeamAttendanceReport();
//     });
//   }

//   @override
//   void
//       dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget
//       build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         await fetchTeamAttendanceReport();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           title: Text(widget.onedata.fullName!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => HeatMapCalendars(
//                               report: report,
//                               name: widget.onedata.fullName ?? "",
//                             )));
//               },
//               icon: Icon(Icons.calendar_month),
//             )
//           ],
//         ).gradientBackground(withActions: true),
//         body: RefreshIndicator(
//           onRefresh: () async {},
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 5),
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             InkWell(
//                               onTap: () {},
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                     color: Colors.green,
//                                     width: 1.5,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(4.0),
//                                   child: InkWell(
//                                     onTap: () => _showImageDialog(context, widget.onedata.faceImage.toString()),
//                                     child: widget.onedata.faceImage!.isNotEmpty && widget.onedata.faceImage != "" && widget.onedata.faceImage != "https://rapi.railtech.co.in/"
//                                         ? ClipRRect(
//                                             child: Image.network(
//                                               (widget.onedata.faceImage.toString()),
//                                               height: 70,
//                                               width: 70,
//                                               fit: BoxFit.fill,
//                                             ),
//                                           )
//                                         : Icon(
//                                             Icons.person,
//                                             size: 70,
//                                             color: Colors.black26,
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     widget.onedata.fullName!,
//                                     style: TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     widget.onedata.designation ?? "",
//                                     style: TextStyle(color: Colors.black38),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     "Mobile No:  ${widget.onedata.mobile ?? ""}",
//                                     style: TextStyle(color: Colors.black38),
//                                   ),
//                                 ),
//                                 Visibility(
//                                   visible: widget.onedata.email != null,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 10),
//                                     child: Text(
//                                       "Email Id:  ${widget.onedata.email ?? ""}",
//                                       style: TextStyle(color: Colors.black38),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             5.widthBox,
//                             Spacer(),
//                             GestureDetector(
//                               onTap: matchFace,
//                               child: Card(
//                                 elevation: 3,
//                                 color: Colors.orange,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                                   child: Center(
//                                       child: Text(
//                                     textAlign: TextAlign.center,
//                                     "Punch\nNow",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Divider(),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "Joining Date : ${widget.onedata.joiningDate ?? ""}",
//                                   style: TextStyle(color: Colors.black38),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   "DepartmentHead :  ${widget.onedata.departmentHead ?? ""}",
//                                   style: TextStyle(color: Colors.black38),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   "State :  ${widget.onedata.state ?? ""}",
//                                   style: TextStyle(color: Colors.black38),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 Text(
//                                   "Total Working hrs : 129:35 hrs",
//                                   style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Card(
//                           elevation: 3,
//                           shape: RoundedRectangleBorder(),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Present = ",
//                                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   "${totalPresentAbsent?.ePA?.totalPresent} days",
//                                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
//                                 ),
//                                 15.widthBox,
//                                 Container(
//                                   height: 20,
//                                   width: 2,
//                                   color: Colors.black38,
//                                 ),
//                                 15.widthBox,
//                                 Text(
//                                   "Absent = ",
//                                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//                                 ),
//                                 Spacer(),
//                                 Text(
//                                   "${totalPresentAbsent?.ePA?.totalAbsent} days",
//                                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//                                 ),
//                                 5.widthBox,
//                               ],
//                             ),
//                           ),
//                         ),
//                         // SizedBox(height: 10),
//                         // TextField(
//                         //   controller: searchController,
//                         //   keyboardType: TextInputType.datetime,
//                         //   decoration: InputDecoration(
//                         //     labelText: "Search by Date",
//                         //     labelStyle: TextStyle(color: Colors.green),
//                         //     contentPadding: EdgeInsets.all(10),
//                         //     focusedBorder: OutlineInputBorder(
//                         //         borderSide:
//                         //             BorderSide(color: Colors.green, width: 2)),
//                         //     prefixIcon: Icon(Icons.search),
//                         //     border: OutlineInputBorder(
//                         //       borderRadius: BorderRadius.circular(8),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 report?.ePRE?.length == 0
//                     ? Image.asset("assets/nodataa.png")
//                     : Container(
//                         height: Get.height * 0.6,
//                         child: ListView.builder(
//                           itemCount: report?.ePRE?.length,
//                           itemBuilder: (BuildContext context, index) {
//                             EPRE epre = report!.ePRE![index];

//                             return Column(
//                               children: [
//                                 epre.firstLocation == ""
//                                     ? Image.asset("assets/nodataa.png")
//                                     : Card(
//                                         elevation: 3,
//                                         shape: RoundedRectangleBorder(),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               if (epre.attStatus != "Present" && epre.firstLocation != "" && widget.onedata.faceImage!.isNotEmpty && widget.onedata.faceImage != "" && widget.onedata.faceImage != "https://rapi.railtech.co.in/")
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 10),
//                                                   child: GestureDetector(
//                                                     onTap: matchFace,
//                                                     child: Card(
//                                                       elevation: 3,
//                                                       color: Colors.orange,
//                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                                                         child: Center(
//                                                             child: Text(
//                                                           "Punch In",
//                                                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                                         )),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               if (epre.attStatus != "Present" && epre.firstLocation != "" && widget.onedata.faceImage!.isNotEmpty && widget.onedata.faceImage != "" && widget.onedata.faceImage != "https://rapi.railtech.co.in/")
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 10),
//                                                   child: GestureDetector(
//                                                     onTap: matchFace,
//                                                     child: Card(
//                                                       elevation: 3,
//                                                       color: Colors.orange,
//                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                                                         child: Center(
//                                                           child: Text(
//                                                             "Punch out",
//                                                             style: TextStyle(
//                                                               color: Colors.white,
//                                                               fontWeight: FontWeight.bold,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               Expanded(
//                                                 flex: 3,
//                                                 child: Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     // Padding(
//                                                     //   padding:
//                                                     //       const EdgeInsets.only(
//                                                     //     left: 28,
//                                                     //   ),
//                                                     //   child: Text(
//                                                     //     epre.fullName ??
//                                                     //         "Unknown",
//                                                     //     style: TextStyle(
//                                                     //         fontWeight:
//                                                     //             FontWeight
//                                                     //                 .bold),
//                                                     //   ),
//                                                     // ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 28),
//                                                       child: Text(
//                                                         "Date: ${epre.punchDate ?? 'N/A'}",
//                                                         style: TextStyle(color: Colors.black38),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 28),
//                                                       child: Text(
//                                                         "Status: ${epre.attStatus ?? ""}",
//                                                         style: TextStyle(
//                                                           color: Colors.black38,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 1,
//                                                           child: Icon(
//                                                             Icons.location_on,
//                                                             color: Colors.green,
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           flex: 6,
//                                                           child: Container(
//                                                             width: MediaQuery.of(context).size.width * 0.65,
//                                                             child: Text(
//                                                               epre.firstLocation ?? "Location N/A",
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: InkWell(
//                                                   onTap: () => Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => ImageViewerScreen(
//                                                         image: epre.firstImage ?? "assets/myPic.jpeg",
//                                                         location: epre.firstLocation ?? "Location N/A",
//                                                         dateTime: epre.firstPunchTime ?? 'N/A',
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   child: Column(
//                                                     children: [
//                                                       Text(
//                                                         epre.firstPunchTime?.split(' ').last ?? 'N/A',
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.normal,
//                                                         ),
//                                                       ),
//                                                       5.heightBox,
//                                                       Container(
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(10),
//                                                           border: Border.all(
//                                                             color: Colors.green,
//                                                             width: 1.5,
//                                                           ),
//                                                         ),
//                                                         child: epre.firstImage!.isNotEmpty && epre.firstImage != "" && epre.firstImage != null
//                                                             ? Image.network(
//                                                                 epre.firstImage ?? "",
//                                                                 height: 55,
//                                                                 width: 55,
//                                                                 fit: BoxFit.cover,
//                                                               )
//                                                             : Image.asset(
//                                                                 "assets/face2.png",
//                                                                 height: 55,
//                                                               ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               15.widthBox,
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Column(
//                                                   children: [
//                                                     Text(
//                                                       epre.lastPunchTime?.split(' ').last ?? '00:00',
//                                                       style: TextStyle(
//                                                         fontWeight: FontWeight.normal,
//                                                       ),
//                                                     ),
//                                                     5.heightBox,
//                                                     epre.lastImage!.isNotEmpty && epre.lastImage != "http://rapi.railtech.co.in/" && epre.lastImage != null
//                                                         ? InkWell(
//                                                             onTap: () => Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                 builder: (context) => ImageViewerScreen(
//                                                                   image: epre.lastImage ?? "assets/face2.png",
//                                                                   location: epre.lastLocation ?? "Location N/A",
//                                                                   dateTime: epre.lastPunchTime ?? 'N/A',
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             child: Container(
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(10),
//                                                                 border: Border.all(
//                                                                   color: Colors.green,
//                                                                   width: 1.5,
//                                                                 ),
//                                                               ),
//                                                               child: Image.network(
//                                                                 epre.lastImage ?? "",
//                                                                 height: 55,
//                                                                 width: 55,
//                                                                 fit: BoxFit.cover,
//                                                               ),
//                                                             ),
//                                                           )
//                                                         : Container(
//                                                             height: 55,
//                                                             width: 55,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(10),
//                                                               border: Border.all(
//                                                                 color: Colors.green,
//                                                                 width: 1.5,
//                                                               ),
//                                                             ),
//                                                             child: Icon(
//                                                               Icons.person,
//                                                               size: 50,
//                                                               color: const Color.fromRGBO(0, 0, 0, 0.38),
//                                                             ),
//                                                           ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                 Divider(
//                                   color: Colors.grey.shade300,
//                                   height: 8,
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
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
import 'dart:typed_data';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:faecauth/screens/image_viewer.dart';
import 'package:faecauth/screens/model/get_all_registered_faces.dart';
import 'package:faecauth/screens/model/profile_model.dart';
import 'package:faecauth/screens/model/single_team_mem_model.dart';
import 'package:faecauth/screens/model/total_present_absent_model.dart';
import 'package:faecauth/screens/team_member/team_attendance_model.dart';
import 'package:faecauth/screens/view_calendar_team_member.dart';
import 'package:faecauth/utils/appHelper/app_helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

String? faceImag;

List<MultiFaceInput> allFacess = [];

class SingleEmpDetails extends StatefulWidget {
  final TDS onedata;
  const SingleEmpDetails({super.key, required this.onedata});

  @override
  State<SingleEmpDetails> createState() => _SingleEmpDetailsState();
}

class _SingleEmpDetailsState extends State<SingleEmpDetails> {
  bool loading = false;
final controller = Get.put(HonmePageController());
  var report = SingleTeamMemberDetailsModel().obs;
  var totalPresentAbsent = TotalPresentAbsentModel().obs;

  Uint8List? imageData;
  final facematcher = FaceMatcher.instance;

  bool isLoading = true;
  final currentDate = DateTime.now();

  Future<void> addFace() async {
     showCountdownDialog(context, 5);
    await facematcher.registerFace(
      widget.onedata.eMPBasicDetailId,
      widget.onedata.fullName!,
      widget.onedata.faceImage == null
          ? ""
          : widget.onedata.faceImage.toString(),
    );
  }

  Uint8List? pickedImg;
  DateTime? punchInTime;
  // Timer for Punch Out
  bool _canPunchOut = false;
  Future<void> matchFace() async {
    await facematcher.matchFace(widget.onedata.eMPBasicDetailId!, widget.onedata.faceImage??"");
    setState(() {
      punchInTime = DateTime.now();
    });
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<String?> getEmpName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empName');
  }

  List<MultiFaceInput>? onedata;
  var registereddata = GetAllRegisteredFaceModel().obs;
  Future<String?> getManagerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('managerId');
  }

  Future<MultiFaceInput?> getFaceDataByImageUrl(dynamic json) async {
    managerId = await getManagerId();
    String? empId = await getEmpBasicDetailId();
    // String?
    //     empName =
    //     await getEmpName();
    if (json is! Map<String, dynamic>) return null;
    setState(() {
      faceImag = json['FaceImage64'];
    });
    String faceImageURL = json['FaceImage'];
    if ((faceImag == null || faceImag!.isEmpty) && faceImageURL.isNotEmpty) {
      faceImag = await AppHelperFunction.downloadImageByUrl(faceImageURL);
    } else {
      faceImag = await AppHelperFunction.downloadImageByUrl("assets/face2.png");
    }
    if (faceImag == null || faceImag!.isEmpty) {
      return null;
    }
    // json['imageName'] = faceImageURL.split("/").last;
    json['imageName'] = widget.onedata.fullName;
    json['imageBase64'] = faceImag;
    // json['empId'] = json['EMPKey'];
    json['empId'] = widget.onedata.eMPBasicDetailId;
    json['MarkedByUserId'] = empId;
    return MultiFaceInput.fromJson(json);
  }

  Future<void> getregisteredface() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      // print("EMP_BasicDetail_Id not found");
      return;
    }
    String url = ApiUrls.matchRegisteredFace;
    Map<String, dynamic> data = {
      "FaceRegistrationId": null,
      "EMP_BasicDetail_Id": widget.onedata.eMPBasicDetailId,
      "FullName": null,
      "EMPKey": null,
      "FaceImage": null,
      "Location": null,
      "Status": null,
      "MarkedByUserId": null
    };
    // {
    //   "FaceRegistrationId": null,
    //   "EMP_BasicDetail_Id": empId,
    //   "FullName": null,
    //   "EMPKey": null,
    //   "FaceImage": null,
    //   "Location": null,
    // };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      // print({"response.body", response.body});

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // print("jsonResponsesdfjkkjdhksjhs${jsonResponse}");
        setState(() {
          registeredFaceResponseModel.value =
              GetAllRegisteredFaceModel.fromJson(jsonResponse);
          // print("jsonResponseskjdhksjhs${registeredFaceResponseModel.value}");
        });

        if (jsonResponse['FRV'] != null && jsonResponse['FRV'] is List) {
          List<dynamic> frvList = jsonResponse['FRV'] ?? [];

          final allFutures = frvList.map((e) => getFaceDataByImageUrl(e));
          final result = await Future.wait(allFutures);
          for (var x in result) {
            setState(() {
              if (x != null && !allFaces.contains(x)) {
                allFaces.add(x);
              }
            });
          }
        } else {
          // print("No faces found in the response.");
        }
      } else {
        // print("Failed to fetch faces: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error fetching faces: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      // timeLimit: Duration(seconds: 10),
    );
  }

  Future<String> getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, (${place.postalCode}), ${place.country}";
      return address;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> _getLocation() async {
    String locations = await getCurrentLocation();

    setState(() {
      location = locations;
      if (locations.startsWith("Error:")) {
      Get.back();
      } else {
     
      }
    });
  }
Future<void> getLocation() async {
  String locations = await getCurrentLocation();
  if (locations.startsWith("Error:")) {
    _showErrorDialog(locations);
  } else {
 String? empId = await getEmpBasicDetailId();
    // await facematcher.matchFace(empId!, faceImage64!);
     showCountdownDialog(context, 5);
      await facematcher.matchFace(widget.onedata.eMPBasicDetailId!,"");
       setState(() {
      punchInTime = DateTime.now();
    });
  }
}
void _showErrorDialog(String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Location Error"),
        content: Text(errorMessage),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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


  Map<DateTime, bool> getAttendanceStatus(SingleTeamMemberDetailsModel model) {
    Map<DateTime, bool> attendanceMap = {};

    if (model.ePRE != null) {
      for (var ePRE in model.ePRE!) {
        if (ePRE.attStatus == 'Present') {
          DateTime punchDate = DateFormat("dd/MM/yyyy").parse(ePRE.punchDate!);
          attendanceMap[punchDate] = true;
        } else {
          DateTime punchDate = DateFormat("dd/MM/yyyy").parse(ePRE.punchDate!);
          attendanceMap[punchDate] = false;
        }
      }
    }

    return attendanceMap;
  }

  Map<DateTime, bool> attendanceMap = {};

  Future<void> fetchAttendanceReport() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      // print("Employee ID is null");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url =
        'http://rapi.railtech.co.in/api/EMPPunch/getPunchReortEmployee';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'EMP_BasicDetail_Id': widget.onedata.eMPBasicDetailId,
          'PunchDateTime': null,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        setState(() {
          report.value = SingleTeamMemberDetailsModel.fromJson(jsonResponse);
          final model = SingleTeamMemberDetailsModel.fromJson(jsonResponse);
          attendanceMap = getAttendanceStatus(model);
          isLoading = false;
        });
      } else {
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

  Future<void> getTotalPresentAbsent() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      // print("Employee ID is null");
      setState(() {
        isLoading = false;
      });
      return;
    }

    String url =
        'http://rapi.railtech.co.in/api/EMPPunch/getTotalPresentAbsent';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "EMP_BasicDetail_Id": widget.onedata.eMPBasicDetailId,
          "FullName": null,
          "EMPKey": null,
          "DepartmentHead": null,
          "CostCenterName": null,
          "TotalPresent": null,
          "TotalAbsent": null,
          "Month": "9",
          "Year": "2024"
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          totalPresentAbsent.value =
              TotalPresentAbsentModel.fromJson(jsonResponse);
          isLoading = false;
        });
      } else {
        // print(
        //     "Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
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

  Future<void> _fetchProfileData() async {
    try {
      String? empId = await getEmpBasicDetailId();
      const baseUrl = 'http://rapi.railtech.co.in/api/Login/getProfile';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'EMP_BasicDetail_Id': empId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          setState(() {
            profile = Profile.fromJson(responseData['CDS'][0]);
          });
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

  Future<void> _showImageDialog(BuildContext context) async {
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  // child: imageWidget,
                  child: faceImag != ""
                      ? Image.memory(
                          base64Decode(faceImag!),
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        )
                      : Icon(Icons.person),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> _removeFace() async {
  //   try {
  //     String? empId = await getEmpBasicDetailId();

  //     const baseUrl = 'http://rapi.railtech.co.in/api/FaceRegistration/Remove';
  //     final response = await http.post(
  //       Uri.parse(baseUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(
  //           <String, dynamic>{"EMP_BasicDetail_Id": empId, "UserId": empId}),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       if (responseData['StatusCode'] == 1) {
  //         setState(() async{
  //         await  addFace();
  //         });
  //       } else {
  //         // print("Error: ${responseData['Message']}");
  //       }
  //     } else {
  //       // print("Failed to load profile data");
  //     }
  //   } catch (e) {
  //     // print("Exception caught: $e");
  //   }
  // }

  // Future<void> showConfirmationDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Confirm Face Remove "),
  //         content: Text("Are you sure you want to remove this face?"),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               // Add your face removal logic here
  //               await _removeFace();
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Remove"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

DateTime? parseTime(String? dateTimeString) {
  if (dateTimeString == null) return null;
  try {
    // Adjust this format if necessary
    return DateFormat("yyyy-MM-dd hh:mm a").parse(dateTimeString).toLocal();
  } catch (e) {
    // print("Error parsing date: $e");
    return null;
  }
}

  Widget? imageWidget;
  DateTime? selectedDate;
  List<EPRE> filteredList = [];

  @override
  void initState() {
    // getregisteredface();
    // fetchAttendanceReport();
    // _fetchProfileData();
    // _getLocation();
    // getTotalPresentAbsent();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await getregisteredface();
      await fetchAttendanceReport();
      await _fetchProfileData();
      await _getLocation();
      await getTotalPresentAbsent();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeatMapCalendarStaff(
                      report: report.value, img: widget.onedata.faceImage),
                ),
              );
            },
            icon: Icon(Icons.calendar_month),
          ),
          IconButton(
              onPressed: () async {
                await _fetchProfileData();
                await _getLocation();
                await getregisteredface();
                await fetchAttendanceReport();
              },
              icon: Icon(Icons.refresh))
        ],
        title: Text(
          '${widget.onedata.fullName}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchProfileData();
          await _getLocation();
          await getregisteredface();
          await fetchAttendanceReport();
        },
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              await _fetchProfileData();
              await _getLocation();
              await getregisteredface();
              await fetchAttendanceReport();
            },
            child: Column(
              children: [
                if (registeredFaceResponseModel.value.status == "Success")
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.widthBox,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () => _showImageDialog(context),
                                        child: faceImag != null
                                            ? Image.memory(
                                                base64Decode(
                                                    faceImag.toString()),
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill,
                                              )
                                            : Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.widthBox,
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.heightBox,
                                  Text(
                                    widget.onedata.fullName ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.onedata.designation ?? "",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.onedata.companyName ?? "",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // if (registeredFaceResponseModel
                                  //             .value.fRV?[0].status ==
                                  //         "Pending" 
                                  //     //     &&
                                  //     // report.value.ePRE?.length == 0
                                  //     )
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(top: 10),
                                  //     child: InkWell(
                                  //       onTap: () =>
                                  //           showConfirmationDialog(context),
                                  //       child: Card(
                                  //         elevation: 3,
                                  //         color: Colors.orange,
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(2)),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.symmetric(
                                  //               horizontal: 3, vertical: 2),
                                  //           child: Center(
                                  //             child: Text(
                                  //               "Face Retake",
                                  //               style: TextStyle(
                                  //                   color: Colors.white,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   )
                               
                                ],
                              ),
                            ),
                            Spacer(),
                            // if (registeredFaceResponseModel.value.fRV?[0].status != "Approved" && report.value.ePRE?.length == 0)
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: GestureDetector(
                            //       onTap: addFace,
                            //       child: Card(
                            //         elevation: 3,
                            //         color: Colors.orange,
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            //           child: Center(
                            //               child: Text(
                            //             textAlign: TextAlign.center,
                            //             "Re-register\nYou Face",
                            //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            //           )),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // Visibility(
                            //   visible: report.value.ePRE?.length == 0 && registeredFaceResponseModel.value.fRV?[0].status == "Approved",
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: GestureDetector(
                            //       onTap: matchFace,
                            //       child: Card(
                            //         elevation: 3,
                            //         color: Colors.orange,
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            //           child: Center(
                            //             child: Text(
                            //               "Punch In",
                            //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // if (report.value.ePRE?.length != 0)
                            //   Visibility(
                            //     visible: report.value.ePRE?[0].punchDate != DateFormat('dd/MM/yyyy').format(currentDate) && registeredFaceResponseModel.value.fRV?[0].status == "Approved" && report.value.ePRE?[0].firstLocation != "" && report.value.ePRE?[0].firstPunchTime != "",
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(top: 10),
                            //       child: GestureDetector(
                            //         onTap: matchFace,
                            //         child: Card(
                            //           elevation: 3,
                            //           color: Colors.orange,
                            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            //             child: Center(
                            //               child: Text(
                            //                 "Punch In",
                            //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // if (report.value.ePRE?.length != 0)
                            //   Visibility(
                            //     visible: registeredFaceResponseModel.value.fRV?[0].status == "Approved" && report.value.ePRE?[0].punchDate == DateFormat('dd/MM/yyyy').format(currentDate) && report.value.ePRE?[0].lastPunchTime == "",
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(top: 10),
                            //       child: GestureDetector(
                            //         onTap: matchFace,
                            //         child: Card(
                            //           elevation: 3,
                            //           color: Colors.orange,
                            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            //             child: Center(
                            //               child: Text(
                            //                 "Punch Out",
                            //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),

                            if (registeredFaceResponseModel
                                        .value.fRV?[0].status !=
                                    "Rejected" &&
                                registeredFaceResponseModel
                                        .value.fRV?[0].status !=
                                    "Approved" 
                                //     &&
                                // report.value.ePRE?.length == 0
                                )
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  // onTap: addFace,
                                  child: Card(
                                    elevation: 3,
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Center(
                                          child: Text(
                                        textAlign: TextAlign.center,
                                        "${registeredFaceResponseModel.value.fRV?[0].status}...\nwait till\nApproved\nor\nReject",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            if (registeredFaceResponseModel
                                        .value.fRV?[0].status ==
                                    "Rejected" 
                                //     &&
                                // report.value.ePRE?.length == 0
                                )
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: addFace,
                                  child: Card(
                                    elevation: 3,
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Center(
                                          child: Text(
                                        textAlign: TextAlign.center,
                                        "Re-register\nYour Face",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            Visibility(
                              visible: report.value.ePRE?.length == 0 &&
                                  registeredFaceResponseModel
                                          .value.fRV?[0].status ==
                                      "Approved",
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: getLocation,
                                  child: Card(
                                    elevation: 3,
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Center(
                                        child: Text(
                                          "Punch In",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (report.value.ePRE?.length != 0)
                              Visibility(
                                visible: report.value.ePRE?[0].punchDate !=
                                        DateFormat('dd/MM/yyyy')
                                            .format(currentDate) &&
                                    registeredFaceResponseModel
                                            .value.fRV?[0].status ==
                                        "Approved" &&
                                    report.value.ePRE?[0].firstLocation != "" &&
                                    report.value.ePRE?[0].firstPunchTime != "",
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: getLocation,
                                    child: Card(
                                      elevation: 3,
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 8),
                                        child: Center(
                                          child: Text(
                                            "Punch In",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (report.value.ePRE?.length != 0)
                              Visibility(
                                visible: registeredFaceResponseModel
                                            .value.fRV?[0].status ==
                                        "Approved" &&
                                    report.value.ePRE?[0].punchDate ==
                                        DateFormat('dd/MM/yyyy')
                                            .format(currentDate) &&
                                    report.value.ePRE?[0].lastPunchTime == ""&& (parseTime(report.value.ePRE?[0]
                                                  .afterFirstPunch)
                                              ?.isBefore(DateTime.now()) ??
                                          false),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: getLocation,
                                    child: Card(
                                      elevation: 3,
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 8),
                                        child: Center(
                                          child: Text(
                                            "Punch Out",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            5.widthBox,
                            5.widthBox,
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // width: report.value.ePRE?[0].punchDate == DateFormat('dd/MM/yyyy').format(currentDate) && allFaces.last.imageBase64 != "" && report.value.ePRE?[0].lastPunchTime == "" ? MediaQuery.of(context).size.width * 0.90 : MediaQuery.of(context).size.width * 0.60,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          ),
                                          10.widthBox,
                                          Text(
                                            location ?? "",
                                            maxLines: 4,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ).expand(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 35),
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         "Cost Center : ",
                                    //         style: TextStyle(
                                    //             color: Colors.black38),
                                    //       ),
                                    //       Text(
                                    //         "",
                                    //         style: TextStyle(
                                    //             color: Colors.black38),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 35),
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         "Tender Id : ",
                                    //         style: TextStyle(
                                    //             color: Colors.black38),
                                    //       ),
                                    //       Text(
                                    //         "",
                                    //         style: TextStyle(
                                    //             color: Colors.black38),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    10.heightBox,
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 30),
                                    //   child: Text(
                                    //     "In-side Geofence",
                                    //     style: TextStyle(
                                    //       color: Colors.green,
                                    //       fontWeight: FontWeight.bold,
                                    //     ),
                                    //   ),
                                    // ),
                                    // if (registeredFaceResponseModel.value.statusCode != 0)
                                    // Obx(
                                    //   () => Padding(
                                    //     padding: const EdgeInsets.only(left: 20),
                                    //     child: Card(
                                    //       elevation: 3,
                                    //       shape: RoundedRectangleBorder(),
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    //         child: Row(
                                    //           mainAxisAlignment: MainAxisAlignment.center,
                                    //           children: [
                                    //             Text(
                                    //               "Present = ",
                                    //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    //             ),
                                    //             Spacer(),
                                    //             Text(
                                    //               "${totalPresentAbsent.value.ePA?.totalPresent ?? ""} days",
                                    //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                    //             ),
                                    //             15.widthBox,
                                    //             Container(
                                    //               height: 20,
                                    //               width: 2,
                                    //               color: Colors.black38,
                                    //             ),
                                    //             15.widthBox,
                                    //             Text(
                                    //               "Absent = ",
                                    //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                    //             ),
                                    //             Spacer(),
                                    //             Text(
                                    //               "${totalPresentAbsent.value.ePA?.totalAbsent ?? ""} days",
                                    //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                    //             ),
                                    //             5.widthBox,
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        5.heightBox,
                      ],
                    ),
                  ),
                if (registeredFaceResponseModel.value.statusCode == 0)
                  Card(
                    shape: RoundedRectangleBorder(),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                            10.widthBox,
                            Obx(
                              ()=>controller. loder.value ==true ? Center(child:Lottie.asset("assets/loading.json",height: 100 ,width: 300),): 
                               Container(
                                width: Get.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile?.fullName ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      profile?.designation ?? "",
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Icon(
                        //       Icons.location_on,
                        //       color: Colors.green,
                        //     ),
                        //     10.widthBox,
                        //     Text(
                        //       location ?? "",
                        //       maxLines: 4,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ).expand(),
                        //     InkWell(
                        //       onTap: addFace,
                        //       child: Container(
                        //         child: Card(
                        //           elevation: 3,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(5)),
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 5, horizontal: 5),
                        //             child: Column(
                        //               children: [
                        //                 SizedBox(height: 18),
                        //                 Image.asset(
                        //                   "assets/face2.png",
                        //                   height: 70,
                        //                 ),
                        //                 SizedBox(height: 10),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        
                        // 10.heightBox,
                      ],
                    ),
                  ),
                report.value.ePRE?.length != 0
                    ? Column(
                        children: [
                          Divider(),
                          Container(
                            height: Get.height * 0.53,
                            child: ListView.builder(
                              itemCount: report.value.ePRE?.length ?? 0,
                              itemBuilder: (BuildContext context, index) {
                                EPRE epre = report.value.ePRE![index];
                                return Column(
                                  children: [
                                    epre.punchDate != ""
                                        ? Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 28),
                                                          child: Text(
                                                            "Date: ${epre.punchDate ?? 'N/A'}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 28),
                                                          child: Text(
                                                            "Status: ${epre.firstPunchTime != null ? 'Present' : 'Absent'}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      29),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Working Hrs : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black38,
                                                                ),
                                                              ),
                                                              Text(
                                                                epre.workDuration ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.65,
                                                                child: Text(
                                                                  maxLines: 2,
                                                                  epre.firstLocation ??
                                                                      "Location N/A",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black38,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageViewerScreen(
                                                            image: epre
                                                                    .firstImage ??
                                                                "assets/myPic.jpeg",
                                                            location: epre
                                                                    .firstLocation ??
                                                                "Location N/A",
                                                            dateTime:
                                                                epre.firstPunchTime ??
                                                                    'N/A',
                                                          ),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            // epre.firstPunchTime ?? 'N/A',
                                                            "${epre.firstPunchTime?.split(' ')[1]}${epre.firstPunchTime?.split(' ')[2]}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          5.heightBox,
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: epre.firstImage!
                                                                        .isNotEmpty &&
                                                                    epre.firstImage !=
                                                                        "" &&
                                                                    epre.firstImage !=
                                                                        null
                                                                ? Image.network(
                                                                    epre.firstImage ??
                                                                        "",
                                                                    height: 55,
                                                                    width: 55,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/face2.png",
                                                                    height: 55,
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  15.widthBox,
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        epre.lastPunchTime != ""
                                                            ? Text(
                                                                "${epre.lastPunchTime?.split(' ')[1] ?? ""}${epre.lastPunchTime?.split(' ')[2] ?? ""}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              )
                                                            : Text(""),
                                                        5.heightBox,
                                                        epre.lastImage!
                                                                    .isNotEmpty &&
                                                                epre.lastImage !=
                                                                    "http://rapi.railtech.co.in/" &&
                                                                epre.lastImage !=
                                                                    null
                                                            ? InkWell(
                                                                onTap: () =>
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ImageViewerScreen(
                                                                      image: epre
                                                                              .lastImage ??
                                                                          "assets/face2.png",
                                                                      location:
                                                                          epre.lastLocation ??
                                                                              "Location N/A",
                                                                      dateTime:
                                                                          epre.lastPunchTime ??
                                                                              'N/A',
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.5,
                                                                    ),
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    epre.lastImage ??
                                                                        "",
                                                                    height: 55,
                                                                    width: 55,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.38),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 28,
                                                          ),
                                                          child: Text(
                                                            epre.fullName ??
                                                                "Unknown",
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
                                                                  left: 28),
                                                          child: Text(
                                                            "Date: ${epre.punchDate ?? 'N/A'}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 28),
                                                          child: Text(
                                                            "Status: ${epre.firstPunchTime != null ? 'Present' : 'Absent'}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 6,
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.65,
                                                                child: Text(
                                                                  epre.firstLocation ??
                                                                      "Location N/A",
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageViewerScreen(
                                                            image: epre
                                                                    .firstImage ??
                                                                "assets/myPic.jpeg",
                                                            location: epre
                                                                    .firstLocation ??
                                                                "Location N/A",
                                                            dateTime:
                                                                epre.firstPunchTime ??
                                                                    'N/A',
                                                          ),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            epre.firstPunchTime
                                                                    ?.split(' ')
                                                                    .last ??
                                                                'N/A',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          5.heightBox,
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            child: epre.firstImage!
                                                                        .isNotEmpty &&
                                                                    epre.firstImage !=
                                                                        "" &&
                                                                    epre.firstImage !=
                                                                        null
                                                                ? Image.network(
                                                                    epre.firstImage ??
                                                                        "",
                                                                    height: 55,
                                                                    width: 55,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/face2.png",
                                                                    height: 55,
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  15.widthBox,
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          epre.lastPunchTime
                                                                  ?.split(' ')
                                                                  .last ??
                                                              '00:00',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                        5.heightBox,
                                                        epre.lastImage!
                                                                    .isNotEmpty &&
                                                                epre.lastImage !=
                                                                    "http://rapi.railtech.co.in/" &&
                                                                epre.lastImage !=
                                                                    null
                                                            ? InkWell(
                                                                onTap: () =>
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ImageViewerScreen(
                                                                      image: epre
                                                                              .lastImage ??
                                                                          "assets/face2.png",
                                                                      location:
                                                                          epre.lastLocation ??
                                                                              "Location N/A",
                                                                      dateTime:
                                                                          epre.lastPunchTime ??
                                                                              'N/A',
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.5,
                                                                    ),
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    epre.lastImage ??
                                                                        "",
                                                                    height: 55,
                                                                    width: 55,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .green,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      0,
                                                                      0,
                                                                      0.38),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Image.asset("assets/nodataa.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
