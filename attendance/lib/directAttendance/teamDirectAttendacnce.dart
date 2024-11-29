import 'dart:convert';
import 'package:face_liveness/face_liveness.dart';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/common/api_collections.dart';
import 'package:faecauth/directAttendance/directPunchInModel.dart';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/main.dart';
import 'package:faecauth/utils/appHelper/app_helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DirectAttendance extends StatefulWidget {
  const DirectAttendance({super.key});

  @override
  State<DirectAttendance> createState() => _DirectAttendanceState();
}

class _DirectAttendanceState extends State<DirectAttendance> {
 
  FaceLiveness faceLiveness = FaceLiveness();
    Future<void> matchFace() async {
        String? costCenterId = await getCostCenterId();

    await facematcher.matchFaceDirect(faceBase64Images,"");

  }

  bool isLoading = true;
  List<FRV> teamMembers = [];
  List<String> faceBase64Images = [];
  String? faceImage64;
  // DirectPunchInModel?directPunchInModel;
  var directPunchInModel =DirectAttendance().obs;
  
List<MultiFaceInput> allFaces = [];
  
 FRV ?frv;
      Future<void> getregisteredface() async {
  
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
        final jsonResponse = jsonDecode(response.body);
        // print("jsonResponseskjdhksjhs${empId}");
        setState(() {
        directPunchInModel.value =DirectPunchInModel.fromJson(jsonResponse) as DirectAttendance;
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
    Future<MultiFaceInput?> getFaceDataByImageUrl(dynamic json) async {

    String? empId = await getEmpBasicDetailId();
   
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
    json['imageName'] =null ;
    json['imageBase64'] = faceImage64;
    // json['empId'] = json['EMPKey'];
    json['empId'] = empId;
    return MultiFaceInput.fromJson(json);
  }


  Future<String?> getCostCenterId() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString('CostCenterId');
  }
    Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

Future<void> getTeamMemberList() async {
  String? costCenterId = await getCostCenterId();

  if (costCenterId == null) {
    setState(() {
      isLoading = false;
    });
    return;
  }

  String url = 'http://rapi.railtech.co.in/api/FaceRegistration/getByCostCenter';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"CostCenterId": costCenterId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final model = DirectPunchInModel.fromJson(data);
      setState(() {
        teamMembers = model.fRV ?? [];
        isLoading = false;
      });
       List<String> faceBase64Images = teamMembers
          .map((member) => member.faceImage64)
          .where((faceBase64) => faceBase64 != null) 
          .cast<String>()
          .toList();

      for (var faceBase64 in faceBase64Images) {
        print("Face Base64: $faceBase64");
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  void initState() {
    super.initState();
    getTeamMemberList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'ATTENDANCE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    InkWell(
                    onTap: matchFace,
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
                                height: 200,
                              ),
                              SizedBox(height: 10),
                              Text("Tap for PunchIn or PunchOut"),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
          ),
    );
  }
}
