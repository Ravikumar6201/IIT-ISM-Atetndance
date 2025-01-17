// ignore_for_file: unused_import, non_constant_identifier_names, unused_local_variable

import 'package:http/http.dart' as http;
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Model/Verify.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<LoginResponse?> Loginverification(
    String PhoneNo, String password, String deviceinfo) async {
  try {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? token = preferences.getString('token');
    // final Uri uri = Uri.https("apps.iitism.ac.in", "/");

    final Uri uri =
        Uri.https(ApiConstants.baseUrllogin, ApiConstants.endpointotpnew);
    final Map<String, dynamic> requestBody = {
      'mobile_no': PhoneNo,
      'password': password,
      'device_info': "hSDfgh"
      // deviceinfo,
      // Other request parameters can be added here
    };

    final Map<String, String> headers = {
      'Host': ApiConstants.baseUrllogin,
      // Other headers can be added here
    };
    final response = await http.post(uri, body: requestBody, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['status'] == "success") {
        final LoginResponse loginResult = LoginResponse.fromJson(json);
        return loginResult;
      } else {
        throw Exception("Login Failed");
      }
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    print("Error: $e");
    return null;
  }
}

Future<MobileVarify?> Varify(String PhoneNo, String deviceinfo) async {
  try {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? token = preferences.getString('token');
    // final Uri uri = Uri.https("apps.iitism.ac.in", "/");

    final Uri uri =
        Uri.https(ApiConstants.baseUrllogin, ApiConstants.endpointotp);
    final Map<String, dynamic> requestBody = {
      'mobileno': PhoneNo,
      'device_info': "hSDfgh"
      // deviceinfo,
      // Other request parameters can be added here
    };

    final Map<String, String> headers = {
      'Host': ApiConstants.baseUrllogin,
      // Other headers can be added here
    };
    final response = await http.post(uri, body: requestBody, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['status'] == "success") {
        final MobileVarify loginResult = MobileVarify.fromJson(json);
        return loginResult;
      } else {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.clear();
        throw Exception("Login Failed");
      }
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // await preferences.clear();
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    print("Error: $e");
    return null;
  }
}

Future<LoginResponse?> fetchLoginDetails(String OTP) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? mobileno = preferences.getString('mobileno');
    String? Timestamp = preferences.getString('timestamp');
    String? sessionid = preferences.getString('sessionId');

    final Uri uri =
        Uri.https(ApiConstants.baseUrllogin, ApiConstants.endpointverify);
    final Map<String, dynamic> requestBody = {
      'mobile_no': mobileno,
      'session_id': sessionid,
      'timestamp': Timestamp,
      'otp': OTP,
      // Other request parameters can be added here
    };

    final response = await http.post(
      uri,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['status'] == "success") {
        final LoginResponse loginResult = LoginResponse.fromJson(json);
        return loginResult;
      } else {
        throw Exception("Login Failed");
      }
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
