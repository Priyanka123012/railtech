import 'package:faecauth/screens/model/daily_attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HeatMapController extends GetxController {
  var calendarFormat = CalendarFormat.month.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var attendanceData = <DateTime, String>{}.obs;
  var currentDate = DateTime.now();

  void populateAttendanceData(DailyAttendanceReportModel report) {
    if (report.ePRE != null && report.ePRE!.isNotEmpty) {
      for (var entry in report.ePRE!) {
        final punchDate = entry.punchDate;
        final attStatus = entry.attStatus;
        if (punchDate != null && attStatus != null) {
          try {
            final date = DateFormat('dd/MM/yyyy').parse(punchDate);
            if (date.isBefore(currentDate) ||
                date.isAtSameMomentAs(currentDate)) {
              attendanceData[DateTime(date.year, date.month, date.day)] =
                  attStatus.toString();
              print(
                  'Added date: ${DateFormat('dd/MM/yyyy').format(date)}, status: $attStatus'); // Debugging line
            }
          } catch (e) {
            print('Error parsing date: $e');
          }
        }
      }
    }
  }

  String getStatusForDate(DateTime date) {
    return attendanceData[DateTime(date.year, date.month, date.day)] ??
        'Absent';
  }

  Future<void> showImageDialog(BuildContext context, EPRE attendance) async {
    if (attendance.attStatus == 'Absent') {
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
                  Text(
                    "User was not present on this day",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Punch In: ${attendance.firstPunchTime?.split(' ').last ?? 'N/A'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "Punch Out: ${attendance.lastPunchTime?.split(' ').last ?? '00:00'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: attendance.firstImage != null &&
                                  attendance.firstImage!.isNotEmpty
                              ? Image.network(
                                  attendance.firstImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black26,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black26,
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: Container(
                            child: attendance.lastImage != null &&
                                    attendance.lastImage!.isNotEmpty
                                ? Image.network(
                                    attendance.lastImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black26,
                                            size: 100,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black26,
                                        size: 100,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
