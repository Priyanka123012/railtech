import 'package:face_liveness/face_liveness.dart';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMemberController extends GetxController {
  var isLoading = true.obs;
  var teamAttendanceModel = LabourListModel().obs;
  var filteredTeamMembers = <TDS>[].obs;
  LabourListModel? teamAttedanceModel;

 Future<bool> SetLabourName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('FullName', value);
  }

  Future<String?> getLabourEmpId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('EMPId');
  }

  Future<String?> getLabourId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('LabourId');
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<String?> setCostCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CostCenterId');
  }

  Future<void> getTeamMemberList() async {
    String? CostCenterId = await setCostCenterId();
    if (CostCenterId == null) {
      print("Employee ID is null");
      isLoading.value = false;
      return;
    }

    String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          // "EMP_BasicDetail_Id": null,
          // "MarkedByUserId": empId
          "LabourId": null,
          "MarkedByUserId": null,
          "CostCenterId": CostCenterId
        }),
      );

      print("Request URL: $url");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        teamAttendanceModel.value =
            LabourListModel.fromJson(jsonResponse);

        // Set the initial filtered list to all team members
        filteredTeamMembers.value = teamAttendanceModel.value.tDS ?? [];

        // Save the first team member's details
        if (teamAttendanceModel.value.tDS != null &&
            teamAttendanceModel.value.tDS!.isNotEmpty) {
          // await setTeamEmpBasicId(
          //     teamAttendanceModel.value.tDS![0].fullName.toString());
          // await setTeamEmpName(
          //     teamAttendanceModel.value.tDS![0].fullName.toString());
        }
        isLoading.value = false;
      } else {
        print(
            "Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
        isLoading.value = false;
      }
    } catch (e) {
      print("Error during fetching attendance report: $e");
      isLoading.value = false;
    }
  }

  void filterTeamMembers(String name) {
    if (name.isEmpty) {
      filteredTeamMembers.value = teamAttendanceModel.value.tDS ?? [];
    } else {
      filteredTeamMembers.value =
          teamAttendanceModel.value.tDS?.where((member) {
                return member.fullName
                        ?.toLowerCase()
                        .contains(name.toLowerCase()) ??
                    false;
              }).toList() ??
              [];
    }
  }

  Future<void> showImageDialog(BuildContext context, String img) async {
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
                  child: ClipRRect(
                    child: Image.network(
                      (img),
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final facematcher = FaceMatcher.instance;

  // Future<void>
  //     matchFace() async {
  //   String?
  //       empId =
  //       await grtTeamEmpBasicId();
  //   await facematcher.matchFace(empId!,fa);
  // }

  Future<MultiFaceInput?> getFaceDataByEmpId() async {
    String? empId = await getLabourEmpId();
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
  }

  void makePhoneCall(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final TextEditingController searchController = TextEditingController();
  final currentDate = DateTime.now();
  FaceLiveness faceLiveness = FaceLiveness();
}
