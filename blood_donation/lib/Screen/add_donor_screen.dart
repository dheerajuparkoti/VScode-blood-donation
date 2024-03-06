import 'dart:convert';
import 'package:blood_donation/Screen/profile_screen.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:provider/provider.dart';

class AddNewDonor extends StatefulWidget {
  const AddNewDonor({Key? key}) : super(key: key);

  @override
  State<AddNewDonor> createState() => _AddNewDonorState();
}

class _AddNewDonorState extends State<AddNewDonor>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final UserProvider userProvider; // Declare userProvider
  bool isLoading = false;
  bool phoneNumberError = false;
  bool dobError = false;
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

//DATE TIME PICKER STARTS HERE
  DateTime selectedDate = DateTime.now();
  final TextEditingController dobController = TextEditingController();

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
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    // Fetch matched results when the widget is created
  }

//ADDING NEW DONOR BY ADMINS START HERE
  regDonor() async {
    var data = {
      'email': emailController.text.trim(),
      'fullName': fullnameController.text.trim(),
      'dob': dobController.text.trim(),
      'gender': selectedGender,
      'bloodGroup': selectedBloodGroup,
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text.trim(),
      'phone': phoneController.text.trim(),
      'userId': userProvider.userId,
    };

    var response = await CallApi().postData(data, 'regDonor');
    // Handle the response
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showSuccess(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Donor registered successfully',
        icon: Icons.check_circle,
      );
      resetDropdowns();
    } else if (response.statusCode == 400) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
        // ignore: use_build_context_synchronously
        context: context,
        message:
            'Registration failed. You are member, only Admin are allow to register new donor.',
        icon: Icons.error,
      );
    } else if (response.statusCode == 400) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Registration failed. User not found',
        icon: Icons.error,
      );
    } else {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Registration Failed, phone number or email already in use',
        icon: Icons.error,
      );
    }
  }
//ENDS HERE

//FETCH DONOR DATA REGISTERED THROUGH ADMINS
  List<dynamic> donorData = [];

  void fetchResults() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'id': userProvider.userId,
    };
    var res = await CallApi().addedMembers(data, 'adminAddedDonors');
    if (res.statusCode == 200) {
      setState(() {
        donorData = json.decode(res.body);
        isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Internal Server Error: Something went wrong',
        icon: Icons.error,
      );
      isLoading = false;
    }
  }

//ENDS HERE

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
  }

  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 0) {
      resetDropdowns();
    } else if (_tabController.index == 1) {
      fetchResults();
    }
  }

  resetDropdowns() {
    setState(() {
      fullnameController.clear();
      dobController.clear();
      wardNoController.clear();
      phoneController.clear();
      emailController.clear();
      usernameController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      selectedGender = null;
      selectedBloodGroup = null;
      selectedProvince = null;
      selectedDistrict = null;
      selectedLocalLevel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                          "Add Donor",
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "My Donors",
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
                        //Code for Add Donor i.e 1st tab
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
                                      '[Note: Only Admins are allow to fill the new donor form. The donor must use this details to register in our app.]',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFF44336),
                                        fontSize: 0.02 * sh,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),

                                    SizedBox(height: 0.005 * sh),
                                    TextField(
                                      //controller: _textControllers['fullName'],
                                      controller: fullnameController,
                                      decoration: const InputDecoration(
                                        hintText: "*Full Name",
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
                                      ),
                                      maxLength: 30,
                                    ),
                                    SizedBox(height: 0.005 * sh),

                                    TextField(
                                      //controller: _dateController,
                                      controller: dobController,
                                      readOnly: true,
                                      onTap: () => _selectDate(context),
                                      decoration: InputDecoration(
                                        hintText: "*Date of Birth (yyyy/mm/dd)",
                                        errorText: dobError
                                            ? 'Age must be between 16-60 to donate blood'
                                            : null,
                                        hintStyle: const TextStyle(
                                            color: Color(0xffaba7a7)),
                                        suffixIcon: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child:
                                              const Icon(Icons.calendar_today),
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
                                        hintText: '*Select Gender',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
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
                                          // Reset selected values for subsequent dropdowns
                                        });
                                      },
                                    ),
                                    SizedBox(height: 0.03 * sh),

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
                                        hintText: '*Select blood Group',
                                        border: InputBorder.none,
                                        hintStyle:
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

                                    SizedBox(height: 0.03 * sh),

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
                                        hintText: '*Select Province',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
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
                                    SizedBox(height: 0.03 * sh),

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
                                        hintText: '*Select District',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
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
                                    SizedBox(height: 0.03 * sh),

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
                                        hintText: '*Select Local Level',
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
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
                                    SizedBox(height: 0.03 * sh),

                                    TextField(
                                      //controller: _textControllers['wardNo'],
                                      controller: wardNoController,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        hintText: "*Ward No.",
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
                                      ),
                                      maxLength: 2,
                                    ),

                                    TextField(
                                        // controller:_textControllers['phoneNumber'],
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: "*Phone Number",
                                          errorText: phoneNumberError
                                              ? 'Phone number must be 10 digits'
                                              : null,
                                          hintStyle: const TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        maxLength: 10,
                                        onChanged: (value) {
                                          setState(() {
                                            // Check if the length of phone number is not 10
                                            phoneNumberError =
                                                value.length != 10;
                                          });
                                        }),
                                    TextField(
                                      // controller: _textControllers['email'],
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: "E-mail",
                                        hintStyle:
                                            TextStyle(color: Color(0xffaba7a7)),
                                      ),
                                      maxLength: 30,
                                    ),
                                    // making add donor button
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
                                            "Add Donor",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
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
                        //End of Add Donor 1st Tab

                        //code for My Donors i.e 2nd tab

                        //HEADER
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.01 * sh),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 0.03 * sw,
                                        bottom: 0,
                                        top: 0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'My Added Donors : ${donorData.length}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 0.02 * sh,
                                          ),
                                        ),
                                      )),
                                  // circular progress bar
                                  if (isLoading)
                                    Center(
                                      child: CircularProgressIndicator(
                                        valueColor: const AlwaysStoppedAnimation<
                                                Color>(
                                            Colors
                                                .red), // Color of the progress indicator
                                        strokeWidth: 0.01 *
                                            sw, // Thickness of the progress indicator
                                        backgroundColor: Colors.black.withOpacity(
                                            0.5), // Background color of the progress indicator
                                      ),
                                    ),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: donorData.length,
                                      itemBuilder: (context, index) {
                                        var result = donorData[index];

                                        // Check if 'profilePic' is a valid URL
                                        final String profilePicUrl =
                                            result['profilePic'];
                                        final bool isValidUrl =
                                            Uri.tryParse(profilePicUrl)
                                                    ?.isAbsolute ??
                                                false;
                                        return InkWell(
                                          onTap: () {
                                            // Navigate to the new screen here
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Profile(
                                                    donorId: result[
                                                        'donorId']), //passing user id to profile screen
                                              ),
                                            );
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                            ),
                                            elevation: 0.0,
                                            child: Stack(
                                              children: <Widget>[
                                                // for underline
                                                Container(
                                                  height: 0.001 *
                                                      sh, // Height of the underline
                                                  color: Colors.green,
                                                  //width:300.0, // Adjust the width accordingly
                                                ),

                                                Padding(
                                                  padding:
                                                      EdgeInsets.all(0.03 * sw),
                                                  child: Row(children: [
                                                    CircleAvatar(
                                                      radius: 0.05 * sw,
                                                      backgroundImage: isValidUrl
                                                          ? NetworkImage(
                                                              profilePicUrl)
                                                          : null, // Set to null if 'profilePicUrl' is not a valid URL
                                                      child: isValidUrl
                                                          ? null // Don't show a child widget if 'profilePicUrl' is a valid URL
                                                          : const Icon(Icons
                                                              .person), // Show an icon if 'profilePicUrl' is not a valid URL
                                                    ),
                                                    SizedBox(
                                                      width: 0.05 * sw,
                                                    ),
                                                    // Text('Name: ${result['fullname']}'),
                                                    Text(result['fullname']),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                ]),
                          ),
                        ),

                        //end of My Donors i.e 2nd tab
                      ]),
                ),
              ]),
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
        phoneNumberError == false &&
        dobError == false &&
        selectedGender != null &&
        selectedBloodGroup != null &&
        selectedProvince != null &&
        selectedDistrict != null &&
        selectedLocalLevel != null &&
        wardNoController.text.trim() != '' &&
        phoneController.text.trim() != '') {
      if (numericRegex.hasMatch(phoneController.text.trim())) {
        regDonor();
        isLoading = false;
      } else {
        CustomSnackBar.showUnsuccess(
            context: context,
            message: "Contact number should contain only numbers.",
            icon: Icons.info);
      }
      isLoading = false;
    } else {
      CustomSnackBar.showUnsuccess(
          context: context,
          message: "Please fill all fields correctly indicated as *.",
          icon: Icons.info);
    }
    isLoading = false;
  }
}
