import 'dart:convert';

import 'package:blood_donation/api/api.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class AmbulanceSearchList extends StatefulWidget {
  final Map<String, dynamic> searchCriteriaData; // importing user search input
  const AmbulanceSearchList({Key? key, required this.searchCriteriaData})
      : super(key: key);

  @override
  State<AmbulanceSearchList> createState() => _AmbulanceSearchListState();
}

class _AmbulanceSearchListState extends State<AmbulanceSearchList> {
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
    var res = await CallApi().postData(searchCriteriaData, 'LoadAmbulanceInfo');

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      final List<dynamic> data = jsonResponse['data'];

      setState(() {
        matchedResults = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          padding: const EdgeInsets.only(top: 30.0),
          child: Container(
              height: 30,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF0025),
                borderRadius: BorderRadius.only(),
              ),
              child: const Center(
                child: Text(
                  'Searched Ambulance Results',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 70.0,
            left: 1.0,
            right: 1.0,
            bottom: 0.0,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                //bottomLeft: Radius.circular(25.0),
                //bottomRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            bottom: 0,
                            top: 10.0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Searched Results : ${matchedResults.length}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
                              height: 100,
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
                                      height: 1.0, // Height of the underline
                                      color: Colors.red,
                                      //width:300.0, // Adjust the width accordingly
                                    ),
                                    //First Row container
                                    Container(
                                      height: 53.0,
                                      padding: const EdgeInsets.all(5.0),
                                      color: const Color(0xFFFFFFFF),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              capitalizedItem,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 1, 1, 1),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    //Second  Row container

                                    Container(
                                      height: 40.0,
                                      padding: const EdgeInsets.all(5.0),
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
                                              icon: const Icon(
                                                Icons.phone,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                              label: const Text('Call',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
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
                                          const SizedBox(width: 2.5),
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: () {
                                                shareContent(
                                                  '"Ambulance Info" \n'
                                                  '$capitalizedItem\n'
                                                  'Address: ${result['localLevel']} - ${result['wardNo']}, ${result['district']},Province: ${result['province']}\n'
                                                  'tel: +977 ${result['contactNo']}\n'
                                                  'App: Mobile Blood Bank Nepal',
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.share,
                                                size: 16.0,
                                                color: Colors.white,
                                              ),
                                              label: const Text('Share',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
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
              strokeWidth: 5.0, // Thickness of the progress indicator
              backgroundColor: Colors.black.withOpacity(
                  0.5), // Background color of the progress indicator
            ),
          ),
      ],
    ));
  }
}
