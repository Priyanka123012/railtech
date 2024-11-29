// import 'package:face_liveness/face_liveness.dart';
// import 'package:flutter/material.dart';

// class FaceLivenessScreen extends StatefulWidget {
//   final FaceLiveness faceLiveness;

//   const FaceLivenessScreen({Key? key, required this.faceLiveness})
//       : super(key: key);

//   @override
//   State<FaceLivenessScreen> createState() => _FaceLivenessScreenState();
// }

// class _FaceLivenessScreenState extends State<FaceLivenessScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Face Liveness Detection")),
//       body: Stack(
//         children: [
//           if (widget.faceLiveness.cameraController != null &&
//               widget.faceLiveness.cameraController!.value.isInitialized)
      
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FloatingActionButton(
//                   onPressed: () async {
//                     await widget.faceLiveness.switchCamera();
//                     setState(() {});
//                   },
//                   child: const Icon(Icons.switch_camera),
//                 ),
//                 FloatingActionButton(
//                   onPressed: () async {
//                     final imagePath = await widget.faceLiveness.captureImage();
//                     if (imagePath != null) {
//                       // Process the captured image here
//                       print("Image captured: $imagePath");
//                     }
//                   },
//                   child: const Icon(Icons.camera),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
