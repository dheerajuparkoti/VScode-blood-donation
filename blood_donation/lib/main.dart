//import 'package:blood_donation/Screen/sign_in_up_screen.dart';
// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:blood_donation/Screen/splash_screen.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/data/internet_connectivity.dart';
import 'package:blood_donation/notification_service.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:blood_donation/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/Screen/search_blood.dart';
import 'package:blood_donation/Screen/request_screen.dart';
import 'package:blood_donation/Screen/emergency_request_screen.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Mobile Blood Bank Nepal';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home:
            const SplashScreen(), // change here to set first screen of the app
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
        const Duration(seconds: 5), (Timer t) => fetchDonorCounts());
    _timer1 =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => topDonorList());
  }

// DONOR COUNTS TO SHOW IN MAIN SCREEN STARTS HERE
  fetchDonorCounts() async {
    bool isConnected = await ConnectivityUtil.isInternetConnected();
    if (isConnected) {
      try {
        final res = await CallApi().countDonors({}, 'DonorCountsByBloodGroup');
        if (res.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(res.body);
          if (mounted) {
            setState(() {
              totalDonors = jsonResponse['totalDonors'];
              bloodGroupCounts =
                  Map<String, int>.from(jsonResponse['bloodGroupCounts']);
            });
          }
        } else {
          throw Exception(
              'Failed to load donor counts. Status code: ${res.statusCode}');
        }
      } catch (e) {
        if (mounted) {
          // Check if the widget is still mounted before showing the dialog
          CustomDialog.showAlertDialog(
            context,
            'Server Error',
            'There was an error connecting to the server. Please try again later.',
            Icons.error_outline,
          );
        }
      }
    } else {
      // No internet connection
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
    }
  }

  // ENDS HERE

  List<Map<String, dynamic>> topDonors = [];

// TOP 3 DONOR LIST TO SHOW IN MAIN SCREEN STARTS HERE
  topDonorList() async {
    bool isConnected = await ConnectivityUtil.isInternetConnected();
    if (isConnected) {
      try {
        final res = await CallApi().topDonors({}, 'getTopDonors');

        if (res.statusCode == 200) {
          final List<dynamic> jsonResponse = json.decode(res.body);

          setState(() {
            topDonors = jsonResponse.cast<Map<String, dynamic>>();
          });
        } else {
          throw Exception(
              'Failed to load donor lists. Status code: ${res.statusCode}');
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        CustomDialog.showAlertDialog(
          context,
          'Server Error',
          'There was an error connecting to the server. Please try again later.',
          Icons.error_outline,
        );
      }
    } else {
      // No internet connection
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
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
    double asr = sh / sw;

    return Scaffold(
      backgroundColor: const Color(0xFF592424),
      drawer: NavigationDrawerScreen(),
      appBar: AppBar(
        title: Text(
          MyApp.title,
          style: TextStyle(
            fontSize: 10.33 * asr,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF592424),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.58 * asr),
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
                  topRight: Radius.circular(25.75 * asr),
                  topLeft: Radius.circular(25.75 * asr),
                  bottomLeft: Radius.circular(25.75 * asr),
                ),
              ),
            ),

            //EMERGENCY MESSAGE SHOWN
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.26 * asr,
                  vertical: 8.26 * asr,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 77.5 * asr,
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
                            topRight: Radius.circular(25.75 * asr),
                            topLeft: Radius.circular(25.75 * asr),
                            // bottomLeft: Radius.circular(25.75*asr),
                            //bottomRight: Radius.circular(25.75*asr),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 7.75 * asr),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Urgent A+ Blood Needed Welcome to “Mobile Blood Bank Nepal” where we prioritize your privacy. This policy outlines how we collect, use, disclose, and protect your information when you use our app. By using the app, you agree to this privacy policy and our terms of service. Hurry up this is dheeraj uparkoti from dangihat nepal Urlabari Morang",
                                style: TextStyle(
                                    fontSize: 6.2 * asr,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //ENDING FOR EMERGENCY MESSAGE

                      // FOR TOTAL MEMBERS SHOWN
                      SizedBox(height: 5.1 * asr),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 15.5 * asr,
                            width: 103.3 * asr,
                            decoration: BoxDecoration(
                              color: const Color(0xFF444242),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(18.1 * asr),
                                bottomRight: Radius.circular(18.1 * asr),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 8.26 * asr),
                            child: Text(
                              'Total Members',
                              style: TextStyle(
                                fontSize: 10.33 * asr,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.9 * asr),
                          Text(
                            ' $totalDonors', // import total members from database
                            style: TextStyle(
                              fontSize: 10.33 * asr,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // ENDING OF TOTAL MEMBERS SHOWN

                      // TOTAL MEMBERS AS PER BLOOD CATEGORY HEADER
                      SizedBox(height: 5.1 * asr),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.26 * asr),
                          height: 15.5 * asr,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF444242),
                            borderRadius: BorderRadius.only(
                                // topRight: Radius.circular(35.0),
                                // bottomRight: Radius.circular(35.0),
                                ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Blood Groups',
                                style: TextStyle(
                                  fontSize: 8.26 * asr,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'No. of Donors Available',
                                style: TextStyle(
                                  fontSize: 8.26 * asr,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),

                      // HEADER END

                      // TOTAL MEMBERS AS PER BLOOD CATEGORY
                      SizedBox(height: 5.1 * asr),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.26 * asr),
                          //  height: 200.0,
                          //   width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //first column
                              Column(
                                children: [
                                  Text(
                                    'A+',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'B+',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'O+',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'AB+',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'A-',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'B-',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'O-',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'AB-',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
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
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['B+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['O+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['AB+'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['A-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['B-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['O-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${bloodGroupCounts['AB-'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 8.26 * asr,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),

                      SizedBox(height: 5.1 * asr),
                      // TOP 3 DONOR LISTS header
                      Container(
                        height: 15.5 * asr,
                        width: 155.0 * asr,
                        decoration: BoxDecoration(
                          color: const Color(0xFF444242),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18.1 * asr),
                            bottomRight: Radius.circular(18.1 * asr),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 8.26 * asr),
                        child: Text(
                          'Top 3 Donor List  🏆 🏆 🏆',
                          style: TextStyle(
                            fontSize: 10.33 * asr,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // LIST OF 3 DONORS
                      //first donor
                      const SizedBox(height: 0.0),

                      SizedBox(
                        height: 155.0 * asr, // Set the height of the container
                        child: ListView.builder(
                          itemCount: topDonors.length,
                          itemBuilder: (context, index) {
                            final donor = topDonors[index];
                            return Container(
                              height: 25.75 * asr, // Set the height of each row
                              color: const Color.fromARGB(49, 158, 158,
                                  158), // Set the background color
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.33 * asr, vertical: 5.1 * asr),
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
                                          fontSize: 7.23 * asr,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      Text(
                                        '${donor['donationCount']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 7.23 * asr,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // for underline
                                  Container(
                                    height:
                                        0.51 * asr, // Height of the underline
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
                width: double.infinity,
                color: const Color(
                    0xFF592424), // Change the background color as needed

                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1.5 * asr, vertical: 1.5 * asr),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                fontSize: 6.0 * asr,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                138, 254, 254, 254), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.1 * asr), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.58 * asr),
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
                                fontSize: 6.0 * asr,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                138, 254, 254, 254), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.1 * asr), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.58 * asr),
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
                                fontSize: 6.0 * asr,
                                color: Colors.black,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                138, 254, 254, 254), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.1 * asr), // Adjust the border radius
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
