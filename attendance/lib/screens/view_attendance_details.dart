import 'dart:convert';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:http/http.dart' as http;
import 'package:faecauth/screens/image_viewer.dart';
import 'package:faecauth/screens/model/daily_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class AttendanceReportScreen extends StatefulWidget {
  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen>
    with SingleTickerProviderStateMixin {
  DailyAttendanceReportModel? report;
  bool isLoading = true;
  DateTime? _selectedDate;
  final currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await fetchAttendanceReport();
    });
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<void> fetchAttendanceReport() async {
    String? empId = await getEmpBasicDetailId();
    if (empId == null) {
      print("Employee ID is null");
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
        body: jsonEncode(<String, dynamic>{
          'EMP_BasicDetail_Id': empId,
          'PunchDateTime': null,
        }),
      );

      print("Request URL: $url");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          report = DailyAttendanceReportModel.fromJson(jsonResponse);
          isLoading = false;
          print("Successfully fetched: ${jsonResponse}");
        });
      } else {
        print(
            "Failed to fetch attendance report: ${response.statusCode} - ${response.reasonPhrase}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Report"),
        backgroundColor: Colors.green.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
      ).gradientBackground(withActions: true),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : report == null || report!.ePRE == null || report!.ePRE!.isEmpty
              ? Center(child: Text("No data available"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.black38),
                                  20.widthBox,
                                  Text(
                                      _selectedDate == null
                                          ? '${currentDate.day}-${currentDate.month}-${currentDate.year}'
                                          : "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          // fontWeight: FontWeight.bold
                                          )),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.cancel,
                                        color: Colors.black38),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          itemCount: report!.ePRE!.length,
                          itemBuilder: (BuildContext context, index) {
                            EPRE epre = report!.ePRE![index];
                            return Column(
                              children: [
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(),
                                  // color: Color.fromARGB(255, 216, 220, 216),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  epre.fullName ?? "Unknown",
                                                  style: TextStyle(
                                                      // fontWeight:
                                                          // FontWeight.bold
                                                          ),
                                              
                                                ),
                                                Text(
                                                  "Date: ${epre.punchDate ?? 'N/A'}",
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                Text(
                                                  "Status: ${epre.firstPunchTime != null ? 'Present' : 'Absent'}",
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(epre.firstLocation ??
                                                        "Location N/A"),
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.green,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewerScreen(
                                                  image: epre.firstImage ??
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
                                                  style: TextStyle(
                                                      // fontWeight:
                                                          // FontWeight.normal
                                                          ),
                                                ),
                                                5.heightBox,
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1.5)),
                                                  child: epre.firstImage!
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          epre.firstImage
                                                              .toString(),
                                                          height: 55,
                                                          width: 55,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          "assets/myPic.jpeg",
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
                                                    'N/A',
                                                style: TextStyle(
                                                    // fontWeight:
                                                    //     FontWeight.normal
                                                        ),
                                              ),
                                              5.heightBox,
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageViewerScreen(
                                                      image: epre.lastImage ??
                                                          "assets/myPic.jpeg",
                                                      location:
                                                          epre.lastLocation ??
                                                              "Location N/A",
                                                      dateTime:
                                                          epre.lastPunchTime ??
                                                              'N/A',
                                                    ),
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1.5)),
                                                  child:
                                                      epre.lastImage!.isNotEmpty
                                                          ? Image.network(
                                                              epre.lastImage
                                                                  .toString(),
                                                              height: 55,
                                                              width: 55,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              "assets/myPic.jpeg",
                                                              height: 55,
                                                            ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: Colors.grey.shade300, height: 8),
                              ],
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
