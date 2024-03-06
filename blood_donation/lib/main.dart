import 'package:blood_donation/Screen/home_screen.dart';
import 'package:blood_donation/Screen/sign_in_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_donation/Screen/splash_screen.dart';
import 'package:blood_donation/notificationservice/local_notification_service.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// firebase notification
Future<void> backgroundHandler(RemoteMessage message) async {
  message.data.toString();
  (message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC-QidEdKNmEMri0_N4c-kmREG5BiDBwEk',
      appId: '1:17189376255:android:4d452ba103d4ea762a7cca',
      messagingSenderId: '17189376255',
      projectId: 'mobile-blood-bank-nepal-a2399',
    ),
  );

  // Set up Firebase messaging and other services
  String? deviceToken = await FirebaseMessaging.instance.getToken();
  if (deviceToken != null) {
    print("Device Token : $deviceToken");
  } else {}

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('mobilebloodbanknepalnotifications');
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();

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
