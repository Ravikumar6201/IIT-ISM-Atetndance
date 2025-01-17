// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Model/Cbcs_CourceModel.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
// For TimeoutException

class UserProvider with ChangeNotifier {
  bool _isLoading = false;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Function to register user

//get course

  List<StudentData> courseList = [];

  Future<bool> loadAssignClass(String session, String sessionYear, String token,
      String userid, bool isNEP) async {
    _isLoading = true;
    notifyListeners();

    try {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('token');
      // String? userid = preferences.getString('userids');
      // bool isNEP = preferences.getBool('isNEP') ?? false;

      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}nep_AsignCourse')
          : Uri.parse('${ApiConstants.baseUrl}AsignCourse');

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': session,
        'sessionyear': sessionYear,
        'auth_id': userid,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map && jsonData['Course_Data'] is List) {
          List<StudentData> sessionList = (jsonData['Course_Data'] as List)
              .map((item) => StudentData.fromJson(item))
              .toList();

          courseList = sessionList.reversed.toList();
          notifyListeners();
          return true; // Indicate success
        } else {
          print('Course_Data key not found or is not a list.');
          courseList = [];
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        courseList = [];
      }
    } catch (err) {
      print('An error occurred: $err');
      courseList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false; // Indicate failure
  }

  //professor likeclass
  List<PendingListModel> courseListlive = [];
  String? sessionData;
  String? sessionYearData;

  Future<bool> loadAssignClassLive(
      String token, userId, session, sessionyear, bool isNEP) async {
    _isLoading = true;
    notifyListeners();

    try {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? token = preferences.getString('token');
      // String? userId = preferences.getString('userids');
      // String? session = preferences.getString('session');
      // String? sessionYear = preferences.getString('sessionyear');

      // sessionData = session.toString();
      // sessionYearData = sessionYear.toString();

      // bool isNEP = preferences.getBool('isNEP') ?? false;

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}nep_LiveAsignCourse_professor')
          : Uri.parse('${ApiConstants.baseUrl}LiveAsignCourse_professor');

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': session,
        'sessionyear': sessionyear,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map) {
          final courseData = jsonData['attendance_list'];

          if (courseData is List) {
            List<PendingListModel> sessionList = [];

            for (var item in courseData) {
              sessionList.add(PendingListModel.fromJson(item));
            }

            courseListlive =
                sessionList.reversed.cast<PendingListModel>().toList();
            notifyListeners();
            return true;
          } else {
            print('Course_Data key not found or is not a list.');
          }
        } else {
          print('Data key not found in JSON.');
        }
      } else {
        courseListlive = [];
        notifyListeners();
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String phone) async {
    const String url = '${ApiConstants.baseUrl}userregister';
    final Map<String, String> headers = {
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };
    final Map<String, String> body = {
      'name': name,
      'email': email,
      'phone': phone,
    };

    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  //Final Submit otp get function
  Future<Map<String, dynamic>> registerUserFinallSubmit(
      String name, String email, String phone, String deviceid) async {
    const String url = '${ApiConstants.baseUrl}userregisternow';
    final Map<String, String> headers = {
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };
    final Map<String, String> body = {
      'name': name,
      'email': email,
      'phone': phone,
      'deviceid': deviceid,
    };

    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Function to resend OTP NEW USER
  Future<Map<String, dynamic>> resendOtp({
    required String name,
    required String email,
    required String phone,
    required String userType,
  }) async {
    const String url = '${ApiConstants.baseUrl}userresendotp';
    final Map<String, String> headers = {
      'Cookie': 'ci_session=209313d8db60f10debe994da762c225eaecc2d67',
    };

    // Prepare form data
    final Map<String, String> body = {
      'email': email,
      'usertype': userType,
      'name': name,
      'phone': phone,
    };

    _isLoading = true;
    notifyListeners(); // Notify listeners about loading state

    try {
      // Make the POST request
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      _isLoading = false;
      notifyListeners(); // Notify listeners loading has stopped

      if (response.statusCode == 200) {
        // Decode the response and return success
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Return failure with status code and reason
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // Notify listeners loading has stopped
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Function to resend OTP OLD USER
  Future<Map<String, dynamic>> resendOtpForOldUser({
    required String email,
    required String userType,
  }) async {
    const String url = '${ApiConstants.baseUrl}userresendotp';
    final Map<String, String> headers = {
      'Cookie': 'ci_session=209313d8db60f10debe994da762c225eaecc2d67',
    };

    // Prepare form data
    final Map<String, String> body = {
      'email': email,
      'usertype': userType,
    };

    _isLoading = true;
    notifyListeners(); // Notify listeners about loading state

    try {
      // Make the POST request
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      _isLoading = false;
      notifyListeners(); // Notify listeners loading has stopped

      if (response.statusCode == 200) {
        // Decode the response and return success
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Return failure with status code and reason
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // Notify listeners loading has stopped
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Function for user login with request otp
  Future<Map<String, dynamic>> userLogin(String email) async {
    const String url = '${ApiConstants.baseUrl}userloginapi';
    Map<String, dynamic> result = {};

    _isLoading = true;
    notifyListeners();

    try {
      // Making the POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Cookie': 'ci_session=21049d44e59e291685bafbaa03c8f5e07d04cb3b',
        },
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        result = {
          'success': true,
          'data': responseData,
        };
      } else {
        // Handle non-200 status codes
        result = {
          'success': false,
          'message': 'Error: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handle exceptions
      result = {
        'success': false,
        'message': 'An error occurred: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return result;
  }

  // Function to log in user
  Future<Map<String, dynamic>> loginUser({
    required String otp,
    required String userId,
    required String deviceId,
  }) async {
    const String url = '${ApiConstants.baseUrl}userloginnow';
    final Map<String, String> headers = {
      'Cookie': 'ci_session=64ef8b5f97fe66e1bc477ab65ff1919ce43f416b',
    };

    // Form data
    final Map<String, String> body = {
      'otp': otp,
      'userid': userId,
      'deviceid': deviceId,
    };

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Make POST request
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      // Stop loading
      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        // Parse and return successful response
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        // Handle error response
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      // Handle exception
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  //get user details
  Map<String, dynamic> userProfile = {}; // Store user profile data

  Future<void> fetchUserProfile(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getuserprofile';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      userProfile = {};
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile

          userProfile = {
            'userid': data['userid'],
            'name': data['name'],
            'email': data['email'],
            'phone': data['phone'],
            'jobtitle': data['jobtitle'],
            'profileimg': data['profileimg'],
            'location': data['location'],
            'website': data['website'],
            'about': data['about'],
          };
          notifyListeners();
        } else {
          userProfile = {};
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //profile edit
  Future<Map<String, dynamic>> Profileupdate(String userid, String token,
      String name, String jobtitle, String about) async {
    const String url = '${ApiConstants.baseUrl}updateuserprofile';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['name'] = name;
    request.fields['jobtitle'] = jobtitle;
    request.fields['about'] = about;

    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchUserProfile(userid, token);
    }
  }

//upload info
  Future<Map<String, dynamic>> ProfileInfoupdate(String userid, String token,
      String email, String phone, String location, String website) async {
    const String url = '${ApiConstants.baseUrl}updateuserinfo';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['email'] = email;
    request.fields['phone'] = phone;
    request.fields['location'] = location;
    request.fields['website'] = website;

    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchUserProfile(userid, token);
    }
  }

//resme get
  List<dynamic> Resumelist = []; // Store the fetched resume data

  Future<void> fetchResume(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getuserresume';

    _isLoading = true;
    notifyListeners();

    try {
      Resumelist = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('resumeData') && data['resumeData'] is List) {
            Resumelist = data['resumeData'];
            notifyListeners();
          } else {
            Resumelist = [];
            debugPrint('No resumeList found in response.');
          }
        } else {
          Resumelist = [];
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //upload resume

//delete resume

  Future<void> DeteleResume(String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}deleteuserresume';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile
          notifyListeners();
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchResume(userId, jwtToken);
    }
  }

//WorkType
  List<dynamic> WorktypeList = []; // Store the fetched resume data

  Future<void> fetchWorktype(String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getworktype';

    _isLoading = true;
    notifyListeners();

    try {
      WorktypeList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('GET', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('worktypeData') &&
              data['worktypeData'] is List) {
            WorktypeList = data['worktypeData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          WorktypeList = [];
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Exprience
  //get exprience
  List<dynamic> Expriencelist = []; // Store the fetched resume data

  Future<void> fetchExprience(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getexperiencelistapi';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('expData') && data['expData'] is List) {
            Expriencelist = data['expData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          Expriencelist = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//add  exprience
  Future<Map<String, dynamic>> addExprience(
      String id,
      String userid,
      String token,
      String desination,
      String workid,
      String company,
      String startmonth,
      String startyear,
      String endmonth,
      String endyear,
      String description) async {
    const String url = '${ApiConstants.baseUrl}addeditexperienceapi';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['companyname'] = company;
    request.fields['designation'] = desination;
    request.fields['work_type'] = workid;
    request.fields['start_month'] = startmonth;
    request.fields['start_year'] = startyear;
    request.fields['end_month'] = endmonth;
    request.fields['end_year'] = endyear;
    request.fields['role_responsibility'] = description;
    request.fields['editid'] = id;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchExprience(userid, token);
    }
  }

//delete exprience
  Future<void> DeteleExprience(
      String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}deleteexperienceapi';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile
          notifyListeners();
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchExprience(userId, jwtToken);
    }
  }

  //Education
  //get exprience
  List<dynamic> Educationlist = []; // Store the fetched resume data

  Future<void> fetchEducation(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}geteducationlistapi';

    _isLoading = true;
    notifyListeners();

    try {
      Educationlist = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('eduData') && data['eduData'] is List) {
            Educationlist = data['eduData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          Educationlist = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//add  education
  Future<Map<String, dynamic>> addEducation(
      String id,
      String userid,
      String token,
      String school,
      String study,
      String startmonth,
      String startyear,
      String endmonth,
      String endyear,
      String description) async {
    const String url = '${ApiConstants.baseUrl}addediteducationapi';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['univercity'] = school;
    request.fields['course'] = study;
    request.fields['start_month'] = startmonth;
    request.fields['start_year'] = startyear;
    request.fields['end_month'] = endmonth;
    request.fields['end_year'] = endyear;
    request.fields['description'] = description;
    request.fields['editid'] = id;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchEducation(userid, token);
    }
  }

//delete education
  Future<void> DeteleEducation(
      String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}deleteeducationapi';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile
          notifyListeners();
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchEducation(userId, jwtToken);
    }
  }

  //Skill
  //get Skill
  List<dynamic> SkilllistMaster = []; // Store the fetched resume data

  Future<void> fetchSkillMaster(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}skillmasterapi';
    _isLoading = true;
    notifyListeners();
    try {
      SkilllistMaster = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('skillmasterData') &&
              data['skillmasterData'] is List) {
            SkilllistMaster = data['skillmasterData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          SkilllistMaster = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<dynamic> Skilllist = []; // Store the fetched resume data

  Future<void> fetchSkill(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getskilllistapi';
    _isLoading = true;
    notifyListeners();
    try {
      Skilllist = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('skillData') && data['skillData'] is List) {
            Skilllist = data['skillData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          Skilllist = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get skill by id
  Map<String, dynamic> SkillByID = {}; // Store the fetched resume data

  Future<Map<String, dynamic>> fetchSkillById(
      String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}getskilldetailapi';
    _isLoading = true;
    notifyListeners();

    try {
      SkillByID = {}; // Initialize with an empty map

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Successfully retrieved data
          SkillByID = {
            'id': data['id'],
            'skillid': data['skillid'],
            'skilltitle': data['skilltitle'],
            'level': data['level'],
            'success': data['success'],
            'message': data['message'],
          };
          return SkillByID;
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Return an empty map in case of any errors or unhandled conditions
    return {};
  }

//add  Skill
  Future<Map<String, dynamic>> addSkill(String id, String userid, String token,
      String skillid, String level) async {
    const String url = '${ApiConstants.baseUrl}addeditskillapi';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['skillid'] = skillid;
    request.fields['level'] = level;
    request.fields['editid'] = id;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchSkill(userid, token);
    }
  }

//delete Skill
  Future<void> DeteleSkill(String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}deleteskillapi';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile
          notifyListeners();
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchSkill(userId, jwtToken);
    }
  }

  //Language
  //get Language
  List<dynamic> Languagelist = []; // Store the fetched resume data

  Future<void> fetchLanguage(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}getlanglistapi';
    _isLoading = true;
    notifyListeners();
    try {
      Languagelist = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('langData') && data['langData'] is List) {
            Languagelist = data['langData'];
            notifyListeners();
          } else {
            debugPrint('No resumeList found in response.');
          }
        } else {
          Languagelist = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//add  Language
  Future<Map<String, dynamic>> addLanguage(String id, String userid,
      String token, String skillname, String level) async {
    const String url = '${ApiConstants.baseUrl}addeditlangapi';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['lang'] = skillname;
    request.fields['level'] = level;
    request.fields['editid'] = id;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchLanguage(userid, token);
    }
  }

//get laguage bu id
  Map<String, dynamic> LaguaheByID = {}; // Store the fetched resume data

  Future<Map<String, dynamic>> fetchLanguageById(
      String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}getlangdetailapi';
    _isLoading = true;
    notifyListeners();

    try {
      LaguaheByID = {}; // Initialize with an empty map

      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Successfully retrieved data
          LaguaheByID = {
            'id': data['id'],
            'lang': data['lang'],
            'level': data['level'],
            'success': data['success'],
            'message': data['message'],
          };
          return LaguaheByID;
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Return an empty map in case of any errors or unhandled conditions
    return {};
  }

//delete Language
  Future<void> DeteleLanguage(String userId, String jwtToken, String id) async {
    const String url = '${ApiConstants.baseUrl}deletelangapi';

    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['id'] = id;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Success response, update the userProfile
          notifyListeners();
        } else {
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchLanguage(userId, jwtToken);
    }
  }

//job list (Recent job)
  List<dynamic> RecentJobList = []; // Store the fetched resume data

  Future<void> fetchrecentjob(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}joblistapi';
    _isLoading = true;
    notifyListeners();
    try {
      RecentJobList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('jobList') && data['jobList'] is List) {
            RecentJobList = data['jobList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          Languagelist = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//job details
  Map<String, dynamic> Jobdetails = {}; // Store fetched job data

  Future<void> fetchjobdetails(
      String userId, String jwtToken, String listId) async {
    const String url = '${ApiConstants.baseUrl}jobdetailapi';
    _isLoading = true;
    notifyListeners();

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });

      // Add form fields
      request.fields['userid'] = userId;
      request.fields['listid'] = listId;

      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for job list in the response
          // Parse job list
          Jobdetails = {
            "id": data['id'] ?? '',
            "company_name": data['company_name'] ?? '',
            "company_logo": data['company_logo'] ?? '',
            "company_city": data['company_city'] ?? '',
            "company_state": data['company_state'] ?? '',
            "company_country": data['company_country'] ?? '',
            "company_website": data['company_website'] ?? '',
            "company_headquarter": data['company_headquarter'],
            "company_founded": data['company_founded'],
            "company_size": data['company_size'],
            "company_revenue": data['company_revenue'],
            "title": data['title'] ?? '',
            "about_company": data['about_company'] ?? '',
            "job_location": data['job_location'] ?? '',
            "job_type": data['job_type'] ?? '',
            "paytype": data['paytype'] ?? '',
            "minimum": data['minimum'] ?? '0',
            "maximum": data['maximum'] ?? '0',
            "amount": data['amount'] ?? '0',
            "rate": data['rate'] ?? '',
            "is_closed": data['is_closed'] ?? '',
            "is_resume_required": data['is_resume_required'] ?? '',
            "jobdescription": data['jobdescription'] ?? '',
            "is_saved": data['is_saved'] ?? '',
            "is_applied": data['is_applied'] ?? '',
            "status": data['status'] ?? '',
            "success": data['success'] ?? '',
            "message": data['message'] ?? '',
          };

          notifyListeners();
        } else {
          Jobdetails = {};
          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//get industries
  List<dynamic> IdustriesList = []; // Store the fetched resume data

  Future<void> fetchindustries(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}industryapi';
    _isLoading = true;
    notifyListeners();
    try {
      IdustriesList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('industryList') &&
              data['industryList'] is List) {
            IdustriesList = data['industryList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          IdustriesList = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//get type of indusries list
  List<dynamic> IdustriesListByID = []; // Store the fetched resume data

  Future<void> fetchindustriesByID(
      String userId, String industryId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}joblistindustryapi';
    _isLoading = true;
    notifyListeners();
    try {
      IdustriesListByID = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['industryid'] = industryId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('jobList') && data['jobList'] is List) {
            IdustriesListByID = data['jobList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          IdustriesListByID = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//applyjob
  Future<Map<String, dynamic>> Applyjob(
      String userid, String token, String jobid, String resumeid) async {
    const String url = '${ApiConstants.baseUrl}jobapplynow';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['jobid'] = jobid;
    request.fields['resumeid'] = resumeid;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      // fetchSkill(userid, token);
    }
  }

//job saved And unsaved
  Future<Map<String, dynamic>> SavedJob(
      String userid, String token, String jobid) async {
    const String url = '${ApiConstants.baseUrl}addremovesavedjob';

    // Headers
    final Map<String, String> headers = {
      'Accept': 'application/ecmascript',
      'Authorization': 'Bearer $token',
      'Cookie': 'ci_session=d672944bd6bca0df4e8aea5729eaf26060335daa',
    };

    // Create a MultipartRequest for form data submission
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll(headers);

    // Add form data fields
    request.fields['userid'] = userid;
    request.fields['jobid'] = jobid;
    _isLoading = true;
    notifyListeners();

    try {
      // Send the request
      var streamedResponse = await request.send();

      // Convert streamed response to http.Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Successful response
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        // API call failed
        return {
          'success': false,
          'error': response.reasonPhrase,
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Exception occurred
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
      fetchjobdetails(userid, token, jobid);
    }
  }

//save job list get
  List<dynamic> SavedJobList = []; // Store the fetched resume data

  Future<void> fetchsavedjob(String userId, String jwtToken) async {
    const String url = '${ApiConstants.baseUrl}savedjoblistapi';
    _isLoading = true;
    notifyListeners();
    try {
      SavedJobList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('savedjobList') &&
              data['savedjobList'] is List) {
            SavedJobList = data['savedjobList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          SavedJobList = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//activity list aplied

  List<dynamic> AppliedList = []; // Store the fetched resume data

  Future<void> fetchAppliedData(
      String userId, String jwtToken, String type) async {
    const String url = '${ApiConstants.baseUrl}jobappliedlistapi';
    _isLoading = true;
    notifyListeners();
    try {
      AppliedList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['type'] = type;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('appliedjobList') &&
              data['appliedjobList'] is List) {
            AppliedList = data['appliedjobList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          AppliedList = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//activity list shortlist
  List<dynamic> ShortlistedList = []; // Store the fetched resume data

  Future<void> fetchShortlistData(
      String userId, String jwtToken, String type) async {
    const String url = '${ApiConstants.baseUrl}jobappliedlistapi';
    _isLoading = true;
    notifyListeners();
    try {
      ShortlistedList = [];
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Add headers
      request.headers.addAll({
        'Accept': 'application/ecmascript',
        'Authorization': 'Bearer $jwtToken',
      });
      // Add form fields (as form data)
      request.fields['userid'] = userId;
      request.fields['type'] = type;
      // Send the request
      var streamedResponse = await request.send();

      // Parse the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == 200) {
          // Check for resume list in the response
          if (data.containsKey('appliedjobList') &&
              data['appliedjobList'] is List) {
            ShortlistedList = data['appliedjobList'];
            notifyListeners();
          } else {
            debugPrint('No Recent Job found in response.');
          }
        } else {
          ShortlistedList = [];

          debugPrint('Unexpected success value: ${data['success']}');
        }
      } else {
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
