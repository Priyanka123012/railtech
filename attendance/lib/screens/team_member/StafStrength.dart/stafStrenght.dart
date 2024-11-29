// // import 'package:faecauth/extension/appbar_ext.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class StaffStrength extends StatefulWidget {
// //   const StaffStrength({super.key});

// //   @override
// //   _StaffStrengthState createState() => _StaffStrengthState();
// // }

// // class _StaffStrengthState extends State<StaffStrength> {
// //   // Sample data for demonstration purposes
// //   final List<String> employees = [
// //     'Alice',
// //     'Bob',
// //     'Charlie',
// //     'David',
// //     'Eva',
// //   ];

// //   String? presentEmployee; // Selected employee for present
// //   String? absentEmployee;  // Selected employee for absent

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(
// //         foregroundColor: Colors.white,
// //         leading: IconButton(
// //             onPressed: () {
// //               Get.back();
// //             },
// //             icon: Icon(
// //               Icons.arrow_back,
// //               color: Colors.white,
// //             )),
// //         title: Text('Staff Summary ',
// //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
// //       ).gradientBackground(withActions: true),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //        Expanded(
// //               child: Column(
// //                 children: [
// //                   _buildCard('Total Staff', '50'), // Total staff
// //                   const SizedBox(height: 3),
// //                     Card(
// //                       elevation: 2,
// //                       child: ExpansionTile(
// //                         title: Text(
// //                           'Today  present',
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                           ),
// //                         ),
// //                         leading: Icon(
// //                           Icons.file_copy,
// //                           color: Colors.green,
// //                         ),
// //                         trailing: Icon(Icons.arrow_drop_down),
// //                         children: <Widget>[
                 

// //                         ],
// //                       ),
// //                     ),
// //                        Card(
// //                       elevation: 2,
// //                       child: ExpansionTile(
// //                         title: Text(
// //                           'Today  Absent',
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                           ),
// //                         ),
// //                         leading: Icon(
// //                           Icons.file_copy,
// //                           color: Colors.green,
// //                         ),
// //                         trailing: Icon(Icons.arrow_drop_down),
// //                         children: <Widget>[
                        
                        
                       
                       
                       
// //                         ],
// //                       ),
// //                     ),
                    
              
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // Card for Total Staff
// //   Widget _buildCard(String title, String count) {
// //     return Card(
// //       elevation: 2,
// //       margin: const EdgeInsets.symmetric(vertical: 10),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //               title,
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             Text(
// //               count,
// //               style: const TextStyle(fontSize: 18),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }


  
 
// // }

// import 'package:faecauth/extension/appbar_ext.dart';
// import 'package:faecauth/screens/team_member/StafStrength.dart/AbsetListStaffStrenght.dart';
// import 'package:faecauth/screens/team_member/StafStrength.dart/presntListStaffStrenght.dart';
// import 'package:faecauth/screens/team_member/StafStrength.dart/total%20strenght.dart';
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
//                         Tab(text: "Total Strengh"),
//                         Tab(text: "Present"),
//                         Tab(text: "Absent"),
                       
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         children: [
//                           TatalStrengh(),
//                          PresentListStaffAttendance(),
//                          AbsentListStaffAttendance(),
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
import 'package:faecauth/screens/team_member/AbsentListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StaffStrength extends StatefulWidget {
  const StaffStrength({super.key});

  @override
  State<StaffStrength> createState() => _StaffStrengthState();
}

class _StaffStrengthState extends State<StaffStrength> {
  List<Employee> _absentList = [];
  int totalStrength = 0;
  int presentToday = 0;
  int absentTotal = 0;

  DateTime startDate = DateTime.now();  
  DateTime endDate = DateTime.now();    

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<void> _fetchAbsentList() async {
    try {
      String? empId = await getEmpBasicDetailId();
      const baseUrl = 'http://rapi.railtech.co.in/api/EMPPunch/getAbsentList';

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
          "Status": "Present",
          "MarkedByUserId": empId
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          final absentEmployeeList = AbsentEmployeeList.fromJson(responseData);
          setState(() {
            _absentList = absentEmployeeList.employees ?? [];
            // Update Present and Absent counts
            totalStrength = _absentList.length;
            presentToday = _absentList.where((emp) => emp.status == "Present").toList().length;
            absentTotal = _absentList.where((emp) => emp.status == "Absent").toList().length;
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

  @override
  void initState() {
    super.initState();
    _fetchAbsentList(); // Fetch the absent list with the default dates
  }

  // Date Picker for selecting start date
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
        title: Text('Staff Strength ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ).gradientBackground(withActions: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date Picker
            Row(
              children: [
                // const Text("Start Date:"),
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
            // Row(
            //   children: [
            //     const Text("End Date:"),
            //     IconButton(
            //       icon: const Icon(Icons.calendar_today),
            //       onPressed: () => _selectEndDate(context),
            //     ),
            //     if (endDate != null)
            //       Text(DateFormat('dd/MM/yyyy').format(endDate)),
            //   ],
            // ),
            const SizedBox(height: 16), // Space between cards

            // Total Strength Card
            Card(
              elevation: 1,
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
                  "$totalStrength Employees",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.group, size: 40),
              ),
            ),
            const SizedBox(height: 5), // Space between cards

            // Present Today Card
            Card(
              elevation: 1,
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
                  "$presentToday Employees",
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.check_circle, size: 40, color: Colors.green),
              ),
            ),
            const SizedBox(height: 5), // Space between cards

            // Absent Total Card
            Card(
              elevation: 1,
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
                  "$absentTotal Employees",
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


