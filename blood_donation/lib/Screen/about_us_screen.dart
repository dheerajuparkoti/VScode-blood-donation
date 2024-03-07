import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.05 * sh,
        title: Text(
          'About Us',
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
                          'LEADERSHIP FOR CHANGE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.02 * sh,
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
                            text: '',
                            style: TextStyle(
                              fontSize: 0.015 * sh,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFFFFFFF),
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text: '',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
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
                          'images/leadership_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YUWASTRA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.02 * sh,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Objectives of the organization "Yuwastra"',
                            style: TextStyle(
                              fontSize: 0.015 * sh,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFFFFF),
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text:
                                    '\n# Yuwastra will be a non-profit, non-political, hereditary, organized, self-governing, public welfare, non-governmental youth-centered social organization.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n# Conduct various humanitarian service programs within the scope of the organization by increasing mutual acquaintance and relationship with the youth of the country and converting them into service opportunities.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n# Advocating the rights of youth, women, children, senior citizens, persons with disabilities and doing targeted work for that group.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n# Conducting programs such as youth conferences, youth festivals, workshops.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFFFFF),
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
                          'images/yuwastra_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LEO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.02 * sh,
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
                            text: 'LEADERSHIP EXPERIENCE OPPERTUNITY',
                            style: TextStyle(
                              fontSize: 0.015 * sh,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFFFFF),
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                text:
                                    '\nThe Leo Club Program is a youth project affiliated with Lions Clubs International, designed for young people aged 12 to 30. It prioritizes various community service projects, leadership training activities, and social events, aiming to develop leadership skills, foster a spirit of volunteerism, and make a positive impact in their communities.Leo District Council 325 C Nepal is the largest district of Multiple District 325 Nepal, functioning within the Koshi Province of Nepal. As part of Lions Clubs International, the council plays a crucial role in fostering collaboration among Leo Clubs, facilitating leadership development opportunities, and promoting the values of service and community engagement among Nepali youth.',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
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
                        width: 0.25 * sw,
                        height: 0.12 * sh,
                        child: Image.asset(
                          'images/leo_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIONS INTERNATIONAL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 0.02 * sh,
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
                            text:
                                'Our mission is to empower Lions clubs, volunteers and partners to improve health and wellbeing, strengthen communities, and support those in need through humanitarian service and grants that impact lives globally, and encourage peace and international understanding. And we fulfill it every day, everywhere we serve.',
                            style: TextStyle(
                              fontSize: 0.015 * sh,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFFFFFFF),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\n\n https://www.lionsclubs.org/',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 70, 153, 255),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchURL('https://www.lionsclubs.org/en');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.25 * sw,
                        height: 0.12 * sh,
                        child: Image.asset(
                          'images/lions_international_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
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
