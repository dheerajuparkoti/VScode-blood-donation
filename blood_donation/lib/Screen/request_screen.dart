// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:blood_donation/Screen/available_list.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/api/api.dart';

// for donor_id
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/user_provider.dart';

class RequestScreen extends StatefulWidget {
  final int notificationReId;
  const RequestScreen({Key? key, required this.notificationReId})
      : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  bool isLoading = false; // for circular progress bar

//Patient Details Declaration
  TextEditingController fullNameController = TextEditingController();
  String? selectedBloodGroup;
  TextEditingController requiredPintController = TextEditingController();
  TextEditingController caseDetailController = TextEditingController();
  TextEditingController contactPersonNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

//Hospital Details Declaration

  TextEditingController hospitalNameController = TextEditingController();
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;
  TextEditingController wardNoController = TextEditingController();

  bool isEmergency = false; // Default value is false

  late UserProvider userProvider; // Declare userProvider
  //UserProvider? userProvider; // Declare userProvider as nullable

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);

    if (widget.notificationReId != 0) {
      _tabController = TabController(initialIndex: 2, length: 3, vsync: this);
    }
    _tabController.addListener(_handleTabChange);
    requiredTime = TimeOfDay.now();
    loadOtherRequests();
    loadMyRequests();
  }

  TimeOfDay? requiredTime;
  TextEditingController requiredTimeController = TextEditingController();
  late String sqlFriendlyTime = '';
  // Function to convert TimeOfDay to SQL-friendly time format
  String formatTimeForSQL(TimeOfDay timeOfDay) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final String formattedTime = DateFormat.Hms().format(dateTime);
    return formattedTime;
  }

  // while retrieving time from database convert it to AM/PM and 12 hour format

  String _formatTimeFromDatabase(String timeString) {
    TimeOfDay timeOfDay = _convertTimeStringToTimeOfDay(timeString);

    // Format time to 12-hour format with AM/PM
    return DateFormat('h:mm a').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute,
    ));
  }

  TimeOfDay _convertTimeStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
  // completed converting

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: requiredTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        requiredTime = picked;
        requiredTimeController.text = picked.format(context);
        requiredTime = picked;
        requiredTimeController.text = DateFormat('h:mm a').format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        ));

        // Convert and set the SQL-friendly time format to the backend field if needed
        sqlFriendlyTime = formatTimeForSQL(picked);
        // Now you can use sqlFriendlyTime in your data or API calls
      });
    }
  }

  // Submitting Blood Request form
  requestBloodForm() async {
    if (requiredTime == null) {
      // If requiredTime is null, call _selectTime to choose a time
      await _selectTime(context);
    }

    var data = {
      'fullName': fullNameController.text.trim(),
      'bloodGroup': selectedBloodGroup,
      'requiredPint': requiredPintController.text.trim(),
      'caseDetail': caseDetailController.text.trim(),
      'contactPersonName': contactPersonNameController.text.trim(),
      'contactNo': contactNoController.text.trim(),
      'requiredDate': requiredDateController.text.trim(),
      'requiredTime': sqlFriendlyTime.trim(),
      'hospitalName': hospitalNameController.text.trim(),
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text.trim(),
      'doId': userProvider.donorId,
    };

    var res = await CallApi()
        .requestBlood(data, 'RequestBlood'); //test is table name for api

    // Check if the response is not null
    if (res != null) {
      //var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context: context,
          message: "Your request for blood is sent successfully to others",
          icon: Icons.check_circle,
        );
        _tabController.animateTo(1);
      } else {
        CustomSnackBar.showUnsuccess(
          context: context,
          message: 'Internal Server Error: Something went wrong',
          icon: Icons.error,
        );
      }
    }
  }

// Submitting Emergency Blood Request form
  emergencyRequestBloodForm() async {
    if (requiredTime == null) {
      // If requiredTime is null, call _selectTime to choose a time
      await _selectTime(context);
    }

    var data = {
      'fullName': fullNameController.text.trim(),
      'bloodGroup': selectedBloodGroup,
      'requiredPint': requiredPintController.text.trim(),
      'caseDetail': caseDetailController.text.trim(),
      'contactPersonName': contactPersonNameController.text.trim(),
      'contactNo': contactNoController.text.trim(),
      'requiredDate': requiredDateController.text.trim(),
      'requiredTime': sqlFriendlyTime.trim(),
      'hospitalName': hospitalNameController.text.trim(),
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text.trim(),
      'doId': userProvider.donorId,
    };

    var res = await CallApi().emergencyRequestBlood(
        data, 'EmergencyRequestBlood'); //test is table name for api

    // Check if the response is not null
    if (res != null) {
      if (res.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context: context,
          message:
              "Your emergency request for blood is sent successfully to others",
          icon: Icons.check_circle,
        );

        _tabController.animateTo(1);
      } else {
        CustomSnackBar.showUnsuccess(
          context: context,
          message: 'Internal Server Error: Something went wrong',
          icon: Icons.error,
        );
      }
    }
  }

//loading My Request from both table request_blood and emergency_request_blood
  String labelReqType = '# Request : 0';

  List<dynamic> loadingAllMyRequests = [];

  loadMyRequests() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    var data = {
      'doId': userProvider.donorId,
    };

    var res = await CallApi().loadAllMyRequests(data, 'LoadMyRequests');

    if (res.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        setState(() {
          loadingAllMyRequests = [
            ...jsonResponse['requestBloods']
                    .map((item) => {...item, 'source': 'requestBloods'}) ??
                [],
            ...jsonResponse['emergencyRequestBloods'].map(
                    (item) => {...item, 'source': 'emergencyRequestBloods'}) ??
                [],
          ];
          isLoading = false;
        });
      } catch (e) {
        CustomDialog.showAlertDialog(
          context,
          'Server Error',
          'There was an error connecting to the server. Please try again later.',
          Icons.error_outline,
        );
        isLoading = false;
      }
    } else {
      // Handle different status codes appropriately
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      //print('API request failed with status code: ${res.statusCode}');
      isLoading = false;
    }
  }

  // completing loading myrequests

  //load Other Requests

  List<dynamic> loadingOtherRequests = [];
  Map<int, int> donorCounts = {};

  loadOtherRequests() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    var data = {
      'doId': userProvider.donorId,
    };

    var res = await CallApi().loadAllMyRequests(data, 'LoadOtherRequests');

    if (res.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        // Use null-aware operator to handle the case where the key is not present or is null
        final List<dynamic> otherRequests = jsonResponse['otherRequestBloods'];

        setState(() {
          if (mounted) {
            loadingOtherRequests = otherRequests;
            //donorCounts = Map<int, int>.from(jsonResponse['donorCounts']);
            donorCounts = _parseDonorCounts(jsonResponse['donorCounts']);
            isLoading = false;
          }
        });
      } catch (e) {
        CustomDialog.showAlertDialog(
          context,
          'Server Error',
          'There was an error connecting to the server. Please try again later.',
          Icons.error_outline,
        );
        isLoading = false;
      }
    } else {
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      // Handle different status codes appropriately
      // print('API request failed with status code: ${res.statusCode}');
      isLoading = false;
    }
  }

  Map<int, int> _parseDonorCounts(dynamic donorCountsJson) {
    Map<int, int> parsedDonorCounts = {};
    if (donorCountsJson is Map) {
      donorCountsJson.forEach((key, value) {
        parsedDonorCounts[int.tryParse(key) ?? 0] = value;
      });
    }
    return parsedDonorCounts;
  }

  // end of other Requests

  // Sending data to emergency_request_available_donors when Im available button clicked

  rAvailableDonors(int reqId) async {
    // if (userProvider != null) {
    var data = {
      'rAvailableId': reqId,
      // 'donorAvailableId': userProvider!.donorId,
      'donorAvailableId': userProvider.donorId,
    };

    var res = await CallApi().erDonors(data,
        'rAvailableDonors'); //this is method name defined in controller and api.php route

    // Check if the response is not null
    if (res != null) {
      var body = jsonDecode(res.body);
      // print('Response body: $body'); // Print the response body for debugging

      // Check if 'success' key exists and is not null
      if (body.containsKey('success') && body['success'] != null) {
        // Check if 'success' is a boolean
        if (body['success'] is bool && body['success']) {
          // print('Request successful!'); // Request was successful
        } else {
          // Handle the case where 'success' is not true
          //print('Request failed: ${body['message']}'); // Print error message
        }
      } else {
        // Handle the case where 'success' key is missing or null
        // print('Invalid response format: Missing or null "success" key.');
      }
    } else {
      // Handle the case where the response is null
      // print('Null response received.');
    }
    // }
  }

  @override
  bool get wantKeepAlive => true;

//Date Time Picker

  DateTime selectedDate = DateTime.now();
  final TextEditingController requiredDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        requiredDateController.text =
            "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

// Function to make a phone call
  makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch(phoneNumber)) {
      // ignore: deprecated_member_use
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to share content
  void shareContent(String content) {
    Share.share(content);
  }

  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 1) {
      fullNameController.clear();
      _resetDropdowns();
      requiredPintController.clear();
      caseDetailController.clear();
      contactPersonNameController.clear();
      contactNoController.clear();
      requiredDateController.clear();
      requiredTimeController.clear();
      hospitalNameController.clear();
      wardNoController.clear();
      isEmergency = false;
      loadMyRequests();
    } else {
      loadOtherRequests();
    }
  }

  void _resetDropdowns() {
    setState(() {
      selectedBloodGroup = null;
      selectedProvince = null;
      selectedDistrict = null;
      selectedLocalLevel = null;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

// delete myRequest
// Function to delete request
  Future<void> deleteRequest(int requestId) async {
    var data = {
      'requestId': requestId,
    };

    var res = await CallApi().delRequest(data, 'deleteRequest');

    if (res.statusCode == 200) {
      CustomSnackBar.showSuccess(
        context: context,
        message: "Your request has been deleted successfully",
        icon: Icons.check_circle,
      );
      loadMyRequests();
    } else {
      CustomSnackBar.showUnsuccess(
        context: context,
        message:
            "Request has not been deleted successfully. please try again later.",
        icon: Icons.error,
      );
    }
  }

// delete myRequest
// Function to delete request
  Future<void> deleteERequest(int eRequestId) async {
    var data = {
      'emergencyRequestId': eRequestId,
    };

    var res = await CallApi().delERequest(data, 'deleteEmergencyRequest');

    if (res.statusCode == 200) {
      CustomSnackBar.showSuccess(
        context: context,
        message: "Your emergency request has been deleted successfully",
        icon: Icons.check_circle,
      );
      loadMyRequests();
    } else {
      CustomSnackBar.showUnsuccess(
        context: context,
        message:
            "Request has not been deleted successfully. please try again later.",
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    super.build(context); // to maintain state between two tabs

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(
        children: <Widget>[
          Container(
            height: 155 * asr,
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
                bottomLeft: Radius.circular(77.5 * asr),
                bottomRight: Radius.circular(103.3 * asr),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.33 * asr,
              vertical: 10.33 * asr,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.1 * asr),
                  topRight: Radius.circular(18.1 * asr),
                  bottomLeft: Radius.circular(18.1 * asr),
                  bottomRight: Radius.circular(18.1 * asr),
                ),
              ),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(170, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.1 * asr),
                      topRight: Radius.circular(18.1 * asr),
                      // bottomLeft: Radius.circular(18.1*asr),
                      // bottomRight: Radius.circular(18.1*asr),
                    ),
                  ),

                  // Set to transparent
                  padding: EdgeInsets.only(top: 5.1 * asr, bottom: 5.1 * asr),

                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.75 * asr),
                      color: const Color(0xffFF0025),
                    ),
                    controller: _tabController,
                    //    isScrollable: true, // Make tabs scrollable
                    indicatorSize: TabBarIndicatorSize
                        .tab, // Use indicator size based on tab size
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "Add New",
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "My Req",
                          style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Other Req",
                          style: TextStyle(
                            color: _tabController.index == 2
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
                      //code for add request i.e 1st tab
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.5 * asr,
                          ),
                          child: Center(
                              child: Column(
                            children: [
                              Text(
                                'Fill the Blood Donation Request Form.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF44336),
                                  fontSize: 8.26 * asr,
                                ),
                              ),

                              SizedBox(height: 2.58 * asr),

                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Patient Details * ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF706969),
                                    fontSize: 7.23 * asr,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.58 * asr),
                              TextField(
                                controller: fullNameController,
                                decoration: const InputDecoration(
                                  hintText: "Full Name",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 30,
                              ),
                              SizedBox(height: 2.58 * asr),

                              //DROPDOWN BLOOD GROUP
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  hintText: 'Select blood Group',
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
                              SizedBox(height: 2.58 * asr),

                              TextField(
                                controller: requiredPintController,
                                decoration: const InputDecoration(
                                  hintText: "Required pint",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 2,
                              ),
                              SizedBox(height: 2.58 * asr),

                              TextField(
                                controller: caseDetailController,
                                decoration: const InputDecoration(
                                  hintText: "Case Detail",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 30,
                              ),
                              SizedBox(height: 2.58 * asr),

                              TextField(
                                controller: contactPersonNameController,
                                decoration: const InputDecoration(
                                  hintText: "Contact Person Name",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 30,
                              ),
                              SizedBox(height: 2.58 * asr),

                              TextField(
                                controller: contactNoController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: "Contact No.",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 10,
                              ),
                              SizedBox(height: 2.58 * asr),

                              TextField(
                                controller: requiredDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  hintText: "Required Date (yyyy/mm/dd)",
                                  hintStyle:
                                      const TextStyle(color: Color(0xffaba7a7)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),

                              SizedBox(height: 2.58 * asr),
                              TextField(
                                controller: requiredTimeController,
                                readOnly: true,
                                onTap: () => _selectTime(context),
                                decoration: InputDecoration(
                                  hintText: "Required Time",
                                  hintStyle:
                                      const TextStyle(color: Color(0xffaba7a7)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectTime(context),
                                    child: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.58 * asr),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Hospital Details * ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF706969),
                                    fontSize: 7.23 * asr,
                                  ),
                                ),
                              ),

                              SizedBox(height: 2.58 * asr),
                              TextField(
                                controller: hospitalNameController,
                                decoration: const InputDecoration(
                                  hintText: "Hospital Name",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 30,
                              ),
                              SizedBox(height: 2.58 * asr),

                              //DROPDOWN PROVINCE
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  hintText: 'Select Province',
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
                              SizedBox(height: 12.24 * asr),

                              // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  hintText: 'Select District',
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
                                                fontWeight: FontWeight.normal),
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
                              SizedBox(height: 12.24 * asr),

                              // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffaba7a7)),
                                  ),
                                  hintText: 'Select Local Level',
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                value: selectedLocalLevel,
                                items: selectedDistrict != null
                                    ? DistrictData
                                        .localLevelList[selectedDistrict!]!
                                        .map((locallevel) {
                                        return DropdownMenuItem<String>(
                                          value: locallevel,
                                          child: Text(
                                            locallevel,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal),
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
                              SizedBox(height: 10.33 * asr),

                              TextField(
                                //controller: _textControllers['wardNo'],
                                controller: wardNoController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: "Ward No.",
                                  hintStyle:
                                      TextStyle(color: Color(0xffaba7a7)),
                                ),
                                maxLength: 2,
                              ),
                              SizedBox(height: 2.58 * asr),

                              CheckboxListTile(
                                title: const Text(
                                  "Is it's an Emergency Request ?",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ), // Label for the checkbox
                                contentPadding: const EdgeInsets.only(
                                    left: 0.0), // Adjust left padding
                                activeColor: Colors
                                    .green, // Change checkbox color when selected
                                checkColor: Colors
                                    .white, // Change color of the check icon
                                value: isEmergency,
                                onChanged: (value) {
                                  setState(() {
                                    isEmergency = value ?? false;
                                  });
                                },
                              ),

                              // Making Request Now Button
                              SizedBox(height: 15.5 * asr),
                              Container(
                                height: 25.75 * asr,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12.9 * asr),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(25.75 * asr),
                                  color: const Color(0xffFF0025),
                                ),
                                //calling insert function when button is pressed
                                child: InkWell(
                                  onTap: () {
                                    validationFields();
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Request Now",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.5 * asr),
                            ],
                          )),
                        ),
                      ),

                      //end of add request i.e 1st tab

                      // code for my Request i.e  2nd tab
                      SingleChildScrollView(
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 5.1 * asr,
                                  bottom: 0,
                                  top: 0,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Total My Requests : ${loadingAllMyRequests.length}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.26 * asr,
                                    ),
                                  ),
                                )),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: loadingAllMyRequests.length,
                                itemBuilder: (context, index) {
                                  final requestData =
                                      loadingAllMyRequests[index];
                                  final source = requestData[
                                      'source']; // for identifying table

                                  // Display donor count based on the source of the request
                                  final allMydonorCount =
                                      requestData['available_donors_count'];

                                  //  int itemCount = index + 1;
                                  if (source == 'requestBloods') {
                                    labelReqType =
                                        "# Request : ${requestData['requestId']}";
                                  } else if (source ==
                                      'emergencyRequestBloods') {
                                    labelReqType =
                                        "# E-Request: ${requestData['emergencyRequestId']}";
                                  }

                                  return SizedBox(
                                    height: 147.9 * asr,
                                    child: Card(
                                      margin: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      elevation: 0.51 * asr,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // First Row Container
                                          Container(
                                            height: 15.5 * asr,
                                            padding: EdgeInsets.all(2.58 * asr),
                                            color: const Color(0xFF444242),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  labelReqType,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'Required Blood : ${requestData['bloodGroup']} ',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Second Row Container

                                          Container(
                                            height: 110 * asr,
                                            padding: EdgeInsets.all(5.1 * asr),
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Patient Name :  ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['fullName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Required Pint : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['requiredPint']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Case Detail : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['caseDetail']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Contact Person : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['contactPersonName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Phone : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['contactNo']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Hospital : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['hospitalName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Address: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${requestData['localLevel']} - ${requestData['wardNo']}, ${requestData['district']},  Pro. ${requestData['province']}',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize:
                                                                  6.2 * asr),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines:
                                                              2, // Adjust this value as needed
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Date & Time : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${requestData['requiredDate']}, ${_formatTimeFromDatabase(requestData['requiredTime'])}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      'Donors Available Up-to-date: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 6.2 * asr),
                                                    ),
                                                    Text(
                                                      '${allMydonorCount ?? 'Loading...'}',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 6.2 * asr),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Third Row Container

                                          Container(
                                            height: 20.4 * asr,
                                            padding: EdgeInsets.all(1.5 * asr),
                                            color: const Color(0xFF8CC653),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // for delete request

                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      CustomDialog
                                                          .showConfirmationDialog(
                                                        context,
                                                        'Delete Confirmation', // Title
                                                        'Are you sure you want to delete this request ?', // Message
                                                        Icons.warning, // Icon
                                                        () {
                                                          // Your action when 'Yes' is pressed
                                                          if (source ==
                                                              'requestBloods') {
                                                            int requestId =
                                                                requestData[
                                                                    'requestId'];
                                                            deleteRequest(
                                                                requestId);
                                                          } else if (source ==
                                                              'emergencyRequestBloods') {
                                                            int emergencyRequestId =
                                                                requestData[
                                                                    'emergencyRequestId'];
                                                            deleteERequest(
                                                                emergencyRequestId);
                                                          }
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      size: 7.23 * asr,
                                                      color: Colors.red,
                                                    ),
                                                    label: Text('Delete',
                                                        style: TextStyle(
                                                          fontSize: 6.2 * asr,
                                                          color: Colors.red,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 1.29 * asr),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons.map,
                                                      size: 7.23 * asr,
                                                      color: Colors.blue,
                                                    ),
                                                    label: Text('Map View',
                                                        style: TextStyle(
                                                          fontSize: 6.2 * asr,
                                                          color: Colors.blue,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 1.29 * asr),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      int passingId = 0;
                                                      String requestType = '';
                                                      if (source ==
                                                          'requestBloods') {
                                                        var requestId =
                                                            requestData[
                                                                'requestId'];
                                                        if (requestId != null) {
                                                          passingId = int.tryParse(
                                                                  requestId
                                                                      .toString()) ??
                                                              0;
                                                          requestType =
                                                              'request';
                                                        }
                                                      } else if (source ==
                                                          'emergencyRequestBloods') {
                                                        var emergencyRequestId =
                                                            requestData[
                                                                'emergencyRequestId'];
                                                        if (emergencyRequestId !=
                                                            null) {
                                                          passingId = int.tryParse(
                                                                  emergencyRequestId
                                                                      .toString()) ??
                                                              0;
                                                          requestType =
                                                              'emergency';
                                                        }
                                                      }

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AvailableListView(
                                                            passedId: passingId,
                                                            requestType:
                                                                requestType,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.list,
                                                      size: 7.23 * asr,
                                                      color: Colors.green,
                                                    ),
                                                    label: Text('List View',
                                                        style: TextStyle(
                                                            fontSize: 6.2 * asr,
                                                            color:
                                                                Colors.green)),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        )
                            //content for my request

                            ),
                      ),
                      // end of my request i.e 2nd tab

                      //code for other request i.e 3rd tab
                      // code for other Request

                      SingleChildScrollView(
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 5.1 * asr,
                                  bottom: 0,
                                  top: 0,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Total Requests : ${loadingOtherRequests.length}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8.26 * asr,
                                    ),
                                  ),
                                )),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: loadingOtherRequests.length,
                                itemBuilder: (context, index) {
                                  final otherRequestData =
                                      loadingOtherRequests[index];
                                  final int requestId =
                                      otherRequestData['requestId'] ?? 0;
                                  final int donorCount =
                                      donorCounts[requestId] ?? 0;
                                  return SizedBox(
                                    height: 150 * asr,
                                    child: Card(
                                      margin: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      elevation: 0.51 * asr,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // First Row Container
                                          Container(
                                            height: 15.5 * asr,
                                            padding: EdgeInsets.all(2.58 * asr),
                                            color: const Color(0xFF444242),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '# Request : ${otherRequestData['requestId']} ',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'Required Blood : ${otherRequestData['bloodGroup']} ',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Second Row Container

                                          Container(
                                            height: 110 * asr,
                                            padding: EdgeInsets.all(5.1 * asr),
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Patient Name : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['fullName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Required Pint : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['requiredPint']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Case Detail : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['caseDetail']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Contact Person : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['contactPersonName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Phone : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['contactNo']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Hospital : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['hospitalName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Address : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${otherRequestData['localLevel']} - ${otherRequestData['wardNo']}, ${otherRequestData['district']},  Pro. ${otherRequestData['province']}',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize:
                                                                  6.2 * asr),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines:
                                                              2, // Adjust this value as needed
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Date & Time : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        '${otherRequestData['requiredDate']}, ${_formatTimeFromDatabase(otherRequestData['requiredTime'])}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Donors Available Up-to-date: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                      Text(
                                                        donorCount.toString(),
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                6.2 * asr),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Third Row Container

                                          Container(
                                            height: 20.4 * asr,
                                            padding: EdgeInsets.all(1.5 * asr),
                                            color: const Color(0xFF8CC653),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      makePhoneCall(
                                                          'tel:+977 ${otherRequestData['contactNo']}');
                                                    },
                                                    icon: Icon(
                                                      Icons.phone,
                                                      size: 7.23 * asr,
                                                      color: Colors.green,
                                                    ),
                                                    label: Text('Call',
                                                        style: TextStyle(
                                                          fontSize: 6.2 * asr,
                                                          color: Colors.green,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 1.29 * asr),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      shareContent(
                                                        '"\tBlood Request Info For" \n'
                                                        'Patient: ${otherRequestData['fullName']}\n'
                                                        'Required Pint: ${otherRequestData['requiredPint']}\n'
                                                        'Case Detail: ${otherRequestData['caseDetail']}\n'
                                                        'Contact Person: ${otherRequestData['contactPersonName']}\n'
                                                        'tel: +977 ${otherRequestData['contactNo']}\n'
                                                        'Hospital: ${otherRequestData['hospitalName']}\n'
                                                        'Address: ${otherRequestData['localLevel']} - ${otherRequestData['wardNo']}, ${otherRequestData['district']},Pro. ${otherRequestData['province']}\n'
                                                        'Date & Time : ${otherRequestData['requiredDate']}, ${_formatTimeFromDatabase(otherRequestData['requiredTime'])}\n'
                                                        'App: Mobile Blood Bank Nepal',
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.share,
                                                      size: 7.23 * asr,
                                                      color: Colors.blue,
                                                    ),
                                                    label: Text('Share',
                                                        style: TextStyle(
                                                          fontSize: 6.2 * asr,
                                                          color: Colors.blue,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 1.29 * asr),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      // Call erAvailableDonors only if userProvider is initialized
                                                      // if (userProvider !=
                                                      //   null) {
                                                      int reqId =
                                                          otherRequestData[
                                                              'requestId'];
                                                      rAvailableDonors(reqId);
                                                      // }
                                                    },
                                                    icon: Icon(
                                                      Icons.waving_hand,
                                                      size: 7.23 * asr,
                                                      color: Colors.red,
                                                    ),
                                                    label: Text("I'm Available",
                                                        style: TextStyle(
                                                          fontSize: 6.2 * asr,
                                                          color: Colors.red,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            height: 2.58 * asr,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        )
                            //content for my request

                            ),
                      ),
                      //end of other request i.e 3rd tab
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
                strokeWidth: 2.58 * asr, // Thickness of the progress indicator
                backgroundColor: Colors.black.withOpacity(
                    0.5), // Background color of the progress indicator
              ),
            ),
        ],
      ),
    );
  }

  void validationFields() {
    if (fullNameController.text.trim() != '' &&
        selectedBloodGroup != null &&
        requiredPintController.text.trim() != '' &&
        caseDetailController.text.trimRight() != '' &&
        contactPersonNameController.text.trim() != '' &&
        contactNoController.text.trim() != '' &&
        requiredDateController.text.trim() != '' &&
        requiredTimeController.text.trim() != '' &&
        hospitalNameController.text.trim() != '' &&
        selectedProvince != null &&
        selectedDistrict != null &&
        selectedDistrict != null &&
        selectedLocalLevel != null &&
        wardNoController.text.trim() != '') {
      CustomDialog.showConfirmationDialog(
          context,
          'Request Confirmation', // Title
          'Are you sure you want to create new request ?', // Message
          Icons.warning, // Icon
          () {
        if (isEmergency == false) {
          requestBloodForm();
        } else {
          emergencyRequestBloodForm();
        }
      });
    } else {
      CustomSnackBar.showUnsuccess(
          context: context,
          message: "Please fill all fields.",
          icon: Icons.info);
    }
  }
}
