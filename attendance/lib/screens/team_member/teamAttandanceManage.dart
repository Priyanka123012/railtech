
// import 'package:faecauth/screens/team_member/faceteanregister.dart';
// import 'package:faecauth/screens/team_member/teamUnregisterFace.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TeamAttandanceManage extends StatefulWidget {
//   @override
//   _TeamAttandanceManageState createState() => _TeamAttandanceManageState();
// }

// class _TeamAttandanceManageState extends State<TeamAttandanceManage>
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
//           "Staff Attandance",
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           dividerColor: Colors.white,
//           unselectedLabelColor: Colors.white,
//           labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//           tabs: [
//             Tab(text: "Face Registration"),
//             Tab(text: "Mark Attendance"),
//             // Tab(text: "Missed Punch"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           TeamUnRegisterFace(),
//           FaceTeamRegister(),
//           // MissedPunch(),
     
//         ],
//       ),
//     );
//   }
// }
