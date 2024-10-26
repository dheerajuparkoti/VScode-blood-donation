import 'package:blood_donation/notificationservice/fcm_service.dart';
import 'package:blood_donation/notificationservice/get_server_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_donation/Screen/splash_screen.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:blood_donation/notificationservice/notification_service.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
// Firebase notification background handler
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // (options: defaultFirebaseAppName.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp(options: DefaultFirebaseOpetions.currentPlatform);
await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

// Get the server key token
  GetServerKey serverKey = GetServerKey();
  String accessToken = await serverKey.getServerKeyToken();
  print('Access Token: $accessToken'); // Print the access token for testing


 

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.subscribeToTopic('mobilebloodbanknepalnotifications');
  
  // Now run the app
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // Request notification permission when the app starts
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    FcmService.firebaseInit();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);


  }

  @override
  Widget build(BuildContext context) {
     return GetMaterialApp(
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
