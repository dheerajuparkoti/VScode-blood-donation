import 'dart:async';
import 'package:blood_donation/Screen/splash_screen.dart';
import 'package:blood_donation/notificationservice/local_notification_service.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/provider/user_provider.dart';

// firebase notification
Future<void> backgroundHandler(RemoteMessage message) async {
  message.data.toString();
  (message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Finally, set up the main widget tree
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
  // Initialize Firebase and other services
  await Firebase.initializeApp();

  // Set up Firebase messaging and other services
  String? deviceToken = await FirebaseMessaging.instance.getToken();
  if (deviceToken != null) {
    print("Device Token was $deviceToken");
  } else {}

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('mobilebloodbanknepalnotifications');
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Blood Bank Nepal',
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.pink,
      ),
      home: const SplashScreen(),
    );
  }
}
