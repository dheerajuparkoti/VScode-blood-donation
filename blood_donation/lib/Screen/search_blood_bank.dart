import 'package:blood_donation/Screen/blood_bank_search_list.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:blood_donation/data/district_data.dart';
import 'package:blood_donation/api/api.dart';
import 'package:provider/provider.dart';

class SearchBloodBank extends StatefulWidget {
  const SearchBloodBank({super.key});

  @override
  State<SearchBloodBank> createState() => _SearchBloodBankState();
}

class _SearchBloodBankState extends State<SearchBloodBank>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late final UserProvider userProvider; // Declare userProvider
  // for input ambulance data
  bool phoneNumberError = false;
  TextEditingController nameCont = TextEditingController();
  TextEditingController wardNoCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();

  String? selectProvince;
  String? selectDistrict;
  String? selectLocalLevel;
  //

  String? selectedBloodGroup;
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedLocalLevel;
  TextEditingController wardNoController = TextEditingController();
  int searchResultcount = 0;
  bool isLoading = false;

  searchBloodBank() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });

    var data = {
      'province': selectedProvince,
      'district': selectedDistrict,
      'localLevel': selectedLocalLevel,
      'wardNo': wardNoController.text,
    };

    var res = await CallApi().searchBloodBank(
        data, 'LoadBloodBankInfo'); //test is table name for api
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(res.body);

      // Extract the count from the parsed JSON
      final count = jsonResponse['count'];

      setState(() {
        searchResultcount = count;
        isLoading = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      CustomDialog.showAlertDialog(
        context,
        'Network Error',
        'There was an error connecting to the server. Please try again later.',
        Icons.error_outline,
      );

      isLoading = false;
    }
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // Access the UserProvider within initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    // Fetch matched results when the widget is created
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
  }

  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 0) {
      resetDropdowns();
    } else if (_tabController.index == 1) {
      resetSearchDropdowns();
    }
  }

  resetDropdowns() {
    nameCont.clear();
    wardNoCont.clear();
    phoneCont.clear();
    selectProvince = null;
    selectDistrict = null;
    selectLocalLevel = null;
  }

  resetSearchDropdowns() {
    selectedProvince = null;
    selectedDistrict = null;
    selectedLocalLevel = null;
    wardNoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFD3B5B5),
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
                  bottomRight: Radius.circular(200.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                    bottomLeft: Radius.circular(35.0),
                    bottomRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(170, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                        // bottomLeft: Radius.circular(35.0),
                        // bottomRight: Radius.circular(35.0),
                      ),
                    ),

                    // Set to transparent
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),

                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xffFF0025),
                      ),
                      controller: _tabController,
                      //    isScrollable: true, // Make tabs scrollable
                      indicatorSize: TabBarIndicatorSize
                          .tab, // Use indicator size based on tab size
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            "Search Blood Bank",
                            style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Add Blood Bank",
                            style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        physics:
                            const NeverScrollableScrollPhysics(), // prevenet screen to swipe left or right
                        children: [
                          SingleChildScrollView(
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
                                            'Search Blood Bank Info By',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        //DROPDOWN PROVINCE
                                        DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            hintText: 'Select Province',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          value: selectedProvince,
                                          items: [
                                            '1',
                                            '2',
                                            '3',
                                            '4',
                                            '5',
                                            '6',
                                            '7'
                                          ].map((province) {
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
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            hintText: 'Select District',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          value: selectedDistrict,
                                          items: selectedProvince != null
                                              ? DistrictData.districtList[
                                                      selectedProvince!]!
                                                  .map((district) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffaba7a7)),
                                            ),
                                            hintText: 'Select Local Level',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          value: selectedLocalLevel,
                                          items: selectedDistrict != null
                                              ? DistrictData.localLevelList[
                                                      selectedDistrict!]!
                                                  .map((locallevel) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                            hintStyle: TextStyle(
                                                color: Color(0xffaba7a7)),
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0xffFF0025),
                                    ),
                                    //calling insert function when button is pressed
                                    child: InkWell(
                                      onTap: () {
                                        if (selectedProvince == null) {
                                        } else {
                                          searchBloodBank();
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Search Now",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
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

                                  const SizedBox(height: 5.0),
                                  Container(
                                    height: 20,
                                    width: 150,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25),
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
                                                  builder: (context) =>
                                                      BloodBankSearchList(
                                                    searchCriteriaData: {
                                                      'province':
                                                          selectedProvince,
                                                      'district':
                                                          selectedDistrict,
                                                      'localLevel':
                                                          selectedLocalLevel,
                                                      'wardNo':
                                                          wardNoController.text,
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      child: const Center(
                                        child: Text(
                                          "View Search Results",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
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

                          // FOR ADD NEW BLOOD BANK INFO
                          SingleChildScrollView(
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5.0),
                                      const Text(
                                        '[Note: Only Admins are allow to fill the new blood bank details form.]',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF44336),
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                      const SizedBox(height: 5.0),
                                      TextField(
                                        controller: nameCont,
                                        decoration: const InputDecoration(
                                          hintText: "*Blood Bank Name",
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        maxLength: 30,
                                      ),
                                      const SizedBox(height: 5.0),

                                      //DROPDOWN PROVINCE
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          hintText: '*Select Province',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        value: selectedProvince,
                                        items: [
                                          '1',
                                          '2',
                                          '3',
                                          '4',
                                          '5',
                                          '6',
                                          '7'
                                        ].map((province) {
                                          return DropdownMenuItem<String>(
                                            value: province,
                                            child: Text(
                                              'Province $province',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
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
                                      const SizedBox(height: 24.0),

                                      // DROPDOWN DISTRICT LISTS BASED ON PROVINCE
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          hintText: '*Select District',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        value: selectedDistrict,
                                        items: selectedProvince != null
                                            ? DistrictData.districtList[
                                                    selectedProvince!]!
                                                .map((district) {
                                                return DropdownMenuItem<String>(
                                                  value: district,
                                                  child: Text(
                                                    district,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
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
                                      const SizedBox(height: 24.0),

                                      // DROPDOWN FOR LOCAL LEVELS BASEDS ON SELECTED DISTRICTS
                                      DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          hintText: '*Select Local Level',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        value: selectedLocalLevel,
                                        items: selectedDistrict != null
                                            ? DistrictData.localLevelList[
                                                    selectedDistrict!]!
                                                .map((locallevel) {
                                                return DropdownMenuItem<String>(
                                                  value: locallevel,
                                                  child: Text(
                                                    locallevel,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                );
                                              }).toList()
                                            : [],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLocalLevel = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 20.0),

                                      TextField(
                                        controller: wardNoCont,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          hintText: "*Ward No.",
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        maxLength: 2,
                                      ),

                                      TextField(
                                          // controller:_textControllers['phoneNumber'],
                                          controller: phoneCont,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: "*Phone Number",
                                            errorText: phoneNumberError
                                                ? 'Phone number must be 10 digits'
                                                : null,
                                            hintStyle: const TextStyle(
                                                color: Color(0xffaba7a7)),
                                          ),
                                          maxLength: 10,
                                          onChanged: (value) {
                                            setState(() {
                                              // Check if the length of phone number is not 10
                                              phoneNumberError =
                                                  value.length != 10;
                                            });
                                          }),

                                      // Making Add button
                                      const SizedBox(height: 30.0),
                                      Container(
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: const Color(0xffFF0025),
                                        ),
                                        //calling insert function when button is pressed
                                        child: InkWell(
                                          onTap: () {
                                            // validationFields();
                                          },
                                          child: const Center(
                                            child: Text(
                                              "Add Data",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30.0),
                                    ],
                                  )),
                            ]),
                          ),
                        ]),
                  ),
                ]),
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
