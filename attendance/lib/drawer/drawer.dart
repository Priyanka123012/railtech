// import 'dart:convert';
// import 'package:faecauth/Expance/expance_view.dart';
// import 'package:faecauth/classess/face_matcher.dart';
// import 'package:faecauth/screens/auth/login_with_email.dart';
// import 'package:faecauth/screens/home_page_screen.dart';
// import 'package:faecauth/screens/profile.dart';
// import 'package:faecauth/screens/team_member/team_attendance_oneday.dart';
// import 'package:faecauth/screens/team_member/team_member_list.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocity_x/velocity_x.dart';

// String?
//     manId;

// class DrawerWidget
//     extends StatefulWidget {
//   const DrawerWidget(
//       {super.key});

//   @override
//   State<DrawerWidget> createState() =>
//       _DrawerWidgetState();
// }

// class _DrawerWidgetState
//     extends State<DrawerWidget> {
// final facematcher =
//     FaceMatcher.instance;
// Future<String?>
//     getEmpName() async {
//   final prefs =
//       await SharedPreferences.getInstance();
//   return prefs.getString('empName');
// }

// Future<String?>
//     getManagerId() async {
//   final prefs =
//       await SharedPreferences.getInstance();
//   return prefs.getString('managerId');
// }

// Future<String?>
//     getEmpId() async {
//   final prefs =
//       await SharedPreferences.getInstance();
//   return prefs.getString('empId');
// }

// bool
//     isvisible =
//     false;

// String?
//     empId;

// @override
// void
//     initState() {
// getManagerId().then((managerId) {
//   if (managerId != null) {
//     setState(() {
//       isvisible = true;
//       manId = managerId;
//     });
//   }
// });
// getEmpId().then((empid) {
//   if (empid != null) {
//     setState(() {
//       isvisible = true;
//       empId = empid;
//     });
//   }
// });

//   super.initState();
// }
//   // Future<void> addFace() async {
//   //   String? empId = await getEmpBasicDetailId();
//   //   String? empName = await getEmpName();
//   //   await facematcher.registerFace(empId, empName!, profile!.imagePath);
//   // }

//   @override
//   Widget
//       build(BuildContext context) {
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.85,
//       shape: RoundedRectangleBorder(),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Column(
//             children: [
//               SizedBox(height: 30),
//               Card(
//                 color: Colors.transparent,
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       gradient: LinearGradient(colors: [
//                         Colors.teal.shade300,
//                         Colors.green
//                       ])),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Card(
//                               shape: RoundedRectangleBorder(),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(),
//                                   child: Image.memory(
//                                     base64Decode(faceImage64!),
//                                     height: 70,
//                                     width: 70,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Expanded(
//                             flex: 6,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   profile!.fullName,
//                                   style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//                                   textAlign: TextAlign.start,
//                                 ),
//                                 5.heightBox,
//                                 Text(
//                                   profile!.designation,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white,
//                                   ),
//                                   textAlign: TextAlign.start,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Card(
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.person,
//                     size: 25,
//                     color: Colors.green.shade500,
//                   ),
//                   title: Text(
//                     "Profile",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
//                 ),
//               ),
//               // if (registeredFaceResponseModel.value.fRV![0].status == "Pending" || registeredFaceResponseModel.value.fRV![0].status == "Rejected")
//               //   Column(
//               //     children: [
//               //       Divider(),
//               //       Card(
//               //         elevation: 2,
//               //         child: ListTile(
//               //           leading: Image.asset(
//               //             "assets/face2.png",
//               //             height: 30,
//               //           ),
//               //           title: Text(
//               //             "Re-register Your Face",
//               //             style: TextStyle(fontSize: 16),
//               //           ),
//               //           // onTap: addFace,
//               //           onTap: () async {
//               //             await facematcher.registerFace(registeredFaceResponseModel.value.fRV![0].eMPBasicDetailId, registeredFaceResponseModel.value.fRV![0].fullName!, registeredFaceResponseModel.value.fRV![0].faceImage!);
//               //           },
//               //         ),
//               //       ),
//               //     ],
//               //   ),
// Divider(),
// ExpansionTile(
//   title: Text(
//     'UPLOAD',
//     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//   ),
//   leading: Icon(Icons.document_scanner),
//   trailing: Icon(Icons.arrow_drop_down),
//   children: <Widget>[
//     Padding(
//       padding: const EdgeInsets.only(left: 35),
//       child: ListTile(
//         title: Text('LABOUR DOCUMENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black38)),
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocumentScreen()));
//         },
//       ),
//     ),
//   ],
// ),
//               Divider(),
//               Card(
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Image.asset(
//                     "assets/face2.png",
//                     height: 30,
//                   ),
//                   title: Text(
//                     "Team Attendance",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllTeamSingleDayAttendance(id: empId!))),
//                 ),
//               ),
//               Divider(),
//               Card(
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Image.asset(
//                     "assets/face2.png",
//                     height: 30,
//                   ),
//                   title: Text(
//                     "View Team",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamAttendanceScreen())),
//                 ),
//               ),
//               Divider(),
//               if (!isvisible)
//                 Card(
//                   elevation: 2,
//                   child: ListTile(
//                     leading: Image.asset(
//                       "assets/face2.png",
//                       height: 30,
//                     ),
//                     title: Text(
//                       "Submit Expance",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     onTap: () {
//                       Get.to(() => ExpancesSubmitScreens());
//                     },
//                   ),
//                 ),
//               Divider(),
//               Card(
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.logout_sharp,
//                     size: 25,
//                     color: Colors.red.shade900,
//                   ),
//                   title: Text(
//                     "Log Out",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onTap: () async {
//                     QuickAlert.show(
//                       context: context,
//                       type: QuickAlertType.confirm,
//                       text: 'Do you want to Log Out',
//                       confirmBtnText: 'Yes',
//                       cancelBtnText: 'No',
//                       confirmBtnColor: Colors.green,
//                       onCancelBtnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreeen())),
//                       onConfirmBtnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView())),
//                     );
//                     setState(() async {
//                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                       prefs.remove('isLoggedIn');
//                       prefs.remove("logResponseKey");
//                       // registeredFaceResponseModel.close();
//                     });
//                   },
//                 ),
//               ),
//               Divider(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:faecauth/Expance/expance_view.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/directAttendance/teamDirectAttendacnce.dart';
import 'package:faecauth/drawer/pages/adddpr.dart';
import 'package:faecauth/drawer/pages/advance_expance.dart';
import 'package:faecauth/drawer/pages/cash_withdawal.dart';
import 'package:faecauth/drawer/pages/change_password.dart';
import 'package:faecauth/drawer/pages/material_consuption.dart';
import 'package:faecauth/drawer/pages/view_dpr.dart';
import 'package:faecauth/drawer/pages/view_expance.dart';
import 'package:faecauth/drawer/pages/view_hr_policy.dart';
import 'package:faecauth/screens/auth/login_with_email.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:faecauth/screens/labour/UnregisterefLabourFace.dart';
import 'package:faecauth/screens/labour/faceregister.dart';
import 'package:faecauth/screens/labour/labourStrenth.dart';
import 'package:faecauth/screens/labour/marklabourAttendance.dart';
import 'package:faecauth/screens/labour/pengindlabourList.dart';
import 'package:faecauth/screens/profile.dart';
import 'package:faecauth/screens/team_member/faceteanregister.dart';
import 'package:faecauth/screens/team_member/markAttendance.dart';
import 'package:faecauth/screens/team_member/pendingAtHr.dart';
import 'package:faecauth/screens/team_member/StafStrength.dart/stafStrenght.dart';
import 'package:faecauth/screens/team_member/teamUnregisterFace.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final facematcher = FaceMatcher.instance;
  Future<String?> getEmpName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empName');
  }

  Future<String?> getManagerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('managerId');
  }

  bool isvisible = false;
  String? selcetItem;

  Future<String?> getEmpId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  String? empId;

  @override
  void initState() {
    // getManagerId().then((managerId) {
    //   if (managerId != null) {
    //     setState(() {
    //       isvisible = true;
    //       manId = managerId;
    //     });
    //   }
    // });
    getEmpId().then((empid) {
      if (empid != null) {
        setState(() {
          isvisible = true;
          empId = empid;
        });
      }
    });
    super.initState();
  }
  // Future<void> addFace() async {
  //   String? empId = await getEmpBasicDetailId();
  //   String? empName = await getEmpName();
  //   await facematcher.registerFace(empId, empName!, profile!.imagePath);
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      shape: RoundedRectangleBorder(),
      child: Column(
        children: [
          SizedBox(height: 30),
          Card(
            color: Colors.transparent,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                      colors: [Colors.teal.shade300, Colors.green])),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Card(
                          shape: RoundedRectangleBorder(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Card(
                              shape: RoundedRectangleBorder(),
                              child: Image.memory(
                                base64Decode(faceImage64!),
                                height: 70,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile!.fullName,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold
                              ),
                              // textAlign: TextAlign.start,
                            ),
                            5.heightBox,
                            Text(
                              profile!.designation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              // textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: Get.height * 0.79,
              child: ListView(
                children: [
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.green.shade500,
                      ),
                      title: Text(
                        "Profile",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen())),
                    ),
                  ),
                  // if (registeredFaceResponseModel.value.fRV![0].status == "Pending" || registeredFaceResponseModel.value.fRV![0].status == "Rejected")
                  //   Column(
                  //     children: [
                  //       Divider(),
                  //       Card(
                  //         elevation: 2,
                  //         child: ListTile(
                  //           leading: Image.asset(
                  //             "assets/face2.png",
                  //             height: 30,
                  //           ),
                  //           title: Text(
                  //             "Re-register Your Face",
                  //             style: TextStyle(fontSize: 16),
                  //           ),
                  //           // onTap: addFace,
                  //           onTap: () async {
                  //             await facematcher.registerFace(registeredFaceResponseModel.value.fRV![0].eMPBasicDetailId, registeredFaceResponseModel.value.fRV![0].fullName!, registeredFaceResponseModel.value.fRV![0].faceImage!);
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // Divider(),
                  // ExpansionTile(
                  //   title: Text(
                  //     'UPLOAD',
                  //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  //   ),
                  //   leading: Icon(Icons.document_scanner),
                  //   trailing: Icon(Icons.arrow_drop_down),
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 35),
                  //       child: ListTile(
                  //         title: Text('LABOUR DOCUMENTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black38)),
                  //         onTap: () {
                  //           Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocumentScreen()));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Divider(),
                  // Card(
                  //   elevation: 2,
                  //   child: ListTile(
                  //     leading: Image.asset(
                  //       "assets/face2.png",
                  //       height: 30,
                  //     ),
                  //     title: Text(
                  //       "Staff Attendance",
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TeamAttandanceManage(
                  //                   // id: '',
                  //                 ))),
                  //   ),
                  // ),
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        'Staff Attendance',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.file_copy,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                      children: <Widget>[
                        Divider(),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: ExpansionTile(
                             leading: Icon(
                                      Icons.face, // Replace this with your desired icon
                                      color: Colors.black,
                                      size: 20,
                                      // Customize color if needed
                                    ),
                            // collapsedBackgroundColor:const Color.fromARGB(255, 236, 236, 236) ,
                            // backgroundColor: const Color.fromARGB (255, 250, 245, 250)
                            title: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                'Face Id',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            children: <Widget>[
                              Divider(),
                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons
                                          .circle, // Replace this with your desired icon
                                      color: Colors.black,
                                      size: 10,
                                      // Customize color if needed
                                    ),
                                    // selectedColor: Color.fromARGB(255, 236, 236, 236),
                                    title: Text('Registered ',
                                        style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FaceTeamRegister()));
                                    },
                                  ),
                                ),
                              ),
                              // Divider(),

                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                      leading: Icon(
                                      Icons.circle, // Replace this with your desired icon
                                      color: Colors.black,
                                      size: 10,
                                      // Customize color if needed
                                    ),
                                    title: Text('Unregistered ',
                                        style: TextStyle(// fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TeamUnRegisterFace(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Divider(),
                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                      leading: Icon(
                                      Icons.circle, 
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    title: Text('Pending',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PendingAtHR()));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Divider(),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: ListTile(
                               leading: Icon(
                                      Icons.mark_chat_read, 
                                      color: Colors.black,
                                      size: 20,
                                    ),
                              title: Text('Mark Attandance',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MarkattendanceTeam()));
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: ListTile(
                               leading: Icon(
                                      Icons.group,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                              title: Text('Staff Strength ',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StaffStrength()));
                              },
                            ),
                          ),
                        ),
                        // Container(
                        //   color: Color.fromARGB(255, 250, 246, 246),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 0, right: 0),
                        //     child: ListTile(
                        //        leading: Icon(
                        //               Icons.mark_chat_read, // Replace this with your desired icon
                        //               color: Colors.black,
                        //               size: 20,
                        //               // Customize color if needed
                        //             ),
                        //       title: Text('Attandance',
                        //           style: TextStyle(
                        //               // fontWeight: FontWeight.bold,
                        //               fontSize: 15,
                        //               color: Colors.black)),
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        //                  DirectAttendance()));
                        //       },
                        //     ),
                        //   ),
                        // ),
                     
                      ],
                    ),
                  ),

                  // Divider(),
                  // Card(
                  //   elevation: 2,
                  //   child: ListTile(
                  //     leading: Icon(Icons.group, color: Colors.green),
                  //     title: Text(
                  //       "View Team",
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TeamAttendanceScreen())),
                  //   ),
                  // ),
                  Divider(),
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        'Labour Attendance',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.file_copy,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                      children: <Widget>[
                        Divider(),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: ExpansionTile(
                             leading: Icon(
                                      Icons.face, 
                                      color: Colors.black,
                                      size: 25,
                                    ),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                'Face Id',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            trailing: Icon(Icons.arrow_drop_down),
                            children: <Widget>[
                              Divider(),
                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                     leading: Icon(
                                      Icons.circle, 
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    title: Text('Registered ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FaceLabpurRegister()));
                                    },
                                  ),
                                ),
                              ),
                              // Divider(),
                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                     leading: Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    title: Text('Unregistered ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UnRegisteredLabourFace()));
                                    },
                                  ),
                                ),
                              ),
                              // Divider(),
                              Container(
                                color: Color.fromARGB(255, 236, 231, 238),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 35),
                                  child: ListTile(
                                     leading: Icon(
                                      Icons.circle, 
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    title: Text('Pending ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PendingAtHRLabour()));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Divider(),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: ListTile(
                               leading: Icon(
                                      Icons.mark_chat_read, 
                                      color: Colors.black,
                                      size: 25,
                                    ),
                              title: Padding(
                                padding: const EdgeInsets.only(left:0),
                                child: Text('Mark Attandance',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black)),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MarkLabourAttendace()));
                              },
                            ),
                          ),
                        ),
                        // Divider(),
                        Container(
                          color: Color.fromARGB(255, 250, 246, 246),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: ListTile(
                               leading: Icon(
                                      Icons.group, 
                                      color: Colors.black,
                                      size: 25,
                                    ),
                              title: Text('Labour Strength ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Labourstrenth()));
                              },
                            ),
                          ),
                        ),
                        // Divider(),
                      ],
                    ),
                  ),

                  // Card(
                  //   elevation: 2,
                  //   child: ListTile(
                  //     leading: Image.asset(
                  //       "assets/face2.png",
                  //       height: 30,
                  //     ),
                  //     title: Text(
                  //       "Labour Attendance",
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => ManageLabourAttandance(
                  //                   // id: '',
                  //                 ))),
                  //   ),
                  // ),
                  //   Divider(),
                  // Card(
                  //   elevation: 2,
                  //   child: ListTile(
                  //     leading: Icon(Icons.group, color: Colors.green),
                  //     title: Text(
                  //       "View Labour",
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TeamAttendanceScreen())),
                  //   ),
                  // ),
                  Visibility(visible: managerId != "null", child: Divider()),
                  Visibility(
                    visible: managerId != "null",
                    child: Card(
                      elevation: 2,
                      child: ExpansionTile(
                        title: Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        leading: Icon(
                          Icons.file_copy,
                          color: Colors.green,
                        ),
                        trailing: Icon(Icons.arrow_drop_down),
                        children: <Widget>[
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: ListTile(
                              title: Text('Cash Withdrawal ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CashWithdrawal()));
                              },
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: ListTile(
                              title: Text('Submit ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExpancesSubmitScreens()));
                              },
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: ListTile(
                              title: Text('View ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewExpense()));
                              },
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: ListTile(
                              title: Text('Advance ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Advanceexpence()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.password_outlined,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Change Password",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Changepassword())),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Bellow this divider facility is not active now, it is only for view and it will be on app soon....",
                      // style: TextStyle(
                      //     color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        'DPR Details',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.file_copy,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: ListTile(
                            title: Text('Add DPR Details',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddDpr()));
                            },
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: ListTile(
                            title: Text('View DPR Details',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Viewdpr()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        'View',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.view_agenda,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                      children: <Widget>[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: ListTile(
                            title: Text('HR Policy',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPdfPage()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider(),
                  Divider(),
                  Card(
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(
                        'Material',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.file_copy,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.arrow_drop_down),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: ListTile(
                            title: Text('Material Consumption',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Materialconsumptiom()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider(),
                  if (!isvisible)
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/face2.png",
                          height: 30,
                        ),
                        title: Text(
                          "Submit Expance",
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          Get.to(() => ExpancesSubmitScreens());
                        },
                      ),
                    ),
                  Divider(),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout_sharp,
                        size: 25,
                        color: Colors.red.shade900,
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to Log Out',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onCancelBtnTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePageScreeen())),
                          onConfirmBtnTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView())),
                        );
                        setState(() async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('isLoggedIn');
                          prefs.remove("logResponseKey");
                          // registeredFaceResponseModel.close();
                        });
                      },
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
