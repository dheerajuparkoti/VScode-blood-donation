import 'dart:async';

import 'package:blood_donation/Screen/sign_in_up_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _LoginState();
}

class _LoginState extends State<SplashScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }

  Future<void> _checkInternetAndNavigate() async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showNoInternetDialog();
    } else {
      // Internet is available
      _startNavigation();
    }
  }

  void _showNoInternetDialog() {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red, // Set the color of the error icon to red
            ),
            SizedBox(
                width: 4.08 *
                    asr), // Add some spacing between the icon and the text
            Text(
              'No Internet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9.30 * asr,
                color: Colors.red, // Set the color of the title text to red
              ),
            ),
          ],
        ),
        content:
            const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retry checking internet connection
              _checkInternetAndNavigate();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _startNavigation() {
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isLoading = false; // Set isLoading to false after 5 seconds
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInSignUp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffF00808),
                  Color(0xffBF371A),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 0.7 * sw,
                height: 0.25 * sh,
                child: Image.asset(
                  'images/mbblogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          if (isLoading) // Show custom styled circular progress indicator if isLoading is true
            Positioned(
              left: 0,
              right: 0,
              bottom: 0.025 * sh, // Adjust bottom value as needed
              child: Center(
                child: SizedBox(
                  width: 0.05 * sh,
                  height: 0.05 * sh,
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white, // Change color of the progress indicator
                    ),
                    strokeWidth: 0.01 * sw, // Adjust strokeWidth as needed
                    backgroundColor: Colors
                        .black12, // Change background color of the progress indicator
                    semanticsLabel: 'Loading', // Add a semantics label
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
