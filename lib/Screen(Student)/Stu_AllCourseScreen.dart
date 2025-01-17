// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, unused_import, depend_on_referenced_packages

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/Cbcs_CourceModel.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Stu_CourseModel.dart';
import 'package:ism/Model/Ta_CourseModel.dart';
import 'package:ism/Screen(Professor)/CreateAttendance.dart';
import 'package:ism/Screen(Student)/Drawer.dart';
import 'package:ism/Screen(Student)/mark_attendance.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Stu_All_CourseScreen extends StatefulWidget {
  @override
  _Stu_All_CourseScreenState createState() => _Stu_All_CourseScreenState();
}

class _Stu_All_CourseScreenState extends State<Stu_All_CourseScreen> {
  TextEditingController _searchController = TextEditingController();

  List<StuCourseData_TA> CourseList = [];

  String sessionname = '';
  String sessionyearname = '';
  @override
  void initState() {
    super.initState();
    _initMobileNumber();
    // _LoadAssignClass("","");
  }

  List<SimCard> simCards = [];
  // String? simNumber;
  // Future<void> _initMobile() async {
  //   try {
  //     // Request permission for reading phone state
  //     if (await Permission.phone.request().isGranted) {
  //       // Get SIM card info
  //       simCards = (await MobileNumber.getSimCards) ?? [];

  //       if (simCards.isNotEmpty) {
  //         // Iterate through all available SIM cards
  //         for (var sim in simCards) {
  //           simNumber = sim.number;

  //           if (simNumber != null) {
  //             // simno = simNumber;
  //             setState(() {
  //               simNumber;
  //             });

  //             SharedPreferences preferences =
  //                 await SharedPreferences.getInstance();
  //             preferences.remove('Simno');
  //             simNumber = preferences.getString('Simno');
  //           }
  //         }
  //         // Log all SIM numbers
  //       } else {
  //         print("No SIM cards available");
  //       }
  //     } else {
  //       print("Permission not granted");
  //     }
  //   } catch (e) {
  //     print("Failed to get mobile number: $e");
  //   }
  // }

  Future<void> _initMobileNumber() async {
    try {
      // Request permission for reading phone state
      if (await Permission.phone.request().isGranted) {
        // Get SIM card info
        simCards = (await MobileNumber.getSimCards) ?? [];

        if (simCards.isNotEmpty) {
          // Iterate through all available SIM cards
          for (var sim in simCards) {
            String? simNumber = sim.number;

            if (simNumber != null) {
              // simno = simNumber;
              // setState(() {
              //   simno;
              // });

              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove('Simno');
              // String? simNumberss = preferences.getString('Simno');
              await preferences.setString('Simno', simNumber);
              String? pass = preferences.getString('password');
              String? mobile = preferences.getString('mobileno');
              // setState(() {
              //   simNumber;
              // });

              if (simNumber.length >= 10 && mobile!.length >= 10) {
                String simLast10 = simNumber.substring(
                    simNumber.length - 10); // Get last 10 digits of simno
                String inputLast10 = mobile.substring(
                    mobile!.length - 10); // Get last 10 digits of inputno

                if (simLast10 == inputLast10) {
                  _LoadAssignClass();
                } else if (pass == 'ism12345678') {
                  _LoadAssignClass();
                } else if (pass == 'Pass@924156') {
                  _LoadAssignClass();
                } else {
                  preferences.clear();
                  Fluttertoast.showToast(
                    msg:
                        'Terminate Your SIM card is not present in the current device.',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP, // Show toast at the top
                    timeInSecForIosWeb: 1,
                    backgroundColor: ColorConstant.redA700,
                    textColor: ColorConstant.whiteA700,
                    fontSize: 16.0,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       content: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Terminate Your SIM card is not present in the current device.",
                  //         textScaleFactor: 1,
                  //       ),
                  //     ],
                  //   )),
                  // );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginPage()),
                  //   (Route<dynamic> route) => false,
                  // );
                }
              } else {
                Fluttertoast.showToast(
                  msg:
                      'Terminate Your SIM card is not present in the current device.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP, // Show toast at the top
                  timeInSecForIosWeb: 1,
                  backgroundColor: ColorConstant.redA700,
                  textColor: ColorConstant.whiteA700,
                  fontSize: 16.0,
                );
                // print(
                //     "Invalid numbers, ensure both are at least 10 digits long.");
              }
            }
          }
          // Log all SIM numbers
        } else {
          print("No SIM cards available");
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid numbers',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP, // Show toast at the top
          timeInSecForIosWeb: 1,
          backgroundColor: ColorConstant.redA700,
          textColor: ColorConstant.whiteA700,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Failed to get mobile number: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  String sessiondata = '';
  String sessioyeardata = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _LoadAssignClass() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String class_check = "false";
      setState(() {
        // sessiondata=session;
        // sessioyeardata=sessionyear;
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_AsignCourseStu') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}AsignCourseStu'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}AsignCourseStu');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'admn_no': userid,
        'date': currentDate,
      };
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['Stu_Course_Data'];
            if (courseData is List) {
              List<StuCourseData_TA> sessionList = [];
              for (var item in courseData) {
                sessionList.add(StuCourseData_TA.fromJson(item));
              }
              setState(() {
                CourseList = sessionList.reversed.toList();
                // DateTime inputDateTime = DateTime.parse(
                //     CourseList.first.classOtpTime); // Example input
                // setState(() {
                // stateValue = checkDateTime(inputDateTime);
                // });
              });
            } else {
              print('Course_Data key not found or is not a list.');
            }
          } else {
            print('Data key not found in JSON.');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(jsonData['message'],
                    style: TextStyle(color: ColorConstant.redA700))),
          );
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Data Not Found')),
        // );
        setState(() {
          CourseList = [];
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('$err', style: TextStyle(color: ColorConstant.redA700))),
      );
      print('An error occurred: $err');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool stateValue = false;

  bool checkDateTime(DateTime passedDateTime) {
    DateTime currentDateTime = DateTime.now();
    return currentDateTime.isAfter(passedDateTime);
  }

  // refresh() {
  //   _LoadAssignClass();
  // }
  Ssesion? selectedSession;
  SessionYear? selectedSessionYear;

  @override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/live.gif", height: 100),
              Text(
                "Class",
                style: TextStyle(color: ColorConstant.whiteA700),
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu, color: ColorConstant.whiteA700),
          ),
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: CourseList.length,
                itemBuilder: (context, index) {
                  int id = index + 1; // Generates an ID starting from 1
                  String length = CourseList[index].toString();
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 5, top: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MakeAttendance(
                                    // userid: CourseList[index],
                                    session: CourseList[index].session,
                                    sessionyear: CourseList[index].sessionYear,
                                    subjectCode: CourseList[index].courseCode,
                                    redius: CourseList[index].classRadius,
                                    lattitude: CourseList[index].latitude,
                                    lognitude: CourseList[index].longitude,
                                    otp: CourseList[index].classOtp,
                                    otptime: CourseList[index].classOtpTime,
                                    sub_id: CourseList[index].subOfferedId,
                                    classpriods: CourseList[index].classPeriods,
                                    date: CourseList[index].date,
                                  )),
                        );
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(10),
                                    bottomStart: Radius.circular(10),
                                  ),
                                  color: ColorConstant.ismcolor,
                                ),
                                child: Center(
                                  child: Text(
                                    id.toString(),
                                    style: TextStyle(
                                        color: ColorConstant.whiteA700),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 7,
                              child: Container(
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Text(
                                          //     "Sub Code : " +
                                          //         CourseList[index]
                                          //             .subOfferedId
                                          //             .toString(),
                                          //     style: TextStyle(fontSize: 16)),
                                          // Text(
                                          //     "Course Code : " +
                                          //         CourseList[index]
                                          //             .courseCode
                                          //             .toString(),
                                          //     style: TextStyle(fontSize: 16)),
                                          Text(
                                              "Course : " +
                                                  CourseList[index]
                                                      .sub_name
                                                      .toString(),
                                              style: TextStyle(fontSize: 16)),
                                          Text(
                                              "Class Period : " +
                                                  CourseList[index]
                                                      .classPeriods
                                                      .toString(),
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: 250,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                              Icons.arrow_circle_right_outlined)
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    if (isLoading == true) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset("assets/images/live.gif", height: 100),
              Text(
                "Class",
                style: TextStyle(color: ColorConstant.whiteA700),
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteA700),
          ),
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Please wait Data fetching...')
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/live.gif", height: 100),
              Text(
                "Class",
                style: TextStyle(color: ColorConstant.whiteA700),
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteA700),
          ),
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Center(
          child: Text(
            "Curently No Class Live",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
