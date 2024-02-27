import 'dart:convert';
import 'package:blood_donation/api/api.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankSearchList extends StatefulWidget {
  final Map<String, dynamic> searchCriteriaData; // importing user search input
  const BloodBankSearchList({Key? key, required this.searchCriteriaData})
      : super(key: key);

  @override
  State<BloodBankSearchList> createState() => _BloodBankSearchListState();
}

class _BloodBankSearchListState extends State<BloodBankSearchList> {
  List<Map<String, dynamic>> matchedResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch matched results when the widget is created
    fetchResults(widget.searchCriteriaData);
  }

// Function to make a phone call
  makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch(phoneNumber)) {
      // ignore: deprecated_member_use
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to share content
  void shareContent(String content) {
    Share.share(content);
  }

  void fetchResults(Map<String, dynamic> searchCriteriaData) async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });
    // Call your API to get matched results here
    // Replace 'YourApiCall' with your actual API call
    var res = await CallApi().postData(searchCriteriaData, 'LoadBloodBankInfo');

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      final List<dynamic> data = jsonResponse['data'];

      setState(() {
        matchedResults = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      // print('API request failed with status code: ${res.statusCode}');
      isLoading = false;
    }
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
          width: sw,
          height: sh,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffBF371A),
                Color(0xffF00808),
              ],
            ),
          ),
        ),

        //HEADER
        Padding(
          padding: EdgeInsets.only(top: 15.5 * asr),
          child: Container(
              height: 15.5 * asr,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF0025),
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Text(
                  'Searched Blood Bank Results',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.33 * asr,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
        ),

        Padding(
          padding: EdgeInsets.only(
            top: 35.7 * asr,
            left: 0.51 * asr,
            right: 0.51 * asr,
            bottom: 0.0,
          ),
          child: Container(
            width: sw,
            height: sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.9 * asr),
                topRight: Radius.circular(12.9 * asr),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.9 * asr),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                            left: 5.1 * asr,
                            bottom: 0,
                            top: 5.1 * asr,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Searched Results : ${matchedResults.length}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.26 * asr,
                              ),
                            ),
                          )),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: matchedResults.length,
                          itemBuilder: (context, index) {
                            final result = matchedResults[index];
                            String capitalizedItem =
                                result['name'].toUpperCase();

                            return SizedBox(
                              height: 51.5 * asr,
                              child: Card(
                                margin: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                elevation: 0.0,
                                child: Column(
                                  children: <Widget>[
                                    // for underline
                                    Container(
                                      height:
                                          0.51 * asr, // Height of the underline
                                      color: Colors.red,
                                      //width:300.0, // Adjust the width accordingly
                                    ),
                                    //First Row container
                                    Container(
                                      height: 27.03 * asr,
                                      padding: EdgeInsets.all(2.58 * asr),
                                      color: const Color(0xFFFFFFFF),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              capitalizedItem,
                                              style: TextStyle(
                                                fontSize: 7.23 * asr,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 1, 1, 1),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 2.58 * asr),
                                    //Second  Row container

                                    Container(
                                      height: 20.4 * asr,
                                      padding: EdgeInsets.all(2.58 * asr),
                                      color: const Color(0xFFFFFFFF),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: () {
                                                makePhoneCall(
                                                    'tel:+977 ${result['contactNo']}');
                                              },
                                              icon: Icon(
                                                Icons.phone,
                                                size: 8.26 * asr,
                                                color: Colors.white,
                                              ),
                                              label: Text('Call',
                                                  style: TextStyle(
                                                    fontSize: 7.23 * asr,
                                                    color: Colors.white,
                                                  )),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors
                                                    .green, // Change the button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0), // Adjust the border radius
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 1.29 * asr),
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: () {
                                                shareContent(
                                                  '"Blood Bank Info" \n'
                                                  '$capitalizedItem\n'
                                                  'Address: ${result['localLevel']} - ${result['wardNo']}, ${result['district']},Province: ${result['province']}\n'
                                                  'tel: +977 ${result['contactNo']}\n'
                                                  'App: Mobile Blood Bank Nepal',
                                                );
                                              },
                                              icon: Icon(
                                                Icons.share,
                                                size: 8.26 * asr,
                                                color: Colors.white,
                                              ),
                                              label: Text('Share',
                                                  style: TextStyle(
                                                    fontSize: 7.23 * asr,
                                                    color: Colors.white,
                                                  )),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors
                                                    .blue, // Change the button color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0), // Adjust the border radius
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // container ends
                                  ],
                                ),
                              ),
                            );
                          })
                    ]),
              ),
            ),
          ),
        ),
        // circular progress bar
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.red), // Color of the progress indicator
              strokeWidth: 2.58 * asr, // Thickness of the progress indicator
              backgroundColor: Colors.black.withOpacity(
                  0.5), // Background color of the progress indicator
            ),
          ),
      ],
    ));
  }
}
