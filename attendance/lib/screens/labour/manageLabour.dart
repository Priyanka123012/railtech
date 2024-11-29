// import 'package:faecauth/screens/labour/LabourFaceRegistartion.dart';
// import 'package:faecauth/screens/team_member/team_attendance_oneday.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ManageLabourAttandance extends StatefulWidget {
//   @override
//   _ManageLabourAttandanceState createState() => _ManageLabourAttandanceState();
// }

// class _ManageLabourAttandanceState extends State<ManageLabourAttandance>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         backgroundColor: Colors.green.shade700,
//         title: Text(
//           "Labour Attandance",
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           dividerColor: Colors.white,
//           unselectedLabelColor: Colors.white,
//           labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//           tabs: [
//             Tab(text: "Face Registration"),
//             Tab(text: "Mark Attendance"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           LabourAttendance(),
         
//         ],
//       ),
//     );
//   }
// }


