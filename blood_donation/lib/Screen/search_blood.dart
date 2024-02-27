import 'dart:convert';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/api/api.dart';
import 'package:blood_donation/Screen/blood_search_list.dart';

class SearchBloodGroup extends StatefulWidget {
  const SearchBloodGroup({super.key});

  @override
  State<SearchBloodGroup> createState() => _SearchBloodGroupState();
}

class _SearchBloodGroupState extends State<SearchBloodGroup> {
  String? selectedBloodGroup;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;
  TextEditingController wardNoController = TextEditingController();
  int searchResultcount = 0;
  bool isLoading = false;

  searchBlood() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'bloodGroup': selectedBloodGroup,
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text.trim(),
    };

    var res = await CallApi()
        .postData(data, 'SearchBlood'); //test is table name for api
    if (res.statusCode == 200) {
      // Parse the response and update the UI with the count
      //final count = int.parse(res.body);
      // Parse the entire JSON response
      final Map<String, dynamic> jsonResponse = json.decode(res.body);
      // Extract the count from the parsed JSON
      final count = jsonResponse['count'];

      setState(() {
        searchResultcount = count;
        isLoading = false;
      });
    } else {
      // No internet connection
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );
      isLoading = false;
    }

/*
    // Check if the response is not null
    if (res != null) {
      var body = jsonDecode(res.body);
      print('Response body: $body'); // Print the response body for debugging

      // Check if 'success' key exists and is not null
      if (body.containsKey('success') && body['success'] != null) {
        // Check if 'success' is a boolean
        if (body['success'] is bool && body['success']) {
          // Parse the response and update the UI with the count
          final count = int.parse(res.body);
          setState(() {
            searchResultcount = count;
          });
          print(searchResultcount);
        } else {
          // Handle the case where 'success' is not true
          print('Searching Failed failed.');
        }
      } else {
        // Handle the case where 'success' key is missing or null
        print('Invalid response format: Missing or null "success" key.');
      }
    } else {
      // Handle the case where the response is null
      print('Null response received.');
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Container(
              height: 155 * asr,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF00808),
                    Color(0xffBF371A),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(77.5 * asr),
                  bottomRight: Radius.circular(155 * asr),
                ),
              ),
            ),
            // FOR LOGO

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15.5 * asr, vertical: 7.75 * asr),
              child: SizedBox(
                width: 155 * asr,
                height: 103.3 * asr,
                child: Image.asset(
                  'images/mbblogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

// FROM HERE

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.5 * asr,
                vertical: 15.5 * asr,
              ),
              //),

              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 306 * asr,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.1 * asr),
                      topRight: Radius.circular(18.1 * asr),
                      bottomLeft: Radius.circular(18.1 * asr),
                      bottomRight: Radius.circular(18.1 * asr),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    'Search Blood Group By',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10.33 * asr,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),

                          //SEARCH BY Group
                          Padding(
                            padding: EdgeInsets.only(
                                left: 7.75 * asr,
                                right: 7.75 * asr,
                                top: 7.75 * asr),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                //DROPDOWN BLOOD GROUP
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    hintText: 'Select blood Group',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xffaba7a7)),
                                  ),
                                  value: selectedBloodGroup,
                                  items: [
                                    'A+',
                                    'B+',
                                    'O+',
                                    'A-',
                                    'B-',
                                    'O-',
                                    'AB+',
                                    'AB-',
                                  ].map((bloodGroup) {
                                    return DropdownMenuItem<String>(
                                      value: bloodGroup,
                                      child: Text('Blood Group $bloodGroup'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBloodGroup = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 7.75 * asr),

                                //DROPDOWN PROVINCE
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    hintText: 'Select Province',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xffaba7a7)),
                                  ),
                                  value: selectedProvince,
                                  items: ['1', '2', '3', '4', '5', '6', '7']
                                      .map((province) {
                                    return DropdownMenuItem<String>(
                                      value: province,
                                      child: Text('Province $province'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedProvince = value;
                                      // Reset selected values for subsequent dropdowns
                                      selectedDistrict = null;
                                      selectedLocalLevel = null;
                                    });
                                  },
                                ),
                                SizedBox(height: 7.75 * asr),

                                // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    hintText: 'Select District',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xffaba7a7)),
                                  ),
                                  value: selectedDistrict,
                                  items: selectedProvince != null
                                      ? DistrictData
                                          .districtList[selectedProvince!]!
                                          .map((district) {
                                          return DropdownMenuItem<String>(
                                            value: district,
                                            child: Text(district),
                                          );
                                        }).toList()
                                      : [],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDistrict = value;
                                      selectedLocalLevel = null;
                                    });
                                  },
                                ),
                                SizedBox(height: 7.75 * asr),

                                // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffaba7a7)),
                                    ),
                                    hintText: 'Select Local Level',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xffaba7a7)),
                                  ),
                                  value: selectedLocalLevel,
                                  items: selectedDistrict != null
                                      ? DistrictData
                                          .localLevelList[selectedDistrict!]!
                                          .map((locallevel) {
                                          return DropdownMenuItem<String>(
                                            value: locallevel,
                                            child: Text(locallevel),
                                          );
                                        }).toList()
                                      : [],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLocalLevel = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 7.75 * asr),

                                TextField(
                                  controller: wardNoController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: "Ward No.",
                                    hintStyle:
                                        TextStyle(color: Color(0xffaba7a7)),
                                  ),
                                  maxLength: 2,
                                ),
                              ],
                            ),
                          ),
                          // end of selection search

                          // Making Search button
                          SizedBox(height: 7.75 * asr),

                          Container(
                            height: 20.4 * asr,
                            margin:
                                EdgeInsets.symmetric(horizontal: 12.9 * asr),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.75 * asr),
                              color: const Color(0xffFF0025),
                            ),
                            //calling insert function when button is pressed
                            child: InkWell(
                              onTap: () {
                                if (selectedBloodGroup == null) {
                                } else {
                                  searchBlood();
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Search Now",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 8.26 * asr),
                                ),
                              ),
                            ),
                          ),

                          // search button end
                          //search results start

                          SizedBox(height: 7.75 * asr),
                          Text(
                            'Searched results', // import total members from database
                            style: TextStyle(
                              fontSize: 7.23 * asr,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xffaba7a7),
                            ),
                          ),

                          SizedBox(height: 2.58 * asr),

                          Text(
                            '$searchResultcount', // import count number from database as per matched query
                            style: TextStyle(
                              fontSize: 15.5 * asr,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xffFF0025),
                            ),
                          ),

                          // view searched results button

                          SizedBox(height: 2.58 * asr),
                          Container(
                            height: 10.33 * asr,
                            width: 77.5 * asr,
                            margin:
                                EdgeInsets.symmetric(horizontal: 12.9 * asr),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.75 * asr),
                              color: const Color(0xffFF0025),
                            ),
                            //calling insert function when button is pressed
                            child: InkWell(
                              onTap: searchResultcount != 0
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BloodSearchList(
                                              searchCriteriaData: {
                                                'bloodGroup':
                                                    selectedBloodGroup,
                                                'province': selectedProvince,
                                                'district': selectedDistrict,
                                                'localLevel':
                                                    selectedLocalLevel,
                                                'wardNo': wardNoController.text,
                                              }),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  "View Search Results",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 7.23 * asr,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // ENDING OF ALL  WORKS
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
                  strokeWidth:
                      2.58 * asr, // Thickness of the progress indicator
                  backgroundColor: Colors.black.withOpacity(
                      0.5), // Background color of the progress indicator
                ),
              ),
          ],
        ));
  }
}
