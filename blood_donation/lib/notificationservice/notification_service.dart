// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:blood_donation/Screen/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:blood_donation/Screen/sign_in_up_screen.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User provisional granted permission');
    } else {
      Future.delayed(Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  //getDeviceToken
  Future<String> getDeviceToken() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound:true,
    );
         // Get the device token
    String? deviceToken = await messaging.getToken();
    print("token=> $deviceToken");
    return deviceToken!;
  }

  //init local notification
  void initLocalNotification(BuildContext context,RemoteMessage message)async{
    var androidInitSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting = DarwinInitializationSettings();

    var initialiazationSetting = InitializationSettings(
      android:androidInitSetting,
      iOS:iosInitSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(initialiazationSetting,onDidReceiveNotificationResponse:(payload){
      handleMessage(context, message);
    }, );

  }

  //firebase init
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen(
      (message){
      RemoteNotification? notification=message.notification;
      AndroidNotification? android = message.notification!.android;
      if(kDebugMode){
        print("notification title:${notification!.title}");
        print("notification.body:${notification.body}");
         print("message.data:${message.data}");
      }

    if(Platform.isIOS){
      iosForGroundMessage();
    }

    if(Platform.isAndroid){
      initLocalNotification(context, message);
      // handleMessage(context, message);
      showNotification(message);
    }
    
    },
    );
  }

//function to show notification
Future<void> showNotification(RemoteMessage message)async
{
AndroidNotificationChannel channel = AndroidNotificationChannel(
  message.notification!.android!.channelId.toString(),
message.notification!.android!.channelId.toString(),
importance: Importance.high,showBadge: true,
playSound: true,
);

//android setting
AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
channel.id.toString(),
channel.name.toString(),
channelDescription: "Channel Description",
importance: Importance.high,
priority: Priority.high,
playSound:true,
);

//ios setting
DarwinNotificationDetails darwinNotificationDetails= const DarwinNotificationDetails(
presentAlert: true,
presentBadge: true,
presentSound: true,
);

//merge setting
NotificationDetails notificationDetails = NotificationDetails(
  android:androidNotificationDetails,
  iOS: darwinNotificationDetails,
);

//show notification
Future.delayed(
  Duration.zero,
  (){
    _flutterLocalNotificationsPlugin.show(
      0, //id
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
      payload: "my_data",
    );
  }
);
}


//background and terminated
Future <void> setupInteractMessage(BuildContext context) async{
  //background state
  FirebaseMessaging.onMessageOpenedApp.listen((event){
     handleMessage(context, event);
  },
  );

  //terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
    if(message!= null && message.data.isNotEmpty){
      handleMessage(context, message);
    }
  },
  );
}

//handle message
Future<void> handleMessage(BuildContext context,RemoteMessage message)async{
  print(
    "Navigating to notification screen, message data: ${message.data}"
  );
 Get.to(() => NotificationScreen());
}




  //ios message
  Future iosForGroundMessage() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert:true,
      badge: true,
      sound: true,

    );
  }

}
