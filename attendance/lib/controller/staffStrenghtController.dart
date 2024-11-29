import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AttendanceController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var attendanceData = {
    "Present": 169,
    "Absent": 309,
    "Late Comers": 34,
    "Early Leavers": 0,
  }.obs;

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}

class DailyAttendanceScreen extends StatelessWidget {
  final AttendanceController attendanceController = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              // Implement CSV download logic
            },
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              // Implement PDF download logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Selector
            Row(
              children: [
                Obx(() => Text(
                  'Date: ${attendanceController.selectedDate.value.toLocal()}'.split(' ')[0],
                  style: TextStyle(fontSize: 16),
                )),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.green),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: attendanceController.selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                    );
                    if (pickedDate != null) {
                      attendanceController.updateDate(pickedDate);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Attendance Pie Chart
           
            SizedBox(height: 20),

            // Tabs for different attendance statuses
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black54,
                      indicatorColor: Colors.green,
                      tabs: [
                        Tab(text: "Present"),
                        Tab(text: "Absent"),
                        Tab(text: "Late Comers"),
                        Tab(text: "Early Leavers"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          buildAttendanceList("Present"),
                          buildAttendanceList("Absent"),
                          buildAttendanceList("Late Comers"),
                          buildAttendanceList("Early Leavers"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttendanceList(String status) {
    // Sample data for demonstration
    final List<Map<String, String>> sampleData = [
      {"name": "Aditya Kumar Tomar", "timeIn": "09:07", "timeOut": "00:00"},
      {"name": "Aditya Rajpatel", "timeIn": "08:59", "timeOut": "00:00"},
      // Add more entries as required
    ];

    return ListView.builder(
      itemCount: sampleData.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text(
              sampleData[index]["name"]!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Time In: ${sampleData[index]["timeIn"]}, Time Out: ${sampleData[index]["timeOut"]}"),
            leading: Icon(Icons.person, color: Colors.green),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}
