import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenService {
  // This function returns the FCM device token
  Future<String?> getDeviceToken() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken != null) {
        print("Device FCM Token: $deviceToken");
      } else {
        print("Failed to get FCM Token");
      }
      return deviceToken;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }
}
