import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.05 * sh,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 0.025 * sh,
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
                Color.fromARGB(255, 14, 14, 14),
                Color.fromARGB(255, 38, 38, 38),
              ],
            ),
          ),
        ),

        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(0.01 * sh),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 0.25 * sw,
                  height: 0.04 * sh,
                  decoration: BoxDecoration(
                    color: const Color(0xFF444242),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0.05 * sh),
                      bottomRight: Radius.circular(0.05 * sh),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.03 * sw, vertical: 0.0),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'We Are',
                          style: TextStyle(
                            fontSize: 0.020 * sh,
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
                        Text(
                          'MOBILE BLOOD BANK NEPAL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.025 * sh,
                            color: const Color(0xffBF371A),
                          ),
                        ),
                        Container(
                          height: 0.002 * sh, // Height of the underline
                          color: Colors.white,
                          width: 0.9 * sw, // Adjust the width accordingly
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(0.01 * sh),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Mobile Blood Bank Nepal - Version 1.0 Beta',
                            style: TextStyle(
                              fontSize: 0.015 * sh,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFFFFFF),
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text:
                                    '\n\n"Mobile Blood Bank Nepal" is a life-saving mobile application designed to streamline blood donation processes in Nepal. With intuitive features, users can easily register as blood donors, providing essential information such as blood type, location, and availability. The app facilitates real-time notifications, alerting users when there is a need for blood donations in their vicinity or when their blood type matches specific requests. Through scheduled appointments and tracking donation history, users can actively contribute to the communitys health initiatives. "Mobile Blood Bank Nepal" aims to enhance accessibility to blood donations, ultimately saving lives and fostering a culture of voluntary blood donation across Nepal.',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.25 * sw,
                        height: 0.12 * sh,
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 0.4 * sw,
                  height: 0.04 * sh,
                  decoration: BoxDecoration(
                    color: const Color(0xFF444242),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0.05 * sh),
                      bottomRight: Radius.circular(0.05 * sh),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.03 * sw, vertical: 0.0),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Privacy & Policy',
                          style: TextStyle(
                            fontSize: 0.020 * sh,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.005 * sh),
                Container(
                  height: 0.002 * sh, // Height of the underline
                  color: Colors.white,
                  width: 0.9 * sw, // Adjust the width accordingly
                ),
                Padding(
                  padding: EdgeInsets.all(0.01 * sh),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Softmine Technologies Pvt. Ltd. built the Mobile Blood Bank Nepal app as a Free app. This SERVICE is provided by Softmine Technologies Pvt. Ltd. at no cost and is intended for use as is.This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Mobile Blood Bank Nepal unless otherwise defined in this Privacy Policy.',
                      style: TextStyle(
                        fontSize: 0.015 * sh,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFFFFFFF),
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: '\n\n# Information Collection and Use ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Name, phone, address, email, date of birth, blood group, photo. The information that we request will be retained by us and used as described in this privacy policy.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Log Data ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nWe want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Cookies ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory.This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Service Providers ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nWe may employ third-party companies and individuals due to the following reasons:\n•	To facilitate our Service;\n•	To provide the Service on our behalf;\n•	To perform Service-related services; or\n•	To assist us in analyzing how our Service is used.\n\n We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Security ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nWe value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Links to other sites',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Childrens Privacy',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nThese Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Changes To This Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nWe may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2024-03-07',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# For More info: ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              '\n https://sites.google.com/view/mobilebloodbanknepal-com',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 70, 153, 255),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL(
                                  'https://sites.google.com/view/mobilebloodbanknepal-com');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 0.4 * sw,
                  height: 0.04 * sh,
                  decoration: BoxDecoration(
                    color: const Color(0xFF444242),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0.05 * sh),
                      bottomRight: Radius.circular(0.05 * sh),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.03 * sw, vertical: 0.0),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Developed By',
                          style: TextStyle(
                            fontSize: 0.020 * sh,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.005 * sh),
                Container(
                  height: 0.002 * sh, // Height of the underline
                  color: Colors.white,
                  width: 0.9 * sw, // Adjust the width accordingly
                ),
                Padding(
                  padding: EdgeInsets.all(0.01 * sh),
                  child: RichText(
                    text: TextSpan(
                      text: 'Softmine Techonologies Pvt. Ltd.',
                      style: TextStyle(
                        fontSize: 0.015 * sh,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFFFFF),
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: '\n# Senior Developers',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\t\t\t Er. Prajwal Poudyal',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\t\t\t Er. Sohan Acharya',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const TextSpan(
                          text: '\n# Developers',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\t\t\t Dheeraj Uparkoti',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\t\t\t Raaj Budhathoki',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const TextSpan(
                          text: '\n# Special Thanks To',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\t\t\t MBCOE Team',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const TextSpan(
                          text: '\n\n# Contact Us ',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '\nFor any questions about this privacy policy, reach out to us at',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        TextSpan(
                          text: '\n\nPhone: +977-9862078434',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 70, 153, 255),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _makePhoneCall('tel:+977-9862078434');
                            },
                        ),
                        const TextSpan(
                          text: '\nEmail: tsoftmine@gmail.com',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: '\n Website: https://softmine.com.np/',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 70, 153, 255),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL('https://softmine.com.np/');
                            },
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

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  // ignore: deprecated_member_use
  if (await canLaunch(phoneNumber)) {
    // ignore: deprecated_member_use
    await launch(phoneNumber);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
