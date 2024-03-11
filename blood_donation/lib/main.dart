import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_donation/Screen/splash_screen.dart';
import 'package:blood_donation/notificationservice/local_notification_service.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // Check and request permission for scheduling exact alarms
  await _checkAndRequestPermission();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC-QidEdKNmEMri0_N4c-kmREG5BiDBwEk',
      appId: '1:17189376255:android:4d452ba103d4ea762a7cca',
      messagingSenderId: '17189376255',
      projectId: 'mobile-blood-bank-nepal-a2399',
    ),
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('mobilebloodbanknepalnotifications');
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
}

Future<void> _checkAndRequestPermission() async {
  PermissionStatus status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Mobile Blood Bank Nepal',
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.pink,
      ),
      home: const SplashScreen(),
    );
  }
}
