import 'dart:convert';

import 'package:blood_donation/Screen/profile_screen.dart';
import 'package:blood_donation/api/api.dart';
import 'package:flutter/material.dart';

class AvailableListView extends StatefulWidget {
  final int passedId; // receiving id of user
  final String requestType; // receiving requestType
  const AvailableListView(
      {Key? key, required this.passedId, required this.requestType})
      : super(key: key);

  @override
  State<AvailableListView> createState() => _AvailableListViewState();
}

class _AvailableListViewState extends State<AvailableListView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch matched results when the widget is created
    fetchResults();
  }

  List<dynamic> donorData = [];

  void fetchResults() async {
    setState(() {
      isLoading = true;
    });

    if (widget.requestType == 'request') {
      var data = {
        'rAvailableId': widget.passedId,
      };
      var res = await CallApi().postData(data, 'rAvailableDonorList');
      if (res.statusCode == 200) {
        setState(() {
          donorData = json.decode(res.body);
          isLoading = false;
        });
      } else {
        print('API request failed with status code: ${res.statusCode}');
        isLoading = false;
      }
    } else if (widget.requestType == 'emergency') {
      var data = {
        'erAvailableId': widget.passedId,
      };
      var res = await CallApi().postData(data, 'erAvailableDonorList');
      if (res.statusCode == 200) {
        setState(() {
          donorData = json.decode(res.body);
          isLoading = false;
        });
      } else {
        // Handle error response
      }
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
                  'Searched Results',
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
                            top: 0.0,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Searched Results : ${donorData.length}',
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
                          itemCount: donorData.length,
                          itemBuilder: (context, index) {
                            var result = donorData[index];

                            // Check if 'profilePic' is a valid URL
                            final String profilePicUrl = result['profilePic'];
                            final bool isValidUrl =
                                Uri.tryParse(profilePicUrl)?.isAbsolute ??
                                    false;
                            return InkWell(
                              onTap: () {
                                // Navigate to the new screen here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                        donorId: result[
                                            'donorAvailableId']), //passing user id to profile screen
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                elevation: 0.0,
                                child: Stack(
                                  children: <Widget>[
                                    // for underline
                                    Container(
                                      height: 1.0, // Height of the underline
                                      color: Colors.green,
                                      //width:300.0, // Adjust the width accordingly
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(children: [
                                        CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage: isValidUrl
                                              ? NetworkImage(profilePicUrl)
                                              : null, // Set to null if 'profilePicUrl' is not a valid URL
                                          child: isValidUrl
                                              ? null // Don't show a child widget if 'profilePicUrl' is a valid URL
                                              : const Icon(Icons
                                                  .person), // Show an icon if 'profilePicUrl' is not a valid URL
                                        ),
                                        const SizedBox(
                                          width: 25.0,
                                        ),
                                        // Text('Name: ${result['fullname']}'),
                                        Text(result['fullname']),
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
              strokeWidth: 5.0, // Thickness of the progress indicator
              backgroundColor: Colors.black.withOpacity(
                  0.5), // Background color of the progress indicator
            ),
          ),
      ],
    ));
  }
}
