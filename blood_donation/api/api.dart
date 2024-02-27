import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String baseUrl = "http://192.168.100.53:8000/api/";

// for login and logout session

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];

      // Store the token in shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);

      return responseData;
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
  }

  // for registering user or signup uploading data to database
  postData(data, apiUrl) async {
    final regDonorUrl = baseUrl + apiUrl;
    return await http.post(
      Uri.parse(regDonorUrl),
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

  _setHeaders() => {
        "Content-type": "application/json",
        "Accept": "application/json",
      };
}
