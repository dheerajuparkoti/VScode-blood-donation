import 'package:flutter/material.dart';

class CustomDialog {
  static void showAlertDialog(
      BuildContext context, String title, String message, IconData iconData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double sw = MediaQuery.of(context).size.width;
        double sh = MediaQuery.of(context).size.height;
        double asr = sh / sw;
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite, // Adjust the width as needed
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min size to make it smaller
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.30 * asr,
                  ),
                ),
                SizedBox(height: 5.1 * asr),
                Icon(
                  iconData,
                  color: Colors.red,
                  size: 20.4 * asr,
                ),
                SizedBox(height: 5.1 * asr),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 8.26 * asr,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 9.30 * asr,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// for snackbar
class CustomSnackBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 4.08 * asr),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
      ),
    );
  }

  // for error snacbar or unsuccess
  static void showUnsuccess({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 4.08 * asr),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: behavior,
      ),
    );
  }
}
