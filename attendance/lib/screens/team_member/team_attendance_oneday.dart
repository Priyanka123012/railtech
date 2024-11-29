import 'dart:convert';
import 'package:faecauth/screens/image_viewer.dart';
import 'package:faecauth/screens/model/daily_attendance_model.dart';
import 'package:faecauth/screens/model/single_team_mem_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTeamSingleDayAttendance extends StatefulWidget {
  final String id;
  const AllTeamSingleDayAttendance({Key? key, required this.id})
      : super(key: key);
  @override
  _AllTeamSingleDayAttendanceState createState() =>
      _AllTeamSingleDayAttendanceState();
}

class _AllTeamSingleDayAttendanceState
    extends State<AllTeamSingleDayAttendance> {
  late Future<DailyAttendanceReportModel?> _attendanceReport;
  DateTime _selectedDate = DateTime.now();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isLoading = true;
  var report = SingleTeamMemberDetailsModel().obs;
  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<DailyAttendanceReportModel?> fetchAttendanceReport(
      String punchDate) async {
    String? empId = await getEmpBasicDetailId();
    try {
      final response = await http.post(
        Uri.parse(
            "https://rapi.railtech.co.in/api/TeamEMPPunch/getPunchReportEmployee"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "EMP_BasicDetail_Id": null,
          "MarkedByUserId": empId,
          "PunchDateTime": punchDate
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DailyAttendanceReportModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching attendance report: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _attendanceReport = fetchAttendanceReport(_formatDate(_selectedDate));
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String convertDate(String dateString) {
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dateString);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    return formattedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade200,
              onPrimary: Colors.white,
              onSurface: Colors.teal.shade300,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _attendanceReport = fetchAttendanceReport(_formatDate(_selectedDate));
      });
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = convertDate(_formatDate(_selectedDate));
    return Scaffold(
      // appBar: AppBar(
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       onPressed: () => _selectDate(context),
      //       icon: Icon(Icons.calendar_month),
      //     ),
      //   ],
      //   title: Text(
      //     'Attendance',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //   ),
      // ).gradientBackground(withActions: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: "Search by name..",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: updateSearchQuery,
            ),
          ),
          Expanded(
            child: FutureBuilder<DailyAttendanceReportModel?>(
              future: _attendanceReport,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.ePRE == null) {
                  return Center(child: Text('No data available'));
                } else {
                  final filteredList = snapshot.data!.ePRE!.where((employee) {
                    final nameLower = employee.fullName?.toLowerCase() ?? '';
                    final queryLower = searchQuery.toLowerCase();
                    return nameLower.contains(queryLower);
                  }).toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    "$formattedDate",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[500]),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  "Time In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[500]),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Time Out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[500]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          height: Get.height * 0.7,
                          child: filteredList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final epre = filteredList[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        epre.fullName ?? '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Time In: ${epre.firstLocation?.isNotEmpty == true ? epre.firstLocation : '.........'}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "Time Out: ${epre.lastLocation?.isNotEmpty == true ? epre.lastLocation : '.........'}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Status : ",
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            epre.attStatus ??
                                                                '',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .blue[500],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        epre.firstPunchTime
                                                                ?.split(' ')
                                                                .last ??
                                                            'N/A',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.5,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      InkWell(
                                                        onTap: () =>
                                                            Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImageViewerScreen(
                                                              image: epre
                                                                      .firstImage ??
                                                                  "assets/myPic.jpeg",
                                                              location: epre
                                                                      .firstLocation ??
                                                                  "Location N/A",
                                                              dateTime:
                                                                  epre.firstPunchTime ??
                                                                      'N/A',
                                                            ),
                                                          ),
                                                        ),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: epre.firstImage!
                                                                        .isNotEmpty &&
                                                                    epre.firstImage !=
                                                                        "" &&
                                                                    epre.firstImage !=
                                                                        null
                                                                ? Image.network(
                                                                    epre.firstImage ??
                                                                        "",
                                                                    height: 60,
                                                                    width: 60,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/face2.png",
                                                                    height: 60,
                                                                    width: 60,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        epre.lastPunchTime
                                                                ?.split(' ')
                                                                .last ??
                                                            'N/A',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.5),
                                                      ),
                                                      SizedBox(height: 5),
                                                      InkWell(
                                                        onTap: () => epre
                                                                    .lastImage!
                                                                    .isNotEmpty &&
                                                                epre.lastImage !=
                                                                    "http://rapi.railtech.co.in/" &&
                                                                epre.lastImage !=
                                                                    null
                                                            ? Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ImageViewerScreen(
                                                                    image: epre
                                                                            .lastImage ??
                                                                        "assets/myPic.jpeg",
                                                                    location: epre
                                                                            .lastLocation ??
                                                                        "Location N/A",
                                                                    dateTime:
                                                                        epre.lastPunchTime ??
                                                                            'N/A',
                                                                  ),
                                                                ),
                                                              )
                                                            : null,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.green,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: epre.lastImage!
                                                                      .isNotEmpty &&
                                                                  epre.lastImage !=
                                                                      "" &&
                                                                  epre.lastImage !=
                                                                      "http://rapi.railtech.co.in/"
                                                              ? Image.network(
                                                                  epre.lastImage ??
                                                                      "",
                                                                  height: 60,
                                                                  width: 60,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.asset(
                                                                  "assets/face2.png",
                                                                  height: 60,
                                                                  width: 60,
                                                                ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Image.asset("assets/nodataa.png"),
                                ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
