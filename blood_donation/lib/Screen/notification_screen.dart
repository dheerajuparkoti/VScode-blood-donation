import 'dart:convert';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // Load emergency requests after userProvider is initialized
    loadingNotifications();
  }
  // loading all notification

  List<dynamic> loadingAllNotifications = [];
  int notificationCount = 0; // Change the type to int

  Future<void> loadingNotifications() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    try {
      // Make API request to fetch notifications
      var res = await CallApi().loadNotification({}, 'loadNotification');

      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        // Extract notifications and count from the response
        final List<dynamic> notifications = jsonResponse['notifications'];
        notificationCount =
            jsonResponse['count']; // Assign count directly to the variable

        setState(() {
          // Update state with the loaded notifications and count
          loadingAllNotifications = notifications;
          isLoading = false; // Set loading to false after data is loaded
        });
      } else {
        // Handle different status codes appropriately
        // print('API request failed with status code: ${res.statusCode}');
        isLoading = false; // Ensure to set loading to false on error
      }
    } catch (e) {
      // Handle errors
      // print('Error loading notifications: $e');
      isLoading = false; // Ensure to set loading to false on error
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(children: [
        Container(
          width: sw,
          height: sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffBF371A),
                Color(0xffF00808),
              ],
            ),
          ),
        ),

        //HEADER
        Padding(
          padding: EdgeInsets.only(top: 15.5 * asr),
          child: Container(
              height: 15.5 * asr,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Text(
                  '"Donate Blood Save Life Now"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.39 * asr,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              )),
        ),

        Padding(
          padding: EdgeInsets.only(
            top: 35.7 * asr,
            left: 0.51 * asr,
            right: 0.51 * asr,
            bottom: 0.0,
          ),
          child: Container(
            width: sw,
            height: sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.1 * asr),
                topRight: Radius.circular(5.1 * asr),
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        left: 5.1 * asr,
                        bottom: 0,
                        top: 0.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Total Notifications : ${loadingAllNotifications.length}',
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
                      itemCount: loadingAllNotifications.length,
                      itemBuilder: (context, index) {
                        final emergencyData = loadingAllNotifications[index];
                        //  final int emergencyRequestId =
                        //      emergencyData['emergencyRequestId'] ?? 0;

                        return SizedBox(
                          height: 147.9 * asr,
                          child: Card(
                            margin: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            elevation: 0.51 * asr,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // First Row Container
                                Container(
                                  height: 15.5 * asr,
                                  padding: EdgeInsets.all(2.58 * asr),
                                  color: const Color(0xFF444242),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '# E- Request : ${emergencyData['emergencyRequestId']}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Required Blood: ${emergencyData['bloodGroup']}',
                                        style: const TextStyle(
                                            color: Colors.white),
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
          ),
        ),
        //end of other request i.e 3rd tab

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
      ]),
    );
  }
}
