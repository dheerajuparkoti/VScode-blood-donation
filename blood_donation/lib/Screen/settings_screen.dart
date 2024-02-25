import 'dart:convert';

import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/model/screen_resolution.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
      // ignore: use_build_context_synchronously
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
  Future<void> updateUserData() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'email': emailController.text.trim(),
      'username': usernameController.text.trim(),
      'password': passwordController.text.trim(),
      'oldPassword': oldPasswordController.text.trim(),
      'id': userProvider.userId,
    };
    var response = await CallApi().updatingUserData(data, 'updateUserData');
    // Handle the response

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showSuccess(
        context: context,
        message: "Updated successfully",
        icon: Icons.check_circle,
      );
      fetchUserData();
      _resetDropdowns();
      isLoading = false;
    } else {
      // var responseData = json.decode(response.body);
      // ignore: use_build_context_synchronously
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
    double asr = ScreenResolution().sh / ScreenResolution().sw;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20.4 * asr,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 10.33 * asr,
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
              left: 15.5 * asr, right: 15.5 * asr, top: 0, bottom: 0,
              //horizontal: 30,
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 15.5*asr),
                  child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF444242),
                        borderRadius: BorderRadius.only(),
                      ),
                      child: const Center(
                        child: Text(
                          'Set Appointment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),

                */

                SizedBox(height: 12.9 * asr),
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
                SizedBox(height: 2.58 * asr),

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
                SizedBox(height: 2.58 * asr),

                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'To change your password :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 2.58 * asr),
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

                SizedBox(height: 2.58 * asr),

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
                SizedBox(height: 15.5 * asr),

                // Making send button
                SizedBox(height: 15.5 * asr),
                Container(
                  height: 20.4 * asr,
                  margin: EdgeInsets.symmetric(horizontal: 12.9 * asr),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.75 * asr),
                    color: const Color(0xffBF371A),
                  ),
                  //calling insert function when button is pressed
                  child: InkWell(
                    onTap: () {
                      if (passwordController.text.trim() != '' ||
                          oldPasswordController.text.trim() != '') {
                        if (oldPasswordController.text.trim() !=
                            passwordController.text.trim()) {
                          updateUserData();
                        }
                      } else {
                        updateUserData();
                      }
                    },
                    child: Center(
                      child: Text(
                        "Apply Changes",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 9.30 * asr),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.5 * asr),
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
              strokeWidth: 2.58 * asr,
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ),

        // Add more widgets as needed
      ]),
    );
  }
}
