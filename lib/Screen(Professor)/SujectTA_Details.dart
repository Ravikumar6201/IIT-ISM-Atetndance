// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_label, no_leading_underscores_for_local_identifiers, camel_case_types, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/Ta_CourseModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subject_TAScreen extends StatefulWidget {
  String sub_of, sub_code, section;
  Subject_TAScreen(
      {required this.sub_of, required this.sub_code, required this.section});
  @override
  _Subject_TAScreenState createState() => _Subject_TAScreenState();
}

class _Subject_TAScreenState extends State<Subject_TAScreen> {
  List<Data> CourseList = [];
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _LoadAssignClass();
    _performSearch();
  }

  bool dealy = false;
  void _performSearch() async {
    await Future.delayed(Duration(seconds: 10)); // 2-second delay
    setState(() {
      dealy = true;
    });
  }

  Future<void> _LoadAssignClass() async {
    setState(() {
      isLoading = true;
      CourseList = [];
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      setState(() {
        // sessiondata=session.toString();
        // sessioyeardata=sessionyear.toString();
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}nep_Get_TA') // If isNEP is true
          : Uri.parse('${ApiConstants.baseUrl}Get_TA'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}Get_TA');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'ft_id': userid,
        'session': session,
        'session_year': sessionyear,
        'sub_offered_id': widget.sub_of,
        'sub_code': widget.sub_code,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['data'];
            if (courseData is List) {
              List<Data> sessionList = [];

              for (var item in courseData) {
                sessionList.add(Data.fromJson(item));
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

  final bool delay = true;
  @override
  Widget build(BuildContext context) {
    if (CourseList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
        appBar: AppBar(
          title: Text(
            widget.sub_code + " (" + widget.section + ")",
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
            delay
                ? Expanded(
                    child: ListView.builder(
                      itemCount: CourseList.length,
                      itemBuilder: (context, index) {
                        int id = index + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          child: InkWell(
                            onTap: () {
                              // Define your onTap action here
                            },
                            child: Container(
                              height: 70,
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
                                              CourseList[index].admnNo,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              CourseList[index].subCode,
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
                                      child: InkWell(
                                        onTap: () {
                                          _Deletepop(context,
                                              CourseList[index].admnNo);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 35,
                                          color: ColorConstant.redA700,
                                        ),
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
                : CircularProgressIndicator(),
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
    } else if (CourseList.isEmpty && delay == true) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "TA List",
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
          child: Text(
            "No TA For This Subject",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "TA List",
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
            "All Assign TA",
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
                      // _classpriodes(context, CourseList[index].subOfferedId);
                      onTap: () {
                        // AttendanceTimeExtand(context);
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
                                          Text(CourseList[index].admnNo,
                                              style: TextStyle(fontSize: 16)),
                                          Text(CourseList[index].subCode,
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
                                              _Deletepop(context,
                                                  CourseList[index].admnNo);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 35,
                                              color: ColorConstant.redA700,
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
    } else if (CourseList.isEmpty && dealy == true) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "TA List",
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
          child: Text(
            "No TA For This Subject",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "TA List",
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

  void _Deletepop(BuildContext context, String admn_no) {
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
            decoration: BoxDecoration(color: Colors.cyan[300]),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Are you Sure Delete TA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _Delete(admn_no);
                        Navigator.of(context).pop();
                        print('delete button pressed');
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
  }

  Future<void> _Delete(String admn_no) async {
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
              '${ApiConstants.baseUrl}nep_Delete_TA') // If isNEP is true
          : Uri.parse('${ApiConstants.baseUrl}Delete_TA'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}Delete_TA');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'ft_id': userid,
        'session': session,
        'session_year': sessionyear,
        'sub_offered_id': widget.sub_of,
        'sub_code': widget.sub_code,
        'admn_no': admn_no
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true) {
          _LoadAssignClass();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('TA Deleted Secussfully')),
          );
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
}
