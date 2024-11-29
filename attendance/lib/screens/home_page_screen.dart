import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/drawer/drawer.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/auth/login_with_email.dart';
import 'package:faecauth/screens/image_viewer.dart';
import 'package:faecauth/screens/model/daily_attendance_model.dart';
import 'package:faecauth/screens/model/get_all_registered_faces.dart';
import 'package:faecauth/screens/model/profile_model.dart';
import 'package:faecauth/screens/model/total_present_absent_model.dart';
import 'package:faecauth/screens/team_atte_per_emp.dart';
import 'package:faecauth/screens/view_attendance.dart';
import 'package:faecauth/utils/appHelper/app_helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

String? managerId;
List<MultiFaceInput> allFaces = [];
List<MultiFaceInput> multiFaceInputs = [];
MultiFaceInput? multiFaceIn;
Profile? profile;
Image? imageWidget;
String? location = "";
var registeredFaceResponseModel = GetAllRegisteredFaceModel().obs;
String? faceImage64;

class HonmePageController extends GetxController {
  RxBool loder = false.obs;
}

class HomePageScreeen extends StatefulWidget {
  const HomePageScreeen({super.key});

  @override
  State<HomePageScreeen> createState() => _HomePageScreeenState();
}

class _HomePageScreeenState extends State<HomePageScreeen> {
  final controller = Get.put(HonmePageController());
  final controller1 = Get.put(HonmePageController());
  bool loading = false;
  Timer? _timer;
  var report = DailyAttendanceReportModel().obs;
  var totalPresentAbsent = TotalPresentAbsentModel().obs;
  Uint8List? imageData;
  final facematcher = FaceMatcher.instance;
  bool isLoading = true;
  DateTime? _selectedDate;
  final currentDate = DateTime.now();
  Future<void> addFace() async {
      
    String? empId = await getEmpBasicDetailId();
    String? empName = await getEmpName();
     showCountdownDialog(context, 5);
    await facematcher.registerFace(
        empId,
        empName!,
        registeredFaceResponseModel.value.statusCode == 0? "": registeredFaceResponseModel.value.fRV![0].faceImage!);
       
  }

  Uint8List? pickedImg;
  // Future<void> matchFace() async {
  //   String? empId = await getEmpBasicDetailId();
  //   await facematcher.matchFace(empId!, faceImage64!);
  // }

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
    controller.loder.value = false;
    String? empId = await getEmpBasicDetailId();
    String? empName = await getEmpName();
    if (json is! Map<String, dynamic>) return null;
    setState(() {
      faceImage64 = json['FaceImage64'];
    });
    String faceImageURL = json['FaceImage'];
    if ((faceImage64 == null || faceImage64!.isEmpty) &&
        faceImageURL.isNotEmpty) {
      faceImage64 = await AppHelperFunction.downloadImageByUrl(faceImageURL);
    } else {
      faceImage64 =
          await AppHelperFunction.downloadImageByUrl("assets/face2.png");
    }
    if (faceImage64 == null || faceImage64!.isEmpty) {
      return null;
    }
    // json['imageName'] = faceImageURL.split("/").last;
    json['imageName'] = empName;
    json['imageBase64'] = faceImage64;
    // json['empId'] = json['EMPKey'];
    json['empId'] = empId;
    return MultiFaceInput.fromJson(json);
  }

  Future<void> getregisteredface() async {
    controller.loder.value = true;
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      // print("EMP_BasicDetail_Id not found");
      return;
    }
    String url = ApiUrls.matchRegisteredFace;
    Map<String, dynamic> data = {
      "FaceRegistrationId": null,
      "EMP_BasicDetail_Id": empId,
      "FullName": null,
      "EMPKey": null,
      "FaceImage": null,
      "Location": null,
      "Status": null,
      "MarkedByUserId": empId
    };
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
        controller.loder.value = false;
        final jsonResponse = jsonDecode(response.body);
        // print("jsonResponseskjdhksjhs${empId}");
        setState(() {
          registeredFaceResponseModel.value =GetAllRegisteredFaceModel.fromJson(jsonResponse);
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

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //       'Location permissions are permanently denied, we cannot request permissions.',
  //     );
  //   }
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //     // timeLimit: Duration(seconds: 10),
  //   );
  // }

Future<Position> _determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    _showLocationDialog(context, 'Location services are disabled. Please enable them in settings.');
    return Future.error('Location services are disabled.');
  }

  // Check location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showLocationDialog(context, 'Location permissions are denied. Please enable them in settings.');
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    _showLocationDialog(context, 'Location permissions are permanently denied. Please enable them in settings.');
    return Future.error('Location permissions are permanently denied');
  }

  // Return the current position if permissions are granted
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  
  );
}

// Function to show a dialog guiding the user to enable location
void _showLocationDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Location Permission Required'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Geolocator.openLocationSettings(); // Open location settings
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Enable'),
        ),
      ],
    ),
  );
}

//IF LOACTION SERVICE PREFETCH THEN CACHHE HIT 10 MIN
  Future<String> getCurrentLocation() async {
    try {
      Position position = await _determinePosition(context);
      // Set a timeout for the placemark retrieval
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      //CHECK CURRENT LOCATION WITN LATLOGN 
      // .timeout(
      //   Duration(seconds: 10),
      //   onTimeout: () => throw TimeoutException("Geocoding request timed out."),
      // );

      Placemark place = placemarks[0];
      String address ="${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, (${place.postalCode}), ${place.country}";
        //  print( "===================$address");
          //CHECK IF VALUE ARE NULLABLE(28/11/2024)
          
      return address;
    } catch (e) {
      return "Error: ${e.toString()}";
       
    }
  }

  Future<void> _getLocation() async {
    String locations = await getCurrentLocation();
    if (locations.startsWith("Error:")) {
      // _showErrorDialog(locations);
    } else {
      setState(() {
        location = locations;
      });
    }
  }

  Future<void> getLocation() async {
    String locations = await getCurrentLocation();
    if (locations.startsWith("Error:")) {
      // _showErrorDialog(locations);
    } else {
      String? empId = await getEmpBasicDetailId();
       showCountdownDialog(context, 5);
      await facematcher.matchFace(empId!, faceImage64!);
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Error"),
          content: Text("We Can't Find Your Loctaion\n please Try Again"),
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
        'http://rapi.railtech.co.in/api/EMPPunch/getPunchReortEmployee';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>
        {
          'EMP_BasicDetail_Id': empId,
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
      print("Error during fetching attendance report: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getTotalPresentAbsent() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      print("Employee ID is null");
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
          "EMP_BasicDetail_Id": empId,
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

  Future<void> _removeFace() async {
    try {
      String? empId = await getEmpBasicDetailId();
      String? empName = await getEmpName();
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

  Future<void> employeeStatus() async {
    try {
      String? empId = await getEmpBasicDetailId();
      const baseUrl = 'http://rapi.railtech.co.in/api/Login/getEmployeeStatus';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"EMP_BasicDetail_Id": empId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          if (responseData['CD']['IsActive'] == "False") {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: 'Your account is inactive. Do you want to log out?',
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('isLoggedIn');
                prefs.remove("logResponseKey");

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (route) => false,
                );
              },
            );
          } else {}
        } else {
          // print("Error: ${responseData['Message']}");
        }
      } else {
        // print(
            // "Error: Server responded with status code ${response.statusCode}");
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
                  setState(()async {
                    // addFace();
                  await  getregisteredface();
                  });
                },
                child: Text("Retake")),
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

// Future<void> showCountdownDialog(BuildContext context, int seconds) async {
//   int countdown = seconds;
//   Timer? timer;

//   // Update countdown every second
//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (countdown == 0) {
//         timer.cancel();
//         Navigator.of(context).pop(); // Close the dialog box when countdown reaches 0
//       } else {
//         countdown--;
//         (context as Element).markNeedsBuild(); // Rebuild to show updated countdown
//       }
//     });
//   }

//   // Show dialog and start the timer
//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       startTimer();
//       return AlertDialog(
//         title: Text('Please wait...'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Registering face in $countdown seconds.'),
//             SizedBox(height: 20),
//             CircularProgressIndicator(),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               timer?.cancel();
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//         ],
//       );
//     },
//   );
  
//   timer?.cancel(); 
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
                Obx(() => controller.loder.value == true
                    ? Lottie.asset("assets/loading.json",
                        height: Get.height * 0.01, width: Get.height * 0.01)
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        // child: imageWidget,
                        // child: faceImage64 != ""
                        //     ? Image.memory(
                        //         base64Decode(faceImage64!),
                        //         height: 70,
                        //         width: 70,
                        //         fit: BoxFit.fill,
                        //       )
                        //     : Icon(Icons.person),
                        child:
                            registeredFaceResponseModel.value.fRV?[0].status !=
                                    "Rejected"
                                ? (faceImage64 != null
                                // ?Image.network(registeredFaceResponseModel.value.fRV?[0].faceImage??"",height: 60,width: 60,fit: BoxFit.fill,)
                                    ? Image.memory(
                                        base64Decode(faceImage64.toString()),
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.fill,
                                      )
                                    : Icon(Icons.person)
                                    )
                                : Icon(
                                    Icons.person,
                                    size: 65,
                                    color: Colors.grey,
                                  ),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime currentTime = DateTime.now();

  DateTime? parseTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    try {
      // Adjust this format if necessary
      return DateFormat("yyyy-MM-dd hh:mm a").parse(dateTimeString).toLocal();
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  Widget? imageWidget;
  DateTime? selectedDate;
  List<EPRE> filteredList = [];

  @override
  void initState() {
    getregisteredface();
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
      await getregisteredface();
      await fetchAttendanceReport();
      await _fetchProfileData();
      await _getLocation();
      await getTotalPresentAbsent();
      await employeeStatus();
    });
    //     _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
    //   await getregisteredface();

    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                if (registeredFaceResponseModel.value.status == "Success")
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeatMapCalendar(
                          report: report.value, img: faceImage64),
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
            'Railtech Infraventure Pvt Ltd',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ).gradientBackground(withActions: true),
        drawer: registeredFaceResponseModel.value.status != "Success"
            ? Drawer(
                child: Center(
                    child: Text(
                textAlign: TextAlign.center,
                "Please Register Your\n Face First",
                style: TextStyle(fontSize: 35, color: Colors.black26),
              )))
            : DrawerWidget(),
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
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
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
                                            onTap: () =>
                                                _showImageDialog(context),
                                            child: registeredFaceResponseModel
                                                        .value.fRV?[0].status !=
                                                    "Rejected" 
                                                ? (faceImage64 != null
                                                // ?Image.network(registeredFaceResponseModel.value.fRV?[0].faceImage??"",height: 60,width: 60,fit: BoxFit.fill,)
                                                    ? Image.memory(
                                                        base64Decode(faceImage64
                                                            .toString()),
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Icon(Icons.person))
                                                : Icon(
                                                    Icons.person,
                                                    size: 65,
                                                    color: Colors.grey,
                                                  )),
                                      ),
                                    )
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
                                      profile?.fullName ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      profile?.designation ?? "",
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      profile?.empKey ?? "",
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (registeredFaceResponseModel
                                                .value.fRV?[0].status ==
                                            "Pending"
                                        //     &&
                                        // report.value.ePRE?.length == 0
                                        )
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: InkWell(
                                          onTap: () =>
                                              showConfirmationDialog(context),
                                          child: Card(
                                            elevation: 3,
                                            color: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Padding(
                                              padding:EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                                              child: Center(
                                                child: Text(
                                                  "Face Retake",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
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
                              if (registeredFaceResponseModel
                                          .value.fRV?[0].status ==
                                      "Pending"
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
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 8),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "Pending\nApproval",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (registeredFaceResponseModel.value.fRV?[0].status =="Rejected")
                                //&& report.value.ePRE?.length == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GestureDetector(
                                    onTap: addFace,
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
                                  visible: report.value.ePRE?[0].punchDate !=
                                          DateFormat('dd/MM/yyyy')
                                              .format(currentDate) &&
                                      registeredFaceResponseModel
                                              .value.fRV?[0].status ==
                                          "Approved" &&
                                      report.value.ePRE?[0].firstLocation != "",
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
                                      report.value.ePRE?[0].lastPunchTime ==
                                          "" ,
                                      //     &&
                                      // (parseTime(report.value.ePRE?[0]
                                      //             .afterFirstPunch)
                                      //         ?.isBefore(DateTime.now()) ??
                                      //     false),
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

                              // if (report.value.ePRE!.length != 0)
                              //   Visibility(
                              //     visible: report.value.ePRE?[0].punchDate == DateFormat('dd/MM/yyyy').format(currentDate) && allFaces.last.imageBase64 != "" && report.value.ePRE?[0].lastPunchTime == "",
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(top: 10),
                              //       child: GestureDetector(
                              //         onTap: registeredFaceResponseModel.value.fRV![0].status != "Approved" ? null : matchFace,
                              //         child: Card(
                              //           elevation: 3,
                              //           color: Colors.orange,
                              //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              //           child: Padding(
                              //             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              //             child: Center(
                              //                 child: Text(
                              //               "Punch Out",
                              //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              //             )),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),

                              // Spacer(),

                              // registeredFaceResponseModel.value.fRV![0].status == "Pending" || registeredFaceResponseModel.value.fRV![0].status == "Rejected"
                              //     ? Card(
                              //         shape: RoundedRectangleBorder(),
                              //         child: Padding(
                              //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              //           child: Text(
                              //             textAlign: TextAlign.center,
                              //             "Image is\nin Under\nPending..",
                              //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                              //           ),
                              //         ))
                              //     : Column(
                              //         children: [
                              // Visibility(
                              //   visible: (report.value.ePRE?[0].punchDate != DateFormat('dd/MM/yyyy').format(currentDate) && report.value.ePRE?[0].firstLocation != ""),
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 10),
                              //     child: GestureDetector(
                              //       onTap: registeredFaceResponseModel.value.fRV![0].status == "Pending" || registeredFaceResponseModel.value.fRV![0].status == "Rejected" ? null : matchFace,
                              //       child: Card(
                              //         elevation: 3,
                              //         color: Colors.orange,
                              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              //           child: Center(
                              //               child: Text(
                              //             "  Punch In ",
                              //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              //           )),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              //           Visibility(
                              //             visible: (report.value.ePRE?[0].punchDate == DateFormat('dd/MM/yyyy').format(currentDate) && allFaces.last.imageBase64 != "" && report.value.ePRE?[0].lastPunchTime == ""),
                              //             child: Padding(
                              //               padding: const EdgeInsets.only(top: 10),
                              //               child: GestureDetector(
                              //                 onTap: registeredFaceResponseModel.value.fRV![0].status == "Pending" || registeredFaceResponseModel.value.fRV![0].status == "Rejected" ? null : matchFace,
                              //                 child: Card(
                              //                   elevation: 3,
                              //                   color: Colors.orange,
                              //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              //                     child: Center(
                              //                       child: Text(
                              //                         "Punch out",
                              //                         style: TextStyle(
                              //                           color: Colors.white,
                              //                           fontWeight: FontWeight.bold,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      10.heightBox,
                                      Padding(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Cost Center : ",
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              profile?.costCenterName ?? "",
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 35),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Tender Id : ",
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              profile?.tenderUid ?? "",
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                      // Container(
                                      //   width: Get.width * 0.8,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(left: 20),
                                      //     child: Card(
                                      //       elevation: 3,
                                      //       shape: RoundedRectangleBorder(),
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      //         child: Column(
                                      //           children: [
                                      //             Row(
                                      //               mainAxisAlignment: MainAxisAlignment.center,
                                      //               children: [
                                      //                 Text(
                                      //                   "Cost Center = ",
                                      //                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Text(
                                      //                   profile?.costCenterName ?? "",
                                      //                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                      //                 ),
                                      //                 15.widthBox,
                                      //                 Container(
                                      //                   height: 20,
                                      //                   width: 2,
                                      //                   color: Colors.black38,
                                      //                 ),
                                      //                 15.widthBox,
                                      //                 Text(
                                      //                   "Tender Id = ",
                                      //                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                      //                 ),
                                      //                 Spacer(),
                                      //                 Text(
                                      //                   profile?.tenderUid ?? "",
                                      //                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                      //                 ),
                                      //                 5.widthBox,
                                      //               ],
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      Divider()
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
                                width: Get.width * 0.52,
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
                              Spacer(),
                              IconButton(
                                  onPressed: () {
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
                                              builder: (context) =>
                                                  HomePageScreeen())),
                                      onConfirmBtnTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginView())),
                                    );
                                  },
                                  icon: Card(
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.logout_sharp,
                                          color: Colors.white,
                                        ),
                                      )))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                         
                              InkWell(
                                onTap: addFace,
                                // onTap: () async {
                                //   await facematcher.registerFace(registeredFaceResponseModel.value.fRV![0].eMPBasicDetailId, registeredFaceResponseModel.value.fRV![0].fullName!, registeredFaceResponseModel.value.fRV![0].faceImage!.toString());
                                // },
                                child: Container(
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 18),
                                          Image.asset(
                                            "assets/face2.png",
                                            height: 70,
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                         
                            ],
                          ),
                          10.heightBox,
                        ],
                      ),
                    ),

                  // if (registeredFaceResponseModel.value.fRV!.length > 0)
                  // isLoading
                  //     ? Center(child: CircularProgressIndicator())
                  //     : report.value.ePRE![0].firstPunchTime!.isEmpty
                  //         ? Image.asset("assets/nodataa.png")
                  //         :

                  report.value.ePRE?.length != 0
                      ? Column(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     left: 10,
                            //     top: 10,
                            //     right: 10,
                            //   ),
                            //   child: InkWell(
                            //     onTap: () {
                            //       showMonthPicker(
                            //         context: context,
                            //         headerColor: Colors.teal,
                            //         selectedMonthBackgroundColor: Colors.amber,
                            //         initialDate: DateTime.now(),
                            //       ).then(
                            //         (date) {
                            //           if (date != null) {
                            //             setState(() {
                            //               selectedDate = date;
                            //             });
                            //           }
                            //         },
                            //       );
                            //     },
                            //     child: Container(
                            //       height: MediaQuery.of(context).size.height * 0.07,
                            //       decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(10)),
                            //       child: Padding(
                            //         padding: EdgeInsets.symmetric(horizontal: 2),
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.calendar_month, color: Colors.black38),
                            //             20.widthBox,
                            //             Text(
                            //               _selectedDate == null ? '${DateFormat('dd/MM/yyyy').format(currentDate)}' : "${DateFormat('MMM/yyyy').format(_selectedDate!)}",
                            //               style: TextStyle(
                            //                 color: Colors.black45,
                            //                 fontWeight: FontWeight.bold,
                            //               ),
                            //             ),
                            //             Spacer(),
                            //             IconButton(
                            //               onPressed: () {},
                            //               icon: Icon(
                            //                 Icons.cancel,
                            //                 color: Colors.black38,
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // 5.heightBox,
                            Divider(),
                            Obx(
                              () => controller1.loder.value == true
                                  ? Center(
                                      child: Lottie.asset("assets/loading.json",
                                          height: 200, width: 300),
                                    )
                                  : Container(
                                      height: Get.height * 0.53,
                                      child: ListView.builder(
                                        itemCount:
                                            report.value.ePRE?.length ?? 0,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          EPRE epre = report.value.ePRE![index];
                                          // print("=>>>>>>>>>>>>>>>>>>>>>>>>  ${  epre.firstLocation}");
                                          return Column(
                                            children: [
                                              epre.punchDate != ""
                                                  ? Card(
                                                      elevation: 3,
                                                      shape:
                                                          RoundedRectangleBorder(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            28),
                                                                    child: Text(
                                                                      "Date: ${epre.punchDate ?? 'N/A'}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black38),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            28),
                                                                    child: Text(
                                                                      "Status: ${epre.firstPunchTime != null ? 'Present' : 'Absent'}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black38,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            29),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "Working Hrs : ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black38,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          epre.workDuration ??
                                                                              "",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 6,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.65,
                                                                          child:
                                                                              Text(
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
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ImageViewerScreen(
                                                                      image: epre
                                                                              .firstImage ??
                                                                          "assets/myPic.jpeg",
                                                                      location:
                                                                          epre.firstLocation ??
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
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    5.heightBox,
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              1.5,
                                                                        ),
                                                                      ),
                                                                      child: epre.firstImage!.isNotEmpty &&
                                                                              epre.firstImage !=
                                                                                  "" &&
                                                                              epre.firstImage !=
                                                                                  null
                                                                          ? Image
                                                                              .network(
                                                                              epre.firstImage ?? "",
                                                                              height: 55,
                                                                              width: 55,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : Image
                                                                              .asset(
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
                                                                  epre.lastPunchTime !=
                                                                          ""
                                                                      ? Text(
                                                                          "${epre.lastPunchTime?.split(' ')[1] ?? ""}${epre.lastPunchTime?.split(' ')[2] ?? ""}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          ""),
                                                                  5.heightBox,
                                                                  epre.lastImage!
                                                                              .isNotEmpty &&
                                                                          epre.lastImage !=
                                                                              "http://rapi.railtech.co.in/" &&
                                                                          epre.lastImage !=
                                                                              null
                                                                      ? InkWell(
                                                                          onTap: () =>
                                                                              Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => ImageViewerScreen(
                                                                                image: epre.lastImage ?? "assets/face2.png",
                                                                                location: epre.lastLocation ?? "Location N/A",
                                                                                dateTime: epre.lastPunchTime ?? 'N/A',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: Border.all(
                                                                                color: Colors.green,
                                                                                width: 1.5,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Image.network(
                                                                              epre.lastImage ?? "",
                                                                              height: 55,
                                                                              width: 55,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              55,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.green,
                                                                              width: 1.5,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                50,
                                                                            color: const Color.fromRGBO(
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
                                                      shape:
                                                          RoundedRectangleBorder(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            28),
                                                                    child: Text(
                                                                      "Date: ${epre.punchDate ?? 'N/A'}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black38),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            28),
                                                                    child: Text(
                                                                      "Status: ${epre.firstPunchTime != null ? 'Present' : 'Absent'}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black38,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 6,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.65,
                                                                          child:
                                                                              Text(
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
                                                                    Navigator
                                                                        .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ImageViewerScreen(
                                                                      image: epre
                                                                              .firstImage ??
                                                                          "assets/myPic.jpeg",
                                                                      location:
                                                                          epre.firstLocation ??
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
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    5.heightBox,
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              1.5,
                                                                        ),
                                                                      ),
                                                                      child: epre.firstImage!.isNotEmpty &&
                                                                              epre.firstImage !=
                                                                                  "" &&
                                                                              epre.firstImage !=
                                                                                  null
                                                                          ? Image
                                                                              .network(
                                                                              epre.firstImage ?? "",
                                                                              height: 55,
                                                                              width: 55,
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          : Image
                                                                              .asset(
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
                                                                    style:
                                                                        TextStyle(
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
                                                                              Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => ImageViewerScreen(
                                                                                image: epre.lastImage ?? "assets/face2.png",
                                                                                location: epre.lastLocation ?? "Location N/A",
                                                                                dateTime: epre.lastPunchTime ?? 'N/A',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: Border.all(
                                                                                color: Colors.green,
                                                                                width: 1.5,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Image.network(
                                                                              epre.lastImage ?? "",
                                                                              height: 55,
                                                                              width: 55,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              55,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.green,
                                                                              width: 1.5,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                50,
                                                                            color: const Color.fromRGBO(
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
                            ),
                          ],
                        )
                      : Image.asset("assets/nodataa.png"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
