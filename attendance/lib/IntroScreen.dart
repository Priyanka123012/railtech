// import 'dart:async';

// import 'package:faecauth/screens/home_page_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class IntroScreen extends StatefulWidget {
//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }

// class _IntroScreenState extends State<IntroScreen> {
// @override
//   void initState() {
//     super.initState();
//     //     Timer(Duration(seconds: 5), () {
//     //   Get.off(() => HomePageScreeen());
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(

//         children: [
//           SizedBox(height:Get.height*0.065,),
//           Text("𝐖𝐞𝐥𝐜𝐨𝐦𝐞 𝐓𝐨 𝐑𝐚𝐢𝐥𝐭𝐞𝐜𝐡 𝐀𝐭𝐭𝐞𝐧𝐝𝐚𝐧𝐜𝐞",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
//           SizedBox(height: Get.height*0.10,),
//           Container(

//             child:Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Image.asset("assets/Railtech IntroScreen Video.gif",fit: BoxFit.cover,),
//             ),

//           ),
//           SizedBox(height: Get.height*0.26,),
//           InkWell(
//             onTap: (){
//               Get.off(()=>HomePageScreeen());
//             },
//             child: Container(
//               height: Get.height*0.06,
//               width: Get.height*0.45,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(20)
//               ),
//               child: Center(child: Text("Skip ",style: TextStyle(fontSize: 20,color: Colors.white),)),
//             ),
//           )
//         ],
//       )
//     );
//   }
// }
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

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
        title: Text('𝐖𝐞𝐥𝐜𝐨𝐦𝐞 𝐓𝐨 𝐑𝐚𝐢𝐥𝐭𝐞𝐜𝐡 𝐀𝐭𝐭𝐞𝐧𝐝𝐚𝐧𝐜𝐞',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.offAll(() => HomePageScreeen());
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            label: Text(
              "Go Home",
              style: TextStyle(color: Colors.white),
            ), // Add your label here
          ),
        ],
      ).gradientBackground(withActions: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset("assets/attendance1.jpg"),
              Image.asset("assets/attendace2.jpg"),
              Image.asset("assets/attendance3.jpg"),
              Image.asset("assets/attendance4.jpg"),
              Image.asset("assets/attendace5.jpg"),
              Image.asset("assets/attendace6.jpg"),
              SizedBox(
                height: 10,
              ),
              //    InkWell(
              //   onTap: (){
              //     Get.off(()=>HomePageScreeen());
              //   },
              //   child: Container(
              //     height: Get.height*0.06,
              //     width: Get.height*0.45,
              //     decoration: BoxDecoration(
              //       color: Colors.green,
              //       borderRadius: BorderRadius.circular(20)
              //     ),
              //     child: Center(child: Text("Skip ",style: TextStyle(fontSize: 20,color: Colors.white),)),
              //   ),
              // ),
              // SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
