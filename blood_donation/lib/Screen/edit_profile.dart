// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final int
      passedDonorId; // receiving donorid of selected user from profile screen
  const EditProfile({super.key, required this.passedDonorId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final UserProvider userProvider; // Declare userProvider
  bool isLoading = false;
  bool dobError = false;
  bool phoneNumberError = false;
  String profilePic = '';

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController wardNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController signInUsernameController = TextEditingController();

  String? selectedGender;
  String? selectedBloodGroup;
  String? selectedCanDonate;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;

  // for donation records declaring variable

  TextEditingController donatedToController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController bloodPintController = TextEditingController();
  bool contactNumberError = false;
  bool selectedDateError = false;

//Date Time Picker

  DateTime selectedDate = DateTime.now();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController donatedDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = picked.toString().split(" ")[0];
        donatedDateController.text = picked.toString().split(" ")[0];
        _validSelectedDate(donatedDateController.text);
        _validateDOB(dobController.text);
      });
    }
  }

  bool isValidSelectedDate(String selectedDate) {
    DateTime? selectDate = DateTime.tryParse(selectedDate);
    DateTime currentDate = DateTime.now();

    // Check if DOB is not null and is less than or equal to today's date
    return selectDate != null && selectDate.isBefore(currentDate) ||
        selectDate!.isAtSameMomentAs(currentDate);
  }

  void _validSelectedDate(String selectedDate) {
    setState(() {
      selectedDateError = !isValidSelectedDate(selectedDate);
    });
  }

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      if (_tabController.index == 0) {
        donatedDateController.clear();
        donatedToController.clear();
        contactController.clear();
        bloodPintController.text = "";
        dobController.clear();
      } else if (_tabController.index == 1) {
        fetchDonorData();
      }
    });
  }

  void _resetDropdowns() {
    setState(() {
      donatedDateController.clear();
      donatedToController.clear();
      contactController.clear();
      bloodPintController.text = "";
      dobController.clear();
      fullnameController.clear();
      wardNoController.clear();
      phoneController.clear();
      selectedGender = null;
      selectedBloodGroup = null;
      selectedCanDonate = null;
      selectedProvince = null;
      selectedDistrict = null;
      selectedLocalLevel = null;
    });
  }

// add new donation record
  addDonationRecord() async {
    var data = {
      'userId': userProvider.userId,
      'donorId': widget.passedDonorId,
      'donatedDate': donatedDateController.text.trim(),
      'donatedTo': donatedToController.text.trim(),
      'bloodPint': "1",
      'contact': contactController.text.trim(),
    };

    var response =
        await CallApi().retrieveDonationHistory(data, 'donationHistory');

    // Check if the request was successful
    // Call the API to register the user

    if (response.statusCode == 200) {
      //  var responseData = json.decode(response.body);
      //  print('Added successfully: ${responseData['message']}');
      CustomSnackBar.showSuccess(
        context: context,
        message: "New donation record has been added successfully",
        icon: Icons.check_circle,
      );

      _resetDropdowns();
    } else if (response.statusCode == 403) {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: "You cannot donate blood within 75 days of your last donation",
        icon: Icons.error,
      );
    } else {
      CustomSnackBar.showUnsuccess(
        context: context,
        message: "You cannot update this guest user",
        icon: Icons.error,
      );
    }
  }

// fetching donor profile details
  // Define variables to store donor information
  Map<String, dynamic> data = {};
  // Assuming profilePic is the URL of the profile picture

  // Function to fetch donor data from the backend
  Future<void> fetchDonorData() async {
    var sendData = {
      'donorId': widget.passedDonorId,
    };
    // Call your API to fetch donor data
    // Example:
    var res = await CallApi().fetchDonor(sendData, 'showProfile');
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      final Map<String, dynamic> profileData = jsonResponse['profileData'];

      setState(() {
        data = profileData;
        // Assign fetched data to variables

        // Assign fetched data to controllers
        fullnameController.text = data['fullName'] ?? '';
        dobController.text = data['dob'] ?? '';
        selectedGender = data['gender'] ?? '';
        selectedBloodGroup = data['bloodGroup'] ?? '';
        selectedCanDonate = data['canDonate'] ?? '';
        selectedProvince = data['province']?.toString() ?? '';
        selectedDistrict = data['district'] ?? '';
        selectedLocalLevel = data['localLevel'] ?? '';
        wardNoController.text = data['wardNo']?.toString() ?? '';
        phoneController.text = data['phone']?.toString() ?? '';
        profilePic = data['profilePic'] ?? '';
      });
    } else {
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
    }
  }

  // ending fetching donor data

// try new code for uploading data profilepic too
// Method to update profile including image
  Future<void> updateProfile() async {
    var data = {
      'donorId': widget.passedDonorId,
      'fullName': fullnameController.text.trim(),
      'dob': dobController.text,
      'gender': selectedGender,
      'bloodGroup': selectedBloodGroup,
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text,
      'phone': phoneController.text,
      'canDonate': selectedCanDonate,
      'userId': userProvider.userId,
    };
    // If an image is selected, attach it to the request
    if (_image != null) {
      var response =
          await CallApi().uploadPhoto(data, 'updateDonorProfile', _image!);

      // Handle the response
      if (response.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context: context,
          message: "Donor profile has been updated successfully.",
          icon: Icons.check_circle,
        );
      } else {
        CustomSnackBar.showUnsuccess(
          context: context,
          message: "Image upload failed. please try again later!",
          icon: Icons.info,
        );
      }
    } else {
      // If no image is selected, send only the other data
      var response = await CallApi().postData(data, 'updateDonorProfile');

      // Check if the request was successful
      // Call the API to register the user

      // Handle the response
      if (response.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context: context,
          message: "Donor profile has been updated successfully.",
          icon: Icons.check_circle,
        );
        fetchDonorData();
      } else {
        CustomDialog.showAlertDialog(
          context,
          'Server Error',
          'There was an error connecting to the server. Please try again later.',
          Icons.error_outline,
        );
      }
    }
  }
// ending of uploading data

/* // working codes for other data but not for profile pic

// adding new donor api
  updateProfile() async {
    var data = {
      'donorId': widget.passedDonorId,
      'fullName': fullnameController.text.trim(),
      'dob': dobController.text,
      'gender': selectedGender,
      'bloodGroup': selectedBloodGroup,
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text,
      'phone': phoneController.text,
      'userId': userProvider.userId,
    };

    var response = await CallApi().postData(data, 'UpdateDonorProfile');

    // Check if the request was successful
    // Call the API to register the user

    // Handle the response
    if (response.statusCode == 200) {
      // Registration successful
      var responseData = json.decode(response.body);
      print('Registration successful: ${responseData['message']}');
      // Navigate to another screen or show a success message
      _resetDropdowns();
    } else if (response.statusCode == 422) {
      print(" i am 422");
      print(json.decode(response.body));
    } else {
      // Registration failed
      var responseData = json.decode(response.body);
      print('Registration failed: ${responseData['message']}');
      // Show an error message to the user
    }
  }

  */

  // for profile picture
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  // end of profile picture

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //final bool isValidUrl = Uri.tryParse(profilePic)?.isAbsolute ?? false;
    String headerNote = '';
    if (userProvider.accountType == 'Member' &&
        userProvider.donorId == widget.passedDonorId) {
      headerNote = '';
    } else if ((userProvider.accountType == 'Admin' ||
            userProvider.accountType == 'SuperAdmin') &&
        userProvider.donorId != widget.passedDonorId) {
      headerNote =
          '[Note: Only Associated admins are allow to update the donor records.]';
    }
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: const [
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
              horizontal: 0.05 * sw,
              vertical: 0.05 * sh,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.05 * sh),
                  topRight: Radius.circular(0.05 * sh),
                  bottomLeft: Radius.circular(0.05 * sh),
                  bottomRight: Radius.circular(0.05 * sh),
                ),
              ),
              child: Column(children: [
                Container(
                  // Set to transparent
                  padding: EdgeInsets.only(
                      top: 0.02 * sh,
                      bottom: 0.02 * sh,
                      left: 0.02 * sw,
                      right: 0.02 * sw),

                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.03 * sh),
                      color: const Color(0xffFF0025),
                    ),
                    controller: _tabController,
                    //    isScrollable: true, // Make tabs scrollable
                    indicatorSize: TabBarIndicatorSize
                        .tab, // Use indicator size based on tab size
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "Add Donation",
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics:
                        const NeverScrollableScrollPhysics(), // prevenet screen to swipe left or right
                    children: [
                      //code for add donation record  i.e 1st tab
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.05 * sw,
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 0.025 * sh, bottom: 0.025 * sh),
                                child: Container(
                                    height: 0.04 * sh,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF444242),
                                      borderRadius: BorderRadius.only(),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Blood Donation Data',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 0.02 * sh,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),

                              SizedBox(height: 0.005 * sh),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Fill the donation details form.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 0.017 * sh,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.005 * sh),

                              TextField(
                                controller: donatedDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  hintText: "Donated Date (yyyy/mm/dd)",
                                  errorText: selectedDateError
                                      ? 'You cannot set donation date for future'
                                      : null,
                                  hintStyle:
                                      const TextStyle(color: Color(0xff858585)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),

                              SizedBox(height: 0.03 * sh),

                              TextField(
                                controller: donatedToController,
                                decoration: const InputDecoration(
                                  hintText: "Donated To",
                                  hintStyle:
                                      TextStyle(color: Color(0xff858585)),
                                ),
                                maxLength: 30,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                        r'^[a-zA-Z ]+$'), // Regular expression pattern for English alphabets and space
                                  ),
                                ],
                              ),

                              TextField(
                                controller: bloodPintController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: "1 Blood Pint",
                                  hintStyle:
                                      TextStyle(color: Color(0xff858585)),
                                ),
                                maxLength: 1,
                                keyboardType: TextInputType.phone,
                              ),
                              TextField(
                                  controller: contactController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Contact",
                                    hintStyle:
                                        TextStyle(color: Color(0xff858585)),
                                    errorText: contactController.text.isEmpty
                                        ? null
                                        : (contactNumberError
                                            ? 'Contact number must be 10 digits'
                                            : null),
                                    labelStyle:
                                        TextStyle(color: Color(0xff858585)),
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
                                      contactNumberError = value.length != 10;
                                    });
                                  }),
                              SizedBox(height: 0.02 * sh),
                              // Making Add button

                              Container(
                                height: 0.05 * sh,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 0.2 * sw),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0.05 * sh),
                                  color: const Color(0xffFF0025),
                                ),
                                //calling insert function when button is pressed
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (selectedDateError == false &&
                                        contactNumberError == false) {
                                      addDonationRecord();
                                      isLoading = false;
                                    } else {
                                      CustomSnackBar.showUnsuccess(
                                          context: context,
                                          message:
                                              "Please fill all fields correctly.",
                                          icon: Icons.info);
                                      isLoading = false;
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      "Click here to add",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 0.02 * sh),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.03 * sh),
                            ],
                          )),
                        ),
                      ),

                      //end of added donation history

                      //Code for Update your profile
                      SingleChildScrollView(
                        child: Column(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.05 * sw,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 0.005 * sh),
                                  Text(
                                    headerNote,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF44336),
                                      fontSize: 0.015 * sh,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),

                                  // circular avatar
                                  Center(
                                    child: GestureDetector(
                                      onTap: getImage,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if (profilePic.isNotEmpty)
                                            CircleAvatar(
                                              radius: 0.1 * sh,
                                              backgroundImage: NetworkImage(
                                                'https://mobilebloodbanknepal.com/$profilePic',
                                              ),
                                              child: (profilePic == 'NA')
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.red,
                                                      size: 50,
                                                    )
                                                  : null,
                                            ),
                                          if (_image != null)
                                            CircleAvatar(
                                              radius: 0.1 * sh,
                                              backgroundImage:
                                                  FileImage(_image!),
                                            ),

                                          // If both profilePic and _image are empty or null, display a default icon

                                          // Use profilePic as String in CircleAvatar widget

                                          Container(
                                            padding: EdgeInsets.all(0.005 * sh),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      0.05 * sw),
                                            ),
                                            child: const Text(
                                              'Change Profile',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // end of circular avatar

                                  SizedBox(height: 0.005 * sh),
                                  TextField(
                                    controller: fullnameController,
                                    decoration: const InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    maxLength: 30,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(
                                            r'^[a-zA-Z ]+$'), // Regular expression pattern for English alphabets and space
                                      ),
                                    ],
                                  ),

                                  TextField(
                                    controller: dobController,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
                                      labelText: "Select Date of Birth",
                                      errorText: dobController.text.isEmpty
                                          ? null
                                          : (dobError
                                              ? 'Age must be between 16-60 to donate blood'
                                              : null),
                                      labelStyle: const TextStyle(
                                          color: Color(0xff858585)),
                                      suffixIcon: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: const Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.03 * sh),

                                  //DROPDOWN Gender
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
                                      labelText: 'Select Gender',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    value: selectedGender,
                                    items: ['Male', 'Female', 'Others']
                                        .map((gender) {
                                      return DropdownMenuItem<String>(
                                        value: gender,
                                        child: Text(gender),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value;
                                        // Reset selected values for subsequent dropdowns
                                      });
                                    },
                                  ),
                                  SizedBox(height: 0.03 * sh),

                                  //CAN DONATE
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
                                      labelText:
                                          'Are you able to donate blood ?',
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(color: Colors.red),
                                    ),
                                    value: selectedCanDonate,
                                    items: [
                                      'Yes',
                                      'No',
                                    ].map((canDonate) {
                                      return DropdownMenuItem<String>(
                                        value: canDonate,
                                        child: Text(
                                          canDonate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCanDonate = value;
                                      });
                                    },
                                  ),

                                  SizedBox(height: 0.03 * sh),

                                  //DROPDOWN BLOOD GROUP
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
                                      labelText: 'Select blood Group',
                                      border: InputBorder.none,
                                      labelStyle:
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
                                        child: Text('Blood Group $bloodGroup'),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBloodGroup = value;
                                      });
                                    },
                                  ),

                                  SizedBox(height: 0.03 * sh),

                                  //DROPDOWN PROVINCE
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
                                      labelText: 'Select Province',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    value: selectedProvince,
                                    items: ['1', '2', '3', '4', '5', '6', '7']
                                        .map((province) {
                                      return DropdownMenuItem<String>(
                                        value: province,
                                        child: Text('Province $province'),
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
                                  SizedBox(height: 0.03 * sh),

                                  // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
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
                                      labelText: 'Select District',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    value: selectedDistrict,
                                    items: selectedProvince != null
                                        ? DistrictData
                                            .districtList[selectedProvince!]!
                                            .map((district) {
                                            return DropdownMenuItem<String>(
                                              value: district,
                                              child: Text(district),
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
                                  SizedBox(height: 0.03 * sh),
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
                                      labelText: 'Select Local Level',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    value: selectedLocalLevel,
                                    items: selectedDistrict != null
                                        ? DistrictData
                                            .localLevelList[selectedDistrict!]!
                                            .map((locallevel) {
                                            return DropdownMenuItem<String>(
                                              value: locallevel,
                                              child: Text(locallevel),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLocalLevel = value;
                                      });
                                    },
                                  ),

                                  TextField(
                                    //controller: _textControllers['wardNo'],
                                    controller: wardNoController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Ward No.",
                                      errorText: (wardNoController
                                                  .text.isNotEmpty &&
                                              int.tryParse(
                                                      wardNoController.text)! >
                                                  33)
                                          ? 'Ward number cannot be greater than 33'
                                          : null,
                                      labelStyle:
                                          TextStyle(color: Color(0xff858585)),
                                    ),
                                    maxLength: 2,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Allow only digits
                                    ],
                                  ),

                                  TextField(
                                      // controller:_textControllers['phoneNumber'],
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: "Phone Number",
                                        errorText: phoneController.text.isEmpty
                                            ? null
                                            : (phoneNumberError
                                                ? 'Phone number must be 10 digits'
                                                : null),
                                        labelStyle:
                                            TextStyle(color: Color(0xff858585)),
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
                                      }),

                                  // Making SignUp button
                                  SizedBox(height: 0.02 * sh),
                                  Container(
                                    height: 0.05 * sh,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0.2 * sw),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(0.05 * sh),
                                      color: const Color(0xffFF0025),
                                    ),
                                    //calling insert function when button is pressed
                                    child: InkWell(
                                      onTap: () {
                                        validationFields();
                                      },
                                      child: Center(
                                        child: Text(
                                          "Update Now",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 0.02 * sh),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.03 * sh),
                                ],
                              )),
                        ]),
                      ),
                      //End of Updating profile
                    ],
                  ),
                ),
              ]),
            ),
          ),

          // circular progress bar
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.red), // Color of the progress indicator
                strokeWidth: 0.01 * sw, // Thickness of the progress indicator
                backgroundColor: Colors.black.withOpacity(
                    0.5), // Background color of the progress indicator
              ),
            ),
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
        wardNoController.text.trim() != '0' &&
        ((wardNoController.text.isNotEmpty &&
            int.tryParse(wardNoController.text)! <= 33)) &&
        phoneController.text.trim() != '' &&
        phoneNumberError == false &&
        dobError == false) {
      if (numericRegex.hasMatch(phoneController.text.trim())) {
        updateProfile();
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
}
