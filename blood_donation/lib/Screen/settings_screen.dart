// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();

  bool isLoading = false;
  bool _isPasswordVisible = false;
  bool _isOldPasswordVisible = false;
  late final UserProvider userProvider; // Declare userProvider

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    fetchUserData();
  }

  Map<String, dynamic> data = {};
  String oldPassword = '';
  // Function to fetch donor data from the backend
  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    var sendData = {
      'id': userProvider.userId,
    };
    // Call your API to fetch donor data
    // Example:

    var res = await CallApi().fetchUserData(sendData, 'fetchingUserData');

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      final Map<String, dynamic> userData = jsonResponse['data'];

      setState(() {
        data = userData;
        // Assign fetched data to controllers
        emailController.text = data['email'] ?? '';
        usernameController.text = data['username'] ?? '';
        oldPassword = data['password'];
        isLoading = false;
      });
    } else {
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );

      isLoading = false;
      // Handle error
    }
  }

  // ending fetching donor data

// try new code for uploading data profilepic too
// Method to update profile including image
  Future<void> updateUserData(String newPassword) async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'email': emailController.text.trim(),
      'username': usernameController.text.trim(),
      'password': newPassword,
      'oldPassword': oldPasswordController.text.trim(),
      'id': userProvider.userId,
    };
    var response = await CallApi().updatingUserData(data, 'updateUserData');
    // Handle the response

    if (response.statusCode == 200) {
      CustomSnackBar.showSuccess(
        context: context,
        message: "Updated successfully",
        icon: Icons.check_circle,
      );
      fetchUserData();
      _resetDropdowns();
      isLoading = false;
    } else if (response.statusCode == 400) {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: "Your old password did not matched. Please enter correct one.",
        icon: Icons.warning,
      );
      fetchUserData();
      _resetDropdowns();
      isLoading = false;
    } else {
      // var responseData = json.decode(response.body);
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      isLoading = false;
    }
  }

// ending of uploading data

  void _resetDropdowns() {
    setState(() {
      passwordController.clear();
      oldPasswordController.clear();
      fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.045 * sh,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 0.025 * sh,
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xffBF371A),
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D2D2D),
                Color(0xFF2D2D2D),
              ],
            ),
          ),
        ),

        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 0.07 * sw,
              right: 0.07 * sw,
              top: 0,
              bottom: 0,
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 0.03 * sh),
                TextField(
                  controller: emailController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Your Email",
                    labelStyle: TextStyle(color: Color(0xffaba7a7)),
                  ),
                  maxLength: 50,
                ),
                SizedBox(height: 0.005 * sh),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Your Username",
                    labelStyle: TextStyle(color: Color(0xffaba7a7)),
                  ),
                  maxLength: 30,
                ),
                SizedBox(height: 0.005 * sh),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'To change your password :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 0.03 * sw,
                    ),
                  ),
                ),
                SizedBox(height: 0.005 * sh),
                TextField(
                  controller: oldPasswordController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Enter Old Password",
                    labelStyle: const TextStyle(color: Color(0xffaba7a7)),
                    icon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isOldPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_isOldPasswordVisible,
                  maxLength: 20,
                ),

                SizedBox(height: 0.005 * sh),

                TextField(
                  controller: passwordController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Enter New Password",
                    labelStyle: const TextStyle(color: Color(0xffaba7a7)),
                    icon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  maxLength: 20,
                ),
                SizedBox(height: 0.05 * sh),

                // Making Apply changes button
                SizedBox(height: 0.05 * sh),
                Container(
                  height: 0.05 * sh,
                  margin: EdgeInsets.symmetric(horizontal: 0.03 * sw),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.05 * sh),
                    color: const Color(0xffBF371A),
                  ),
                  //calling insert function when button is pressed
                  child: InkWell(
                    onTap: () {
                      if (oldPasswordController.text.trim() != '') {
                        if (passwordController.text.trim() != '') {
                          updateUserData(passwordController.text.trim());
                          // if new password is not given and only try to update
                          //either email or username
                        } else {
                          updateUserData(oldPasswordController.text.trim());
                        }
                        // if old password is not provided
                      } else {
                        CustomSnackBar.showUnsuccess(
                            context: context,
                            message:
                                "Please enter old password to make changes.",
                            icon: Icons.info);
                      }
                    },
                    child: Center(
                      child: Text(
                        "Apply Changes",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 0.02 * sh),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.05 * sh),
              ],
            )),
          ),
        ),

        // end of settings
        // circular progress bar
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 0.01 * sw,
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),

        // Add more widgets as needed
      ]),
    );
  }
}
