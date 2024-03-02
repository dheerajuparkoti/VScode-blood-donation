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
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 20.4 * asr,
          title: Text(
            'Profile : $donorId',
            style: TextStyle(
              fontSize: 10.33 * asr,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.26 * asr,
                      vertical: 8.26 * asr,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 15.5 * asr,
                          width: 51.5 * asr,
                          decoration: BoxDecoration(
                            color: const Color(0xFF444242),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18.1 * asr),
                              bottomRight: Radius.circular(18.1 * asr),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 8.26 * asr),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 10.33 * asr,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Details of Donor Profile
                        SizedBox(
                            height: 8.26 * asr), // providing vertical spacing
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fullName,
                                  // get name from user database
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.33 * asr,
                                    color: const Color(0xffBF371A),
                                  ),
                                ),

                                //for underline
                                Container(
                                  height: 1.03 * asr, // Height of the underline
                                  color: Colors.white,
                                  width:
                                      0.9 * sw, // Adjust the width accordingly
                                ),
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            //horizontal: 8.26*asr,
                            vertical: 3.06 * asr,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //first column starts
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Date of Birth',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Phone No.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Account Type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Blood Group',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Donation Times',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'Can Donate',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ]),

                              // first column ends

                              //second column starts
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5.1 * asr),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
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
                                    style: TextStyle(
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    accountType,
                                    style: TextStyle(
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    bloodGroup,
                                    style: TextStyle(
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    totalDonationTimesForDonor.toString(),
                                    style: TextStyle(
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    totalDonationTimesForDonor == 0
                                        ? canDonate
                                        : (lastDonationExceeds72Days
                                            ? 'No'
                                            : 'Yes'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              ),
                              //Third Column Ends

                              SizedBox(
                                width: 10.0 * asr,
                              ),

                              // Check if 'profilePic' is a valid URL
                              Padding(
                                padding: EdgeInsets.only(right: 2.58 * asr),
                                child: CircleAvatar(
                                  radius: 0.12 * sw,

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
                          height: 1.03 * asr, // Height of the underline
                          color: Colors.white,
                          width: 155 * asr, // Adjust the width accordingly
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            //horizontal: 8.26*asr,
                            vertical: 3.06 * asr,
                          ),
                          child: Row(
                            children: [
                              //first column starts
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      'E-mail',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ]),

                              // first column ends

                              //second column starts
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5.1 * asr),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    Text(
                                      ':',
                                      style: TextStyle(
                                        fontSize: 6.2 * asr,
                                        color: const Color(0xffffffff),
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
                                    style: TextStyle(
                                      fontSize: 0.013 * sh,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 0.013 * sh,
                                      color: const Color(0xffffffff),
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
                          height: 1.03 * asr, // Height of the underline
                          color: Colors.white,
                          width: 155 * asr, // Adjust the width accordingly
                        ),

                        // DONATION HISTORY RECORDS
                        SizedBox(height: 8.26 * asr),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 15.5 * asr,
                                width: 103.3 * asr,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF444242),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18.1 * asr),
                                    bottomRight: Radius.circular(18.1 * asr),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 8.26 * asr),
                                child: Text(
                                  'Donation History',
                                  style: TextStyle(
                                    fontSize: 10.33 * asr,
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
                          height: 0.51 * asr, // Height of the underline
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
                                    fontSize: 6.2*asr,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'No. of Pints',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2*asr,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'Hospital',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2*asr,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2*asr,
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
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'Donated Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                  'Donated To',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2 * asr,
                                    color: const Color(0xffffffff),
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'No. of Pint',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2 * asr,
                                    color: const Color(0xffffffff),
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Contact',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 6.2 * asr,
                                    color: const Color(0xffffffff),
                                  ),
                                )),
                              ],
                              rows: donationHistory.map((record) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                    '${record['donatedDate']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['donatedTo']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['bloodPint']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
                                    ),
                                  )),
                                  DataCell(Text(
                                    '${record['contact']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 6.2 * asr,
                                      color: const Color(0xffffffff),
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
                  padding: EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 2.58 * asr),
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
                                  5.1 * asr), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.58 * asr),
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
                                  5.1 * asr), // Adjust the border radius
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.58 * asr),
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
                                  5.1 * asr), // Adjust the border radius
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
                  strokeWidth: 2.58 * asr,
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
          ],
        ));
  }
}
