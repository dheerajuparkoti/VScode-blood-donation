import 'package:connectivity/connectivity.dart';

class ConnectivityUtil {
  static Future<bool> isInternetConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
