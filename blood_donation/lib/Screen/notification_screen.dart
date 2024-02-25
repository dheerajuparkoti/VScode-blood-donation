import 'dart:convert';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/model/screen_resolution.dart';
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
      print("I am started");
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        print('API Response: $jsonResponse');
        // Extract notifications and count from the response
        final List<dynamic> notifications = jsonResponse['notifications'];
        notificationCount =
            jsonResponse['count']; // Assign count directly to the variable

        setState(() {
          // Update state with the loaded notifications and count
          loadingAllNotifications = notifications;
          isLoading = false; // Set loading to false after data is loaded
          print("Success notified");
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
    double asr = ScreenResolution().sh / ScreenResolution().sw;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.33 * asr),
            Text(
              'Notification Count: $notificationCount', // Display the notification count
              style: TextStyle(fontSize: 9.30 * asr),
            ),
          ],
        ),
      ),
    );
  }
}
