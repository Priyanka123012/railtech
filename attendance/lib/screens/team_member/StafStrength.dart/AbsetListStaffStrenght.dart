// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class AbsentListStaffAttendance extends StatefulWidget {
//   const AbsentListStaffAttendance({super.key});

//   @override
//   State<AbsentListStaffAttendance> createState() => _AbsentListStaffAttendanceState();
// }

// class _AbsentListStaffAttendanceState extends State<AbsentListStaffAttendance> {
//   List<dynamic> _absentList = [];
//   DateTime? startDate;
//   DateTime? endDate;

//   Future<String?> getEmpBasicDetailId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('empId');
//   }

//   Future<void> _fetchAbsentList() async {
//     try {
//       String? empId = await getEmpBasicDetailId();
//       const baseUrl = 'http://rapi.railtech.co.in/api/EMPPunch/getAbsentList';

//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "StartDate": startDate,
//           "EndDate": endDate  ,
//           "Status": "",
//           "MarkedByUserId": empId
//         }),
//       );

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['StatusCode'] == 1) {
//           setState(() {
//             _absentList = responseData['CDS'];
//           });
//         } else {
//           print("Error: ${responseData['Message']}");
//         }
//       } else {
//         print("Failed to load profile data");
//       }
//     } catch (e) {
//       print("Exception caught: $e");
//     }
//   }

//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//       initialDateRange: startDate != null && endDate != null ? DateTimeRange(start: startDate!, end: endDate!) : null,
//     );
//     if (picked != null) {
//       setState(() {
//         startDate = picked.start;
//         endDate = picked.end;
//       });
//       _fetchAbsentList();
//     }
//   }

//   String formatDate(String dateString) {
//     try {
//       final DateTime parsedDate = DateTime.parse(dateString);
//       return DateFormat('dd/MM/yyyy').format(parsedDate);
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchAbsentList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Absent List"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: () => _selectDateRange(context),
//           ),
//         ],
//       ),
//       body: _absentList.isEmpty
//           ?  Center(child:Image.asset("assets/nodataa.png"),)
//           : ListView.builder(
//               itemCount: _absentList.length,
//               itemBuilder: (context, index) {
//                 final item = _absentList[index];
//                 final date = item['AbsentDate'] != null ? formatDate(item['AbsentDate']) : 'No Date';
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     title: Text(date),
//                     subtitle: Text(item['Reason'] ?? 'No Reason'),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsentEmployeeList {
  int? statusCode;
  String? status;
  String? statusText;
  List<Employee>? employees;

  AbsentEmployeeList(
      {this.statusCode, this.status, this.statusText, this.employees});

  factory AbsentEmployeeList.fromJson(Map<String, dynamic> json) {
    return AbsentEmployeeList(
      statusCode: json['StatusCode'],
      status: json['status'],
      statusText: json['statusText'],
      employees: (json['EP'] as List).map((i) => Employee.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StatusCode': statusCode,
      'status': status,
      'statusText': statusText,
      'EP': employees?.map((i) => i.toJson()).toList(),
    };
  }
}

class Employee {
  String? fullName;
  String? mobile;
  String? status;

  Employee({this.fullName, this.mobile, this.status});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      fullName: json['FullName'],
      mobile: json['Mobile'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FullName': fullName,
      'Mobile': mobile,
      'Status': status,
    };
  }
}

class AbsentListStaffAttendance extends StatefulWidget {
  @override
  State<AbsentListStaffAttendance> createState() =>
      _AbsentListStaffAttendanceState();
}

class _AbsentListStaffAttendanceState extends State<AbsentListStaffAttendance> {
  List<Employee> _absentList = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    _fetchAbsentList();
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<void> _fetchAbsentList() async {
    try {
      String? empId = await getEmpBasicDetailId();
      const baseUrl = 'http://rapi.railtech.co.in/api/EMPPunch/getAbsentList';

      print(
          "StartDate: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'null'}");
      print(
          "EndDate: ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'null'}");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "StartDate": startDate != null
              ? DateFormat('dd/MM/yyyy').format(startDate!)
              : null,
          "EndDate": endDate != null
              ? DateFormat('dd/MM/yyyy').format(endDate!)
              : null,
          "Status": "Absent",
          "MarkedByUserId": empId
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          final absentEmployeeList = AbsentEmployeeList.fromJson(responseData);
          setState(() {
            _absentList = absentEmployeeList.employees ?? [];
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      print('Could not launch $phoneNumber');
    }
  }

Future<void> _sendWhatsAppMessage(String phoneNumber) async {
  final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
  if (await canLaunch(whatsappUri.toString())) {
    await launch(whatsappUri.toString());
  } else {
    print('Could not launch WhatsApp for $phoneNumber');
  }
}

  Future<void> _selectDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
      });
      _fetchAbsentList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDateRange(context),
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: startDate != null && endDate != null
                          ? "${DateFormat('dd-MM-yyyy').format(startDate!)} to ${DateFormat('dd-MM-yyyy').format(endDate!)}"
                          : "Select Date Range",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    "Total Absent:  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${_absentList.length}", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _absentList.isEmpty
                  ? Center(child: Text("No data available"))
                  : ListView.builder(
                      itemCount: _absentList.length,
                      itemBuilder: (context, index) {
                        final item = _absentList[index];
                        final mobileNumber = item.mobile ?? "";

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(item.fullName ?? "No Name"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("FullName: ${item.fullName ?? "N/A"}"),
                                Text(
                                    "Mobile: ${mobileNumber.isNotEmpty ? mobileNumber : "Unknown"}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (mobileNumber.isNotEmpty) {
                                      _makePhoneCall(mobileNumber);
                                    }
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 8), // Space between icons
                                GestureDetector(
                                  onTap: () {
                                    if (mobileNumber.isNotEmpty) {
                                      _sendWhatsAppMessage(mobileNumber);
                                    }
                                  },
                                  child: Icon(
                                    Icons.message,
                                    color: Colors.green, // WhatsApp icon color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
