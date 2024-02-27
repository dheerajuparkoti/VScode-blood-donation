import 'dart:convert';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyRequest extends StatefulWidget {
  final int notificationErId;

  const EmergencyRequest({Key? key, required this.notificationErId})
      : super(key: key);

  @override
  State<EmergencyRequest> createState() => _EmergencyRequestState();
}

class _EmergencyRequestState extends State<EmergencyRequest>
    with AutomaticKeepAliveClientMixin {
  //late UserProvider userProvider; // Declare userProvider
  UserProvider? userProvider; // Declare userProvider as nullable
  bool isLoading = true; // for circular progress bar

//load emergency Requests

/*
  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    loadEmergencyRequests();
    erAvailableDonors(reqId);
  }
*/

  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    // Load emergency requests after userProvider is initialized
    loadEmergencyRequests();
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

  // loading Emergency Requestsssss

  List<dynamic> loadingEmergencyRequests = [];
  Map<int, int> donorCounts = {};

  Future<void> loadEmergencyRequests() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    var res = await CallApi().loadAllMyRequests({}, 'LoadEmergencyRequests');

    if (res.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        // Use null-aware operator to handle the case where the key is not present or is null
        final List<dynamic> emergencyRequests =
            jsonResponse['emergencyRequestBloods'];

        setState(() {
          loadingEmergencyRequests = emergencyRequests;
          donorCounts = _parseDonorCounts(jsonResponse['donorCounts']);
          isLoading = false; // Set loading to false after data is loaded
        });
      } catch (e) {
        //print('Error decoding API response: $e');
        isLoading = false; // Ensure to set loading to false on error
      }
    } else {
      // Handle different status codes appropriately
      // print('API request failed with status code: ${res.statusCode}');
      isLoading = false; // Ensure to set loading to false on error
    }
  }

  Map<int, int> _parseDonorCounts(dynamic donorCountsJson) {
    Map<int, int> parsedDonorCounts = {};
    if (donorCountsJson is Map) {
      donorCountsJson.forEach((key, value) {
        parsedDonorCounts[int.tryParse(key) ?? 0] = value;
      });
    }
    return parsedDonorCounts;
  }

// end of emergency Requests

// Sending data to emergency_request_available_donors when Im available button clicked

  erAvailableDonors(int reqId) async {
    if (userProvider != null) {
      var data = {
        'erAvailableId': reqId,
        'donorAvailableId': userProvider!.donorId,
      };

      var res = await CallApi().erDonors(data,
          'erAvailableDonors'); //this is method name defined in controller and api.php route

      // Check if the response is not null
      if (res != null) {
        var body = jsonDecode(res.body);
        // print('Response body: $body'); // Print the response body for debugging

        // Check if 'success' key exists and is not null
        if (body.containsKey('success') && body['success'] != null) {
          // Check if 'success' is a boolean
          if (body['success'] is bool && body['success']) {
            // print('Request successful!'); // Request was successful
          } else {
            // Handle the case where 'success' is not true
            //print('Request failed: ${body['message']}'); // Print error message
          }
        } else {
          // Handle the case where 'success' key is missing or null
          // print('Invalid response format: Missing or null "success" key.');
        }
      } else {
        // Handle the case where the response is null
        // print('Null response received.');
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  String _formatTimeFromDatabase(String timeString) {
    TimeOfDay timeOfDay = _convertTimeStringToTimeOfDay(timeString);

    // Format time to 12-hour format with AM/PM
    return DateFormat('h:mm a').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute,
    ));
  }

  TimeOfDay _convertTimeStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    super.build(context);

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(children: [
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
                color: Colors.green,
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Text(
                  '"Donate Blood Save Life Now"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.39 * asr,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
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
                topLeft: Radius.circular(5.1 * asr),
                topRight: Radius.circular(5.1 * asr),
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                        left: 5.1 * asr,
                        bottom: 0,
                        top: 0.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Total E-Requests : ${loadingEmergencyRequests.length}',
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
                      itemCount: loadingEmergencyRequests.length,
                      itemBuilder: (context, index) {
                        final emergencyData = loadingEmergencyRequests[index];
                        final int emergencyRequestId =
                            emergencyData['emergencyRequestId'] ?? 0;
                        final int donorCount =
                            donorCounts[emergencyRequestId] ?? 0;

                        return SizedBox(
                          height: 147.9 * asr,
                          child: Card(
                            margin: const EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            elevation: 0.51 * asr,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // First Row Container
                                Container(
                                  height: 15.5 * asr,
                                  padding: EdgeInsets.all(2.58 * asr),
                                  color: const Color(0xFF444242),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '# E- Request : ${emergencyData['emergencyRequestId']}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Required Blood: ${emergencyData['bloodGroup']}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),

                                // Second Row Container

                                Container(
                                  height: 107.1 * asr,
                                  padding: EdgeInsets.all(5.1 * asr),
                                  color: Colors.white,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Patient Name : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['fullName']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Required Pint : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['requiredPint']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Case Detail : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['caseDetail']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Contact Person : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['contactPersonName']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Phone : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['contactNo']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Hospital : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['hospitalName']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Address : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              '${emergencyData['localLevel']}-${emergencyData['wardNo']}, ${emergencyData['district']}, Pro. ${emergencyData['province']}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Date & Time : ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              //  '${emergencyData['requiredDate']}, ${emergencyData['requiredTime']}',
                                              '${emergencyData['requiredDate']}, ${_formatTimeFromDatabase(emergencyData['requiredTime'])}',

                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Donors Available Up-to-date: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 6.2 * asr),
                                            ),
                                            Text(
                                              donorCount.toString(),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 6.2 * asr),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Third Row Container

                                Container(
                                  height: 20.4 * asr,
                                  padding: EdgeInsets.all(1.5 * asr),
                                  color: const Color(0xFF8CC653),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            makePhoneCall(
                                                'tel:+977 ${emergencyData['contactNo']}');
                                          },
                                          icon: Icon(
                                            Icons.phone,
                                            size: 7.23 * asr,
                                            color: Colors.green,
                                          ),
                                          label: Text('Call',
                                              style: TextStyle(
                                                fontSize: 6.2 * asr,
                                                color: Colors.green,
                                              )),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xffFFFFFF), // Change the button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
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
                                              '"\t Emergency Blood Request Info For" \n'
                                              'Patient: ${emergencyData['fullName']}\n'
                                              'Required Pint: ${emergencyData['requiredPint']}\n'
                                              'Case Detail: ${emergencyData['caseDetail']}\n'
                                              'Contact Person: ${emergencyData['contactPersonName']}\n'
                                              'tel: +977 ${emergencyData['contactNo']}\n'
                                              'Hospital: ${emergencyData['hospitalName']}\n'
                                              'Address: ${emergencyData['localLevel']} - ${emergencyData['wardNo']}, ${emergencyData['district']},Pro. ${emergencyData['province']}\n'
                                              'Date & Time : ${emergencyData['requiredDate']}, ${_formatTimeFromDatabase(emergencyData['requiredTime'])}\n'
                                              'App: Mobile Blood Bank Nepal',
                                            );
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            size: 7.23 * asr,
                                            color: Colors.blue,
                                          ),
                                          label: Text('Share',
                                              style: TextStyle(
                                                fontSize: 6.2 * asr,
                                                color: Colors.blue,
                                              )),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xffFFFFFF), // Change the button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  0.0), // Adjust the border radius
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 1.29 * asr),
                                      Expanded(
                                        flex: 2,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            // Call erAvailableDonors only if userProvider is initialized
                                            if (userProvider != null) {
                                              int reqId = emergencyData[
                                                  'emergencyRequestId'];
                                              erAvailableDonors(reqId);
                                            }
                                            /*
                                            //make entry
                                            int reqId = emergencyData[
                                                'emergencyRequestId'];

                                            erAvailableDonors(reqId);
                                            */
                                            // Call onPressedButton with reqId
                                          },
                                          icon: Icon(
                                            Icons.waving_hand,
                                            size: 7.23 * asr,
                                            color: Colors.red,
                                          ),
                                          label: Text("I'm Available",
                                              style: TextStyle(
                                                fontSize: 6.2 * asr,
                                                color: Colors.red,
                                              )),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(
                                                0xffFFFFFF), // Change the button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  0.0), // Adjust the border radius
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              )
                  //content for my request

                  ),
            ),
          ),
        ),
        //end of other request i.e 3rd tab

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
      ]),
    );
  }
}
