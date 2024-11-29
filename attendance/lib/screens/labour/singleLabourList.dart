import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:faecauth/screens/image_viewer.dart';
import 'package:faecauth/screens/labour/labourattandanceCalendar.dart';
import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
import 'package:faecauth/screens/model/daily_attendance_model.dart';
import 'package:faecauth/screens/model/get_all_registered_faces.dart';
import 'package:faecauth/screens/model/profile_model.dart';

import 'package:faecauth/screens/model/total_present_absent_model.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';
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

String?LabourFaceImage;

class LaboursDetails extends StatefulWidget {
  final TDS onedata;
  const LaboursDetails({super.key, required this.onedata});

  @override
  State<LaboursDetails> createState() => _LaboursDetailsState();
}

class _LaboursDetailsState extends State<LaboursDetails> {
  bool loading = false;
  final controller = Get.put(HonmePageController());
  var report = DailyAttendanceReportModel().obs;
  var totalPresentAbsent = TotalPresentAbsentModel().obs;

  Uint8List? imageData;
  final facematcher = FaceMatcher.instance;

  bool isLoading = true;
  final currentDate = DateTime.now();

  // Future<void> addFace() async {
  //   showCountdownDialog(context, 5);
  //   await facematcher.registerFaceLabour(
  //     widget.onedata.labourId,
  //     widget.onedata.fullName!,
  //     widget.onedata.faceImage == null
  //         ? ""
  //         : widget.onedata.faceImage.toString(),
  //   );
  // }

  Uint8List? pickedImg;
  DateTime? punchInTime;
  // Future<void> matchFace() async {
  //   await facematcher.matchFaceLabour(widget.onedata.labourId!, faceImag ?? "");
  //   setState(() {
  //     punchInTime = DateTime.now();
  //   });
  // }
  Future<String?> setCostCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CostCenterId');
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

  Future<void> getRegisteredFace() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      print("Error: EMP_BasicDetail_Id not found");
      return;
    }
print(widget.onedata.labourId);
    String url =
        'http://rapi.railtech.co.in/api/LabourFaceRegistration/getFaceRegistered';

    Map<String, dynamic> requestData = {
      "LabourId": widget.onedata.labourId,
      "MarkedByUserId": null,
      "Status": null
    };

    try {
      // Send POST request to get face data
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestData),
      );

    
      if (response.statusCode == 200) {
        controller.loder.value = false;
        final jsonResponse = jsonDecode(response.body);
        // print("jsonResponseskjdhksjhs${empId}");
        setState(() {
          registeredFaceResponseModel.value =
              GetAllRegisteredFaceModel.fromJson(jsonResponse);
          // print("jsonResponseskjdhksjhs${registeredFaceResponseModel.value}");
        });
        if (jsonResponse['FRV'] != null && jsonResponse['FRV'] is List) {
          List<dynamic> frvList = jsonResponse['FRV'] ?? [];
          final allFutures = frvList.map((e) => getFaceDataByImageUrl(e['FaceImage']));
          final result = await Future.wait(allFutures);
          for (var x in result) {
            setState(() {
              if (x != null && !allFaces.contains(x)) {
                allFaces.add(x);
              }
            });
          }
        } else {
          controller.loder.value = false;
          // print("No faces found in the response.");
        }
      } else {
        controller.loder.value = false;
        // print("Failed to fetch faces: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error fetching faces: $e");
    }
  }

Future<MultiFaceInput?> getFaceDataByImageUrl(String faceImageUrl) async {
  managerId = await getManagerId();
  String? empId = await getEmpBasicDetailId();
  
  if (faceImageUrl.isEmpty) return null;
  
  setState(() {
    faceImag = null;
  });
  
  // Check if the URL is valid and download the image
  if (faceImageUrl.isNotEmpty) {
    faceImag = await AppHelperFunction.downloadImageByUrl(faceImageUrl);
  }
  
  if (faceImag == null || faceImag!.isEmpty) {
    faceImag = await AppHelperFunction.downloadImageByUrl("assets/face2.png");
  }
  
  if (faceImag == null || faceImag!.isEmpty) {
    return null;
  }
  
  // Prepare the JSON for the face input
  Map<String, dynamic> json = {
    'imageBase64': faceImag,
    'imageName': widget.onedata.fullName,
    'empId': widget.onedata.labourId,
    'MarkedByUserId': empId,
  };

  return MultiFaceInput.fromJson(json);
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
      String address ="${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, (${place.postalCode}), ${place.country}";
      return address;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<void> _getLocation() async {
    String locations = await getCurrentLocation();
    setState(() {
      location = locations;
    });
  }

  Future<void> getLocation() async {
    String? labourId = widget.onedata.labourId;
    String? faceImageLabour = widget.onedata.faceImage64;
    String locations = await getCurrentLocation();
    if (locations.startsWith("Error:")) {
      _showErrorDialog(locations);
    } else {
      showCountdownDialog(context, 5);

      await facematcher.matchFaceLabour(labourId ?? "", faceImageLabour??"");
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
          content:
              Text(" Sorry,We Can't Find Your Loctaion\n please Try Again"),
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
                  Text(
                    'Wait $countdown seconds.',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              // actions: [
              //   TextButton(
              //     onPressed: () {s
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

  Map<DateTime, bool> getAttendanceStatus(DailyAttendanceReportModel model) {
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
        'http://rapi.railtech.co.in/api/LabourPunch/getPunchReortEmployee';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'LabourId': widget.onedata.labourId,
          'PunchDateTime': null,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        setState(() {
          report.value = DailyAttendanceReportModel.fromJson(jsonResponse);
          final model = DailyAttendanceReportModel.fromJson(jsonResponse);
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
    String url =
        'http://rapi.railtech.co.in/api/LabourPunch/getTotalPresentAbsent';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "LabourId": widget.onedata.labourId,
          "EMPId": widget.onedata.eMPId,
          "FullName": null,
          "DepartmentHead": null,
          "CostCenterName": null,
          "TotalPresent": null,
          "TotalAbsent": null,
          "Month": "10",
          "Year": "2024"
        }),
      );
      if (response.statusCode == 200) {
        // print("-----------------------------------------total--------------------------");

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

  Future<void> _showImageDialog(BuildContext context) async {
    // print("=============>>>>  $faceImage64");
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
                      ?
                      // Image.network(faceImag??"", height: 70,width: 70,)
                      Image.memory(
                          base64Decode(faceImag ?? ""),
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
    getManagerId().then((managerIds) {
      if (managerIds != null) {
        setState(() {
          managerId = managerIds;
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await getRegisteredFace();
      await fetchAttendanceReport();

      await _getLocation();
      // await getTotalPresentAbsent();
    });
    super.initState();
  }
bool isWithinPunchInTime() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day, 8); 
  final end = DateTime(now.year, now.month, now.day,11,30); 
  return now.isAfter(start) && now.isBefore(end);
}
  @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.onedata.fullName ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (registeredFaceResponseModel.value.status == "Success")
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HeatMapCalendar(report: report.value, img: faceImage64),
                  ),
                );
            },
            icon: Icon(Icons.calendar_month),
          ),
          IconButton(
              onPressed: () async {
                await _getLocation();
                await getRegisteredFace();
                await fetchAttendanceReport();
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _getLocation();
          await getRegisteredFace();
          await fetchAttendanceReport();
        },
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              await _getLocation();
              await getRegisteredFace();
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
                                            // ? Image.network(faceImag??"", height: 70,width: 70,)
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  10.heightBox,
                                  Text(
                                    widget.onedata.fullName ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    widget.onedata.eMPId ?? "",
                                    // profile?.designation ?? "",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Text(
                                  //   profile?.costCenterName ?? "",
                                  //   style: TextStyle(
                                  //     color: Colors.black38,
                                  //     fontSize: 13,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   profile?.tenderUid ?? "",
                                  //   style: TextStyle(
                                  //     color: Colors.black38,
                                  //     fontSize: 13,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Spacer(),
                            // if (registeredFaceResponseModel
                            //             .value.fRV?[0].status !=
                            //         "Rejected" &&
                            //     registeredFaceResponseModel
                            //             .value.fRV?[0].status !=
                            //         "Approved" &&
                            //     report.value.ePRE?.length == 0)
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: GestureDetector(
                            //       // onTap: addFace,
                            //       child: Card(
                            //         elevation: 3,
                            //         color: Colors.orange,
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(2)),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 5, vertical: 8),
                            //           child: Center(
                            //               child: Text(
                            //             textAlign: TextAlign.center,
                            //             "${registeredFaceResponseModel.value.fRV?[0].status}...\nwait till\nApproved\nor\nReject",
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold),
                            //           )),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // if (registeredFaceResponseModel
                            //             .value.fRV?[0].status ==
                            //         "Rejected" &&
                            //     report.value.ePRE?.length == 0)
                            //   Padding(
                            //     padding: const EdgeInsets.only(top: 10),
                            //     child: GestureDetector(
                            //       onTap: addFace,
                            //       child: Card(
                            //         elevation: 3,
                            //         color: Colors.orange,
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(2)),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               horizontal: 5, vertical: 8),
                            //           child: Center(
                            //               child: Text(
                            //             textAlign: TextAlign.center,
                            //             "Re-register\nYour Face",
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold),
                            //           )),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            Visibility(
                              visible: report.value.ePRE?.length == 0 &&
                                  registeredFaceResponseModel
                                          .value.fRV?[0].status ==
                                      "Approved",
                                      //  && isWithinPunchInTime(),
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
                                    report.value.ePRE?[0].firstPunchTime != "" ,
                                    // && isWithinPunchInTime(),
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
                            // if (report.value.ePRE?.length != 0)
                            //   Visibility(
                            //     visible: registeredFaceResponseModel.value.fRV?[0].status =="Approved" &&
                            //         report.value.ePRE?[0].punchDate ==DateFormat('dd/MM/yyyy').format(currentDate) &&
                            //         report.value.ePRE?[0].lastPunchTime == "",
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(top: 10),
                            //       child: GestureDetector(
                            //         onTap: matchFace,
                            //         child: Card(
                            //           elevation: 3,
                            //           color: Colors.orange,
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:  BorderRadius.circular(2)),
                            //           child: Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 5, vertical: 8),
                            //             child: Center(
                            //               child: Text(
                            //                 "Punch Out",
                            //                 style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.bold),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
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
                                    Padding(
                                      padding: EdgeInsets.only(left: 35),
                                      child: Row(
                                        children: [],
                                      ),
                                    ),

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
                            Container(
                              width: Get.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.onedata.fullName ?? "",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.onedata.eMPId ?? "",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                        10.heightBox,
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
                                                                "00:00",
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
                                                  // 15.widthBox,
                                                  // Expanded(
                                                  //   flex: 1,
                                                  //   child: Column(
                                                  //     children: [
                                                  //       epre.lastPunchTime != ""
                                                  //           ? Text(
                                                  //               "${epre.lastPunchTime?.split(' ')[1] ?? ""}${epre.lastPunchTime?.split(' ')[2] ?? ""}",
                                                  //               style:
                                                  //                   TextStyle(
                                                  //                 fontWeight:
                                                  //                     FontWeight
                                                  //                         .normal,
                                                  //               ),
                                                  //             )
                                                  //           : Text(""),
                                                  //       5.heightBox,
                                                  //       epre.lastImage!
                                                  //                   .isNotEmpty &&
                                                  //               epre.lastImage !=
                                                  //                   "http://rapi.railtech.co.in/" &&
                                                  //               epre.lastImage !=
                                                  //                   null
                                                  //           ? InkWell(
                                                  //               onTap: () =>
                                                  //                   Navigator
                                                  //                       .push(
                                                  //                 context,
                                                  //                 MaterialPageRoute(
                                                  //                   builder:
                                                  //                       (context) =>
                                                  //                           ImageViewerScreen(
                                                  //                     image: epre
                                                  //                             .lastImage ??
                                                  //                         "assets/face2.png",
                                                  //                     location:
                                                  //                         epre.lastLocation ??
                                                  //                             "Location N/A",
                                                  //                     dateTime:
                                                  //                         epre.lastPunchTime ??
                                                  //                             'N/A',
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //               child:
                                                  //                   Container(
                                                  //                 decoration:
                                                  //                     BoxDecoration(
                                                  //                   borderRadius:
                                                  //                       BorderRadius.circular(
                                                  //                           10),
                                                  //                   border:
                                                  //                       Border
                                                  //                           .all(
                                                  //                     color: Colors
                                                  //                         .green,
                                                  //                     width:
                                                  //                         1.5,
                                                  //                   ),
                                                  //                 ),
                                                  //                 child: Image
                                                  //                     .network(
                                                  //                   epre.lastImage ??
                                                  //                       "",
                                                  //                   height: 55,
                                                  //                   width: 55,
                                                  //                   fit: BoxFit
                                                  //                       .cover,
                                                  //                 ),
                                                  //               ),
                                                  //             )
                                                  //           : Container(
                                                  //               height: 55,
                                                  //               width: 55,
                                                  //               decoration:BoxDecoration(
                                                  //                 borderRadius:  BorderRadius.circular(10),
                                                  //                 border: Border.all(
                                                  //                   color: Colors.green,
                                                  //                   width: 1.5,
                                                  //                 ),
                                                  //               ),
                                                  //               child: Icon(
                                                  //                 Icons.person,
                                                  //                 size: 50,
                                                  //                 color: const Color
                                                  //                     .fromRGBO(
                                                  //                     0,
                                                  //                     0,
                                                  //                     0,
                                                  //                     0.38),
                                                  //               ),
                                                  //             ),
                                                  //     ],
                                                  //   ),
                                                  // ),
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
                                                            decoration:BoxDecoration(
                                                              borderRadius:  BorderRadius.circular(10),
                                                              border:  Border.all(color: Colors.green,width: 1.5,
                                                              ),
                                                            ),
                                                            child: epre.firstImage!.isNotEmpty &&epre.firstImage !="" &&epre.firstImage !=null? Image.network(epre.firstImage ??"",height: 55,width: 55,fit: BoxFit.cover,): Image.asset("assets/face2.png",height: 55,  ),
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
                                                        Text(epre.lastPunchTime?.split(' ').last ??'00:00',style: TextStyle(fontWeight:FontWeight.normal,
                                                          ),
                                                        ),
                                                        5.heightBox,
                                                        epre.lastImage!.isNotEmpty &&epre.lastImage !="http://rapi.railtech.co.in/" &&epre.lastImage !=null
                                                            ? InkWell(
                                                                onTap: () =>
                                                                    Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:(context) =>ImageViewerScreen(
                                                                      image: epre.lastImage ??
                                                                          "assets/face2.png",
                                                                      location:
                                                                          epre.lastLocation ??   "Location N/A",
                                                                      dateTime:
                                                                          epre.lastPunchTime ??   'N/A',
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),  border:Border.all(color: Colors.green,width:1.5,),
                                                                  ),
                                                                  child: Image.network(
                                                                    epre.lastImage ??  "",
                                                                    height: 55,
                                                                    width: 55,
                                                                    fit: BoxFit  .cover,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:BoxDecoration(
                                                                  borderRadius:  BorderRadius.circular(10),
                                                                  border: Border.all(color: Colors.green,width: 1.5,
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons.person,
                                                                  size: 50,
                                                                  color: const Color.fromRGBO(0,0,0,0.38),
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
