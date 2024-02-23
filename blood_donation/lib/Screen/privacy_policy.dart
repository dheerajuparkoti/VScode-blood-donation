import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          title: const Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xffBF371A),
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2D2D2D),
                  Color(0xFF2D2D2D),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 30.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF444242),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'We Are',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MOBILE BLOOD BANK NEPAL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xffBF371A),
                            ),
                          ),
                          Container(
                            height: 2, // Height of the underline
                            color: Colors.white,
                            width: 300.0, // Adjust the width accordingly
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text:
                                  'Welcome to “Mobile Blood Bank Nepal” where we prioritize your privacy. This policy outlines how we collect, use, disclose, and protect your information when you use our app. By using the app, you agree to this privacy policy and our terms of service.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFFFFFFF),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '\n',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset(
                            'images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200.0,
                    height: 30.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF444242),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Privacy & Policy',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 2, // Height of the underline
                    color: Colors.white,
                    width: 300.0, // Adjust the width accordingly
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: const TextSpan(
                        text:
                            'Welcome to “Mobile Blood Bank Nepal” where we prioritize your privacy. This policy outlines how we collect, use, disclose, and protect your information when you use our app. By using the app, you agree to this privacy policy and our terms of service.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFFFFFFF),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\n\n# Information Collection ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nWe collect information directly from you when you register on app, request blood, set appointments, This includes details like your name, contact information, location and medical information.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Use of Information ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nYour information is used to enhance app features, such as finding blood donors, locating ambulances, and creating members of the related organization. We may also use it for communication purposes, like sending updates or confirmations. Rest assured, we don’t share or sell your data for third-party marketing purposes.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Data Retention ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nWe keep collected information as long as necessary for app features and services, after which we either delete or anonymize it.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Data Security ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nWhile we take reasonable measures to safeguard your data, complete security in the digital realm is challenging. We can’t guarantee absolute security but are committed to protecting your information from unauthorized access, disclosure, alteration, or destruction.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Third-Party Services ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nRest assured, our app doesn’t integrate with any third-party websites or services. You can use it with confidence, knowing that your information remains within our secure ecosystem. We prioritize transparency, and if this ever changes, we’ll update you promptly. As always, your privacy is our priority.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Changes to this Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nWe may update this policy to reflect changes in our practices or applicable laws. Material changes will be communicated by posting the updated policy on our app or through other means.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\n\n# Contact Us ',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\nFor any questions about this privacy policy, reach out to us at',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          TextSpan(
                            text: '\ninfo@mobilebloodbanknepal.com ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xffBF371A),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add more widgets as needed
        ]),
      );
}
