import 'package:faecauth/screens/auth/login_ctrl.dart';
import 'package:faecauth/utils/appHelper/app_fontfamily.dart';
import 'package:faecauth/utils/appHelper/app_helper.dart';
import 'package:faecauth/utils/appHelper/app_helper_function.dart';
import 'package:faecauth/utils/appScaffold.dart';
import 'package:faecauth/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();

//Harshit Dwivedi
//  static TextEditingController email =
//       TextEditingController(text: "8127746666");
//   static TextEditingController password = TextEditingController(text: "513055");

//Kriti Mishra
  // static TextEditingController email =
  //     TextEditingController(text: "6306337655");
  // static TextEditingController password = TextEditingController(text: "427505");

//SANCHITA VAISH
  // static TextEditingController email =
  //     TextEditingController(text: "8948946256");
  // static TextEditingController password = TextEditingController(text: "848628");

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKeyLogin = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (loginController) {
          return AppScaffold(
            isLoading: loginController.isLoading,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            // height: MediaQuery.of(context).size.height * 0.25,
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: Image.asset(
                              "assets/logo1.png",
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        // Text(
                        //   "Welcome",
                        //   style: AppFontFamily().roboto.copyWith(
                        //       fontSize: 26,
                        //       color: Colors.black38,
                        //       fontWeight: FontWeight.w700),
                        // ),
                        // Text(
                        //   "Railtech Infraventure Pvt.Ltd.",
                        //   textAlign: TextAlign.center,
                        //   style: AppFontFamily().roboto.copyWith(
                        //       fontSize: 26,
                        //       color: Colors.black38,
                        //       fontWeight: FontWeight.w700),
                        // ),
                        AppDimensions().vSpace30(),
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  "Login Now",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                AppDimensions().vSpace30(),
                                loginView(),
                                AppDimensions().vSpace30(),
                                AppDimensions().vSpace30(),
                                CustomButton(
                                    onStartNowClick: () {
                                      if (_formKeyLogin.currentState!
                                          .validate()) {
                                        loginController.login(
                                            email: LoginView.email.text,
                                            password: LoginView.password.text);
                                        AppHelperFunction().hideKeyBoard();
                                      }
                                    },
                                    buttonText: "Login",
                                    textColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    startColor: Colors.red,
                                    endColor: Colors.red),
                                // AppDimensions().vSpace30(),
                                AppDimensions().vSpace10(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool isObsecur = true;

  Widget loginView() {
    return Form(
      key: _formKeyLogin,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            // validator: (input) =>
            //     input!.isValidEmail() ? null : "Enter Invalid email",
            controller: LoginView.email,
            keyboardType: TextInputType.emailAddress,
            maxLength: 50,
            cursorColor: Colors.black,
            style: AppFontFamily().roboto.copyWith(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              fillColor: Colors.black,
              filled: false,
              counter: SizedBox(),
              errorStyle: AppFontFamily().roboto.copyWith(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              hintText: "Mobile Number",
              hintStyle: AppFontFamily().roboto.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              suffixIcon: Icon(Icons.person),
            ),
          ),
          AppDimensions().vSpace20(),
          TextFormField(
            // validator: (input) =>
            //     input!.isValidEmail() ? null : "Enter Invalid email",
            keyboardType: TextInputType.text,
            obscureText: isObsecur,
            maxLength: 20,
            controller: LoginView.password,
            cursorColor: Colors.black,
            style: AppFontFamily().roboto.copyWith(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12),
              fillColor: Colors.black,
              filled: false,
              counter: SizedBox(),
              errorStyle: AppFontFamily().roboto.copyWith(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
              hintText: "Password",
              hintStyle: AppFontFamily().roboto.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.black),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  isObsecur = !isObsecur;
                  setState(() {});
                },
                child: isObsecur
                    ? Icon(Icons.visibility_off)
                    : Icon(
                        Icons.visibility,
                        color: Colors.purple,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}'
            r'\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
