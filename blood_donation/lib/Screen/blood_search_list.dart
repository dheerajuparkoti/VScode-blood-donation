// ignore_for_file: unnecessary_const
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:blood_donation/Screen/profile_screen.dart';
import 'package:blood_donation/api/api.dart';

class BloodSearchList extends StatefulWidget {
  final Map<String, dynamic> searchCriteriaData; // importing user search input
  const BloodSearchList({Key? key, required this.searchCriteriaData})
      : super(key: key);

  @override
  State<BloodSearchList> createState() => _BloodSearchListState();
}

class _BloodSearchListState extends State<BloodSearchList> {
  List<Map<String, dynamic>> matchedResults = [];
  List<Map<String, dynamic>> matchedUserData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch matched results when the widget is created
    fetchResults(widget.searchCriteriaData);
  }

  void fetchResults(Map<String, dynamic> searchCriteriaData) async {
    setState(() {
      isLoading = true;
    });
    // Call your API to get matched results here
    // Replace 'YourApiCall' with your actual API call
    var res = await CallApi().postData(searchCriteriaData, 'searchBlood');

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      final List<dynamic> data = jsonResponse['data'];
      final List<dynamic> userData = jsonResponse['regUserData'];

      setState(() {
        matchedResults = List<Map<String, dynamic>>.from(data);
        matchedUserData = List<Map<String, dynamic>>.from(userData);

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

    return Scaffold(
        // backgroundColor: const Color(0xffF00808),
        /*
        appBar: AppBar(
          title: const Text(
            'Searched Results',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xffBF371A),
        ),
        */
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
          padding: EdgeInsets.only(top: 0.03 * sh),
          child: Container(
              height: 0.04 * sh,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF0025),
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Text(
                  'Searched Results',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 0.025 * sh,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
        ),

        Padding(
          padding: EdgeInsets.only(
            top: 0.08 * sh,
            left: 0.01 * sw,
            right: 0.01 * sw,
            bottom: 0.0,
          ),
          child: Container(
            width: sw,
            height: sh,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 14, 14, 14),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.025 * sh),
                topRight: Radius.circular(0.025 * sh),
                //bottomLeft: Radius.circular(25.0),
                //bottomRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(0.00 * sw),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                            left: 0.03 * sw,
                            bottom: 0,
                            top: 0.025 * sh,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Searched Results : ${matchedResults.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 0.02 * sh,
                              ),
                            ),
                          )),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: matchedResults.length,
                          itemBuilder: (context, index) {
                            final result = matchedResults[index];

                            // Check if 'profilePic' is a valid URL
                            final String profilePicUrl = result['profilePic'];
                            final bool isValidUrl =
                                Uri.tryParse(profilePicUrl)?.isAbsolute ??
                                    false;
                            return InkWell(
                              onTap: () {
                                int passDonorId = int.parse(result['donorId']);
                                // Navigate to the new screen here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                        donorId:
                                            passDonorId), //passing user id to profile screen
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                color: const Color.fromARGB(255, 103, 137, 103),
                                elevation: 0.0,
                                child: Stack(
                                  children: <Widget>[
                                    // for underline
                                    Container(
                                      height:
                                          0.001 * sh, // Height of the underline
                                      color: Colors.white,
                                      //width:300.0, // Adjust the width accordingly
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(0.03 * sw),
                                      child: Row(children: [
                                        CircleAvatar(
                                          radius: 0.05 * sw,
                                          backgroundImage: isValidUrl
                                              ? NetworkImage(
                                                  'https://mobilebloodbanknepal.com/$profilePicUrl')
                                              : null, // Set to null if 'profilePicUrl' is not a valid URL
                                          child: isValidUrl
                                              ? null // Don't show a child widget if 'profilePicUrl' is a valid URL
                                              : const Icon(Icons
                                                  .person), // Show an icon if 'profilePicUrl' is not a valid URL
                                        ),
                                        SizedBox(
                                          width: 0.05 * sw,
                                        ),
                                        // Text('Name: ${result['fullname']}'),
                                        Text(
                                          result['fullname'],
                                          style: const TextStyle(
                                            color: Colors
                                                .white, // Set foreground color (text color)
                                            fontSize: 16.0, // Set font size
                                            // Add more text style properties as needed
                                          ),
                                        ),
                                      ]),
                                    ),
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
              strokeWidth: 0.01 * sw, // Thickness of the progress indicator
              backgroundColor: Colors.black.withOpacity(
                  0.5), // Background color of the progress indicator
            ),
          ),
      ],
    ));
  }
}
