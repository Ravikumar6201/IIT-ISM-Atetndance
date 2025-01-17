// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_label, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/Cbcs_CourceModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:ism/Screen(Professor)/SujectTA_Details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TAScreen extends StatefulWidget {
  @override
  _TAScreenState createState() => _TAScreenState();
}

class _TAScreenState extends State<TAScreen> {
  final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];
  List<StudentData> CourseList = [];
  String? sessions, sessionsyear;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _LoadAssignClass();
  }

  void _showFormDialog(String ft_id, sub_offered_id, sub_code) {
    final TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('TA Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  labelText: 'Enter Admission No.',
                  labelStyle: TextStyle(color: Colors.blue),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
                style: TextStyle(
                  backgroundColor: Colors.blue[50],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Course Name : "), Text(sub_code ?? "")],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Session : "), Text(sessions ?? '')],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: BorderRadius.circular(10)),
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Session Year : "),
                      Text(sessionsyear ?? "")
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  Add_TA(_textFieldController.text, ft_id, sub_offered_id,
                      sub_code);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        sessions = session;
        sessionsyear = sessionyear;
        // sessiondata=session.toString();
        // sessioyeardata=sessionyear.toString();
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
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
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
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: CourseList.length,
                itemBuilder: (context, index) {
                  int id = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Subject_TAScreen(
                              sub_of: CourseList[index].subOfferedId.toString(),
                              sub_code: CourseList[index].subId.toString(),
                              section: CourseList[index].section.toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
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
                                padding: const EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        CourseList[index].subId,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                          'Course : ' +
                                              CourseList[index].sub_name,
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _showFormDialog(
                                      CourseList[index].empNo,
                                      CourseList[index].subOfferedId,
                                      CourseList[index].subId,
                                    );
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                        color: ColorConstant.ismcolor),
                                  )),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "All Course",
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

  /* @override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
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
                        left: 8.0, right: 8.0, bottom: 5, top: 5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Subject_TAScreen(
                                  sub_of: CourseList[index].subOfferedId,
                                  sub_code: CourseList[index].subId)),
                        );
                      },
                      // _classpriodes(context, CourseList[index].subOfferedId);
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
                                          Text(CourseList[index].subId,
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
                                          InkWell(
                                            onTap: () {
                                              _showFormDialog(
                                                  CourseList[index].empNo,
                                                  CourseList[index]
                                                      .subOfferedId,
                                                  CourseList[index].subId);
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: 35,
                                            ),
                                          )
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
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "All Course",
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
  Future<void> Add_TA(String admn_no, ft_id, sub_offered_id, sub_code) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}nep_Add_TA') // If isNEP is true
          : Uri.parse('${ApiConstants.baseUrl}Add_TA'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}Add_TA');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // for (var student in StudentList) {
      try {
        final Map<String, dynamic> body = {
          "status": 'Active',
          "remark": 'Assign',
          "admn_no": admn_no,
          'ft_id': ft_id,
          "sub_offered_id": sub_offered_id,
          'sub_code': sub_code,
          "session": session,
          'session_year': sessionyear
          // Assuming status is a field in StudentDataList
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == true) {
            Fluttertoast.showToast(
              msg: jsonData['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            // Handle success scenario for this student
            print('Attendance record for  inserted successfully');
          } else {
            // Handle error scenario for this student
            print('Failed to insert attendance record for ');
            if (jsonData.containsKey('error')) {
              print('Error message: ${jsonData['error']}');
            }
          }
        } else {
          print('HTTP request failed with status: ${response.statusCode}');
        }
      } catch (err) {
        print('An error occurred while processing : $err');
      }
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
