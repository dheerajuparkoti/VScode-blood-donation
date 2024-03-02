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
        //  print('API request failed with status code: ${res.statusCode}');
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
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

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
                  'Donors Available List',
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
            left: 0.03 * sw,
            right: 0.03 * sw,
            bottom: 0.0,
          ),
          child: Container(
            width: sw,
            height: sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.025 * sh),
                topRight: Radius.circular(0.025 * sh),
                //bottomLeft: Radius.circular(25.0),
                //bottomRight: Radius.circular(25.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(0.03 * sw),
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
                              'Available Donors up-to-date : ${donorData.length}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 0.02 * sh,
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
                                      height:
                                          0.001 * sh, // Height of the underline
                                      color: Colors.green,
                                      //width:300.0, // Adjust the width accordingly
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(0.03 * sw),
                                      child: Row(children: [
                                        CircleAvatar(
                                          radius: 0.05 * sw,
                                          backgroundImage: isValidUrl
                                              ? NetworkImage(profilePicUrl)
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
              strokeWidth: 0.01 * sw, // Thickness of the progress indicator
              backgroundColor: Colors.black.withOpacity(
                  0.5), // Background color of the progress indicator
            ),
          ),
      ],
    ));
  }
}
