import 'package:flutter/material.dart';

class CustomDialog {
  static void showAlertDialog(
      BuildContext context, String title, String message, IconData iconData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double sh = MediaQuery.of(context).size.height;
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
                    fontSize: 0.025 * sh,
                  ),
                ),
                SizedBox(height: 0.005 * sh),
                Icon(
                  iconData,
                  color: Colors.red,
                  size: 0.05 * sh,
                ),
                SizedBox(height: 0.005 * sh),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 0.018 * sh,
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
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 0.018 * sh,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // for confirmation dialog box

  static void showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    IconData iconData,
    Function onYesPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double sh = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 0.025 * sh,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: Colors.red,
                size: 0.05 * sh,
              ),
              SizedBox(height: 0.005 * sh),
              Text(
                message,
                style: TextStyle(
                  fontSize: 0.018 * sh,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onYesPressed(); // Execute the function when 'Yes' is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 0.018 * sh,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 0.018 * sh,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 0.05 * sw),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 0.05 * sw),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
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
