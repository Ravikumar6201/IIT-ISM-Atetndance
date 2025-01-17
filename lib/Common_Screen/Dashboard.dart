// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, file_names, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_import, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Class/DeviceId_IpAddress.dart';
import 'package:ism/Class/currentDevice.dart';
import 'package:ism/Class/notificationsServices.dart';
import 'package:ism/Common_Screen/sessionNsessionyear.dart';
import 'package:ism/Core/SQLite/DbHelpher.dart';
import 'package:ism/Core/conenction.dart';
import 'package:ism/Core/DeviceInfo.dart';
import 'package:ism/Login/Login.dart';
import 'package:ism/Login/mocklocation.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Profile(local).dart';
import 'package:ism/Screen(Professor)/AttendancePending/ListOfPending.dart';
import 'package:ism/Screen(Professor)/ProLiveClass.dart';
import 'package:ism/Screen(Professor)/CreateAttendance.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:ism/Screen(Professor)/Edit/History_by_day.dart';
import 'package:ism/Screen(Professor)/Report/SubjectwiseTotal_Class.dart';
import 'package:ism/Screen(Professor)/TA/TaScreen.dart';
import 'package:ism/Screen(Professor)/TodayAttendance.dart';
import 'package:ism/Screen(Student)/Attendance_History.dart';
import 'package:ism/Screen(Student)/mark_attendance.dart';
import 'package:ism/Screen(Student)/Drawer.dart';
import 'package:ism/Common_Screen/Profile.dart';
import 'package:ism/Screen(Student)/Stu_AllCourseScreen.dart';
import 'package:ism/Screen(Student)/Support.dart';
import 'package:ism/Screen(Professor)/AssignClass.dart';
import 'package:ism/Screen(TA)/AllCourseScreen.dart';
import 'package:ism/Screen(TA)/Edit/TA_History_by_day.dart';
import 'package:ism/Screen(TA)/TA_AttendancePending/Ta_All_PendingList.dart';
import 'package:ism/Screen(TA)/DrawerTA.dart';
import 'package:ism/Screen(TA)/liveCouerseList.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sql.dart';
import 'package:upgrader/upgrader.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // DeviceInfo getDeviceToken = DeviceInfo();
  NotificationServices notificationServices = NotificationServices();
  bool checker = false;
  List<User> usertype = [];
  List<User> usertypes = [];
  List<UserOtherDetails> userOtherdetailslist = [];
  List<UserOtherDetails> userOtherdetailslists = [];
  List<UserDetails> userdetails = [];
  List<UserDetails> userdetailss = [];
  List<Tadata> TaDatalist = [];
  List<Tadata> TaDatalists = [];
  List<SimCard> simCards = [];
  String? number;
  String? otp;
  final dbHelper = DatabaseHelper();
  String? _deviceId;
  bool deviceMatched = false;
  @override
  void initState() {
    super.initState();
    // getDeviceId();
    _LoadSession();
    _fetchDatafromlocalstorage();
    _checkMockLocation();
    _loadToggleValue();
    // _initMobileNumber();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.setupInteractBirth_Aniv(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
    print('FCM============================================================');
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BOVsVElecSRuWSXP2sX-273wdMckHwqxvRJJmrEn8PherIJnW-xmb_73PjBLQaUSD6m646bamE6zQQWzYSS23eA')
        .then((token) {
      setToken(token ?? ' ');
    });
  }

  void setToken(String token) async {
    print('FCM Token: $token');
    postToken(token);
  }

  Future<void> _fetchDatafromlocalstorage() async {
    List<User> users = await DatabaseHelper.instance.getUsersbyList();
    if (users.isNotEmpty) {
      usertypes = await DatabaseHelper.instance.getUsersbyList();
      userdetailss = await DatabaseHelper.instance.getUsersdetailsbyList();

      userOtherdetailslists =
          await DatabaseHelper.instance.getUsersotherdetailsbyList();
      TaDatalists = await DatabaseHelper.instance.getTadetailsbyList();
      setState(() {});
      usertypes;
      userdetailss;
      userOtherdetailslists;
      TaDatalists;
      if (usertypes.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userids', usertypes.first.id);
        setState(() {
          deviceMatched = true;
        });
      }
    } else {
      _firstLoad();
    }
  }

  //post  token
  Future postToken(String fncToken) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? memberid = preferences.getString('memberid');
      String? token = preferences.getString('token');
      String? devideinfo = preferences.getString("devicename");
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}deviceID') // If isNEP is true
          : Uri.parse('${ApiConstants.baseUrl}deviceID'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}deviceID');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'deviceid': fncToken,
        'deviceinfo': devideinfo,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          print(jsonData['message']);
        }
        print(response);
      } else {
        print("device id not store");
      }
    } catch (_) {
      return false;
    }
    setState(() {
      deviceMatched = true;
    });
  }

  Future<void> _checkMockLocation() async {
    // bool isMock = await LocationService.isMockLocation();
    // if (isMock) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Not Allow to Use Mock Location for this App')),
    //   );
    //   SharedPreferences preferences = await SharedPreferences.getInstance();
    //   await preferences.clear();
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //     (Route<dynamic> route) => false,
    //   );
    //   // _showMockLocationAlert();
    // }
  }

  void _showMockLocationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mock Location Detected'),
        content:
            Text('Access to the app is blocked due to detected mock location.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshPage() async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 1));
    _fetchDatafromlocalstorage();
    // _firstLoad();
    setState(() {});
  }

  bool isLoading = false;
  Future<void> _firstLoad() async {
    // if(){

    // }
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      bool isNEP = false;
      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}User_Details') // If isNEP is true
          : Uri.parse('${ApiConstants.baseUrl}User_Details');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map) {
          final usersData = jsonData['User'];
          final userDetailsData = jsonData['UserDetails'];
          final tadataData = jsonData['Tadata'];
          final UserOtherData = jsonData['UserOtherDetails'];

          if (usersData == null ||
              userDetailsData == null ||
              UserOtherData == null) {
            print('Required keys not found in JSON.');
            return;
          }

          User userObject = User.fromJson(usersData);
          UserOtherDetails userOther = UserOtherDetails.fromJson(UserOtherData);
          UserDetails userDetailsObject = UserDetails.fromJson(userDetailsData);
          setState(() {
            usertype = [userObject];
            userOtherdetailslist = [userOther];
            userdetails = [userDetailsObject];
            if (tadataData != null) {
              Tadata tadataObject = Tadata.fromJson(tadataData);
              TaDatalist = [tadataObject];
            } else {
              TaDatalist = [];
            }
            // preferences.setString('userids', usertype.first.id);
          });
          // Example user data
          Map<String, dynamic> userData = {
            'id': usertype.first.id,
            'password': usertype.first.password,
            'ci_password': usertype.first.ciPassword,
            'auth_id': usertype.first.authId,
            'created_date': usertype.first.createdDate,
            'updated_date': usertype.first.updatedDate,
            'user_hash': usertype.first.userHash,
            'failed_attempt_cnt': usertype.first.failedAttemptCnt,
            'success_attempt_cnt': usertype.first.successAttemptCnt,
            'is_blocked': usertype.first.isBlocked,
            'status': usertype.first.status,
            'remark': usertype.first.remark
          };

          // Insert user data
          await dbHelper.insertUser(userData);
          print('User inserted!');

          // Fetch and print users (for verification)
          List<Map<String, dynamic>> users = await dbHelper.getUsers();
          print('Users: $users');

          // Example user details data
          Map<String, dynamic> userDetails = {
            'id': userdetails.first.id,
            'salutation': userdetails.first.salutation,
            'first_name': userdetails.first.firstName,
            'middle_name': userdetails.first.middleName,
            'last_name': userdetails.first.lastName,
            'sex': userdetails.first.sex,
            'category': userdetails.first.category,
            'allocated_category': userdetails.first.allocatedCategory,
            'dob': userdetails.first.dob,
            'email': userdetails.first.email,
            'photopath': userdetails.first.photopath,
            'marital_status': userdetails.first.maritalStatus,
            'physically_challenged': userdetails.first.physicallyChallenged,
            'dept_id': userdetails.first.deptId,
            'updated': userdetails.first.updated,
          };

          // Insert user details data
          await dbHelper.insertUserDetails(userDetails);
          print('User details inserted!');

          // Fetch and print user details (for verification)
          List<Map<String, dynamic>> userDetailsget =
              await dbHelper.getUserDetails();
          print('User Details: $userDetailsget');

          // Example user other details data
          Map<String, dynamic> userOtherDetailsData = {
            'id': userOtherdetailslist.first.id,
            'religion': userOtherdetailslist.first.religion,
            'nationality': userOtherdetailslist.first.nationality,
            'kashmiri_immigrant': userOtherdetailslist.first.kashmiriImmigrant,
            'hobbies': userOtherdetailslist.first.hobbies,
            'fav_past_time': userOtherdetailslist.first.favPastTime,
            'birth_place': userOtherdetailslist.first.birthPlace,
            'mobile_no': userOtherdetailslist.first.mobileNo,
            'father_name': userOtherdetailslist.first.fatherName,
            'mother_name': userOtherdetailslist.first.motherName,
            'emp_allergy': userOtherdetailslist.first.empAllergy,
            'emp_disease': userOtherdetailslist.first.empDisease,
            'bank_name': userOtherdetailslist.first.bankName,
            'bank_accno': userOtherdetailslist.first.bankAccno,
            'ifsc_code': userOtherdetailslist.first.ifscCode,
          };

          // Insert user other details data
          await dbHelper.insertUserOtherDetails(userOtherDetailsData);
          print('User other details inserted!');

          // Fetch and print user other details (for verification)
          List<Map<String, dynamic>> userOtherDetails =
              await dbHelper.getUserOtherDetails();
          print('User Other Details: $userOtherDetails');

          Map<String, dynamic> taDetailsData = {
            'id': TaDatalist.first.id,
            'session_year': TaDatalist.first.sessionYear,
            'session': TaDatalist.first.session,
            'sub_code': TaDatalist.first.subCode,
            'sub_offered_id': TaDatalist.first.subOfferedId,
            'ft_id': TaDatalist.first.ftId,
            'admn_no': TaDatalist.first.admnNo,
            'remark': TaDatalist.first.remark,
            'status': TaDatalist.first.status,
            'created_at': TaDatalist.first.createdAt,
            'modified_at': TaDatalist.first.modifiedAt,
          };

          // Insert TA details data
          await dbHelper.insertTaDetails(taDetailsData);
          print('TA details inserted!');

          // Fetch and print TA details (for verification)
          List<Map<String, dynamic>> taDetails = await dbHelper.getTaDetails();
          print('TA Details: $taDetails');
          _fetchDatafromlocalstorage();
          preferences.remove("userids");

          if (usertype.isNotEmpty) {
            preferences.setString('userids', usertype.first.id);
            setState(() {
              deviceMatched = true;
            });
          } else {
            print('usertype is empty, cannot set userids');
          }
        } else {
          print('Unexpected JSON format.');
        }
      } else {
        print('Logout button pressed');
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('Logout button pressed');
      print('An error occurred: $err');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //get for set  session and ses
  //sion year
  List<Ssesion> sessionlist = [];
  List<SessionYear> sessionyearlist = [];

  String? _selectedsessionOption, _selectedsessionyeOption;
  String? sessionget;
  String? sessionyear;

  Future<void> _LoadSession() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      setState(() {
        sessionget = preferences.getString("session") ?? "";
        sessionyear = preferences.getString("sessionyear") ?? "";
      });

      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}sessionyear') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}sessionyear'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}sessionyear');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is Map) {
          final session = jsonData['session'];
          final session_year = jsonData['session_year'];

          if (session is List) {
            List<Ssesion> sessionList = [];

            for (var item in session) {
              sessionList.add(Ssesion.fromJson(item));
            }

            setState(() {
              sessionList.reversed;
              sessionlist = sessionList;
            });
          } else {
            print('session_year key not found or is not a list.');
          }

          if (session_year is List) {
            List<SessionYear> sessionYearList = [];

            for (var item in session_year) {
              sessionYearList.add(SessionYear.fromJson(item));
            }

            setState(() {
              sessionYearList.reversed;
              sessionyearlist = sessionYearList;
            });
            if (sessionyear == "" && sessionget == "") {
              AbsentAlert(context);
            }
          } else {
            print('session_year key not found or is not a list.');
          }
        } else {
          print('Data key not found in JSON.');
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String sessiondata = '';
  String sessioyeardata = '';
  Future<void> _LoadAssignClass(String session, String sessionyear) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // preferences.remove('session');
      // preferences.remove('sessionyear');
      await preferences.setString('session', session);
      await preferences.setString('sessionyear', sessionyear);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session And Session Year Set Secussfully')),
      );
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      setState(() {
        _fetchDatafromlocalstorage();
        isLoading = false;
      });
    }
  }

  Ssesion? selectedSession;
  SessionYear? selectedSessionYear;
  void AbsentAlert(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 100,
            height: 270,
            // decoration: BoxDecoration(color: ColorConstant.ismcolor),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Set Session & Year",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Session',
                    ),
                    items: sessionlist.map((Ssesion option) {
                      return DropdownMenuItem<String>(
                        value: option.session,
                        child: Text(option.session),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedsessionOption = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Session field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Session Year',
                    ),
                    items: sessionyearlist.map((SessionYear option) {
                      return DropdownMenuItem<String>(
                        value: option.sessionYear,
                        child: Text(option.sessionYear),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedsessionyeOption = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Session Year field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.remove('session');
                        preferences.remove('sessionyear');
                        await preferences.setString(
                            'session', _selectedsessionOption.toString());
                        await preferences.setString(
                            'sessionyear', _selectedsessionyeOption.toString());
                        // Perform some action with the input
                        _LoadAssignClass(_selectedsessionOption.toString(),
                            _selectedsessionyeOption.toString());
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isNEP = false; // Initial state of the toggle button, false means "CBSE"

  // Load the toggle value from SharedPreferences
  Future<void> _loadToggleValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isNEP =
          preferences.getBool('isNEP') ?? false; // Default is "CBSE" (false)
    });
  }

  // Save the toggle value to SharedPreferences
  Future<void> _saveToggleValue(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isNEP', value);
  }

  bool connection = false;
  Future<void> conenction() async {
    var connectivityResult = await ConnectivityService.checkConnectivity();
    if (connectivityResult.first.name == 'none') {
      setState(() {
        connection = false;
      });
    } else {
      setState(() {
        connection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    conenction();

    if (usertypes.isNotEmpty &&
        userdetailss.isNotEmpty &&
        deviceMatched == true) {
      Widget drawer;

      if (usertypes != null) {
        if (usertypes.first.authId == "stu" && TaDatalists.isEmpty) {
          drawer = CustomDrawer();
        } else if (usertypes.first.authId == "emp") {
          drawer = CustomDrawerProfessor();
        } else if (TaDatalists.isNotEmpty) {
          drawer = CustomDrawerTA();
        } else {
          drawer =
              Container(); // Default empty drawer if role is not recognized
        }
      } else {
        drawer = Container(); // Default empty drawer if details are null
      }
      return UpgradeAlert(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: drawer,
          appBar: AppBar(
            title: Text(
              "Dashboard",
              style: TextStyle(color: ColorConstant.whiteA700),
            ),
            leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Icon(Icons.menu, color: ColorConstant.whiteA700),
            ),
            actions: [
              Row(
                children: [
                  Text(isNEP ? 'NEP' : 'CBCS',
                      style: TextStyle(
                          fontSize: 16, color: ColorConstant.whiteA700)),
                  Switch(
                    value: isNEP,
                    onChanged: (value) {
                      _refreshPage();
                      setState(() {
                        isNEP = value; // Toggle between NEP and CBSE
                      });
                      _saveToggleValue(
                          value); // Save the value in SharedPreferences
                    },
                    activeColor:
                        ColorConstant.redA701, // Switch when NEP is selected
                    inactiveThumbColor:
                        Colors.grey, // Switch when CBSE is selected
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ],
              ),
            ],
            backgroundColor: ColorConstant.ismcolor,
          ),
          body: RefreshIndicator(
            onRefresh: _refreshPage,
            child: Column(
              children: [
                // if (connection == true)
                //   Container(
                //       height: 20,
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: ColorConstant.green900,
                //       ),
                //       child: Center(
                //         child: Text("Internet Connection",
                //             style: TextStyle(
                //               color: ColorConstant.whiteA700,
                //             )),
                //       )),
                if (connection == false)
                  Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorConstant.redA700,
                      ),
                      child: Center(
                        child: Text("No Internet Connection",
                            style: TextStyle(
                              color: ColorConstant.whiteA700,
                            )),
                      )),
                if (usertypes.first.authId == "stu" && TaDatalists.isEmpty)
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(3, (index) {
                        final colors = [
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                        ];
                        final titles = [
                          '',
                          'Profile',
                          'Attendance History',
                          "Support"
                        ];
                        final iconss = [
                          Image.asset("assets/images/live.gif", height: 120),
                          Icon(
                            Icons.person_2,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.history,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.support,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                        ];
                        final routes = [
                          () => Stu_All_CourseScreen(),
                          () =>
                              ProfileDetails(userdetailsss: userdetailss.first),
                          () => Attendance_History(),
                          () => SupportPage()
                        ];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => routes[index]()),
                            );
                          },
                          child: Card(
                            color: colors[index],
                            margin: EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  iconss[index],
                                  SizedBox(height: 10),
                                  Text(
                                    titles[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                if (usertypes.first.authId == "emp")
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 5,
                      children: List.generate(7, (index) {
                        final colors = [
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                        ];
                        final titles = [
                          'Create Attendance',
                          '',
                          'Pending Submission',
                          'Profile',
                          'Assign TA',
                          'Edit Attendance',
                          'Class Count'
                        ];
                        final iconss = [
                          Icon(
                            Icons.create_rounded,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Image.asset("assets/images/live.gif", height: 120),
                          Icon(
                            Icons.pending_outlined,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.person_3_outlined,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.apartment_rounded,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.edit_document,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.list_alt_rounded,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          )
                        ];
                        final routes = [
                          () => AssignClass_Screen(),
                          () => Attendance_Subjectlist(),
                          () => DatewisePendingScreen(),
                          () =>
                              ProfileDetails(userdetailsss: userdetailss.first),
                          () => TAScreen(),
                          () => AttendanceByDay(),
                          () => Subject_Wise_ReportCount()
                        ];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => routes[index]()),
                            );
                          },
                          child: Card(
                            color: colors[index],
                            margin: EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  iconss[index],
                                  SizedBox(height: 10),
                                  Text(
                                    titles[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                if (TaDatalists.isNotEmpty)
                  Expanded(
                    flex: 2,
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(7, (index) {
                        final colors = [
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                          ColorConstant.ismcolor,
                        ];
                        final titles = [
                          '',
                          'Ptofile',
                          'Attendance History',
                          "Create Attendance",
                          'Live TA Class',
                          'Pending Submission',
                          'Edit Attendance',
                        ];
                        final iconss = [
                          Image.asset("assets/images/live.gif", height: 120),
                          Icon(
                            Icons.person_2,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.history,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.create_new_folder_sharp,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.live_tv_outlined,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.pending_outlined,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                          Icon(
                            Icons.edit_calendar,
                            size: 50,
                            color: ColorConstant.whiteA700,
                          ),
                        ];
                        final routes = [
                          () => Stu_All_CourseScreen(),
                          () =>
                              ProfileDetails(userdetailsss: userdetailss.first),
                          () => Attendance_History(),
                          () => Ta_All_CourseScreen(),
                          () => LiveTa_Screen(),
                          () => TADatewisePendingScreen(),
                          () => TA_AttendanceByDay(),
                        ];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => routes[index]()),
                            );
                          },
                          child: Card(
                            color: colors[index],
                            margin: EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  iconss[index],
                                  SizedBox(height: 10),
                                  Text(
                                    titles[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      // } else if (sessionyear == "" && sessionget == "") {
      //   return Container();
      //   // Show a toast message
      //   Fluttertoast.showToast(
      //     msg: "Please select a session", // Toast message
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0,
      //   );

      //   // Navigate to the session screen
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             Session_SetScreen()), // Change to your session screen widget
      //     (Route<dynamic> route) => true,
      //   );
    } else {
      // _refreshPage();
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(color: ColorConstant.whiteA700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration:
                                BoxDecoration(color: ColorConstant.cyan300),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Are you Sure To Log Out',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstant.whiteA700,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        await preferences.clear();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                          (Route<dynamic> route) => false,
                                        );
                                        print('Logout button pressed');
                                        // Navigator.of(context).pop();
                                        // Handle OK action here
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.logout_outlined,
                    color: ColorConstant.whiteA700,
                    size: 35,
                  )),
            ),
          ],
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (connection == false)
              Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstant.redA700,
                  ),
                  child: Center(
                    child: Text("No Internet Connection",
                        style: TextStyle(
                          color: ColorConstant.whiteA700,
                        )),
                  )),
            if (connection == true) Center(child: CircularProgressIndicator()),
          ],
        )),
      );
    }
  }

//   Future<void> _initMobileNumber() async {
//     try {
//       // Request permission for reading phone state
//       if (await Permission.phone.request().isGranted) {
//         // Get SIM card info
//         simCards = (await MobileNumber.getSimCards) ?? [];

//         if (simCards.isNotEmpty) {
//           // Lists to store SIM data

//           // Iterate through all available SIM cards
//           for (var sim in simCards) {
//             String? simNumber = sim.number;

//             if (simNumber != null) {
//               SharedPreferences preferences =
//                   await SharedPreferences.getInstance();
//               setState(() {
//                 number = preferences.getString('inputno');
//                 otp = preferences.getString('otpdef');
//               });
//               if (simNumber == number || otp == '772370') {
//                 print('Sim are present in curernt device ');
//               } else {
//                 SharedPreferences preferences =
//                     await SharedPreferences.getInstance();
//                 await preferences.clear();
//                 final dbHelper = DatabaseHelper();
//                 // Truncate 'user' table
//                 await dbHelper.truncateTableuser('user');
//                 print('User table truncated!');

//                 // Truncate 'UserDetails' table
//                 await dbHelper.truncateTableuserdetails('UserDetails');
//                 print('UserDetails table truncated!');

//                 // Truncate 'userotherdetails' table
//                 await dbHelper
//                     .truncateTableuserotherdetails('userotherdetails');
//                 print('UserOtherDetails table truncated!');

//                 // Truncate 'tadetails' table
//                 await dbHelper.truncateTableta('tadetails');
//                 print('TADetails table truncated!');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                       content: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Your SIM card is not present in the current device.",
//                         textScaleFactor: 1,
//                       ),
//                     ],
//                   )),
//                 );
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                   (Route<dynamic> route) => false,
//                 );
//                 print('Logout button pressed');
//               }
//             }
//           }
//         } else {
//           print("No SIM cards available");
//           SharedPreferences preferences = await SharedPreferences.getInstance();
//           await preferences.clear();
//           final dbHelper = DatabaseHelper();
//           // Truncate 'user' table
//           await dbHelper.truncateTableuser('user');
//           print('User table truncated!');

//           // Truncate 'UserDetails' table
//           await dbHelper.truncateTableuserdetails('UserDetails');
//           print('UserDetails table truncated!');

//           // Truncate 'userotherdetails' table
//           await dbHelper.truncateTableuserotherdetails('userotherdetails');
//           print('UserOtherDetails table truncated!');

//           // Truncate 'tadetails' table
//           await dbHelper.truncateTableta('tadetails');
//           print('TADetails table truncated!');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   "Your SIM card is not present in the current device.",
//                   textScaleFactor: 1,
//                 ),
//               ],
//             )),
//           );
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//             (Route<dynamic> route) => false,
//           );
//           print('Logout button pressed');
//         }
//       } else {
//         SharedPreferences preferences = await SharedPreferences.getInstance();
//         await preferences.clear();
//         final dbHelper = DatabaseHelper();
//         // Truncate 'user' table
//         await dbHelper.truncateTableuser('user');
//         print('User table truncated!');

//         // Truncate 'UserDetails' table
//         await dbHelper.truncateTableuserdetails('UserDetails');
//         print('UserDetails table truncated!');

//         // Truncate 'userotherdetails' table
//         await dbHelper.truncateTableuserotherdetails('userotherdetails');
//         print('UserOtherDetails table truncated!');

//         // Truncate 'tadetails' table
//         await dbHelper.truncateTableta('tadetails');
//         print('TADetails table truncated!');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "Your SIM card is not present in the current device.",
//                 textScaleFactor: 1,
//               ),
//             ],
//           )),
//         );
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//           (Route<dynamic> route) => false,
//         );
//         print('Logout button pressed');
//       }
//     } catch (e) {
//       print("Failed to get mobile number: $e");
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       await preferences.clear();
//       final dbHelper = DatabaseHelper();
//       // Truncate 'user' table
//       await dbHelper.truncateTableuser('user');
//       print('User table truncated!');

//       // Truncate 'UserDetails' table
//       await dbHelper.truncateTableuserdetails('UserDetails');
//       print('UserDetails table truncated!');

//       // Truncate 'userotherdetails' table
//       await dbHelper.truncateTableuserotherdetails('userotherdetails');
//       print('UserOtherDetails table truncated!');

//       // Truncate 'tadetails' table
//       await dbHelper.truncateTableta('tadetails');
//       print('TADetails table truncated!');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               "Your SIM card is not present in the current device.",
//               textScaleFactor: 1,
//             ),
//           ],
//         )),
//       );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         (Route<dynamic> route) => false,
//       );
//       print('Logout button pressed');
//     }
//   }
// }

  Future<void> fetchDataAndPrint() async {
    List<Profile> profiles = await DBSQL.instance.fatchdataSQLNew();
    for (var profile in profiles) {
      print('Profile ID: ${profile.proId}');
      print('Name: ${profile.proname}');
      print('Email: ${profile.proemail}');
      print('Password: ${profile.propassword}');
      print('Is Saved: ${profile.issaved}');
      print('-------------------');
    }
  }
}
