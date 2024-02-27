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
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double asr = sh / sw;
    super.build(context);
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFD3B5B5),
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
                  bottomRight: Radius.circular(103.3 * asr),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.33 * asr,
                vertical: 10.33 * asr,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.1 * asr),
                    topRight: Radius.circular(18.1 * asr),
                    bottomLeft: Radius.circular(18.1 * asr),
                    bottomRight: Radius.circular(18.1 * asr),
                  ),
                ),
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(170, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.1 * asr),
                        topRight: Radius.circular(18.1 * asr),
                        // bottomLeft: Radius.circular(35.0),
                        // bottomRight: Radius.circular(35.0),
                      ),
                    ),

                    // Set to transparent
                    padding: EdgeInsets.only(top: 5.1 * asr, bottom: 5.1 * asr),

                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.75 * asr),
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
                                            'Search Blood Bank Info By',
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
                                        SizedBox(height: 7.75 * asr),

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
                                        SizedBox(height: 7.75 * asr),

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
                                        SizedBox(height: 7.75 * asr),

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
                                  SizedBox(height: 7.75 * asr),
                                  Container(
                                    height: 20.4 * asr,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(25.75 * asr),
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
                                      fontSize: 7.75 * asr,
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

                                  SizedBox(height: 2.58 * asr),
                                  Container(
                                    height: 10.33 * asr,
                                    width: 77.5 * asr,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12.9 * asr),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(25.75 * asr),
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
                                      child: Center(
                                        child: Text(
                                          "View Search Results",
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 7.23 * asr,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.white,
                                            decorationThickness: 1.03 * asr,
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.5 * asr,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 2.58 * asr),
                                      Text(
                                        '[Note: Only Admins are allow to fill the new blood bank details form.]',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFF44336),
                                          fontSize: 8.26 * asr,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),

                                      SizedBox(height: 2.58 * asr),
                                      TextField(
                                        controller: nameCont,
                                        decoration: const InputDecoration(
                                          hintText: "*Blood Bank Name",
                                          hintStyle: TextStyle(
                                              color: Color(0xffaba7a7)),
                                        ),
                                        maxLength: 30,
                                      ),
                                      SizedBox(height: 2.58 * asr),

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
                                      SizedBox(height: 12.24 * asr),

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
                                      SizedBox(height: 12.24 * asr),

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
                                      SizedBox(height: 10.33 * asr),

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
                                      SizedBox(height: 15.5 * asr),
                                      Container(
                                        height: 25.75 * asr,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12.9 * asr),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              25.75 * asr),
                                          color: const Color(0xffFF0025),
                                        ),
                                        //calling insert function when button is pressed
                                        child: InkWell(
                                          onTap: () {
                                            // validationFields();
                                          },
                                          child: Center(
                                            child: Text(
                                              "Add Data",
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 9.30 * asr),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15.5 * asr),
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
