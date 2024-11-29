// // import 'dart:convert';
// // import 'dart:typed_data';

// // import 'package:animated_splash_screen/animated_splash_screen.dart';
// // import 'package:faecauth/classess/face_matcher.dart';
// // import 'package:faecauth/classess/permission.dart';
// // import 'package:faecauth/extension/string_ext.dart';
// // import 'package:faecauth/screens/auth/login_with_email.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart';
// // import 'package:responsive_sizer/responsive_sizer.dart';
// // import 'package:velocity_x/velocity_x.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await AppPermissions.instance.checkAllPermissions();
// //   await FaceMatcher.instance.init();
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ResponsiveSizer(
// //       builder: (context, orientation, screenType) {
// //         return MaterialApp(
// //           debugShowCheckedModeBanner: false,
// //           title: 'Flutter Demo',
// //           theme: ThemeData(
// //             colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
// //             useMaterial3: true,
// //           ),
// //   home: AnimatedSplashScreen(
// //     splash: Image.asset('assets/face2.png'),
// //     splashIconSize: 200,
// //     nextScreen: LoginView(),
// //     splashTransition: SplashTransition.fadeTransition,
// //     backgroundColor: Colors.teal,
// //   ),
// // );
// //       },
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:faecauth/classess/face_matcher.dart';
// import 'package:faecauth/classess/permission.dart';
// import 'package:faecauth/common/constant.dart';
// import 'package:faecauth/screens/auth/login_model.dart';
// import 'package:faecauth/screens/auth/login_with_email.dart';
// import 'package:faecauth/screens/home_page_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:in_app_update/in_app_update.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// late SharedPreferences _prefs;
// var isLoggedIn;
// final facematcher = FaceMatcher.instance;
// void main() async {
//   await GetStorage.init();

//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
//       _prefs = await SharedPreferences.getInstance();
//       isLoggedIn = _prefs.getString(Constants.isLoggedIn);
//       if (isLoggedIn != null && isLoggedIn == '1') {
//         String loginResp = _prefs.getString(Constants.logResponseKey)!;
//         LoginResponseModel resp =LoginResponseModel.fromJson(jsonDecode(loginResp));
//         Constants.loginResponse.value = resp;
//       }
//       await AppPermissions.instance.checkAllPermissions();
//       await FaceMatcher.instance.init();
//       // await DatabaseHelper().database;

//       // Workmanager().initialize(
//       //   callbackDispatcher,
//       //   isInDebugMode: true,
//       // );
//       // Workmanager().registerPeriodicTask(
//       //   "1",
//       //   "syncAttendanceData",
//       //   frequency: Duration(hours: 1),
//       // );
//       // NetworkSyncManager networkSyncManager = NetworkSyncManager();

//       // Connectivity()
//       //     .onConnectivityChanged
//       //     .listen((List<ConnectivityResult> result) {
//       //       if (result != ConnectivityResult.none) {
//       //         networkSyncManager.syncAttendanceData();
//       //       }
//       //     } as void Function(List<ConnectivityResult> event)?);
      
//       double storedLatitude = 26.846260;
//       double storedLongitude = 80.948997;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setDouble('storedLatitude', storedLatitude);
//       await prefs.setDouble('storedLongitude', storedLongitude);
      
//       runApp(
//         const MyApp(),
//       );
//     },
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   Future<void> _checkForUpdate(BuildContext context) async {
//     try {
//       final updateInfo = await InAppUpdate.checkForUpdate();
//       if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
//         // Perform an immediate update or flexible update
//         await InAppUpdate.performImmediateUpdate();
//       }
//     } catch (e) {
//       print("Failed to check for updates: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _checkForUpdate(context);
//     return GetMaterialApp(
//       enableLog: true,
//       title: 'Attendance',
//       debugShowCheckedModeBanner: false,
//       darkTheme: null,
//       themeMode: ThemeMode.light,
//       // home: LoginView(),
//       home: AnimatedSplashScreen(
//         splash: Image.asset('assets/latest_logo.jpg'),
//         splashIconSize: 200,
//         nextScreen: isLoggedIn != "1" ? LoginView() : HomePageScreeen(),
//         splashTransition: SplashTransition.fadeTransition,
//         backgroundColor: Colors.white,
//       ),
//     );
//     // return ResponsiveSizer(
//     //   builder: (context, orientation, screenType) {
//     //     return MaterialApp(
//     //       debugShowCheckedModeBanner: false,
//     //       title: 'Flutter Demo',
//     //       theme: ThemeData(
//     //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//     //         useMaterial3: true,
//     //       ),
//     //       home: AnimatedSplashScreen(
//     //         splash: Image.asset('assets/logo.jpg'),
//     //         splashIconSize: 200,
//     //         nextScreen: isLoggedIn != "1" ? LoginView() : HomePageScreeen(),
//     //         splashTransition: SplashTransition.fadeTransition,
//     //         backgroundColor: Colors.white,
//     //       ),
//     //     );
//     //   },
//     // );
//   }
// }

import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:faecauth/classess/face_matcher.dart';
import 'package:faecauth/classess/permission.dart';
import 'package:faecauth/common/constant.dart';
import 'package:faecauth/screens/auth/login_model.dart';
import 'package:faecauth/screens/auth/login_with_email.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _prefs;
var isLoggedIn;
final facematcher = FaceMatcher.instance;

void main() async {
  await GetStorage.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn = _prefs.getString(Constants.isLoggedIn);
    if (isLoggedIn != null && isLoggedIn == '1') {
      String loginResp = _prefs.getString(Constants.logResponseKey)!;
      LoginResponseModel resp = LoginResponseModel.fromJson(jsonDecode(loginResp));
      Constants.loginResponse.value = resp;
    }

    await AppPermissions.instance.checkAllPermissions();
    await FaceMatcher.instance.init();

    double storedLatitude = 26.846260;
    double storedLongitude = 80.948997;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('storedLatitude', storedLatitude);
    await prefs.setDouble('storedLongitude', storedLongitude);

    // Call the method to check for app update before launching the app
    await _checkForUpdate();

    runApp(const MyApp());
  });
}

Future<void> _checkForUpdate() async {
  try {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      // Show the dialog to prompt for an update if available
      await _showUpdateDialog();
    }
  } catch (e) {
    print("Failed to check for updates: $e");
  }
}

Future<void> _showUpdateDialog() async {
  // Show a dialog to prompt the user to update the app
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Available"),
        content: Text("A new version of the app is available. Please update it from the Play Store."),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
         
              // Perform an immediate update
              await InAppUpdate.performImmediateUpdate();
            },
            child: Text("Update Now"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: Text("Later"),
          ),
        ],
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      darkTheme: null,
      themeMode: ThemeMode.light,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/latest_logo.jpg'),
        splashIconSize: 200,
        nextScreen: isLoggedIn != "1" ? LoginView() : HomePageScreeen(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
