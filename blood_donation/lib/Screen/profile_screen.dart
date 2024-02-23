import 'dart:convert';
import 'package:blood_donation/Screen/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // for phone make
import 'package:share/share.dart'; // Import the share package
import 'package:blood_donation/api/api.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class Profile extends StatefulWidget {
  final int donorId; // receiving id of user

  const Profile({Key? key, required this.donorId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> loadingProfile = {};
  Map<String, dynamic> loadingUserData = {};

  int donorId = 0;
  String profilePic = '';
  String fullName = '';
  String dob = '';
  String gender = '';
  String bloodGroup = '';
  int province = 0;
  String district = '';
  String localLevel = '';
  int wardNo = 0;
  String phone = '';
  String email = '';
  String canDonate = '';
  String accountType = '';
  String address = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch matched results when the widget is created
    loadProfile().then((_) {
      // After loadProfile is complete, call retrieveDonationHistory
      retrieveDonationHistory();
    });
  }

  loadProfile() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'donorId': widget.donorId,
    };

    var res = await CallApi().postData(data, 'LoadProfile');

    if (res.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);

        // print('API Response: $jsonResponse');

        final Map<String, dynamic> profileData = jsonResponse['profileData'];
        final Map<String, dynamic> userData = jsonResponse['regUserData'];

        setState(() {
          loadingUserData = userData;
          loadingProfile = profileData;
          isLoading = false;

          donorId = loadingProfile['donorId'] ?? 0;
          profilePic = loadingProfile['profilePic'] ?? '';
          fullName = loadingProfile['fullName'] ?? '';
          dob = loadingProfile['dob'] ?? '';
          gender = loadingProfile['gender'] ?? '';
          bloodGroup = loadingProfile['bloodGroup'] ?? '';
          province = loadingProfile['province'] ?? 0;
          district = loadingProfile['district'] ?? '';
          localLevel = loadingProfile['localLevel'] ?? '';
          wardNo = loadingProfile['wardNo'] ?? 0;
          phone = loadingProfile['phone'] ?? '';
          email = loadingProfile['email'] ?? 'N/A';
          canDonate = loadingProfile['canDonate'] ?? '';
          accountType = loadingUserData['accountType'] ?? 'Guest';
          address = "$localLevel $wardNo, $district, P-$province";
        });
      } catch (e) {
        //print('Error decoding API response: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      //print('API request failed with status code: ${res.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

// function to load donation history
  bool lastDonationExceeds72Days = false;
  List<dynamic> donationHistory = [];
  int totalDonationTimesForDonor = 0;

  retrieveDonationHistory() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'doId': widget.donorId,
    };

    final res = await CallApi()
        .retrieveDonationHistory(data, 'RetrieveDonationHistory');
    if (res.statusCode == 200) {
      final donationData = jsonDecode(res.body);

      setState(() {
        donationHistory = donationData['donationHistory'];
        lastDonationExceeds72Days = donationData['lastDonationExceeds72Days'];
        totalDonationTimesForDonor = donationData['totalDonationTimes'];

        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

// Function to make a phone call
  _makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch(phoneNumber)) {
      // ignore: deprecated_member_use
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to share content
  void shareContent() {
    Share.share('Check out this amazing content!');
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidUrl = Uri.tryParse(profilePic)?.isAbsolute ?? false;

    // Access the UserProvider
    UserProvider userProvider = Provider.of<UserProvider>(context);
    Text('User ID: ${userProvider.userId}');

    String editBtnText; // Declare the variable here
    // Determine the text for the edit button based on conditions

    if (userProvider.accountType == 'Member' &&
        userProvider.donorId != donorId) {
      editBtnText = "Back";
    } else if (userProvider.accountType == 'Member' &&
        userProvider.donorId == donorId) {
      editBtnText = "Edit";
    } else if ((userProvider.accountType == 'Admin' ||
            userProvider.accountType == 'SuperAdmin') &&
        userProvider.donorId == donorId) {
      editBtnText = "Edit";
    } else if ((userProvider.accountType == 'Admin' ||
            userProvider.accountType == 'SuperAdmin') &&
        accountType == "Guest") {
      editBtnText = "Edit";
    } else {
      editBtnText = "Back";
    }

    /*
    if (userProvider.accountType == 'Member' &&
        userProvider.donorId == donorId) {
      editBtnText = "Edit";
    } else if (userProvider.accountType == 'Admin' &&
        userProvider.donorId == donorId) {
      editBtnText = "Edit";
    } else if (userProvider.accountType == 'Admin' &&
        userProvider.donorId != donorId) {
      editBtnText = "Edit";
    } else if (userProvider.accountType == 'SuperAdmin' &&
        userProvider.donorId == donorId) {
      editBtnText = "Edit";
    } else if (userProvider.accountType == 'Admin' &&
        userProvider.donorId != donorId) {
      editBtnText = "Edit";
    } else {
      editBtnText = "Back";
    }
    */

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          title: Text(
            'Profile : $donorId',
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF4CAF50),
        ),
        body: Stack(
          children: <Widget>[
            // background Color
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF444242),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(35.0),
                              bottomRight: Radius.circular(35.0),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 16.0),
                          child: const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Details of Donor Profile
                        const SizedBox(
                            height: 16.0), // providing vertical spacing
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fullName,
                                  // get name from user database
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xffBF371A),
                                  ),
                                ),

                                //for underline
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
                          padding: const EdgeInsets.symmetric(
                            //horizontal: 16.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //first column starts
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Phone No.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Account Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Blood Group',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Donation Times',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Can Donate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ]),

                              // first column ends

                              //second column starts
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //second column ends

                              //Third Column Starts // Import data from database
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dob,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    accountType,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    bloodGroup,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    totalDonationTimesForDonor.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    totalDonationTimesForDonor == 0
                                        ? canDonate
                                        : (lastDonationExceeds72Days
                                            ? 'No'
                                            : 'Yes'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              ),
                              //Third Column Ends

                              const SizedBox(
                                width: 65.0,
                              ),

                              // Check if 'profilePic' is a valid URL
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: CircleAvatar(
                                  radius: 55.0,

                                  backgroundImage: isValidUrl
                                      ? NetworkImage(profilePic)
                                      : null, // Set to null if 'profilePicUrl' is not a valid URL
                                  child: isValidUrl
                                      ? null // Don't show a child widget if 'profilePicUrl' is a valid URL
                                      : const Icon(
                                          Icons.person,
                                          color: Colors.red,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //making underline
                        Container(
                          height: 2, // Height of the underline
                          color: Colors.white,
                          width: 300.0, // Adjust the width accordingly
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            //horizontal: 16.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              //first column starts
                              const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'E-mail',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ]),

                              // first column ends

                              //second column starts
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //second column ends

                              //Third Column Starts // Import data from database
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    address, // import data for address
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              ),
                              //Third Column Ends
                            ],
                          ),
                        ),

                        //making underline
                        Container(
                          height: 2, // Height of the underline
                          color: Colors.white,
                          width: 300.0, // Adjust the width accordingly
                        ),

                        // DONATION HISTORY RECORDS
                        const SizedBox(height: 16.0),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 200.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF444242),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(35.0),
                                    bottomRight: Radius.circular(35.0),
                                  ),
                                ),
                                padding: const EdgeInsets.only(left: 16.0),
                                child: const Text(
                                  'Donation History',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]),
                        // starting table for donation history first making
                        //Row Headers

                        // for underline
                        Container(
                          height: 1, // Height of the underline
                          color: Colors.white,
                          width:
                              double.infinity, // Adjust the width accordingly
                        ),
/*
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'No. of Pints',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'Hospital',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ]),
                        ),
                        */
                        SizedBox(
                          height: 300, // Adjust height as needed
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Donated Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                  'Donated To',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'No. of Pint',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xffffffff),
                                  ),
                                )),
                              ],
                              rows: donationHistory.map((record) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                    '${record['donatedDate']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['donatedTo']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['bloodPint']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['contact']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),

// DONATION HISTORY RECORDS COMPLETE
                      ],
                    ))),

            // Row of buttons at the bottom
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: double.infinity,
                color: const Color(
                    0xFF4CAF50), // Change the background color as needed

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            //  _makePhoneCall('tel:+977$Concatenate phne number');
                            _makePhoneCall('tel:+977 $phone');
                            // Handle first button press
                          },
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                          label: const Text('Call',
                              style: TextStyle(
                                color: Colors.green,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(
                                0xFFFFFFFF), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            // Handle first button press
                            shareContent(); // Call the share function
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.blue,
                          ),
                          label: const Text('Share',
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(
                                0xFFFFFFFF), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            if (editBtnText == 'Back') {
                              // Pop the current screen if the button text is "Back"
                              Navigator.of(context).pop();
                            } else {
                              // Navigate to the new screen here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                      passedDonorId:
                                          donorId), //passing user id to profile screen
                                ),
                              );
                            }
                            // Handle first button press
                          },
                          icon: const Icon(
                            Icons.edit_document,
                            color: Colors.red,
                          ),
                          label: Text(editBtnText,
                              style: const TextStyle(
                                color: Colors.red,
                              )),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(
                                0xFFFFFFFF), // Change the button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                  strokeWidth: 5.0,
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
          ],
        ));
  }
}
