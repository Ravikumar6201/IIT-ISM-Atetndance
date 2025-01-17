// ignore_for_file: use_key_in_widget_constructors, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/AllCourseListStudent.dart';
import 'package:ism/Screen(Student)/Attendance_sessionwise.dart';
import 'package:ism/Screen(Student)/Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance_History extends StatefulWidget {
  @override
  _Attendance_HistoryState createState() => _Attendance_HistoryState();
}

class _Attendance_HistoryState extends State<Attendance_History> {
  @override
  void initState() {
    _LoadAssignClass();
    _performSearch();
  }

  bool dealy = false;
  void _performSearch() async {
    await Future.delayed(Duration(seconds: 4)); // 2-second delay
    setState(() {
      dealy = true;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<StuCourseData> CourseAssignList = [];
  bool isLoading = false;
  String? sessionname;
  String? sessionyearname;

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
        sessionname = session.toString();
        sessionyearname = sessionyear.toString();
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_allAsignCourseStu_new') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}allAsignCourseStu_new'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}allAsignCourseStu');
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
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['Stu_Course_Data'];

            if (courseData is List) {
              List<StuCourseData> sessionList = [];

              for (var item in courseData) {
                sessionList.add(StuCourseData.fromJson(item));
              }

              setState(() {
                CourseAssignList = sessionList.reversed.toList();
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
        setState(() {
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Not Found')),
        );
        setState(() {
          CourseAssignList = [];
        });

        // print('HTTP request failed with status: ${response.statusCode}');
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

  @override
  Widget build(BuildContext context) {
    // if (CourseAssignList.isNotEmpty) {
    // if(sessionlist.isNotEmpty &&sessionyearlist.isNotEmpty){
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "All Course",
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
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              child: Column(
                children: [
                  if (CourseAssignList.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: CourseAssignList.length,
                        itemBuilder: (context, index) {
                          int id = index + 1; // Generates an ID starting from 1
                          String length = CourseAssignList[index].toString();
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5, top: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Student_HistoryScreen(
                                            sub_id: CourseAssignList[index]
                                                .subOfferedId,
                                            course: CourseAssignList[index]
                                                .courseCode,
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
                                                  Text(
                                                      CourseAssignList[index]
                                                          .courseCode,
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  Text(
                                                      "Course : " +
                                                          CourseAssignList[
                                                                  index]
                                                              .sub_name
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  //     Text(
                                                  // CourseAssignList[index]
                                                  //     .,
                                                  // style:
                                                  //     TextStyle(fontSize: 16)),
                                                  // if(CourseAssignList[index].subId !=null && CourseAssignList[index].subId !="")

                                                  // Text('Subject Code : 41245', style: TextStyle(fontSize: 16)),
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
                    ),
                  if (CourseAssignList.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 250.0),
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
    // } else if (CourseAssignList.isEmpty && dealy == true) {
    //   return Scaffold(
    //     key: _scaffoldKey,
    //     appBar: AppBar(
    //       title: Row(
    //         children: [
    //           // if(sessionname =='')
    //           Text(
    //             sessionname ?? "Session",
    //             style: TextStyle(color: ColorConstant.whiteA700),
    //           ),
    //           // if(sessionyearname =='')

    //           Padding(
    //             padding: const EdgeInsets.only(left: 5.0),
    //             child: Text(
    //               sessionyearname ?? 'session year',
    //               style: TextStyle(color: ColorConstant.whiteA700),
    //             ),
    //           ),
    //         ],
    //       ),
    //       leading: InkWell(
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //         child: Icon(Icons.arrow_back_ios_new_outlined,
    //             color: ColorConstant.whiteA700),
    //       ),
    //       backgroundColor: ColorConstant.ismcolor,
    //     ),
    //     body: Center(
    //       child: Text(
    //         "No Course",
    //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //       ),
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text(
    //         "All Course",
    //         style: TextStyle(color: ColorConstant.whiteA700),
    //       ),
    //       leading: InkWell(
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //         child: Icon(Icons.arrow_back_ios, color: ColorConstant.whiteA700),
    //       ),
    //       backgroundColor: ColorConstant.ismcolor,
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           CircularProgressIndicator(),
    //           Text('Please wait Data fetching...')
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }

  /* @override
  Widget build(BuildContext context) {
    _attendanceData.sort((a, b) => a['classCode'].compareTo(b['classCode']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance History',style: TextStyle(color: ColorConstant.whiteA700),),
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios,color: ColorConstant.whiteA700,),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: ListView.builder(
        itemCount: _attendanceData.length,
        itemBuilder: (context, index) {
          final item = _attendanceData[index];
          return InkWell(onTap: (){
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ToadyAttendanceP_TA(),
            //     ),
            //   );
          },
            child: ListTile(
              title: Text('Class: ${item['classCode']}'),
              subtitle: Text('Attendance: ${item['attendancePercentage']}%'),
              trailing: IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  _showHistory(context, item['history']);
                },
              ),
            ),
          );
        },
      ),
    );
  }*/

  void _showHistory(BuildContext context, String history) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance History'),
          content: Text(history),
          actions: <Widget>[
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
