import 'dart:convert';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:http/http.dart' as http;
import 'package:faecauth/screens/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _profile;

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<MultiFaceInput?> getFaceDataByEmpId() async {
    String? empId = await getEmpBasicDetailId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFaces = prefs.getStringList('saved_faces');

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

  Future<void> displayFaceImage() async {
    MultiFaceInput? faceData = await getFaceDataByEmpId();

    if (faceData != null) {
      imageWidget = Image.memory(
        base64Decode(faceData.imageBase64),
        height: 90,
        width: 90,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = Icon(
        Icons.person,
        size: 100,
        color: Colors.black38,
      );
    }

    setState(() {});
  }

  Widget? imageWidget;

  // Future<void> _showImageDialog(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         insetAnimationDuration: Duration(seconds: 3),
  //         shape: RoundedRectangleBorder(),
  //         child: Container(
  //           padding: EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 height: MediaQuery.of(context).size.height * 0.5,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: imageWidget,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                  child: Image.memory(
                    base64Decode(faceImage64!),
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    // _loadFaceData();
    displayFaceImage();
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

      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          setState(() {
            _profile = Profile.fromJson(responseData['CDS'][0]);
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

  // String? _faceImage;

  // Future<void> _loadFaceData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _faceImage = prefs.getString('face_image');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _profile == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.31,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade700, Colors.teal.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          40.heightBox,
                          Stack(
                            children: [
                              InkWell(
                                onTap: () => _showImageDialog(context),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Card(
                                      shape: RoundedRectangleBorder(),
                                      // child: imageWidget,
                                      child: Image.memory(
                                        base64Decode(faceImage64!),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          15.heightBox,
                          Text(
                            _profile!.fullName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            _profile!.designation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 20),
                    //   child: IconButton(
                    //       onPressed: () {
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreeen()));
                    //       },
                    //       icon: Icon(
                    //         Icons.arrow_back,
                    //         size: 30,
                    //         color: Colors.white,
                    //       )),
                    // )
                  ],
                ),
                20.heightBox,
                Icon(
                  Icons.person,
                  // size: 50,
                ),
                Text(
                  "Profile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.green.shade300,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ListView(
                    children: [
                      Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Employee Code           :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2, child: Text(_profile!.empKey)),
                                ],
                              ),
                              8.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Father Name                : ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(profile!.FatherName),
                                  ),
                                ],
                              ),
                              8.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Date of Joining            :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(_profile!.joiningDate)),
                                ],
                              ),
                              8.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Company                      : ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(_profile!.companyName)),
                                ],
                              ),
                              8.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Department                  :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(_profile!.departmentHead)),
                                ],
                              ),
                              8.heightBox,
                               Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Reporting Manager     :   ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2, child: Text(profile!.reportingManager)),
                                      
                                ],
                              ),
                                 8.heightBox,
                                  Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Aadhar Number            :  ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2, child: Text(profile!.AadharNumber)),
                                      
                                ],
                              ),
                               8.heightBox,
                                 Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Current Cost Center     : ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2, child: Text(profile!.costCenterName)),
                                      
                                ],
                              ),
                                    8.heightBox,
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Phone                             :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                  Expanded(
                                      flex: 2, child: Text(_profile!.mobile)),
                                      
                                ],
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      20.heightBox,
                      // Card(
                      //   elevation: 5,
                      //   color: Colors.white,
                      //   shape: RoundedRectangleBorder(),
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 20, vertical: 10),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Contact Info",
                      //           style: TextStyle(
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black),
                      //         ),
                      //         Divider(),
                      //         10.heightBox,
                      //         Row(
                      //           children: [
                      //             Expanded(
                      //               flex: 1,
                      //               child: Text(
                      //                 "Phone",
                      //                 style: TextStyle(
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.black,
                      //                 ),
                      //               ),
                      //             ),
                      //             Expanded(
                      //               flex: 1,
                      //               child: Text(
                      //                 _profile!.mobile,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         8.heightBox,
                      //       ],
                      //     ),
                      //   ),
                      // )
                   
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
