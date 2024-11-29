import 'dart:convert';
import 'package:faecauth/extension/appbar_ext.dart';
import 'package:faecauth/screens/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPassword = false;
  bool _isPasswordVis = false;

  Future<String?> getManagerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('managerId');
  }

  Future<String?> getEmpBasicDetailId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId');
  }

  Future<String?> getEmpType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empType');
  }

  Future<void> _updatePassword() async {
    final oldPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    String? empId = await getEmpBasicDetailId();
    String? managerId = await getManagerId();
    String? empType = await getEmpType();

    // Ensure passwords match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      const url = 'http://rapi.railtech.co.in/api/Login/ChangePassword';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'OldPassword': oldPassword,
          'NewPassword': newPassword,
          'ConfirmPassword': confirmPassword,
          'Type': empType,
          'Id': empId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['StatusCode'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePageScreeen()));
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${responseData['Message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    } catch (e) {
      print("Exception caught: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
          ),
        ),
        title: Text('Change Password',
            // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20
            )
            ,
      ).gradientBackground(withActions: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: currentPasswordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    label: const Text('Current Password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: newPasswordController,
                  obscureText: !_isPassword,
                  decoration: InputDecoration(
                    label: const Text('New Password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPassword = !_isPassword;
                        });
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreenAccent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: !_isPasswordVis,
                  decoration: InputDecoration(
                    label: const Text('Confirm Password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVis
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVis = !_isPasswordVis;
                        });
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreenAccent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        currentPasswordController.clear();
                        newPasswordController.clear();
                        confirmPasswordController.clear();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 170,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 111, 0),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        _updatePassword(); // Call the method to update the password
                      },
                      child: const Text(
                        'Update Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
