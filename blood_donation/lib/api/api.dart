import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class CallApi {
  //final String baseUrl = "https://mobilebloodbanknepal.com/api/";
  final String baseUrl = "http://192.168.1.67:8000/api/";

  final String loginUrl = "login";

// for login and logout session
  Future<Map<String, dynamic>> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + loginUrl),
      body: {'identifier': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Extract token information
      String token = responseData['token']['id'].toString(); // Use the token id or any field you need
      String rememberToken = responseData['remember_token'] ?? '';
      int userId = responseData['userId'] ?? 0;
      int donorId = responseData['donorId'] ?? 0;
      String accountType = responseData['accountType'] ?? '';
     

      // Store the token and remember_token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token); // Ensure this is the correct token you need
      await prefs.setString('remember_token', rememberToken); // Store remember token
      await prefs.setInt('userId', userId);
      await prefs.setInt('donorId', donorId);
      await prefs.setString('accountType', accountType);

      return responseData;

    } else if (response.statusCode == 401) {
      // Handle unauthorized (invalid username or password) case
      throw Exception('401');
    } else {
      // Handle other error cases
      throw Exception('Failed to log in. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to log in: $e');
  }
}


  Future<void> logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Future<http.Response> postData(
  //  Map<String, dynamic> data, String apiUrl) async {

  // for registering user or signup uploading data to database
  postData(data, apiUrl) async {
    final regUserUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(regUserUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for counting all donors and each blood group wise
  countDonors(data, apiUrl) async {
    final countDonorUrl = baseUrl + apiUrl;
    return await http.get(
      Uri.parse(countDonorUrl),
      headers: _setHeaders(),
    );
  }

  // for showing top 3 donor list
  topDonors(data, apiUrl) async {
    final topDonorUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(topDonorUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for Reset Password weather the user exists ornot
  checkUser(data, apiUrl) async {
    final checkUserUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(checkUserUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// for Creating new Request of blood
  requestBlood(data, apiUrl) async {
    final requestBloodUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(requestBloodUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for Creating new Emergency Request of blood
  emergencyRequestBlood(data, apiUrl) async {
    final emergencyRequestBloodUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(emergencyRequestBloodUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// for loading all MyRequests emergency_request_blood + request_blood both
  loadAllMyRequests(data, apiUrl) async {
    final myRequestsUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(myRequestsUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  loadEmergencyRequests(data, apiUrl) async {
    final erRequestsUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(erRequestsUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for loading notifications from event, request bloods and emergencyrequest bloods
  loadNotification(data, apiUrl) async {
    final notUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(notUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for Setting Appointment to office
  setAppoint(data, apiUrl) async {
    final setAppointUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(setAppointUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // loading Events

  loadAllEvents(data, apiUrl) async {
    final eventUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(eventUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// for searching blood group
  searchBlood(data, apiUrl) async {
    final searchBloodGroupUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(searchBloodGroupUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// for searching Ambulance Info
  searchAmbulance(data, apiUrl) async {
    final searchAmbulanceUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(searchAmbulanceUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for adding new ambulance data
  addAmbulance(data, apiUrl) async {
    final regAmbulanceUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(regAmbulanceUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// for searching BloodBank Info
  searchBloodBank(data, apiUrl) async {
    final searchBloodBankUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(searchBloodBankUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for adding new blood bank data
  addBloodBank(data, apiUrl) async {
    final regBloodBankUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(regBloodBankUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for adding new donation records to donation_histories table
  retrieveDonationHistory(data, apiUrl) async {
    final donationHistoryUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(donationHistoryUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for adding new emergency_request_available_donors record
  erDonors(data, apiUrl) async {
    final erAvailableUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(erAvailableUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  //loading added members by admin/superadmin

  addedMembers(data, apiUrl) async {
    final addMemUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(addMemUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

// fetching donor details in update profile

  fetchDonor(data, apiUrl) async {
    final fetchDonorUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(fetchDonorUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // for uploading photo
  // Method for uploading photos with multipart requests
  Future uploadPhoto(
      Map<String, dynamic> data, String apiUrl, File image) async {
    final uploadPhotoUrl = baseUrl + apiUrl;

    var request = http.MultipartRequest('POST', Uri.parse(uploadPhotoUrl));

    // Convert data to Map<String, String>
    request.fields
        .addAll(data.map((key, value) => MapEntry(key, value.toString())));

    var stream = http.ByteStream(image.openRead());
    var length = await image.length();

    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: path.basename(image.path),
    );

    request.files.add(multipartFile);

    var response = await request.send();

    return response;
  }

  // sending likes to events
  eventLikes(data, apiUrl) async {
    final eventLikesUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(eventLikesUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // sending attends to events
  eventAttends(data, apiUrl) async {
    final eventAttendsUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(eventAttendsUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // sending attends to events
  notificationRead(data, apiUrl) async {
    final notiReadUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(notiReadUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // fetching status events
  fetchEventStatus(data, apiUrl) async {
    final fetchEventUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(fetchEventUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // delete MyRequest
  delRequest(data, apiUrl) async {
    final delRequestUrl = baseUrl + apiUrl;
    return await http.delete(
      Uri.parse(delRequestUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // delete MyEmergencyRequest
  delERequest(data, apiUrl) async {
    final delERequestUrl = baseUrl + apiUrl;
    return await http.delete(
      Uri.parse(delERequestUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // fetchUserData
  fetchUserData(data, apiUrl) async {
    final fetchUserUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(fetchUserUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // UpdateUserData
  updatingUserData(data, apiUrl) async {
    final updateUserUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(updateUserUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        "Content-type": "application/json",
        "Accept": "application/json",
      };
}
