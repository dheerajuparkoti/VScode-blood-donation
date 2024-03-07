import 'dart:async';
import 'dart:convert';

import 'package:blood_donation/Screen/emergency_request_screen.dart';
import 'package:blood_donation/Screen/request_screen.dart';
import 'package:blood_donation/Screen/search_blood.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/data/internet_connectivity.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:blood_donation/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> bloodGroupCounts = {};
  int totalDonors = 0;

  late Timer _timer; // Declare _timer here
  late Timer _timer1; // Declare _timer here

  @override
  void initState() {
    super.initState();
    fetchDonorCounts();
    topDonorList();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => fetchDonorCounts());
    _timer1 = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => topDonorList());
  }

  bool stopDisplayDialog = false;

// DONOR COUNTS TO SHOW IN MAIN SCREEN STARTS HERE
  fetchDonorCounts() async {
    // bool isConnected = await ConnectivityUtil.isInternetConnected();
    // if (isConnected) {
    final res = await CallApi().countDonors({}, 'donorCountsByBloodGroup');
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      if (mounted) {
        setState(() {
          stopDisplayDialog == false;
          totalDonors = jsonResponse['totalDonors'];
          bloodGroupCounts =
              Map<String, int>.from(jsonResponse['bloodGroupCounts']);
        });
      }
      // } else {
      // throw Exception(
      //   'Failed to load donor counts. Status code: ${res.statusCode}');
      //}
      // } else {
      /*
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      */
      //ignore: use_build_context_synchronously
      //CustomSnackBar.showUnsuccess(
      //  context: context,
      //message:
      //  'Network Error, There was an error connecting to the server. Please check your internet connection.',
      //icon: Icons.error_outline);
    }
  }

  // ENDS HERE

  List<Map<String, dynamic>> topDonors = [];

// TOP 3 DONOR LIST TO SHOW IN MAIN SCREEN STARTS HERE
  topDonorList() async {
    bool isConnected = await ConnectivityUtil.isInternetConnected();
    if (isConnected) {
      final res = await CallApi().topDonors({}, 'getTopDonors');
      if (res.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(res.body);
        if (mounted) {
          setState(() {
            topDonors = jsonResponse.cast<Map<String, dynamic>>();
          });
        }
      } else {
        throw Exception(
            'Failed to load donor lists. Status code: ${res.statusCode}');
      }
    } else {
      /*
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      */
      // ignore: use_build_context_synchronously
      CustomSnackBar.showUnsuccess(
          context: context,
          message: 'Network Error, Please check your internet connection.',
          icon: Icons.error_outline);
    }
  }

  // ENDS HERE

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed of
    _timer.cancel();
    _timer1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF592424),
      drawer: NavigationDrawerScreen(),
      appBar: AppBar(
        title: Text(
          'Welcome To',
          style: TextStyle(
            fontSize: 0.025 * sh,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF592424),
      ),
      body: Padding(
        padding: EdgeInsets.all(0.005 * sh),
        child: Stack(
          children: <Widget>[
            // background Color
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 125, 27, 27),
                    Color.fromARGB(255, 198, 84, 59),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0.05 * sh),
                  topLeft: Radius.circular(0.05 * sh),
                ),
              ),
            ),

            //EMERGENCY MESSAGE SHOWN
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.02 * sw,
                  vertical: 0.02 * sh,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 0.15 * sh,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 125, 27, 27),
                              Color.fromARGB(255, 198, 84, 59),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.05 * sh),
                            topLeft: Radius.circular(0.05 * sh),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.025 * sw),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 0.75 * sw,
                                height: 0.12 * sh,
                                child: Image.asset(
                                  'images/mbblogo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              /*
                              child: Text(
                                "Welcome to “Mobile Blood Bank Nepal” ",
                                style: TextStyle(
                                    fontSize: 0.02 * sh,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              */
                            ),
                          ],
                        ),
                      ),

                      //ENDING FOR EMERGENCY MESSAGE

                      // FOR TOTAL MEMBERS SHOWN

                      SizedBox(height: 0.01 * sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 0.05 * sh,
                            width: 0.5 * sw,
                            decoration: BoxDecoration(
                              color: const Color(0xFF444242),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(0.05 * sh),
                                bottomRight: Radius.circular(0.05 * sh),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 0.03 * sw),
                            child: Text(
                              'Total Members',
                              style: TextStyle(
                                fontSize: 0.025 * sh,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 0.05 * sw),
                          Text(
                            ' $totalDonors', // import total members from database
                            style: TextStyle(
                              fontSize: 0.025 * sh,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // ENDING OF TOTAL MEMBERS SHOWN

                      // TOTAL MEMBERS AS PER BLOOD CATEGORY HEADER
                      SizedBox(height: 0.01 * sh),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 0.04 * sw),
                          height: 0.04 * sh,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF444242),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Blood Groups',
                                style: TextStyle(
                                  fontSize: 0.02 * sh,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'No. of Donors Available',
                                style: TextStyle(
                                  fontSize: 0.02 * sh,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),

                      // HEADER END

                      // TOTAL MEMBERS AS PER BLOOD CATEGORY
                      SizedBox(height: 0.005 * sh),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 0.05 * sw),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //first column
                              Column(
                                children: [
                                  Text(
                                    'A+',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'B+',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'O+',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'A-',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'B-',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'O-',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'AB+',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'AB-',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              //Second Column
                              Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${bloodGroupCounts['A+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['B+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['O+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['A-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['B-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['O-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['AB+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['AB-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 0.02 * sh,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),

                      SizedBox(height: 0.01 * sh),
                      // TOP 3 DONOR LISTS header
                      Container(
                        height: 0.04 * sh,
                        width: 0.7 * sw,
                        decoration: BoxDecoration(
                          color: const Color(0xFF444242),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0.05 * sh),
                            bottomRight: Radius.circular(0.05 * sh),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 0.03 * sw),
                        child: Text(
                          'Top 3 Donor List  🏆 🏆 🏆',
                          style: TextStyle(
                            fontSize: 0.025 * sh,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // LIST OF 3 DONORS
                      //first donor
                      const SizedBox(height: 0.0),

                      SizedBox(
                        height: 0.5 * sh,
                        child: ListView.builder(
                          itemCount: topDonors.length,
                          itemBuilder: (context, index) {
                            final donor = topDonors[index];
                            return Container(
                              height: 0.06 * sh,
                              color: const Color.fromARGB(49, 158, 158, 158),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.05 * sw, vertical: 0.01 * sh),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${donor['fullName']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 0.018 * sh,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      Text(
                                        '${donor['donationCount']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 0.018 * sh,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // for underline
                                  Container(
                                    height:
                                        0.001 * sh, // Height of the underline
                                    color: Colors.white,
                                    //width:300.0, // Adjust the width accordingly
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
// DONATION HISTORY RECORDS COMPLETE
                    ]),
              ),
            ),

            //FOR BOTTOM BUTTTONS

            // Row of buttons at the bottom
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: 0.08 * sh,
                width: double.infinity,
                color: const Color(
                    0xFF592424), // Change the background color as needed

                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.01 * sw, vertical: 0.005 * sh),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RequestScreen(
                                        notificationReId: 0,
                                      )),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          label: Text('Add New Request',
                              style: TextStyle(
                                fontSize: 0.015 * sh,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(138, 254, 254, 254),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.01 * sh),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.01 * sw),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EmergencyRequest(
                                      notificationErId: 0)),
                            );
                          },
                          icon: const Icon(
                            Icons.view_list_outlined,
                            color: Colors.black,
                          ),
                          label: Text('Urgent Requests',
                              style: TextStyle(
                                fontSize: 0.015 * sh,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                138, 254, 254, 254), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0.01 * sh), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.01 * sw),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchBloodGroup()),
                            );
                            // Handle first button press
                          },
                          icon: const Icon(
                            Icons.bloodtype_outlined,
                            color: Colors.black,
                          ),
                          label: Text('Search Blood',
                              style: TextStyle(
                                fontSize: 0.015 * sh,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                138, 254, 254, 254), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0.01 * sh), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
