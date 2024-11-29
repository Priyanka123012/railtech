// import 'dart:convert';

// import 'package:faecauth/screens/labour/laboutModel/LabourListModel.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class TatalStrengh extends StatefulWidget {
//   const TatalStrengh({super.key});

//   @override
//   State<TatalStrengh> createState() => _TatalStrenghState();
// }

// class _TatalStrenghState extends State<TatalStrengh> {
//   DateTime? startDate;
//   DateTime? endDate;
//   LabourListModel? teamAttedanceModel;
//   bool isLoading = true;
//   // Fetch employee ID from shared preferences
//   Future<String?> getEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }
//  Future<String?> setCostCenterId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('CostCenterId');
//   }
// Future<void> gatTeamMemberList() async {
//   String? empId = await getEmpBasicDetailId();
//    String? costCenterId = await setCostCenterId();

//   if (empId == null) {
//     print("Employee ID is null");
//     setState(() {
//       isLoading = false;
//     });
//     return;
//   }

//   String url = 'http://rapi.railtech.co.in/api/LabourDetails/get';

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>
//       {
//    "LabourId": null,
//            "MarkedByUserId": null,
//        "CostCenterId": costCenterId,
//       }),
//     );

//     print("Request URL: $url");
//     print("Response status: ${response.statusCode}");
//     print("Response body: ${response.body}");

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       setState(() {
//         teamAttedanceModel = LabourListModel.fromJson(jsonResponse);
//         teamAttendanceModel.value = LabourListModel.fromJson(jsonResponse);
        
//         // Filter only team members without a registered face image
//          filteredTeamMembers.value = teamAttendanceModel.value.tDS?.where((member) =>
//      member.status == null ||
//           member.status==""||
//     member.faceImage == "https://rapi.railtech.co.in/"
//   ).toList() ?? [];
// });


//       isLoading = false;
//       print("Successfully fetched: ${response.statusCode}");
//     } else {
//       print("Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   } catch (e) {
//     print("Error during fetching attendance report: $e");
//     setState(() {
//       isLoading = false;
//     });
//   }
// }


//   // Show date picker for start date selection
//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null && picked != startDate) {
//       setState(() {
//         startDate = picked;
//         endDate = picked; 
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     gatTeamMemberList()
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Total Strength")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(
//                   "Start Date: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'Select Date'}",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => _selectStartDate(context),
//                   child: const Text("Select Start Date"),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(
//                   "End Date: ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'Select Date'}",
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
