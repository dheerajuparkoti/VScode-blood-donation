// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final int
      passedDonorId; // receiving donorid of selected user from profile screen
  const EditProfile({Key? key, required this.passedDonorId}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final UserProvider userProvider; // Declare userProvider
  bool isLoading = false;
  String profilePic = '';

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController wardNoController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController signInUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
        dobController.text = "${picked.year}/${picked.month}/${picked.day}";
        donatedDateController.text =
            "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 0) {
      donatedDateController.clear();
      donatedToController.clear();
      contactController.clear();
      bloodPintController.clear();
      dobController.clear();
    } else if (_tabController.index == 1) {
      fetchDonorData();
    }
  }

  void _resetDropdowns() {
    setState(() {
      donatedDateController.clear();
      donatedToController.clear();
      contactController.clear();
      bloodPintController.clear();
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
      'bloodPint': bloodPintController.text.trim(),
      'contact': contactController.text.trim(),
    };

    var response =
        await CallApi().retrieveDonationHistory(data, 'DonationHistory');

    // Check if the request was successful
    // Call the API to register the user

    if (response.statusCode == 200) {
      //  var responseData = json.decode(response.body);
      //  print('Added successfully: ${responseData['message']}');
      // ignore: use_build_context_synchronously
      CustomSnackBar.showSuccess(
        context: context,
        message: "New donation record has been added successfully",
        icon: Icons.check_circle,
      );

      _resetDropdowns();
    } else if (response.statusCode == 403) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
        context: context,
        message: "You cannot donate blood within 75 days of your last donation",
        icon: Icons.error,
      );
    } else {
      // ignore: use_build_context_synchronously
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
      // ignore: use_build_context_synchronously
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
          await CallApi().uploadPhoto(data, 'UpdateDonorProfile', _image!);

      // Handle the response
      if (response.statusCode == 200) {
        // Image uploaded successfully

        // Handle response as needed
      } else {
        // Image upload failed

        // Handle response as needed
      }
    } else {
      // If no image is selected, send only the other data
      var response = await CallApi().postData(data, 'UpdateDonorProfile');

      // Check if the request was successful
      // Call the API to register the user

      // Handle the response
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        CustomSnackBar.showSuccess(
          context: context,
          message: "New donation record has been added successfully",
          icon: Icons.check_circle,
        );
        fetchDonorData();
      } else {
        // ignore: use_build_context_synchronously
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
      } else {
        // print('No image selected.');
      }
    });
  }

  // end of profile picture

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isValidUrl = Uri.tryParse(profilePic)?.isAbsolute ?? false;
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
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(
        children: <Widget>[
          Container(
            height: 300.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF00808),
                  Color(0xffBF371A),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150.0),
                bottomRight: Radius.circular(200.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                  bottomLeft: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0),
                ),
              ),
              child: Column(children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(170, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                      // bottomLeft: Radius.circular(35.0),
                      // bottomRight: Radius.circular(35.0),
                    ),
                  ),

                  // Set to transparent
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),

                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                          padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 0, bottom: 0,
                            //horizontal: 30,
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF444242),
                                      borderRadius: BorderRadius.only(),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Blood Donation Data',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),

                              const SizedBox(height: 5.0),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Fill the donation details form.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),

                              TextField(
                                controller: donatedDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  hintText: "Donated Date (yyyy/mm/dd)",
                                  hintStyle:
                                      const TextStyle(color: Color(0xffaba7a7)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20.0),
                              TextField(
                                controller: donatedToController,
                                decoration: const InputDecoration(
                                  hintText: "Donated To",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 50,
                              ),
                              const SizedBox(height: 5.0),
                              TextField(
                                controller: bloodPintController,
                                decoration: const InputDecoration(
                                  hintText: "Blood Pint",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 2,
                                keyboardType: TextInputType.phone,
                              ),
                              TextField(
                                controller: contactController,
                                decoration: const InputDecoration(
                                  hintText: "Contact",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 5.0),

                              // Making Add button
                              const SizedBox(height: 30.0),
                              Container(
                                height: 40,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color(0xffFF0025),
                                ),
                                //calling insert function when button is pressed
                                child: InkWell(
                                  onTap: () {
                                    addDonationRecord();
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Click here to add",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                            ],
                          )),
                        ),
                      ),

                      //end of added donation history

                      //Code for Update your profile
                      SingleChildScrollView(
                        child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 5.0),
                                  Text(
                                    headerNote,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF44336),
                                      fontSize: 16,
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
                                          CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Colors.grey,
                                            // backgroundImage: profilePic != null ? NetworkImage(profilePic) : AssetImage('assets/default_avatar.png'),
                                            // backgroundImage: _image != null ? FileImage(_image!) : null,
                                            backgroundImage: _image != null
                                                ? FileImage(_image!)
                                                : null,
                                            child: _image == null
                                                ? const Icon(
                                                    Icons.person,
                                                    size: 75,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),

                                          // Use profilePic as String in CircleAvatar widget
                                          /*
                                          CircleAvatar(
                                            radius: 100.0,

                                            backgroundImage: isValidUrl
                                                ? NetworkImage(
                                                    'profile_pictures/GiIq7WbVkwroxX71c6EK0w2ywUmNHqm09unwmg4R.jpg')
                                                : null, // Set to null if 'profilePicUrl' is not a valid URL
                                            child: isValidUrl
                                                ? null // Don't show a child widget if 'profilePicUrl' is a valid URL
                                                : const Icon(
                                                    Icons.person,
                                                    color: Colors.red,
                                                  ),
                                          ),
                                          */

                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(20),
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

                                  const SizedBox(height: 5.0),
                                  TextField(
                                    controller: fullnameController,
                                    decoration: const InputDecoration(
                                      labelText: "Full Name",
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
                                    ),
                                    maxLength: 30,
                                  ),
                                  const SizedBox(height: 5.0),

                                  TextField(
                                    controller: dobController,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
                                      labelText: "Date of Birth (yyyy/mm/dd)",
                                      labelStyle: const TextStyle(
                                          color: Color(0xffaba7a7)),
                                      suffixIcon: GestureDetector(
                                        onTap: () => _selectDate(context),
                                        child: const Icon(Icons.calendar_today),
                                      ),
                                    ),
                                    maxLength: 30,
                                  ),

                                  //DROPDOWN Gender
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      labelText: 'Select Gender',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
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
                                  const SizedBox(height: 24.0),

                                  //CAN DONATE
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
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

                                  const SizedBox(height: 24),

                                  //DROPDOWN BLOOD GROUP
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      labelText: 'Select blood Group',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
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

                                  const SizedBox(height: 24),

                                  //DROPDOWN PROVINCE
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      labelText: 'Select Province',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
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
                                  const SizedBox(height: 24.0),

                                  // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      labelText: 'Select District',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
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
                                  const SizedBox(height: 24.0),

                                  // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffaba7a7)),
                                      ),
                                      labelText: 'Select Local Level',
                                      border: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
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
                                  const SizedBox(height: 20.0),

                                  TextField(
                                    //controller: _textControllers['wardNo'],
                                    controller: wardNoController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: "Ward No.",
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
                                    ),
                                    maxLength: 2,
                                  ),

                                  TextField(
                                    // controller:_textControllers['phoneNumber'],
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: "Phone Number",
                                      labelStyle:
                                          TextStyle(color: Color(0xffaba7a7)),
                                    ),
                                    maxLength: 10,
                                  ),

                                  // Making SignUp button
                                  const SizedBox(height: 30.0),
                                  Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0xffFF0025),
                                    ),
                                    //calling insert function when button is pressed
                                    child: InkWell(
                                      onTap: () {
                                        updateProfile();
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Update Now",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
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
                strokeWidth: 5.0, // Thickness of the progress indicator
                backgroundColor: Colors.black.withOpacity(
                    0.5), // Background color of the progress indicator
              ),
            ),
        ],
      ),
    );
  }
}
