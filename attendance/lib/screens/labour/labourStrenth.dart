
// import 'package:faecauth/extension/appbar_ext.dart';
// import 'package:faecauth/screens/team_member/StafStrength.dart/AbsetListStaffStrenght.dart';
// import 'package:faecauth/screens/team_member/StafStrength.dart/presntListStaffStrenght.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class StaffAttendanceReport extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         foregroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         title: Text('Staff Strenght',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//       ).gradientBackground(withActions: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
           
          
//             // Tabs for different attendance statuses
//             Expanded(
//               child: DefaultTabController(
//                 length: 3,
//                 child: Column(
//                   children: [
//                     TabBar(
//                       labelColor: Colors.green,
//                       unselectedLabelColor: Colors.black54,
//                       indicatorColor: Colors.green,
//                       tabs: [
//                         Tab(text: "Present"),
//                         Tab(text: "Absent"),
//                         Tab(text: "Total Stre"),
                       
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                          PresentListStaffAttendance(),
//                          AbsentListStaffAttendance()
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
import 'package:faecauth/screens/labour/laboutModel/gettotalpresentabsent.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Labourstrenth extends StatefulWidget {
  const Labourstrenth({super.key});

  @override
  State<Labourstrenth> createState() => _LabourstrenthState();
}

class _LabourstrenthState extends State<Labourstrenth> {
  List<EP> _absentList = [];
  int totalStrength = 0;
  int presentToday = 0;
  int absentTotal = 0;
  GetTotalpresntabsentModel? getTotalpresntabsentModel;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  // Method to fetch absent list from the API

  // Method to fetch absent list from the API
 Future<void> _fetchAbsentList() async {
  try {
    String? empId = await getEmpBasicDetailId();
    const baseUrl = 'http://rapi.railtech.co.in/api/LabourPunch/get_Present_Absent_Count';
    String formattedStartDate = DateFormat('dd/MM/yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd/MM/yyyy').format(endDate);

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "StartDate": formattedStartDate,
        "EndDate": formattedEndDate,
        "Status": "",
        "MarkedByUserId": empId
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['StatusCode'] == 1) {
        final absentEmployeeList = GetTotalpresntabsentModel.fromJson(responseData);

        setState(() {
          _absentList = absentEmployeeList.eP ?? []; 
          presentToday = 0;
          absentTotal = 0;

          for (var emp in _absentList) {
            if (emp.status == "Present") {
              presentToday += int.tryParse(emp.totalCount ?? '0') ?? 0;
            } else if (emp.status == "Absent") {
              absentTotal += int.tryParse(emp.totalCount ?? '0') ?? 0;
            }
          }
        });
      } else {
        print("Error: ${responseData['Message']}");
      }
    } else {
      print("Failed to load Absent data");
    }
  } catch (e) {
    print("Exception caught: $e");
  }
}




  Future<String?> setCostCenterId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('CostCenterId');
  }

  var teamAttendanceModel = LabourListModel().obs;
  Future<void> gatTeamMemberList() async {
    String? empId = await getEmpBasicDetailId();
    String? costCenterId = await setCostCenterId();
    if (empId == null || costCenterId == null) {
      print("Employee ID or Cost Center ID is null");
      return;
    }

    String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "LabourId": null,
          "MarkedByUserId": null,
          "CostCenterId": costCenterId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        LabourListModel labourList = LabourListModel.fromJson(jsonResponse);

        setState(() {
          teamAttendanceModel.value = labourList;
          totalStrength = labourList.tDS?.length ?? 0; 
        });
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during fetching team list: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAbsentList();
    gatTeamMemberList();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != startDate) {
      setState(() {
        startDate = selectedDate;
        endDate = selectedDate;
      });
      _fetchAbsentList();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != endDate) {
      setState(() {
        endDate = selectedDate;
      });
      _fetchAbsentList();
    }
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
        title: Text('Labour Strength ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectStartDate(context),
                ),
                if (startDate != null)
                  Text(DateFormat('dd/MM/yyyy').format(startDate)),
              ],
            ),
            const SizedBox(height: 16),
            // End Date Picker
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  "Total Strength",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$totalStrength Labour",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.group, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  "Present Today",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$presentToday Labour",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.check_circle, size: 40, color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  "Absent Today",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$absentTotal Labour",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.cancel, size: 40, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
