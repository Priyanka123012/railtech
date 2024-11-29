import 'dart:convert';
import 'package:faecauth/extension/appbar_ext.dart';

import 'package:faecauth/screens/model/single_team_mem_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HeatMapCalendarStaff extends StatefulWidget {
  final SingleTeamMemberDetailsModel ? report;
  final String? img;

  HeatMapCalendarStaff({required this.report, this.img});

  @override
  _HeatMapCalendarStaffState createState() => _HeatMapCalendarStaffState();
}

class _HeatMapCalendarStaffState extends State<HeatMapCalendarStaff>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, EPRE> attendanceData = {};
  final DateTime _currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    _populateAttendanceData(widget.report!);
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _populateAttendanceData(SingleTeamMemberDetailsModel report) {
    if (report.ePRE != null && report.ePRE!.isNotEmpty) {
      for (var entry in report.ePRE!) {
        final punchDate = entry.punchDate;
        if (punchDate != null) {
          try {
            final date = DateFormat('dd/MM/yyyy').parse(punchDate);
            if (date.isBefore(_currentDate) ||
                date.isAtSameMomentAs(_currentDate)) {
              attendanceData[DateTime(date.year, date.month, date.day)] = entry;
              print(
                  'Added date: ${DateFormat('dd/MM/yyyy').format(date)}, status: ${entry.attStatus}'); // Debugging line
            }
          } catch (e) {
            print('Error parsing date: $e');
          }
        }
      }
    }
  }

  EPRE? _getAttendanceForDate(DateTime date) {
    return attendanceData[DateTime(
      date.year,
      date.month,
      date.day,
    )];
  }

  String convertDate(String dateString) {
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dateString);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    return formattedDate;
  }

  final currentDate = DateTime.now();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  // Future<void> _showImageDialogs(BuildContext context, EPRE attendance) async {
  //   _controller.reset();
  //   _controller.forward();
  //   String formattedDate = convertDate(attendance.punchDate!);
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SlideTransition(
  //         position: _offsetAnimation,
  //         child: AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           content: Container(
  //             padding: EdgeInsets.all(10),
  //             width: MediaQuery.of(context).size.width,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(height: 20),
  //                 // Text(
  //                 //   attendance.attStatus ?? "",
  //                 //   style: TextStyle(color: Colors.green.shade700, fontSize: 19, fontWeight: FontWeight.bold),
  //                 // ),
  //                 // attendance.firstLocation != "" &&
  //                 //         attendance.lastImage != "http://rapi.railtech.co.in/"
  //                 attendance.firstLocation != "" && ( 
  //                       attendance.lastImage != "http://rapi.railtech.co.in/" || formattedDate ==  DateFormat('MMMM dd, yyyy').format(DateTime.now()) )
  //                     ? Text(
  //                         attendance.attStatus ?? "",
  //                         style: TextStyle(
  //                             color: Colors.green.shade700,
  //                             fontSize: 19,
  //                             fontWeight: FontWeight.bold),
  //                       )
  //                     : Text(
  //                         "Missed Punch",
  //                         style: TextStyle(
  //                             color: Colors.blue[300],
  //                             fontSize: 17,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                 Text(
  //                   formattedDate,
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 17,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     Column(
  //                       children: [
  //                         Text(
  //                           "Time In",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold, fontSize: 16),
  //                         ),
  //                         Text(
  //                           "${attendance.firstPunchTime!.split(" ")[1]} ${attendance.firstPunchTime!.split(" ")[2]}",
  //                           // "${attendance.firstPunchTime?.split(' ').last ?? 'N/A'}",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold, fontSize: 13),
  //                         ),
  //                       ],
  //                     ),
  //                     Column(
  //                       children: [
  //                         Text(
  //                           "Time Out",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold, fontSize: 16),
  //                         ),
  //                         Text(
  //                           "${attendance.lastPunchTime?.split(' ').last ?? '00:00'}",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold, fontSize: 13),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     Container(
  //                       width: 70.0,
  //                       height: 70.0,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(width: 2, color: Colors.green),
  //                         image: DecorationImage(
  //                           image: NetworkImage(attendance.firstImage ?? ""),
  //                           fit: BoxFit.cover,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                     ),
  //                     Container(
  //                       width: 70.0,
  //                       height: 70.0,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(width: 2, color: Colors.green),
  //                         image: DecorationImage(
  //                           image: NetworkImage(attendance.lastImage ?? ""),
  //                           fit: BoxFit.cover,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       flex: 1,
  //                       child: Text(
  //                         attendance.firstLocation ?? "",
  //                         textAlign: TextAlign.center,
  //                         maxLines: 3,
  //                         style: TextStyle(color: Colors.black45, fontSize: 13),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 1,
  //                       child: Text(
  //                         attendance.lastLocation ?? "",
  //                         textAlign: TextAlign.center,
  //                         maxLines: 3,
  //                         style: TextStyle(color: Colors.black45, fontSize: 13),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.model_training),
  //                     Text("Shifting Timing : 09:00-18:00",
  //                         style: TextStyle(fontWeight: FontWeight.bold)),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.timer_sharp),
  //                     Text(
  //                         "Logged Hours : ${attendance.firstPunchTime!.split(" ")[1]} ${attendance.firstPunchTime!.split(" ")[2]}",
  //                         style: TextStyle(fontWeight: FontWeight.bold)),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 // Row(
  //                 //   children: [
  //                 //     Icon(
  //                 //       Icons.timer,
  //                 //       color: Colors.black38,
  //                 //     ),
  //                 //     Text("Overtime :", style: TextStyle(fontWeight: FontWeight.bold)),
  //                 //     Text(" 09:13", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
  //                 //   ],
  //                 // ),
  //                 Divider(),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     InkWell(
  //                       onTap: () => Navigator.pop(context),
  //                       child: Card(
  //                         color: Colors.amber.shade900,
  //                         shape: RoundedRectangleBorder(),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 20, vertical: 6),
  //                           child: Text("OK",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 15,
  //                                   color: Colors.white)),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
    Future<void> _showImageDialogs(BuildContext context, EPRE attendance) async {
  _controller.reset();
  _controller.forward();
  String formattedDate = convertDate(attendance.punchDate!);

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return SlideTransition(
        position: _offsetAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                attendance.firstLocation != "" &&
                        (attendance.lastImage != "http://rapi.railtech.co.in/" ||
                            formattedDate == DateFormat('MMMM dd, yyyy').format(DateTime.now()))
                    ? Text(
                        attendance.attStatus ?? "",
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Missed Punch",
                        style: TextStyle(
                            color: Colors.blue[300],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                Text(
                  formattedDate,
                  style: TextStyle(
                      color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Time In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          attendance.firstPunchTime != null &&
                                  attendance.firstPunchTime!.split(" ").length >= 2
                              ? "${attendance.firstPunchTime!.split(" ")[1]} ${attendance.firstPunchTime!.split(" ")[2]}"
                              : "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Time Out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          attendance.lastPunchTime != null &&
                                  attendance.lastPunchTime!.split(" ").length >= 2
                              ? "${attendance.lastPunchTime!.split(" ")[1]} ${attendance.lastPunchTime!.split(" ")[2]}"
                              : "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.green),
                        image: DecorationImage(
                          image: NetworkImage(attendance.firstImage ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.green),
                        image: DecorationImage(
                          image: NetworkImage(attendance.lastImage ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        attendance.firstLocation ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(color: Colors.black45, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        attendance.lastLocation ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(color: Colors.black45, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.model_training),
                    Text("Shifting Timing : 09:00-18:00", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.timer_sharp),
                    Text(
                      "Logged Hours : ${attendance.firstPunchTime != null && attendance.firstPunchTime!.split(" ").length >= 2 ? "${attendance.firstPunchTime!.split(" ")[1]} ${attendance.firstPunchTime!.split(" ")[2]}" : "N/A"}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Card(
                        color: Colors.amber.shade900,
                        shape: RoundedRectangleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Text("OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}



  Future<void> _showImageDialog(BuildContext context) async {
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
                  child: widget.img != null
                      ? Image.memory(
                          base64Decode(widget.img!),
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        )
                      : Icon(Icons.person, size: 70, color: Colors.black26),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showAnimatedDialog(BuildContext context) async {
    _controller.reset();
    _controller.forward();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SlideTransition(
          position: _offsetAnimation,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 170,
              width: 150,
              child: Column(
                children: [
                  Text("Absent",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Image.asset("assets/absent.png", height: 80),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Card(
                          color: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: Text("OK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _showAnimatedDialog2(BuildContext context) async {
    _controller.reset();
    _controller.forward();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SlideTransition(
          position: _offsetAnimation,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 170,
              width: 150,
              child: Column(
                children: [
                  Text("Sunday",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Image.asset("assets/absent.png", height: 80),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Card(
                          color: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: Text("OK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Attendance Log',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ).gradientBackground(withActions: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card(
                        //   elevation: 2,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(4.0),
                        //     child: InkWell(
                        //       onTap: () => _showImageDialog(context),
                        //       child: widget.img != null
                        //           ? Image.memory(
                        //               base64Decode(widget.img.toString()),
                        //               height: 80,
                        //               width: 80,
                        //               fit: BoxFit.fill,
                        //             )
                        //           : Icon(
                        //               Icons.person,
                        //               size: 70,
                        //               color: Colors.black26,
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   profile?.fullName ?? "",
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // Text(
                                //   profile?.designation ?? "",
                                //   style: TextStyle(
                                //     color: Colors.black38,
                                //     fontSize: 13,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // Text(
                                //   profile?.empKey ?? "",
                                //   style: TextStyle(
                                //     color: Colors.black38,
                                //     fontSize: 13,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // Text(
                                //   profile?.costCenterName ?? "",
                                //   style: TextStyle(
                                //     color: Colors.black38,
                                //     fontSize: 13,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // Text(
                                //   profile?.tenderUid ?? "",
                                //   style: TextStyle(
                                //     color: Colors.black38,
                                //     fontSize: 13,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      textAlign: TextAlign.center,
                      "Click on date to see Punch In/Out Time and Image",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                          fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 15,
                            width: 15,
                            color: Colors.green[200],
                          ),
                        ),
                        Text("Present"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 15,
                            width: 15,
                            color: Colors.red[200],
                          ),
                        ),
                        Text("Absent"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 15,
                            width: 15,
                            color: Colors.amber[200],
                          ),
                        ),
                        Text("Sunday"),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 15,
                            width: 15,
                            color: Colors.blue[200],
                          ),
                        ),
                        Text("Missed"),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
                    TableCalendar(
            weekNumbersVisible: false,
            daysOfWeekVisible: true,
            daysOfWeekHeight: 20,
            weekendDays: [DateTime.sunday],
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: _currentDate,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              final attendance = _getAttendanceForDate(selectedDay);
              if (selectedDay.weekday == DateTime.sunday && attendance==null) {
                _showAnimatedDialog2(context);
              } else if (attendance != null) {
                _showImageDialogs(context, attendance);
              } else if (attendance == null) {
                _showAnimatedDialog(context);
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          calendarBuilders: CalendarBuilders(
  defaultBuilder: (context, day, focusedDay) {
    final attendance = _getAttendanceForDate(day);
    final isSunday = day.weekday == DateTime.sunday;
    final isPresent = attendance?.attStatus == 'Present';
    final hasPunchInOut = attendance?.firstPunchTime != null && attendance?.lastPunchTime != null;
    
    Color? dayColor;

    if (day.isAfter(_currentDate)) {
      // Future dates
      dayColor = Colors.grey[300];
    } else if (isSunday) {
      if (hasPunchInOut) {
        // Sunday with both punch-in and punch-out, showing as green for present
        dayColor = Colors.green[200];
      } else {
        // Sunday without punch-in/punch-out, show as orange
        dayColor = Colors.orange[200];
      }
    } else {
      // Regular day attendance
      if (attendance?.lastImage != "http://rapi.railtech.co.in/" && !isPresent) {
        dayColor = Colors.red[200]; // Absent or incomplete punch
      } else if (isPresent && attendance?.lastImage == "http://rapi.railtech.co.in/") {
        dayColor = Colors.blue[200]; // Present but with missed image
      } else {
        dayColor = Colors.green[200]; // Present and completed punch
      }
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: dayColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  },
  todayBuilder: (context, day, focusedDay) {
    final attendance = _getAttendanceForDate(day);
    final isPresent = attendance?.attStatus == 'Present';
    final missed = attendance?.punchDate != DateFormat('dd/MM/yyyy').format(_currentDate) && !isPresent;

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: missed ? Colors.grey[200] : Colors.green[200],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  },
),
                    )]));}

  bool isSameDay(DateTime? date1, DateTime? date2) {
    return date1 != null &&
        date2 != null &&
        date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}


// import 'package:faecauth/extension/appbar_ext.dart';
// import 'package:faecauth/screens/home_page_screen.dart';
// import 'package:faecauth/screens/model/single_team_mem_model.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class HeatMapCalendars extends StatefulWidget {
//   final SingleTeamMemberDetailsModel? report;
//   final String? name;

//   HeatMapCalendars({required this.report, this.name});

//   @override
//   _HeatMapCalendarsState createState() => _HeatMapCalendarsState();
// }

// class _HeatMapCalendarsState extends State<HeatMapCalendars>
//     with SingleTickerProviderStateMixin {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   final Map<DateTime, EPRE> attendanceData = {};
//   final DateTime _currentDate = DateTime.now();

//   @override
//   void initState() {
    
//     super.initState();
//     _populateAttendanceData(widget.report!);
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     _offsetAnimation = Tween<Offset>(
//       begin: const Offset(0.0, 1.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   void _populateAttendanceData(SingleTeamMemberDetailsModel report) {
//     if (report.ePRE != null && report.ePRE!.isNotEmpty) {
//       for (var entry in report.ePRE!) {
//         final punchDate = entry.punchDate;
//         if (punchDate != null) {
//           try {
//             final date = DateFormat('dd/MM/yyyy').parse(punchDate);
//             if (date.isBefore(_currentDate) ||
//                 date.isAtSameMomentAs(_currentDate)) {
//               attendanceData[DateTime(date.year, date.month, date.day)] = entry;
//               print(
//                   'Added date: ${DateFormat('dd/MM/yyyy').format(date)}, status: ${entry.attStatus}'); // Debugging line
//             }
//           } catch (e) {
//             print('Error parsing date: $e');
//           }
//         }
//       }
//     }
//   }

//   EPRE? _getAttendanceForDate(DateTime date) {
//     return attendanceData[DateTime(
//       date.year,
//       date.month,
//       date.day,
//     )];
//   }

//   String convertDate(String dateString) {
//     DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dateString);
//     String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
//     return formattedDate;
//   }

//   final currentDate = DateTime.now();
//   late AnimationController _controller;
//   late Animation<Offset> _offsetAnimation;

//   Future<void> _showImageDialogs(BuildContext context, EPRE attendance) async {
//     _controller.reset();
//     _controller.forward();
//     String formattedDate = convertDate(attendance.punchDate!);
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return SlideTransition(
//           position: _offsetAnimation,
//           child: AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: Container(
//               padding: EdgeInsets.all(10),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 20),
//                   // Text(
//                   //   attendance.attStatus ?? "",
//                   //   style: TextStyle(color: Colors.green.shade700, fontSize: 19, fontWeight: FontWeight.bold),
//                   // ),
//                   // attendance.firstLocation != "" &&
//                   //         attendance.lastImage != "http://rapi.railtech.co.in/"
//                   attendance.firstLocation != "" && ( 
//                         attendance.lastImage != "http://rapi.railtech.co.in/" || formattedDate ==  DateFormat('MMMM dd, yyyy').format(DateTime.now()) )
//                       ? Text(
//                           attendance.attStatus ?? "",
//                           style: TextStyle(
//                               color: Colors.green.shade700,
//                               fontSize: 19,
//                               fontWeight: FontWeight.bold),
//                         )
//                       : Text(
//                           "Missed Punch",
//                           style: TextStyle(
//                               color: Colors.blue[300],
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold),
//                         ),
//                   Text(
//                     formattedDate,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             "Time In",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           Text(
//                             // "${attendance.firstPunchTime?.split(' ').last ?? 'N/A'}",
//                              "${attendance.firstPunchTime?.split(' ')[1]}${attendance.firstPunchTime?.split(' ')[2]}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             "Time Out",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           Text(
//                             "${attendance.lastPunchTime?.split(' ')[1]}${attendance.lastPunchTime?.split(' ')[2]}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       if(attendance.firstImage != "")
//                       Container(
//                         width: 70.0,
//                         height: 70.0,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 2, color: Colors.green),
//                           image: DecorationImage(
//                             image: NetworkImage(attendance.firstImage!),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                        if(attendance.lastImage != "")
//                       Container(
//                         width: 70.0,
//                         height: 70.0,
//                         decoration: BoxDecoration(
//                           border: Border.all(width: 2, color: Colors.green),
//                           image: DecorationImage(
//                             image: NetworkImage(attendance.lastImage!),
//                             fit: BoxFit.cover,
//                           ),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           attendance.firstLocation ?? "",
//                           textAlign: TextAlign.center,
//                           maxLines: 3,
//                           style: TextStyle(color: Colors.black45, fontSize: 13),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           attendance.lastLocation ?? "",
//                           textAlign: TextAlign.center,
//                           maxLines: 3,
//                           style: TextStyle(color: Colors.black45, fontSize: 13),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.model_training),
//                       Text("Shifting Timing : 09:00-18:00",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.timer_sharp),
//                       Text(
//                           "Logged Hours : ${attendance.firstPunchTime!.split(" ").last}",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   // Row(
//                   //   children: [
//                   //     Icon(
//                   //       Icons.timer,
//                   //       color: Colors.black38,
//                   //     ),
//                   //     Text("Overtime :", style: TextStyle(fontWeight: FontWeight.bold)),
//                   //     Text(" 09:13", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
//                   //   ],
//                   // ),
//                   Divider(),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () => Navigator.pop(context),
//                         child: Card(
//                           color: Colors.amber.shade900,
//                           shape: RoundedRectangleBorder(),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//                             child: Text("OK",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _showImageDialog(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(),
//           child: Container(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Container(
//                 //   height: MediaQuery.of(context).size.height * 0.5,
//                 //   width: MediaQuery.of(context).size.width,
//                 //   // child: imageWidget,
//                 //   child: widget.img != null
//                 //       ? Image.memory(
//                 //           base64Decode(widget.img!),
//                 //           height: 70,
//                 //           width: 70,
//                 //           fit: BoxFit.fill,
//                 //         )
//                 //       : Icon(Icons.person, size: 70, color: Colors.black26),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _showAnimatedDialog(BuildContext context) async {
//     _controller.reset();
//     _controller.forward();

//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return SlideTransition(
//           position: _offsetAnimation,
//           child: AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: Container(
//               height: 170,
//               width: 150,
//               child: Column(
//                 children: [
//                   Text("Absent",
//                       style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Image.asset("assets/absent.png", height: 80),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: () => Navigator.pop(context),
//                         child: Card(
//                           color: Colors.blue.shade900,
//                           shape: RoundedRectangleBorder(),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 6),
//                             child: Text("OK",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                     color: Colors.white)),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: Text('Attendance',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//       ).gradientBackground(withActions: true),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                 child: Column(
//                   children: [
//                     Text(
//                       textAlign: TextAlign.center,
//                       "Click on date to see Punch In/Out Time and Image",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black38,
//                           fontSize: 14),
//                     ),
//                     SizedBox(height: 10),
//                     Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 15,
//                             width: 15,
//                             color: Colors.green[200],
//                           ),
//                         ),
//                         Text("Present"),
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 15,
//                             width: 15,
//                             color: Colors.red[200],
//                           ),
//                         ),
//                         Text("Absent"),
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 15,
//                             width: 15,
//                             color: Colors.amber[200],
//                           ),
//                         ),
//                         Text("Weekly Off"),
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             height: 15,
//                             width: 15,
//                             color: Colors.blue[200],
//                           ),
//                         ),
//                         Text("Missed"),
//                       ],
//                     ),
//                     Divider(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           TableCalendar(
//             weekNumbersVisible: false,
//             daysOfWeekVisible: true,
//             daysOfWeekHeight: 20,
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: _currentDate,
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });

//               final attendance = _getAttendanceForDate(selectedDay);
//               if (attendance != null) {
//                 _showImageDialogs(context, attendance);
//               }
//               if (attendance == null) {
//                 _showAnimatedDialog(context);
//               }
//             },
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//             calendarBuilders: CalendarBuilders(
//               defaultBuilder: (context, day, focusedDay) {
//                 final attendance = _getAttendanceForDate(day);
//                 final isPresent = attendance?.attStatus == 'Present';
//                 final isSunday = day.weekday == DateTime.sunday;
//                 return Container(
//                   margin: const EdgeInsets.all(4.0),
//                   decoration: BoxDecoration(
//                     color: day.isBefore(_currentDate) ||
//                             day.isAtSameMomentAs(_currentDate)
//                         ? (isSunday
//                             ? Colors.orange[200]
//                             : attendance?.lastImage !=
//                                         "http://rapi.railtech.co.in/" &&
//                                     !isPresent
//                                 ? Colors.red[200]
//                                 : isPresent &&
//                                         attendance?.lastImage ==
//                                             "http://rapi.railtech.co.in/"
//                                     ? Colors.blue[200]
//                                     : Colors.green[200])
//                         : Colors.grey[300],
//                     borderRadius: BorderRadius.circular(6.0),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${day.day}',
//                       style: TextStyle().copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//               todayBuilder: (context, day, focusedDay) {
//                 final attendance = _getAttendanceForDate(day);
//                 final isPresent = attendance?.attStatus == 'Present';
//                 final missed = attendance?.punchDate !=
//                         DateFormat('dd/MM/yyyy').format(_currentDate) &&
//                     !isPresent;
//                 return Container(
//                   margin: const EdgeInsets.all(4.0),
//                   decoration: BoxDecoration(
//                     color: missed ? Colors.grey[200] : Colors.green[200],
//                     borderRadius: BorderRadius.circular(6.0),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${day.day}',
//                       style: TextStyle().copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool isSameDay(DateTime? date1, DateTime? date2) {
//     return date1 != null &&
//         date2 != null &&
//         date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }
