// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:blood_donation/Screen/home_screen.dart';
import 'package:blood_donation/data/internet_connectivity.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/notificationservice/get_device_token.dart';
import 'package:blood_donation/notificationservice/notification_service.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'dart:math'; // for generating min 8 digit new password
import 'package:blood_donation/widget/custom_dialog_boxes.dart';

// for sending email using gmail
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({super.key});

  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  bool isLoading = false;
  bool passwordsMatch = true;
  bool confirmPasswordTyping = false;
  bool phoneNumberError = false;
  bool dobError = false;
  bool emailValid = false;
  bool isEmailEmpty = true;
  String deviceTokenToSendPushNotification = "";

  TextEditingController fullnameController = TextEditingController();
  TextEditingController wardNoController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();

  TextEditingController signInUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  String? selectedBloodGroup;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

// REGISTRATION USER FUNCTION STARTS HERE
  void regUser() async {
    setState(() {
      isLoading = true;
    });
     // Get the device token
     NotificationService notificationService =NotificationService();
    String deviceToken = await notificationService.getDeviceToken();

    var data = {
      'email': emailController.text.trim(),
      'username': usernameController.text.trim(),
      'password': confirmPasswordController.text.trim(),
      'fullName': fullnameController.text.trim(),
      'dob': dobController.text.trim(),
      'gender': selectedGender,
      'bloodGroup': selectedBloodGroup,
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text.trim(),
      'phone': phoneController.text.trim(),
      'deviceToken': deviceToken
    };

    var response = await CallApi().postData(data, 'regUser');
    if (response.statusCode == 200) {
      CustomSnackBar.showSuccess(
        context: context,
        message: 'Donor registered successfully',
        icon: Icons.check_circle,
      );
      _tabController.animateTo(0);
      isLoading = false;
    } else if (response.statusCode == 201) {
      CustomSnackBar.showSuccess(
        context: context,
        message: 'User registered successfully',
        icon: Icons.check_circle,
      );
      _tabController.animateTo(0);
      isLoading = false;
    } else if (response.statusCode == 500) {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: 'Internal Server Error: Something went wrong',
        icon: Icons.error,
      );
      isLoading = false;
    } else {
      // Other error cases, including 500 Internal Server Error but im
      //showing here username / email already exists.
      CustomSnackBar.showUnsuccess(
        context: context,
        message: 'User with provided username/email already exists',
        icon: Icons.error,
      );
      isLoading = false;
    }
  }
//  ENDS HERE

  @override
  bool get wantKeepAlive => true;

//DATE TIME PICKER STARTS HERE
  DateTime selectedDate = DateTime.now();
  final TextEditingController dobController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2101),
      helpText: 'Select a date of birth in AD',
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //dobController.text = "${picked.year}/${picked.month}/${picked.day}";
        dobController.text = picked.toString().split(" ")[0];
        _validateDOB(dobController.text);
      });
    }
  }
// ENDS HERE

//Date of Birth Validation
  bool isValidDOB(String dob) {
    // Parse the input DOB string into a DateTime object
    DateTime? dobDate = DateTime.tryParse(dob);

    // Check if DOB is not null and falls within the age range of 18 to 60
    if (dobDate != null) {
      // Calculate age based on the DOB and current date
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - dobDate.year;
      if (currentDate.month < dobDate.month ||
          (currentDate.month == dobDate.month &&
              currentDate.day < dobDate.day)) {
        age--;
      }

      // Check if the age falls within the desired range (18 to 60)
      return age >= 16 && age <= 60;
    } else {
      return false; // Return false if DOB is null
    }
  }

  void _validateDOB(String dob) {
    setState(() {
      dobError = !isValidDOB(dob);
    });
  }

  @override
  void initState() {
    super.initState();
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          // LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {}
      },
    );
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

// HANDLE TAB CHANGES START HERE
  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 0) {
      signInUsernameController.clear();
      passwordController.clear();
      _resetDropdowns();
      dobController.clear();
    } else if (_tabController.index == 1) {
      fullnameController.clear();
      dobController.clear();
      wardNoController.clear();
      phoneController.clear();
      emailController.clear();
      usernameController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    }
  }
// ENDS HERE

//RESET DROPDOWN START HERE
  void _resetDropdowns() {
    setState(() {
      selectedGender = null;
      selectedBloodGroup = null;
      selectedProvince = null;
      selectedDistrict = null;
      selectedLocalLevel = null;
    });
  }
// ENDS HERE

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    dobController.dispose();
    super.dispose();
  }

  bool validateEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(?:\.[\w-]+)*@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // to maintain state between two tabs

    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(
        children: <Widget>[
          Container(
            height: 0.45 * sh,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF00808),
                  Color(0xffBF371A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.25 * sh),
                bottomRight: Radius.circular(0.5 * sh),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.08 * sw, vertical: 0.025 * sh),
            child: SizedBox(
              width: 0.7 * sw,
              height: 0.25 * sh,
              child: Image.asset(
                'images/mbblogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.08 * sw,
              vertical: 0.03 * sh,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 0.75 * sh,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.05 * sh),
                    topRight: Radius.circular(0.05 * sh),
                    bottomLeft: Radius.circular(0.05 * sh),
                    bottomRight: Radius.circular(0.05 * sh),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.025 * sh,
                    ),
                    TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.03 * sh),
                        color: const Color(0xffFF0025),
                      ),
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 0.1 * sw),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics:
                            const NeverScrollableScrollPhysics(), // restricting Swipe left or right between two tabs
                        children: <Widget>[
                          // SIGN IN CONTENTS START HERE
                          SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05 * sw,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 0.025 * sh),
                                    TextField(
                                      controller: signInUsernameController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Username or Email",
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                        icon: Icon(Icons.person),
                                      ),
                                      maxLength: 30,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                              r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                        ),
                                      ],
                                    ),

                                    TextField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: "Enter Password",
                                        hintStyle: const TextStyle(
                                            color: Color(0xff858585)),
                                        icon: const Icon(Icons.lock),
                                        suffixIcon: Semantics(
                                          label: _isPasswordVisible
                                              ? 'Hide Password'
                                              : 'Show Password',
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                            child: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                      obscureText: !_isPasswordVisible,
                                      maxLength: 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                              r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.01 * sh),

                                    
                                    // Making Login button

                                    Container(
                                      height: 0.06 * sh,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.1 * sw),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.03 * sh),
                                        color: const Color(0xffFF0025),
                                      ),

                                      //calling insert function when button is pressed
                                      child: InkWell(
                                        onTap: () async {
                                          // first checking internet connection
                                          bool isConnected =
                                              await ConnectivityUtil
                                                  .isInternetConnected();
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (isConnected) {
                                            // Internet is connected
                                            if (signInUsernameController.text
                                                    .trim() ==
                                                '') {
                                              CustomSnackBar.showUnsuccess(
                                                  context: context,
                                                  message:
                                                      "Please enter the username or Email",
                                                  icon: Icons.info);
                                              isLoading = false;
                                            } else if (passwordController.text
                                                    .trim() ==
                                                '') {
                                              CustomSnackBar.showUnsuccess(
                                                  context: context,
                                                  message:
                                                      "Please enter the password",
                                                  icon: Icons.info);
                                              isLoading = false;
                                            } else if (signInUsernameController
                                                        .text
                                                        .trim() !=
                                                    '' &&
                                                passwordController.text
                                                        .trim() !=
                                                    '') {
                                              loginData(context);
                                            }
                                          } else {
                                            // No internet connection
                                            CustomDialog.showAlertDialog(
                                              context,
                                              'Network Error',
                                              'There was an error connecting to the server. Please try again later.',
                                              Icons.error_outline,
                                            );
                                            isLoading = false;
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 0.022 * sh),
                                          ),
                                        ),
                                      ),
                                    ),
                                       TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const ForgotPasswordDialog(),
                                        );
                                        // loginData(context);
                                      },
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                          color: const Color(0xFF959595),
                                          fontSize: 0.015 * sh,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              const Color(0xffFF0025),
                                          decorationThickness: 0.5,
                                        ),
                                      ),
                                    ),

                                    
                                  ],
                                )),
                          ),
// ENDS HERE

//SIGN UP CONTENT STARTS HERE

                          SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0.05 * sw,
                                ),
                                child: Column(
                                  children: [
                                    Semantics(
                                      label: 'Enter Fullname',
                                      child: TextField(
                                        controller: fullnameController,
                                        decoration: const InputDecoration(
                                          hintText: "Full Name",
                                          hintStyle: TextStyle(
                                              color: Color(0xFF858585)),
                                        ),
                                        maxLength: 30,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^[a-zA-Z ]+$'), // Regular expression pattern for English alphabets and space
                                          ),
                                        ],
                                      ),
                                    ),

                                    TextField(
                                      controller: dobController,
                                      readOnly: true,
                                      onTap: () => _selectDate(context),
                                      decoration: InputDecoration(
                                        hintText: "Select Date of Birth",
                                        errorText: dobController.text.isEmpty
                                            ? null
                                            : (dobError
                                                ? 'Age must be between 16-60 to donate blood'
                                                : null),
                                        hintStyle: const TextStyle(
                                            color: Color(0xff858585)),
                                        suffixIcon: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child:
                                              const Icon(Icons.calendar_today),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 0.02 * sh),

                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        hintText: 'Select Gender',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      value: selectedGender,
                                      items: ['Male', 'Female', 'Others']
                                          .map((gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(
                                            gender,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 0.02 * sh),

                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        hintText: 'Select blood Group',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      value: selectedBloodGroup,
                                      items: [
                                        'A+',
                                        'B+',
                                        'O+',
                                        'A-',
                                        'B-',
                                        'O-',
                                        'AB+',
                                        'AB-',
                                      ].map((bloodGroup) {
                                        return DropdownMenuItem<String>(
                                          value: bloodGroup,
                                          child: Text(
                                            'Blood Group $bloodGroup',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBloodGroup = value;
                                        });
                                      },
                                    ),

                                    SizedBox(height: 0.02 * sh),

                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        hintText: 'Select Province',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      value: selectedProvince,
                                      items: ['1', '2', '3', '4', '5', '6', '7']
                                          .map((province) {
                                        return DropdownMenuItem<String>(
                                          value: province,
                                          child: Text(
                                            'Province $province',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedProvince = value;
                                          // Reset selected values for subsequent dropdowns
                                          selectedDistrict = null;
                                          selectedLocalLevel = null;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 0.02 * sh),

                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        hintText: 'Select District',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      value: selectedDistrict,
                                      items: selectedProvince != null
                                          ? DistrictData
                                              .districtList[selectedProvince!]!
                                              .map((district) {
                                              return DropdownMenuItem<String>(
                                                value: district,
                                                child: Text(
                                                  district,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              );
                                            }).toList()
                                          : [],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDistrict = value;
                                          selectedLocalLevel = null;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 0.02 * sh),

                                    // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff858585)),
                                        ),
                                        hintText: 'Select Local Level',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      value: selectedLocalLevel,
                                      items: selectedDistrict != null
                                          ? DistrictData.localLevelList[
                                                  selectedDistrict!]!
                                              .map((locallevel) {
                                              return DropdownMenuItem<String>(
                                                value: locallevel,
                                                child: Text(
                                                  locallevel,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              );
                                            }).toList()
                                          : [],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedLocalLevel = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 0.02 * sh),

                                    Semantics(
                                      label: "Enter Ward Number",
                                      child: TextField(
                                        controller: wardNoController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "Ward No.",
                                          errorText: (wardNoController
                                                      .text.isNotEmpty &&
                                                  int.tryParse(wardNoController
                                                          .text)! >
                                                      33)
                                              ? 'Ward number cannot be greater than 33'
                                              : null,
                                          hintStyle: const TextStyle(
                                            color: Color(0xFF858585),
                                          ),
                                        ),
                                        maxLength: 2,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Allow only digits
                                        ],
                                      ),
                                    ),

                                    TextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: "Phone Number",
                                        errorText: phoneController.text.isEmpty
                                            ? null
                                            : (phoneNumberError
                                                ? 'Phone number must be 10 digits'
                                                : null),
                                        hintStyle: const TextStyle(
                                          color: Color(0xff858585),
                                        ),
                                      ),
                                      maxLength: 10,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(
                                            10), // Ensures maxLength is respected
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          // Check if the length of phone number is not 10
                                          phoneNumberError = value.length != 10;
                                        });
                                      },
                                    ),

                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: "E-mail",
                                        hintStyle: const TextStyle(
                                            color: Color(0xff858585)),
                                        errorText: emailController.text.isEmpty
                                            ? null
                                            : (isEmailEmpty
                                                ? null
                                                : (emailValid
                                                    ? null
                                                    : 'Invalid email address')),
                                      ),
                                      maxLength: 30,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                              r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          emailValid = validateEmail(value);
                                          isEmailEmpty = value
                                              .isEmpty; // Update isEmailEmpty
                                        });
                                      },
                                    ),

                                    TextField(
                                      controller: usernameController,
                                      decoration: const InputDecoration(
                                        hintText: "Username",
                                        hintStyle:
                                            TextStyle(color: Color(0xff858585)),
                                      ),
                                      maxLength: 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')), // Deny whitespace
                                      ],
                                    ),

                                    TextField(
                                      controller: newPasswordController,
                                      decoration: InputDecoration(
                                        hintText: "New Password",
                                        hintStyle: const TextStyle(
                                            color: Color(0xff858585)),
                                        suffixIcon: Semantics(
                                          label: _isPasswordVisible
                                              ? 'Hide New Password'
                                              : 'Show New Password',
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                            child: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                      obscureText: !_isPasswordVisible,
                                      maxLength: 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                              r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: confirmPasswordController,
                                      decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        hintStyle: const TextStyle(
                                            color: Color(0xff858585)),
                                        suffixIcon: Semantics(
                                          label: _isPasswordVisible
                                              ? 'Hide Confirm Password'
                                              : 'Show Confirm Password',
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isConfirmPasswordVisible =
                                                    !_isConfirmPasswordVisible;
                                              });
                                            },
                                            child: Icon(
                                              _isConfirmPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                      obscureText: !_isConfirmPasswordVisible,
                                      maxLength: 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(
                                              r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          confirmPasswordTyping = true;
                                          if (confirmPasswordTyping) {
                                            passwordsMatch = value ==
                                                newPasswordController.text;
                                          }
                                        });
                                      },
                                    ),
                                    // Show error message if passwords don't match
                                    if (!passwordsMatch &&
                                        confirmPasswordTyping &&
                                        confirmPasswordController
                                            .text.isNotEmpty)
                                      const Text(
                                        'Passwords do not match',
                                        style: TextStyle(color: Colors.red),
                                      ),

                                    //making sign up button
                                    SizedBox(height: 0.02 * sh),
                                    Container(
                                      height: 0.06 * sh,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.1 * sw),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.03 * sh),
                                        color: const Color(0xffFF0025),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          // first checking internet connection
                                          bool isConnected =
                                              await ConnectivityUtil
                                                  .isInternetConnected();
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (isConnected) {
                                            // Internet is connected
                                            validationFields();
                                          } else {
                                            // No internet connection
                                            CustomDialog.showAlertDialog(
                                              context,
                                              'Network Error',
                                              'There was an error connecting to the server. Please try again later.',
                                              Icons.error_outline,
                                            );
                                            isLoading = false;
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "Sign Up",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 0.022 * sh),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 0.025 * sh),
                                  ],
                                )),
                          ),
// SIGN UP CONTENTS ENDS HERE
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

//CIRCULAR PROGRESS BAR STARTS HERE
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
                strokeWidth: 0.01 * sw,
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
//ENDS HERE
        ],
      ),
    );
  }

  void validationFields() {
    setState(() {
      isLoading = true;
    });
    RegExp numericRegex = RegExp(r'^[0-9]+$');
    if (fullnameController.text.trim() != '' &&
        dobController.text.trim() != '' &&
        selectedGender != null &&
        selectedBloodGroup != null &&
        selectedProvince != null &&
        selectedDistrict != null &&
        selectedLocalLevel != null &&
        wardNoController.text.trim() != '' &&
        ((wardNoController.text.isNotEmpty &&
            int.tryParse(wardNoController.text)! <= 33)) &&
        phoneController.text.trim() != '' &&
        phoneNumberError == false &&
        dobError == false &&
        emailController.text.trim() != '' &&
        usernameController.text.trim() != '' &&
        newPasswordController.text.trim() != '' &&
        confirmPasswordController.text.trim() != '' &&
        (newPasswordController.text.trim() ==
            confirmPasswordController.text.trim()) &&
        (emailController.text.isEmpty ||
            (emailController.text.isNotEmpty && isEmailEmpty || emailValid))) {
      if (numericRegex.hasMatch(phoneController.text.trim())) {
        regUser();
        isLoading = false;
      } else {
        CustomSnackBar.showUnsuccess(
            context: context,
            message: "Contact number should contain only numbers.",
            icon: Icons.info);
        isLoading = false;
      }
    } else {
      CustomSnackBar.showUnsuccess(
          context: context,
          message: "Please fill all fields correctly.",
          icon: Icons.info);
      isLoading = false;
    }
  }

//LOGIN STARTS HERE --------------------------------------------------
  loginData(BuildContext context) async {
    setState(() {
      isLoading = true; // Set isLoading to true when login button is pressed
    });

    final username = signInUsernameController.text.trim();
    final password = passwordController.text.trim();

    // Create an instance of CallApi
    CallApi callApi = CallApi();

    try {
      final Map<String, dynamic> response =
          await callApi.login(username, password);

      if (response.containsKey('token') && response.containsKey('userId')) {

    final dynamic token = response['token'];
    final int userId = response['userId'];
    final int donorId = response['donorId'];
    final String accountType = response['accountType'];

    // Print the token and other user information
    print("TOKEN IS = $token");
    print("USER ID IS = $userId");
    print("DONOR ID IS = $donorId");
    print("ACCOUNT TYPE IS = $accountType");

    // Store the token and user ID globally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rememberToken', token.toString());

    // Store other user information as well

    print("Login Successful, token saved.");

    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUserId(userId);
    userProvider.setDonorId(donorId);
    userProvider.setUserAccountType(accountType);

    // Navigate to the home screen or another screen
  Get.off(() => const HomeScreen());
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('401') ||
          e is Exception && e.toString().contains('404')) {
        CustomDialog.showAlertDialog(
          context,
          'Invalid Username or Password',
          'Please check your username and password and try again.',
          Icons.warning_rounded,
        );
      } else {
         print("Login failed");
        CustomDialog.showAlertDialog(
          context,
          'Network Error',
          'There was an error connecting to the server. Please try again later.',
          Icons.error_outline,
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
// ENDS  HERE--------------------------------------------------------------

// CHECKING WEATHER THE USER EXISTS OR NOT  STARTS HERE --------------------------
// calling api for checking weather the email or phone i.e user exists or not
Future<bool> checkUserExists(
    String email, String phone, String newPassword) async {
  // Create the request body
  final Map<String, String> data = {
    'email': email,
    'phone': phone,
    'new_password': newPassword,
  };

  // Make the API request
  var res = await CallApi().checkUser(data, 'checkUserExists');

  // Check if the request was successful
  if (res.statusCode == 200) {
    // Parse the response JSON
    final responseData = json.decode(res.body);

    // Extract the 'exists' field from the response
    final bool exists = responseData['exists'];

    // Return the result
    return exists;
  } else {
    // If the request failed, throw an error
    throw Exception('Failed to check user existence');
  }
}
// ENDS HERE ------------------------

// FORGOT PASSWORD SEND EMAIL TO RESET THE PASSWORD OF THE ACCOUNT
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    double sh = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: TextStyle(
          fontSize: 0.025 * sh,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
            ),
          ),
          SizedBox(height: 0.02 * sh),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    String email = _emailController.text.trim();
                    String phone = _phoneController.text.trim();
                    String newPassword = generateRandomPassword();

                    // Check if the user exists
                    bool userExists =
                        await checkUserExists(email, phone, newPassword);

                    if (userExists) {
                      bool emailSent = await sendEmail(email, newPassword);
                      if (emailSent) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const ResetMessageDialog(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to send email.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email or phone does not exist.'),
                        ),
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
            child: const Text('Submit'),
          ),
          if (isLoading)
            const CircularProgressIndicator(), // Show CircularProgressIndicator if isLoading is true
        ],
      ),
    );
  }
}
// ENDS  HERE -----------------------------------------------

// RESET PASSWORD DIALOG START HERE  ------------------------------------------
class ResetMessageDialog extends StatelessWidget {
  const ResetMessageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: const Text(
          'Password reset instructions sent to your email. Please check inbox.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
// ENDS HERE  --------------------------------------------------

// GENERATING RANDOM PASSWORD START HERE  --------------------------------------
String generateRandomPassword() {
  const int minLength = 8;
  const String allowedChars = '0123456789';
  final Random random = Random.secure();
  String newPassword = '';

  for (int i = 0; i < minLength; i++) {
    newPassword += allowedChars[random.nextInt(allowedChars.length)];
  }

  return newPassword;
}
// ENDS HERE  ----------------------------------------------------------------

// SENDING EMAIL FUNCTIONALITY START HERE
Future<bool> sendEmail(String email, String appPassword) async {
  try {
    String username =
        'infomobilebloodbanknepal@gmail.com'; // Your Gmail address
    String password = 'hwqw awib ikys faiv'; // Your Gmail password

    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    //   final smtpServer = gmailSaslXoauth2(username, Password);  // if u use this mail doesnot work
    final message = Message()
      ..from = Address(username, 'Mobile Blood Bank Nepal')
      ..recipients.add(email) // Recipient's email address
      ..subject = 'Password Reset'
      ..text =
          'Please do not share this password. The new password is $appPassword ';

    await send(message, smtpServer);
    return true; // Return true if email was sent successfully
  } catch (e) {
    // Add more detailed error handling/logging here if needed
    return false; // Return false if there was an error sending the email
  }
}

// ENDS HERE   ----------------------------------------------------------------
