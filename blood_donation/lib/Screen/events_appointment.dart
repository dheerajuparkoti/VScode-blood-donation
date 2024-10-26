// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:blood_donation/widget/custom_dialog_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // for date format
import 'package:blood_donation/api/api.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

// for user_id

import '../provider/user_provider.dart';

class EventsAppointments extends StatefulWidget {
  final int? notificationEvId;
  const EventsAppointments({super.key,  this.notificationEvId});

  @override
  State<EventsAppointments> createState() => _EventsAppointmentsState();
}

class _EventsAppointmentsState extends State<EventsAppointments>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  bool isLoading = false; // for circular progress bar
  bool setDateError = false;

  TextEditingController aboutController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  late UserProvider userProvider; // Declare userProvider

  TimeOfDay? setTime;
  TextEditingController setTimeController = TextEditingController();
  late String sqlFriendlyTime = '';
  // Function to convert TimeOfDay to SQL-friendly time format
  String formatTimeForSQL(TimeOfDay timeOfDay) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final String formattedTime = DateFormat.Hms().format(dateTime);
    return formattedTime;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: setTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        setTime = picked;
        setTimeController.text = picked.format(context);
        setTime = picked;
        setTimeController.text = DateFormat('h:mm a').format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        ));

        // Convert and set the SQL-friendly time format to the backend field if needed
        sqlFriendlyTime = formatTimeForSQL(picked);
        // Now you can use sqlFriendlyTime in your data or API calls
      });
    }
  }

  // Submitting Blood Request form

  setAppointment() async {
    if (setTime == null) {
      // If requiredTime is null, call _selectTime to choose a time
      await _selectTime(context);
    }

    var data = {
      'about': aboutController.text.trim(),
      'setDate': setDateController.text.trim(),
      'setTime': sqlFriendlyTime.trim(),
      'remarks': remarksController.text.trim(),
      'doId': userProvider.userId,
    };

    var res = await CallApi().setAppoint(data, 'setAppointment');

    if (res != null) {
      //  var body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        CustomSnackBar.showSuccess(
          context: context,
          message:
              "Appointment details send successfully. we'll response soon. Thank you",
          icon: Icons.check_circle,
        );
        _tabController.animateTo(0);
      } else {
        CustomSnackBar.showUnsuccess(
          context: context,
          message: 'Internal Server Error: Something went wrong',
          icon: Icons.error,
        );
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

//Date Time Picker

  DateTime selectedDate = DateTime.now();
  final TextEditingController setDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        setDateController.text = picked.toString().split(" ")[0];
        _validSelectedDate(setDateController.text);
      });
    }
  }

  bool isValidSelectedDate(String selectedDate) {
    DateTime? selectDate = DateTime.tryParse(selectedDate);
    DateTime currentDate = DateTime.now();

    // Check if DOB is not null and is less than or equal to today's date
    return selectDate != null && selectDate.isAfter(currentDate);
  }

  void _validSelectedDate(String selectedDate) {
    setState(() {
      setDateError = !isValidSelectedDate(selectedDate);
    });
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

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    setTime = TimeOfDay.now();
    loadEvents();
  }

// Load Events
  List<dynamic> loadingEvents = [];

  loadEvents() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to load data
    });
    var data = {
      'donorId': userProvider.donorId,
    };
    var res = await CallApi().loadAllEvents(data, 'loadEvents');

    if (res.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(res.body);
        final List<dynamic> loadedEvents = jsonResponse['responseEvents'];

        setState(() {
          loadingEvents = loadedEvents;

          // Set loading to false after data is loaded
          isLoading = false;
        });
      } catch (e) {
        isLoading = false; // Ensure to set loading to false on error
      }
    } else {
      isLoading = false; // Ensure to set loading to false on error
    }
  }
// End of Load Events

  bool isLiked = false;

// Send Like to Event

  likeEvents(int eventId) async {
    var data = {
      'eventId': eventId,
      'donorId': userProvider.donorId,
    };

    var res = await CallApi().eventLikes(data,
        'likeEvent'); //this is method name defined in controller and api.php route

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        isLiked = !isLiked;
        loadEvents();
      });
    } else {
      // Handle error
      //print('Failed to toggle like status: ${res.statusCode}');
    }
  }

// ending of liking

// sending attend

  bool isAttended = false;
  attendEvents(int eventId) async {
    var data = {
      'eventId': eventId,
      'donorId': userProvider.donorId,
    };

    var res = await CallApi().eventAttends(data,
        'attendEvent'); //this is method name defined in controller and api.php route

    // Check if the response is not null
    if (res.statusCode == 200) {
      setState(() {
        isAttended = !isAttended;
        loadEvents();
      });
    } else {
      // Handle error
      // print('Failed to toggle like status: ${res.statusCode}');
    }
  }

// converted to 12 hour AM/PM format

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
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {});
    if (_tabController.index == 0) {
      aboutController.clear();
      setDateController.clear();
      setTimeController.clear();
      remarksController.clear();
      loadEvents();
    } else if (_tabController.index == 1) {}
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    super.build(context); // to maintain state between two tabs
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD3B5B5),
      body: Stack(
        children: <Widget>[
          Container(
            height: 0.45 * sh,
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
                bottomLeft: Radius.circular(0.25 * sh),
                bottomRight: Radius.circular(0.5 * sh),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.05 * sw,
              vertical: 0.05 * sh,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.05 * sh),
                  topRight: Radius.circular(0.05 * sh),
                  bottomLeft: Radius.circular(0.05 * sh),
                  bottomRight: Radius.circular(0.05 * sh),
                ),
              ),
              child: Column(children: [
                Container(
                  // Set to transparent
                  padding: EdgeInsets.only(
                      top: 0.02 * sh,
                      bottom: 0.02 * sh,
                      left: 0.02 * sw,
                      right: 0.02 * sw),

                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.03 * sh),
                      color: const Color(0xffFF0025),
                    ),
                    controller: _tabController,
                    //    isScrollable: true, // Make tabs scrollable
                    indicatorSize: TabBarIndicatorSize
                        .tab, // Use indicator size based on tab size
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "Events",
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Set Appointment",
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
                      //Code for Events i.e 1st tab

                      SingleChildScrollView(
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                  left: 0.03 * sw,
                                  right: 0.01 * sw,
                                  bottom: 0,
                                  top: 0,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Total Events : ${loadingEvents.length}',
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
                                itemCount: loadingEvents.length,
                                itemBuilder: (context, index) {
                                  final eventData = loadingEvents[index];

                                  return SizedBox(
                                    height: 0.345 * sh,
                                    child: Card(
                                      margin: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      elevation: 0.0012 * sh,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          // First Row Container
                                          Container(
                                            height: 0.037 * sh,
                                            padding: EdgeInsets.all(0.005 * sh),
                                            color: const Color(0xFF444242),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '# Event Id: ${eventData['eventId']}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Second Row Container

                                          Container(
                                            height: 0.245 * sh,
                                            padding: EdgeInsets.all(0.012 * sh),
                                            color: Colors.white,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Event Name : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['eventName']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Venue : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['venue']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Chief Guest : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['chiefGuest']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    Text(
                                                      'Event Details : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 0.015 * sh),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${eventData['eventDetail']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines:
                                                            2, // Adjust this value as needed
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                  ]),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Organized By : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['organizedBy']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Phone : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['contactNo']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Address : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['localLevel']} - ${eventData['wardNo']}, ${eventData['district']}, Province ${eventData['province']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Date & Time : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                      Text(
                                                        '${eventData['eventDate']}, ${_formatTimeFromDatabase(eventData['eventTime'])}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize:
                                                                0.015 * sh),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Third Row Container

                                          Container(
                                            height: 0.05 * sh,
                                            padding: EdgeInsets.all(0.008 * sw),
                                            color: const Color(0xFF8CC653),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      makePhoneCall(
                                                          'tel:+977 ${eventData['contactNo']}');
                                                    },
                                                    icon: Icon(
                                                      Icons.phone,
                                                      size: 0.017 * sh,
                                                      color: Colors.green,
                                                    ),
                                                    label: Text('',
                                                        style: TextStyle(
                                                          fontSize: 0.012 * sh,
                                                          color: Colors.green,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0.008 * sw),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      shareContent(
                                                        '"\t Join Us!! Event going to be held " \n'
                                                        'Event Name: ${eventData['eventName']}\n'
                                                        'Venue: ${eventData['venue']}\n'
                                                        'Chief Guest: ${eventData['chiefGuest']}\n'
                                                        'Event Details: ${eventData['eventDetail']}\n'
                                                        'Organized By: ${eventData['organizedBy']}\n'
                                                        'tel: +977 ${eventData['contactNo']}\n'
                                                        'Address: ${eventData['localLevel']} - ${eventData['wardNo']}, ${eventData['district']},Pro. ${eventData['province']}\n'
                                                        'Date & Time : ${eventData['eventDate']}, ${_formatTimeFromDatabase(eventData['eventTime'])}\n'
                                                        'Our App: Mobile Blood Bank Nepal',
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.share,
                                                      size: 0.017 * sh,
                                                      color: Colors.blue,
                                                    ),
                                                    label: Text('',
                                                        style: TextStyle(
                                                          fontSize: 0.015 * sh,
                                                          color: Colors.blue,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0.008 * sw),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      int eventId =
                                                          eventData['eventId'];
                                                      attendEvents(eventId);
                                                    },
                                                    icon: Icon(
                                                      Icons.waving_hand,
                                                      size: 0.017 * sh,
                                                      color:
                                                          eventData['attend'] ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.orange,
                                                    ),
                                                    label: Text(
                                                        eventData['attend'] ==
                                                                true
                                                            ? 'Attended'
                                                            : 'Attend',
                                                        style: TextStyle(
                                                          fontSize: 0.015 * sh,
                                                          color: eventData[
                                                                      'attend'] ==
                                                                  true
                                                              ? Colors.green
                                                              : Colors.orange,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                0.0), // Adjust the border radius
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 0.008 * sw),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      int eventId =
                                                          eventData['eventId'];
                                                      likeEvents(eventId);
                                                    },
                                                    icon: Icon(
                                                      Icons.thumb_up,
                                                      size: 0.017 * sh,
                                                      color:
                                                          eventData['like'] ==
                                                                  true
                                                              ? Colors.blue
                                                              : Colors.red,
                                                    ),
                                                    label: Text(
                                                        eventData['like'] ==
                                                                true
                                                            ? 'Liked'
                                                            : 'Like',
                                                        style: TextStyle(
                                                          fontSize: 0.015 * sh,
                                                          color: eventData[
                                                                      'like'] ==
                                                                  true
                                                              ? Colors.blue
                                                              : Colors.red,
                                                        )),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(
                                                          0xffFFFFFF), // Change the button color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
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
                        )),
                      ),
                      //End of Events

                      //code for Set Appointment i.e 2nd tab
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.05 * sw,
                          ),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 0.025 * sh, bottom: 0.025 * sh),
                                child: Container(
                                    height: 0.04 * sh,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF444242),
                                      borderRadius: BorderRadius.only(),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Set Appointment',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 0.02 * sh,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),

                              SizedBox(height: 0.005 * sh),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Fill the appointment details form.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 0.017 * sh,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.005 * sh),
                              TextField(
                                controller: aboutController,
                                decoration: const InputDecoration(
                                  hintText: "Appointment About",
                                  hintStyle:
                                      TextStyle(color: Color(0xff858585)),
                                ),
                                maxLength: 50,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                        r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                  ),
                                ],
                              ),

                              TextField(
                                controller: setDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  hintText: "Select Date",
                                  errorText: setDateError
                                      ? 'Appointment date cannot be in the past'
                                      : null,
                                  hintStyle:
                                      const TextStyle(color: Color(0xff858585)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),

                              SizedBox(height: 0.03 * sh),
                              TextField(
                                controller: setTimeController,
                                readOnly: true,
                                onTap: () => _selectTime(context),
                                decoration: InputDecoration(
                                  hintText: "Set Time",
                                  hintStyle:
                                      const TextStyle(color: Color(0xff858585)),
                                  suffixIcon: GestureDetector(
                                    onTap: () => _selectTime(context),
                                    child: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.03 * sh),

                              TextField(
                                controller: remarksController,
                                decoration: const InputDecoration(
                                  hintText: "Remarks",
                                  hintStyle:
                                      TextStyle(color: Color(0xff858585)),
                                ),
                                maxLength: 30,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                        r'[a-zA-Z0-9!@#$%^&*()-_=+;:,./?`~]'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.02 * sh),
                              // Making send button
                              Container(
                                height: 0.05 * sh,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 0.2 * sw),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(0.05 * sh),
                                  color: const Color(0xffFF0025),
                                ),
                                //calling insert function when button is pressed
                                child: InkWell(
                                  onTap: () {
                                    validationFields();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Click here to send",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 0.02 * sh),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),

                      //end of Set Appointment
                    ],
                  ),
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
                strokeWidth: 0.01 * sw, // Thickness of the progress indicator
                backgroundColor: Colors.black.withOpacity(
                    0.5), // Background color of the progress indicator
              ),
            ),
        ],
      ),
    );
  }

  void validationFields() {
    if (aboutController.text.trim() != '' &&
        setDateController.text.trim() != '' &&
        setTimeController.text.trim() != '' &&
        remarksController.text.trim() != '' &&
        setDateError == false) {
      setAppointment();
    } else {
      CustomSnackBar.showUnsuccess(
          context: context,
          message: "Please fill all fields correctly indicated as *.",
          icon: Icons.info);
    }
  }
}
