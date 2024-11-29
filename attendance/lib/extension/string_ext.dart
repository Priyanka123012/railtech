// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// extension AppStringExt on String {
//   void showToast({int duration = 10}) {
//     final message = this.trim();
//     if (message.isEmpty) return;

//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: duration,
//       backgroundColor: Colors.black,
//       textColor: Colors.white,
//       fontSize: 14.0,
//     );

//     if (Theme.of(navigatorKey.currentContext!).platform ==
//         TargetPlatform.android) {
//       Future.delayed(Duration(seconds: duration)).then((value) {
//         Fluttertoast.cancel();
//       });
//     } else {
//       Future.delayed(Duration(seconds: duration)).then((value) {
//         Fluttertoast.cancel();
//       });
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
extension AppStringExt on String {
  void showToast({int duration = 10}) {
    final message = this.trim();
    if (message.isEmpty) return;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG, // You may also set it to Toast.LENGTH_SHORT if preferred
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14.0,
    );

    final context = navigatorKey.currentContext;
    if (context != null) {
      Future.delayed(Duration(seconds: duration)).then((_) {
        Fluttertoast.cancel(); // This may be optional since the toast length is already set
      });
    }
  }
}

