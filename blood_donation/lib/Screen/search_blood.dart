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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Container(
              height: 300.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF00808),
                    Color(0xffBF371A),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(150.0),
                  bottomRight: Radius.circular(300.0),
                ),
              ),
            ),
            // FOR LOGO

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: SizedBox(
                width: 300.0,
                height: 200.0,
                child: Image.asset(
                  'images/mbblogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

// FROM HERE

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 30.0,
              ),
              //),

              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 600.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                      bottomLeft: Radius.circular(35.0),
                      bottomRight: Radius.circular(35.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    'Search Blood Group By',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),

                          //SEARCH BY Group
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15.0),
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
                                const SizedBox(height: 15.0),

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
                                const SizedBox(height: 15.0),

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
                                const SizedBox(height: 15.0),

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
                                const SizedBox(height: 15.0),

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
                          const SizedBox(height: 15.0),

                          Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
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
                              child: const Center(
                                child: Text(
                                  "Search Now",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),

                          // search button end
                          //search results start

                          const SizedBox(height: 15.0),
                          const Text(
                            'Searched results', // import total members from database
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color(0xffaba7a7),
                            ),
                          ),

                          const SizedBox(height: 5.0),

                          Text(
                            '$searchResultcount', // import count number from database as per matched query
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFF0025),
                            ),
                          ),

                          // view searched results button

                          const SizedBox(height: 5.0),
                          Container(
                            height: 20,
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
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
                              child: const Center(
                                child: Text(
                                  "View Search Results",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
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
                  strokeWidth: 5.0, // Thickness of the progress indicator
                  backgroundColor: Colors.black.withOpacity(
                      0.5), // Background color of the progress indicator
                ),
              ),
          ],
        ));
  }
}
