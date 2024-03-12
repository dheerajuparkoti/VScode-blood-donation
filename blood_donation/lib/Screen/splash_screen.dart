import 'dart:async';
import 'package:blood_donation/Screen/sign_in_up_screen.dart';
//import 'package:blood_donation/provider/user_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _LoginState();
}

class _LoginState extends State<SplashScreen> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
    //_checkUserLoggedIn();
  }

/*
  Future<void> _checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');
    UserProvider userProvider = UserProvider();

    if (authToken != null) {
      final userId = prefs.getInt('userId');
      final donorId = prefs.getInt('donorId');
      final accountType = prefs.getString('accountType');
      userProvider.setUserId(userId!);
      userProvider.setDonorId(donorId!);
      userProvider.setUserAccountType(accountType!);
      // Use the fetched information as needed

      if (mounted) {
        setState(() {
          isLoading = false; // Set isLoading to false after 5 seconds
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInSignUp()),
        );
      }
    }
  }
  */

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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.red, // Set the color of the error icon to red
            ),
            SizedBox(
                width: 8), // Add some spacing between the icon and the text
            Text(
              'No Internet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
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
                width: 300.0,
                height: 300.0,
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
              bottom: 20, // Adjust bottom value as needed
              child: Center(
                child: Semantics(
                  label: 'Loading Mobile Blood Bank Nepal',
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white, // Change color of the progress indicator
                      ),
                      strokeWidth: 0.01 * sw, // Adjust strokeWidth as needed
                      backgroundColor: Colors
                          .black12, // Change background color of the progress indicator
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
