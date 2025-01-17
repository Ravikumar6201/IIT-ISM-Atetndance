// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(TA)/TodayAttendanceByTA.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LiveTa_Screen extends StatefulWidget {
  @override
  _LiveTa_ScreenState createState() => _LiveTa_ScreenState();
}

class _LiveTa_ScreenState extends State<LiveTa_Screen> {
  TextEditingController _searchController = TextEditingController();

  List<Ssesion> sessionlist = [];
  List<SessionYear> sessionyearlist = [];
  List<SessionYear> TotalAssignClass = [];
  List<PendingListModel> CourseList = [];

  String sessionname = '';
  String sessionyearname = '';
  @override
  void initState() {
    super.initState();
    _LoadAssignClass();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  String sessiondata = '';
  String sessioyeardata = '';

  Future<void> _LoadAssignClass() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      setState(() {
        sessiondata = session.toString();
        sessioyeardata = sessionyear.toString();
      });

      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_LiveAsignCourseTA') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}LiveAsignCourseTA'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}LiveAsignCourseTA');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'admn_no': userid,
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
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var isLandscape = screenSize.width > screenSize.height;
    var appBarHeight = AppBar().preferredSize.height;
    var padding = 8.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/live.gif", height: appBarHeight),
            SizedBox(width: padding),
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
      body: CourseList.isNotEmpty
          ? Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: CourseList.length,
                      itemBuilder: (context, index) {
                        int id = index + 1; // Generates an ID starting from 1
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Current_AttendanceScreen_TA(
                                    sub_offered_id: CourseList[index]
                                        .subOfferedId
                                        .toString(),
                                    session: sessiondata,
                                    sessionyear: sessioyeardata,
                                    date: CourseList[index].date.toString(),
                                    otp: CourseList[index].classOtp.toString(),
                                    priod: CourseList[index]
                                        .classPeriods
                                        .toString(),
                                    sub_id:
                                        CourseList[index].courseCode.toString(),
                                    proid:
                                        CourseList[index].engagedBy.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height:
                                  screenSize.height * 0.1, // Responsive height
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: screenSize.width *
                                        0.1, // Responsive width
                                    decoration: BoxDecoration(
                                      color: ColorConstant.ismcolor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        id.toString(),
                                        style: TextStyle(
                                            color: ColorConstant.whiteA700),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Course Code : " +
                                                  CourseList[index].courseCode,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            if (CourseList[index].section !=
                                                    null &&
                                                CourseList[index].section != "")
                                              Text(
                                                "Course : " +
                                                    CourseList[index].sub_name,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            if (CourseList[index]
                                                    .classPeriods !=
                                                null)
                                              Text(
                                                "Class Period : " +
                                                    CourseList[index]
                                                        .classPeriods,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                          Icons.arrow_circle_right_outlined),
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
            )
          : Center(
              child: Text(
                "Currently No Class Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
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
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              /* Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<Ssesion>(
                      value: selectedSession,
                      hint: Text('Select Session'),
                      onChanged: (Ssesion? newValue) {
                        setState(() {
                          selectedSession = newValue;
                          sessionname =selectedSession!.session;
                        });
                      },
                      items: sessionlist.map<DropdownMenuItem<Ssesion>>((Ssesion value) {
                        return DropdownMenuItem<Ssesion>(
                          value: value,
                          child: Text(value.session),
                        );
                      }).toList(),
                    ),
                    DropdownButton<SessionYear>(
                      value: selectedSessionYear,
                      hint: Text('Session Year'),
                      onChanged: (SessionYear? newValue) {
                        setState(() {
                          selectedSessionYear = newValue;
                          sessionyearname= selectedSessionYear!.sessionYear;
                        });
                      },
                      items: sessionyearlist.map<DropdownMenuItem<SessionYear>>((SessionYear value) {
                        return DropdownMenuItem<SessionYear>(
                          value: value,
                          child: Text(value.sessionYear),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                       await _LoadAssignClass(sessionname,sessionyearname);
                        // Handle submit action
                        // print('Selected Session: ${sessionname}, Selected Year: ${sessionyearname}');
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
              if(CourseList.isNotEmpty)*/
              Expanded(
                child: ListView.builder(
                  itemCount: CourseList.length,
                  itemBuilder: (context, index) {
                    int id = index + 1; // Generates an ID starting from 1
                    String length = CourseList[index].toString();
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 4, top: 4),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Current_AttendanceScreen(
                                      sub_offered_id: CourseList[index]
                                          .subOfferedId
                                          .toString(),
                                      session: sessiondata.toString(),
                                      sessionyear: sessioyeardata.toString(),
                                      date: CourseList[index]
                                          .date
                                          .toString(),
                                      // class_priod: '1',
                                    )),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ToadyAttendanceP_TA(
                          //             sub_offered_id: CourseList[index]
                          //                 .subOfferedId
                          //                 .toString(),
                          //             session: sessiondata.toString(),
                          //             sessionyear: sessioyeardata.toString(),
                          //             // class_priod: '1',
                          //           )),
                          // );
                          // _classpriodes(context, CourseList[index].subOfferedId);
                          //     Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ToadyAttendanceP_TA(sub_offered_id: CourseList[index].subOfferedId.toString(),session: sessiondata.toString(),sessionyear: sessioyeardata.toString(),class_priod: '1',)),
                          // );
                        },
                        child: Container(
                          height: 50,
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
                                            Text(
                                                "Course Code : " +
                                                    CourseList[index]
                                                        .courseCode,
                                                style: TextStyle(fontSize: 16)),
                                            // Text(CourseList[index].subOfferedId,
                                            //     style: TextStyle(fontSize: 16)),
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
                                            Icon(Icons
                                                .arrow_circle_right_outlined)
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
              if (CourseList.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Text(
                      "Please Select Session and Session Year",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    } else if (CourseList.isEmpty) {
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
            "Currently No Class Available",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
*/
  void _classpriodes(
    BuildContext context,
    String sub_id,
  ) {
    final List<int> dataList = [1, 2];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text("Select Priodes"),
              // Padding(
              //   padding: const EdgeInsets.only(left: 5.0),
              //   child: Text(sessionyearname ?? 'Session Year'),
              // ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                        color: ColorConstant.ismcolor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dataList[index].toString(),
                                    style: TextStyle(
                                        color: ColorConstant.whiteA700)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                color: ColorConstant.whiteA700),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
