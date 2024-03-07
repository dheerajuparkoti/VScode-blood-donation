import 'dart:convert';
import 'package:blood_donation/Screen/emergency_request_screen.dart';
import 'package:blood_donation/Screen/events_appointment.dart';
import 'package:blood_donation/Screen/request_screen.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
  List<dynamic> loadingNotificationWithDonorId = [];
  int notificationCount = 0; // Change the type to int

  Future<void> loadingNotifications() async {
    var data = {
      'doId': userProvider!.donorId,
    };
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    try {
      // Make API request to fetch notifications
      var res = await CallApi().loadNotification(data, 'loadNotification');

      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        // Extract notifications and count from the response
        final List<dynamic> notifications = jsonResponse['notifications'];
        final List<dynamic> notificationswithDonorId =
            jsonResponse['notificationswithDonorId'];
        notificationCount =
            jsonResponse['count']; // Assign count directly to the variable

        setState(() {
          // Update state with the loaded notifications and count
          loadingAllNotifications = notifications;
          loadingNotificationWithDonorId = notificationswithDonorId;
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
  notifiReadEr(int erId) async {
    var data = {
      'erId': erId,
      'doId': userProvider?.donorId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadErId');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        loadingNotifications();
      });
    } else {}
  }

// ending of notification status

// update notification read status

  notifiReadRe(int rId) async {
    var data = {
      'rId': rId,
      'doId': userProvider?.userId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadReId');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        loadingNotifications();
      });
    } else {
      // Handle error
    }
  }

// ending of notification status

// update notification read status

  notifiReadEvent(int evId) async {
    var data = {
      'evId': evId,
      'doId': userProvider!.donorId,
    };

    var res = await CallApi().notificationRead(data, 'notificationReadEvent');

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        loadingNotifications();
      });
    } else {}
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.045 * sh,
        title: Text(
          'Notifications ($notificationCount)',
          style: TextStyle(
            fontSize: 0.025 * sh,
          ),
        ),
        centerTitle: true,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: const Color.fromARGB(255, 14, 14, 14),
      ),
      //resizeToAvoidBottomInset: false,

      body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 14, 14, 14),
                Color.fromARGB(255, 25, 25, 25),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 0.01 * sw,
              right: 0.01 * sw,
              top: 0,
              bottom: 0,
            ),
            child: SizedBox(
              width: sw,
              height: sh,
              child: SingleChildScrollView(
                child: Center(
                    child: Column(
                  children: <Widget>[
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: loadingAllNotifications.length,
                        itemBuilder: (context, index) {
                          final notificationData =
                              loadingAllNotifications[index];
                          // check if Emergency request has been read
                          final bool isErReadByDonor =
                              loadingNotificationWithDonorId
                                  .any((notification) {
                            final dynamic erId = notification[
                                'erId']; // Use dynamic type for flexibility
                            final dynamic notificationErId =
                                notificationData['erId'];

                            // Check if both erId fields are not null and match
                            return erId != null &&
                                notificationErId != null &&
                                erId.toString() == notificationErId.toString();
                          });

                          // check if Request has been read
                          final bool isReReadByDonor =
                              loadingNotificationWithDonorId
                                  .any((notification) {
                            final dynamic rId = notification[
                                'rId']; // Use dynamic type for flexibility
                            final dynamic notificationReId =
                                notificationData['rId'];

                            // Check if both erId fields are not null and match
                            return rId != null &&
                                notificationReId != null &&
                                rId.toString() == notificationReId.toString();
                          });

                          // check if Request has been read
                          final bool isEventReadByDonor =
                              loadingNotificationWithDonorId
                                  .any((notification) {
                            final dynamic evId = (notification[
                                'evId']); // Use dynamic type for flexibility
                            final dynamic notificationEventId =
                                (notificationData['evId']);

                            // Check if both erId fields are not null and match
                            return evId != null &&
                                notificationEventId != null &&
                                evId.toString() ==
                                    notificationEventId.toString();
                          });

                          return InkWell(
                            onTap: () {
                              if (notificationData['erId'] != null) {
                                notifiReadEr(
                                    (int.parse(notificationData['erId'])));

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmergencyRequest(
                                      notificationErId: int.parse(notificationData[
                                          'erId']), // Pass the required parameter
                                    ),
                                  ),
                                );
                              } else if (notificationData['rId'] != null) {
                                notifiReadRe(
                                    int.parse(notificationData['rId']));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestScreen(
                                      notificationReId: int.parse(notificationData[
                                          'rId']), // Pass the required parameter
                                    ),
                                  ),
                                );
                              } else if (notificationData['evId'] != null) {
                                notifiReadEvent(
                                    int.parse(notificationData['evId']));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventsAppointments(
                                      notificationEvId: int.parse(notificationData[
                                          'evId']), // Pass the required parameter
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0 * sh),
                              ),
                              elevation: 0.0012 * sh,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // First Row Container
                                  Container(
                                    height: 0.07 * sh,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.025 * sw,
                                        vertical: 0 * sh),
                                    color: isErReadByDonor
                                        ? const Color.fromARGB(
                                            255, 51, 103, 163)
                                        : isReReadByDonor
                                            ? const Color.fromARGB(
                                                255, 51, 103, 163)
                                            : isEventReadByDonor
                                                ? const Color.fromARGB(
                                                    255, 51, 103, 163)
                                                : const Color(0xC9272727),
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
                                  SizedBox(height: 0.001 * sh),
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
        ),
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
      ]),
    );
  }
}
