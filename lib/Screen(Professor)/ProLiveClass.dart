// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Core/provider.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:ism/Screen(Professor)/TodayAttendance.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Attendance_Subjectlist extends StatefulWidget {
  @override
  _Attendance_SubjectlistState createState() => _Attendance_SubjectlistState();
}

class _Attendance_SubjectlistState extends State<Attendance_Subjectlist> {
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
    _performSearch();
    // UserProfile();

    // _LoadSession();
    // _LoadAssignClass("","");
  }

  String? Token;
  String? userID;
  String? session;
  String? sessionyear;
  bool isnep = false;
  UserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    sessionyear = preferences.getString('sessionyear');
    session = preferences.getString('session');
    Token = preferences.getString('token');
    userID = preferences.getString('userids');
    isnep = preferences.getBool('isNEP') ?? false;
    setState(() {
      Token;
      userID;
      Token;
      userID;
      isnep;
    });
    print(Token);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //get recent job
      final provider = context.read<UserProvider>();
      bool isSuccess = await provider.loadAssignClassLive(Token.toString(),
          userID.toString(), session.toString(), sessionyear.toString(), isnep);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Courses loaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load courses.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
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
              '${ApiConstants.baseUrl}nep_LiveAsignCourse_professor') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}LiveAsignCourse_professor'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}LiveAsignCourse_professor');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        // 'userid': userid,
        'session': session,
        'sessionyear': sessionyear,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Ssesion? selectedSession;
  SessionYear? selectedSessionYear;

  @override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
        appBar: AppBar(
          title: Text(
            "Live Class",
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: CourseList.length,
                      itemBuilder: (context, index) {
                        int id = index + 1; // Generates an ID starting from 1
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Current_AttendanceScreen(
                                          sub_offered_id:
                                              CourseList[index].subOfferedId,
                                          session: sessiondata.toString(),
                                          sessionyear:
                                              sessioyeardata.toString(),
                                          date: CourseList[index].date,
                                          otp: CourseList[index].classOtp,
                                          priod: CourseList[index].classPeriods,
                                          sub_id: CourseList[index].courseCode,
                                          proid: CourseList[index].engagedBy,
                                        )),
                              );
                              // _classpriodes(context, CourseList[index].subOfferedId);
                            },
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      width: constraints.maxWidth * 0.6,
                                      padding: const EdgeInsets.all(5.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(CourseList[index].courseCode,
                                                style: TextStyle(fontSize: 16)),
                                            Text(
                                                'Class Period : ' +
                                                    CourseList[index]
                                                        .classPeriods,
                                                style: TextStyle(fontSize: 16)),
                                            if (CourseList[index].section !=
                                                null)
                                              Text(
                                                  'Section : ' +
                                                      CourseList[index].section,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            if (CourseList[index].sub_name !=
                                                null)
                                              Text(
                                                  'Course : ' +
                                                      CourseList[index]
                                                          .sub_name,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: constraints.maxWidth * 0.1,
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
            );
          },
        ),
      );
    } else if (CourseList.isEmpty && dealy) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Live Class",
            style: TextStyle(color: ColorConstant.whiteA700),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:
                Icon(Icons.arrow_back_ios_new, color: ColorConstant.whiteA700),
          ),
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Live Class",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Live Class",
            style: TextStyle(color: ColorConstant.whiteA700),
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
    }
  }

  /*@override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
        appBar: AppBar(
          title: Text(
            "Live Class",
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
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: CourseList.length,
                  itemBuilder: (context, index) {
                    int id = index + 1; // Generates an ID starting from 1
                    String length = CourseList[index].toString();
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 5, top: 5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Current_AttendanceScreen(
                                      sub_offered_id:
                                          CourseList[index].subOfferedId,
                                      session: sessiondata.toString(),
                                      sessionyear: sessioyeardata.toString(),
                                      date: CourseList[index].date,
                                    )),
                          );
                          // _classpriodes(context, CourseList[index].subOfferedId);
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
                                            Text(CourseList[index].courseCode,
                                                style: TextStyle(fontSize: 16)),
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
    } else if (CourseList.isEmpty && dealy == true) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              // if(sessionname =='')
              Text(
                "Live",
                style: TextStyle(color: ColorConstant.whiteA700),
              ),
              // if(sessionyearname =='')

              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  'Class',
                  style: TextStyle(color: ColorConstant.whiteA700),
                ),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Live Class",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Live Class",
            style: TextStyle(color: ColorConstant.whiteA700),
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
