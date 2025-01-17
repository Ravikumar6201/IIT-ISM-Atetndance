// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/sessionNsessionyear.dart';
import 'package:ism/Model/Cbcs_CourceModel.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:ism/Screen(Professor)/Report/ReportDateList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Subject_Wise_ReportCount extends StatefulWidget {
  @override
  _Subject_Wise_ReportCountState createState() =>
      _Subject_Wise_ReportCountState();
}

class _Subject_Wise_ReportCountState extends State<Subject_Wise_ReportCount> {
  TextEditingController _searchController = TextEditingController();

  List<Ssesion> sessionlist = [];
  List<SessionYear> sessionyearlist = [];
  List<SessionYear> TotalAssignClass = [];
  List<StudentData> CourseList = [];

  String? sessionname;
  String? sessionyearname;
  @override
  void initState() {
    super.initState();
    getsession();
    _performSearch();
    // _LoadSession();

    // _LoadAssignClass("","");
  }

  bool dealy = false;
  void _performSearch() async {
    await Future.delayed(Duration(seconds: 4)); // 2-second delay
    setState(() {
      dealy = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  Future<void> getsession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? session = preferences.getString('session');
    String? token = preferences.getString('token');
    String? sessionyear = preferences.getString('sessionyear');
    setState(() {
      sessionname = session.toString();
      sessionyearname = sessionyear.toString();
    });
    _LoadAssignClass(session.toString(), sessionyear.toString());
  }

  Future<void> _LoadSession() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
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
        if (jsonData['status'] == true) {
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
            } else {
              print('session_year key not found or is not a list.');
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
        print('HTTP request failed with status: ${response.statusCode}');
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

  String sessiondata = '';
  String sessioyeardata = '';
  Future<void> _LoadAssignClass(String session, String sessionyear) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      setState(() {
        sessiondata = session;
        sessioyeardata = sessionyear;
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_AsignCourse') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}AsignCourse'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}AsignCourse');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'auth_id': userid,
        'session': session,
        'sessionyear': sessionyear,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['Course_Data'];

            if (courseData is List) {
              List<StudentData> sessionList = [];

              for (var item in courseData) {
                sessionList.add(StudentData.fromJson(item));
              }

              setState(() {
                CourseList = sessionList.reversed.toList();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Not Found')),
        );
        setState(() {
          CourseList = [];
        });

        // print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Ssesion? selectedSession;
  SessionYear? selectedSessionYear;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // if ( CourseList.isNotEmpty) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Total Assign Course",
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: ColorConstant.whiteA700),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      drawer: CustomDrawerProfessor(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorConstant.ismcolor,
            ))
          : CourseList.isNotEmpty
              ? Expanded(
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
                                  builder: (context) => DatewiseReportScreen(
                                        sub_id: CourseList[index]
                                            .subOfferedId
                                            .toString(),
                                        session: sessiondata.toString(),
                                        sessionyear: sessioyeardata.toString(),
                                        courseName:
                                            CourseList[index].subId.toString(),
                                        section: CourseList[index]
                                            .section
                                            .toString(),
                                        course: CourseList[index]
                                            .sub_name
                                            .toString(),
                                      )),
                            );
                          },
                          child: Container(
                            height: 90,
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
                                      borderRadius:
                                          BorderRadiusDirectional.only(
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
                                              Text(CourseList[index].subId,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              if (CourseList[index].section !=
                                                      null ||
                                                  CourseList[index].section !=
                                                      "")
                                                Text('Subject Code : 41245',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              if (CourseList[index].subId !=
                                                      null &&
                                                  CourseList[index].subId != "")
                                                Text(
                                                    "Course : " +
                                                        CourseList[index]
                                                            .sub_name,
                                                    style: TextStyle(
                                                        fontSize: 14)),
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
                                              Icon(Icons.arrow_forward)
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
                )
              // if (CourseList.isEmpty)
              : Center(
                  child: Text(
                    " No Course",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
    );
    //   } else if (CourseList.isEmpty && dealy == true) {
    //     return Scaffold(
    //       key: _scaffoldKey,
    //       appBar: AppBar(
    //         title: Row(
    //           children: [
    //             // if(sessionname =='')
    //             Text(
    //               "All Course",
    //               style: TextStyle(color: ColorConstant.whiteA700),
    //             ),
    //             // if(sessionyearname =='')
    //           ],
    //         ),
    //         leading: InkWell(
    //           onTap: () {
    //             _scaffoldKey.currentState?.openDrawer();
    //           },
    //           child: Icon(Icons.menu, color: ColorConstant.whiteA700),
    //         ),
    //         backgroundColor: ColorConstant.ismcolor,
    //       ),
    //       body: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               "No Course",
    //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //             ),
    //             // ElevatedButton(
    //             //     onPressed: () {
    //             //       Navigator.push(
    //             //         context,
    //             //         MaterialPageRoute(
    //             //             builder: (context) => Session_SetScreen()),
    //             //       );
    //             //     },
    //             //     style: ElevatedButton.styleFrom(
    //             //       backgroundColor: ColorConstant.ismcolor,
    //             //       // elevation: 3,
    //             //     ),
    //             //     child: Text(
    //             //       "Set Session And Session year",
    //             //       style: TextStyle(color: ColorConstant.whiteA700),
    //             //     )),
    //           ],
    //         ),
    //       ),
    //     );
    //   } else {
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: Text(
    //           "All Course",
    //           style: TextStyle(color: ColorConstant.whiteA700),
    //         ),
    //         leading: InkWell(
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //           child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteA700),
    //         ),
    //         backgroundColor: ColorConstant.ismcolor,
    //       ),
    //       body: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             CircularProgressIndicator(),
    //             Text('Please wait Data fetching...')
    //           ],
    //         ),
    //       ),
    //     );
    //   }
  }
}
