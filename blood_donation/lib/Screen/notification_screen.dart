import 'dart:convert';
import 'package:blood_donation/Screen/emergency_request_screen.dart';
import 'package:blood_donation/Screen/events_appointment.dart';
import 'package:blood_donation/Screen/request_screen.dart';
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

// update notification read status
  bool isRead = false;
  notifiReadEr(int erId) async {
    var data = {
      'erId': erId,
      'doId': userProvider!.donorId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadErId');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        isRead = !isRead;
        loadingNotifications();
      });
    } else {}
  }

// ending of notification status

// update notification read status
  bool isReadReq = false;
  notifiReadRe(int rId) async {
    var data = {
      'rId': rId,
      'doId': userProvider!.donorId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadReId');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        isReadReq = !isReadReq;
        loadingNotifications();
      });
    } else {
      // Handle error
      print(' ${res.statusCode}');
    }
  }

// ending of notification status

// update notification read status
  bool isReadEvent = false;
  notifiReadEvent(int evId) async {
    var data = {
      'evId': evId,
      'doId': userProvider!.donorId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadEvent');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        isReadReq = !isReadReq;
        loadingNotifications();
      });
    } else {
      // Handle error
      print(' ${res.statusCode}');
    }
  }

// ending of notification status

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

        Padding(
          padding: EdgeInsets.only(
            top: 20.4 * asr,
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
                        final notificationData = loadingAllNotifications[index];

                        return InkWell(
                          onTap: () {
                            if (notificationData['erId'] != null) {
                              notifiReadEr(notificationData['erId']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmergencyRequest(
                                    notificationErId: notificationData[
                                        'erId'], // Pass the required parameter
                                  ),
                                ),
                              );
                            } else if (notificationData['rId'] != null) {
                              notifiReadRe(notificationData['rId']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestScreen(
                                    notificationReId: notificationData[
                                        'rId'], // Pass the required parameter
                                  ),
                                ),
                              );
                            } else if (notificationData['evId'] != null) {
                              notifiReadEvent(notificationData['evId']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventsAppointments(
                                    notificationEvId: notificationData[
                                        'evId'], // Pass the required parameter
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 25.75 * asr,
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
                                    height: 25 * asr,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.58 * asr,
                                        vertical: 0 * asr),
                                    color: const Color(0xFF444242),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          // Wrap with Flexible widget
                                          child: Text(
                                            notificationData['erId'] != null
                                                ? 'New emergency request available. Tap here to view details. Request no. is ${notificationData['erId']}'
                                                : notificationData['rId'] !=
                                                        null
                                                    ? 'New request available. Tap here to view details. Request no. is: ${notificationData['rId']}'
                                                    : notificationData[
                                                                'evId'] !=
                                                            null
                                                        ? 'New event available. Tap here to view details. Event no. is: ${notificationData['evId']}'
                                                        : 'Unknown notification type',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
