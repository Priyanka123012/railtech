import 'dart:io';

import 'package:faecauth/common/custome_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Utils {
  bool isSearchExpanded = false, isOpen = false;

  static void showToast(String text, [Color? bgColor]) {
    // Fluttertoast.cancel();
    ScaffoldMessenger.of(Get.context!).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    /* Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        // backgroundColor: bgColor,
        backgroundColor: Colors.grey.shade900,
        textColor: Colors.white,
        fontSize: 16.0); */
  }

  static void print(message) {
    if (!kReleaseMode) {
      debugPrint(message.toString());
    }
  }

  static bool isNumber(string) {
    try {
      // var data = double.tryParse(string);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isNetworkConnected({showToast = true}) async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } on SocketException catch (_) {
      if (showToast) {
        Utils.showToast('No Internet Connection', Colors.red);
      }
      return false;
    } catch (e) {
      Utils.showToast('Something went wrong', Colors.red);
      return false;
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static showPopupDialog(text, onPressed) {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          // ignore: deprecated_member_use
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Container(
                  alignment: Alignment.center,
                  child: Dialog(
                      insetPadding: const EdgeInsets.only(
                          left: 15, right: 15, top: 30, bottom: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: LayoutBuilder(
                                builder: (context, constraints) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Utils.textViewAlign(
                                            text,
                                            17,
                                            Colors.black,
                                            FontWeight.w600,
                                            TextAlign.center),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: constraints.maxWidth * 0.3,
                                          margin: const EdgeInsets.only(
                                              right: 5, top: 10, left: 5),
                                          child: MaterialButton(
                                            elevation: 10,
                                            highlightElevation: 0,
                                            onPressed: onPressed,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        80.0)),
                                            padding: const EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    CustomColors
                                                        .gradientBueStart,
                                                    CustomColors.gradientBueEnd
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(80.0)),
                                              ),
                                              child: Container(
                                                constraints: const BoxConstraints(
                                                    minHeight:
                                                        45.0), // min sizes for Material buttons
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'OK',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: '',
        context: Get.context!,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
    ;
  }

  static Future<DateTime> selectDatePicker(
      {required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) async {
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        helpText: 'Select Date',
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) {
      return Future.value(picked);
    }

    return initialDate;
  }

  static showEditTimeUpDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // ignore: deprecated_member_use
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Dialog(
                  insetPadding: const EdgeInsets.only(
                      left: 15, right: 15, top: 30, bottom: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Utils.textViewAlign(
                                  'Order edit time has finished. Please contact admin.',
                                  17,
                                  Colors.black,
                                  FontWeight.w600,
                                  TextAlign.center),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: constraints.maxWidth * 0.3,
                                margin: const EdgeInsets.only(
                                    right: 5, top: 10, left: 5),
                                child: MaterialButton(
                                  elevation: 10,
                                  highlightElevation: 0,
                                  onPressed: () {
                                    Utils.hideLoader(context);
                                    Utils.hideLoader(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  padding: const EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          CustomColors.gradientBueStart,
                                          CustomColors.gradientBueEnd
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(80.0)),
                                    ),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minHeight:
                                              45.0), // min sizes for Material buttons
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'OK',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  )));
        });
  }

  static showDateTimeCorrectionDialog(BuildContext context) {
    showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          // ignore: deprecated_member_use
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Container(
                  alignment: Alignment.center,
                  child: Dialog(
                      insetPadding: const EdgeInsets.only(
                          left: 15, right: 15, top: 30, bottom: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: LayoutBuilder(
                                builder: (context, constraints) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Utils.textViewAlign(
                                            'Please correct your phone date and time to mark attendance',
                                            17,
                                            Colors.black,
                                            FontWeight.w600,
                                            TextAlign.center),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          width: constraints.maxWidth * 0.3,
                                          margin: const EdgeInsets.only(
                                              right: 5, top: 10, left: 5),
                                          child: MaterialButton(
                                            elevation: 10,
                                            highlightElevation: 0,
                                            onPressed: () {
                                              // SystemChannels.platform
                                              //     .invokeMethod('SystemNavigator.pop');
                                              Utils.hideLoader(context);
                                              Utils.hideLoader(context);
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        80.0)),
                                            padding: const EdgeInsets.all(0.0),
                                            child: Ink(
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: <Color>[
                                                    CustomColors
                                                        .gradientBueStart,
                                                    CustomColors.gradientBueEnd
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(80.0)),
                                              ),
                                              child: Container(
                                                constraints: const BoxConstraints(
                                                    minHeight:
                                                        45.0), // min sizes for Material buttons
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'OK',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }

  static bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(email);
  }

  /*  static bool isStrongePassword(String password) {
    String p =
        r'^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(password);
  } */
  static bool isStrongePassword(String password) {
    // Reset error message
    String _errorMessage = '';
    // Password length greater than 6
    if (password.length < 8) {
      _errorMessage += 'Password must be longer than 8 characters.\n';
    }
    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }
    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }
    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }
    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• Special character is missing.\n';
    }
    if (_errorMessage.isNotEmpty) {
      showToast(_errorMessage);
    }

    // If there are no error messages, the password is valid
    return _errorMessage.isEmpty;
  }

  static String formatDate(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    // String string = dateFormat.format(DateTime.now());

    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = dateTime.day.toString().padLeft(2, '0') +
        ' ' +
        getMonth(date) +
        ', ' +
        dateTime.year.toString();

    return formattedDate;
  }

  static DateTime getDateTime(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MMM-dd");

    // String string = dateFormat.format(DateTime.now());

    DateTime dateTime = dateFormat.parse(date);
    DateTime dateTimeFormatted =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // String formattedDate = dateTime.day.toString().padLeft(2, '0') +
    //     ' ' +
    //     getMonth(date) +
    //     ', ' +
    //     dateTime.year.toString();

    return dateTimeFormatted;
  }

  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static String getMonth(String date) {
    int year = int.parse(date.split('-')[0]);
    int month = int.parse(date.split('-')[1]);
    int day = int.parse(date.split('-')[2]);

    DateTime a = DateTime(year, month, day);

    return DateFormat('MMM').format(a);
  }

  static String getDay(String date) {
    int year = int.parse(date.split('-')[0]);
    int month = int.parse(date.split('-')[1]);
    int day = int.parse(date.split('-')[2]);

    DateTime a = DateTime(year, month, day);

    return DateFormat('EEE').format(a);
  }

  static void showLoaderDialog() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.transparent.withOpacity(0.02),
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: SizedBox(
              // height: Get.height,
              // width: Get.width,
              child: LoadingAnimationWidget.flickr(
                leftDotColor: CustomColors.primaryColor,
                rightDotColor: CustomColors.primaryColorDark,
                size: 50,
              ),
            ));
      },
    );
  }

  static void hideLoader([BuildContext? context]) {
    Get.back();
  }

  static Widget textView(
      String text, double fontSize, Color? textColor, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  static Widget textViewAlign(String text, double fontSize, Color? textColor,
      FontWeight fontWeight, TextAlign textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      style: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  static String formatCurrentMonth(DateTime dateTime) {
    DateFormat formatter = DateFormat('MMM');
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static bool equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static Widget elevatedButton(
      {height = 50.0,
      marginLeft = 0.0,
      marginRight = 0.0,
      marginTop = 0.0,
      marginBottom = 0.0,
      required onPressed,
      isEnabled = true,
      text = 'OK',
      fontSize = 18.0,
      borderRadius = 40.0,
      textColor = Colors.white}) {
    return Container(
      height: height,
      margin:
          EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEnabled
                  ? [
                      Colors.red,
                      Colors.green,
                    ]
                  : [
                      Colors.grey,
                      Colors.grey,
                    ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            backgroundColor:
                WidgetStateProperty.all<Color>(CustomColors.primaryColorDark),
            elevation: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return 0.0;
                }
                return 5.0;
              },
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ))),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  /*  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  } */

  int get weekOfMonth {
    var currDate = this;
    currDate = DateTime(currDate.year, currDate.month, currDate.day);
    final firstDayOfTheMonth = DateTime(currDate.year, currDate.month, 1);
    DateTime date = firstDayOfTheMonth;
    int week = 1;

    while (!(date.isAtSameMomentAs(date)) || !(currDate.isBefore(date))) {
      week++;
      date = date.add(const Duration(days: 7));
    }
    int diff = date.difference(currDate).inDays;
    int a = firstDayOfTheMonth.weekday - diff;
    if (a > 0) {
      return week;
    } else {
      return week - 1;
    }
  }
}
