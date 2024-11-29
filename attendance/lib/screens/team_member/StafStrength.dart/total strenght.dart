import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TatalStrengh extends StatefulWidget {
  const TatalStrengh({super.key});

  @override
  State<TatalStrengh> createState() => _TatalStrenghState();
}

class _TatalStrenghState extends State<TatalStrengh> {
  DateTime? startDate;
  DateTime? endDate;

  // Fetch employee ID from shared preferences
  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  // Fetch total strength data
  Future<void> _fetchTotalStrength() async {
    try {
      String? empId = await getEmpBasicDetailId();
      const baseUrl = 'http://rapi.railtech.co.in/api/EMPPunch/get_Present_Absent_Count';

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
          "StartDate": startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : null,
          "EndDate": endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : null,
          "Status": "",
          "MarkedByUserId": empId
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          setState(() {
            // Handle the success response here
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

  // Show date picker for start date selection
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        endDate = picked; // Set end date to same as start date
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTotalStrength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Strength")),
      body: Column(
        children: [
          // Display the selected start and end dates
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Start Date: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate!) : 'Select Date'}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _selectStartDate(context),
                  child: const Text("Select Start Date"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "End Date: ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate!) : 'Select Date'}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Add other widgets and logic as needed
        ],
      ),
    );
  }
}
