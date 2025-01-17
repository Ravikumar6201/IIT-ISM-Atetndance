// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, unused_element, unused_local_variable, camel_case_types, must_be_immutable, depend_on_referenced_packages, unused_field, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_advanced_networkimage_2/zoomable.dart';

class AllStudenrListScreen extends StatefulWidget {
  String sub_offered_id, date;

  AllStudenrListScreen({required this.sub_offered_id, required this.date});

  @override
  _AllStudenrListScreenState createState() => _AllStudenrListScreenState();
}

class _AllStudenrListScreenState extends State<AllStudenrListScreen> {
  String totalStudent = '';
  String _search = '';
  String? _classtime;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
  }

  List<StudentAttendance> AllStudentList = [];
  List<StudentAttendance> UpdateStudentList = [];
  List<StudentAttendance> AbsentStudentList = [];
  bool isLoading = false;
  bool ischeck = true;
  bool pagerload = false;
  int presentStudent = 0;
  int? absentStudent;
  String? session, sessionyear;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _LoadAssignClass() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      setState(() {
        _classtime = preferences.getString('classtime');
        session = preferences.getString('session');
        sessionyear = preferences.getString('sessionyear');
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList_getReport') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList_getReport'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList_getReport');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': session,
        'sessionyear': sessionyear,
        'sub_offered_id': widget.sub_offered_id,
        'date': widget.date,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          if (jsonData is Map<String, dynamic> &&
              jsonData.containsKey('attendance_list')) {
            final attendanceList =
                jsonData['attendance_list'] as Map<String, dynamic>;

            final studentAttendanceMap =
                attendanceList['student_attendance'] as List;

            List<StudentAttendance> sessionList = [];
            List<StudentAttendance> statusZeroList = [];

            for (var item in studentAttendanceMap) {
              StudentAttendance student =
                  StudentAttendance.fromJson(item as Map<String, dynamic>);
              sessionList.add(student);

              if (student.status == '0') {
                statusZeroList.add(student);
              }
            }

            setState(() {
              AllStudentList = sessionList;
              AbsentStudentList = statusZeroList;
              absentStudent = AbsentStudentList.length;
              totalStudent = AllStudentList.length.toString();
              presentStudent = AllStudentList.length - AbsentStudentList.length;
            });
          } else {
            print('AllStudentAttendanceList key not found or is not a map.');
            setState(() {
              AllStudentList = [];
            });
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
          AllStudentList = [];
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('$err', style: TextStyle(color: ColorConstant.redA700))),
      );
      print('An error occurred: $err');
      setState(() {
        AllStudentList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawerProfessor(),
      appBar: AppBar(
        title: Text(
          '$totalStudent  (${widget.date})',
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
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Please wait Data fetching...')
                ],
              ),
            )
          : AllStudentList.isNotEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.05,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Text(
                                  "Present: $presentStudent",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Absent: $absentStudent",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: AllStudentList.length,
                        itemBuilder: (context, index) {
                          int id = index + 1;
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
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
                                              color: ColorConstant.whiteA700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      width: width * 0.6,
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
                                                  'Roll No: ${AllStudentList[index].admnNo}'),
                                              Text(
                                                  'Name: ${AllStudentList[index].stu_name ?? ""}'),
                                              if (AllStudentList[index]
                                                          .remark2 ==
                                                      "1" ||
                                                  AllStudentList[index]
                                                          .remark2 ==
                                                      null)
                                                Text('Physically Not Verified',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .accentColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width * 0.12,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Present",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: ColorConstant
                                                            .green900,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Checkbox(
                                                  value: AllStudentList[index]
                                                          .status ==
                                                      '1',
                                                  onChanged: (bool? value) {},
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Absent",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: ColorConstant
                                                            .redA701,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  child: Checkbox(
                                                    value: AllStudentList[index]
                                                            .status ==
                                                        '0',
                                                    onChanged: (bool? value) {
                                                      if (value != null &&
                                                          value) {}
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : dealy
                  ? Center(
                      child: Text(
                        "Currently No Attendance List Found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    if (AllStudentList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
        appBar: AppBar(
          title: Text(
            totalStudent + '  (' + widget.date + ')',
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                                child: Text(
                              "Persent : " + presentStudent.toString(),
                              style: TextStyle(fontSize: 18),
                            )),
                            Center(
                                child: Text(
                              "Absent : " + absentStudent.toString(),
                              style: TextStyle(fontSize: 18),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: AllStudentList.length,
                      itemBuilder: (context, index) {
                        int id = index + 1; // Generates an ID starting from 1
                        String length = AllStudentList[index].toString();
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 5, top: 5),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              // border: Border.all(width: ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
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
                                            color: ColorConstant.whiteA700,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
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
                                            Text(
                                                'Roll No: ${AllStudentList[index].admnNo}'),
                                            if (AllStudentList[index].remark2 ==
                                                    "1" ||
                                                AllStudentList[index].remark2 ==
                                                    null)
                                              Text('Physically Not Verified',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ColorConstant
                                                          .accentColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 65,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Present",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: ColorConstant
                                                          .green900,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Checkbox(
                                                value: AllStudentList[index]
                                                        .status ==
                                                    '1',
                                                onChanged: (bool? value) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 65,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Absent",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          ColorConstant.redA701,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                child: Checkbox(
                                                  value: AllStudentList[index]
                                                          .status ==
                                                      '0',
                                                  onChanged: (bool? value) {
                                                    if (value != null &&
                                                        value) {}
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 65,
                                        //   child: Column(
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     children: [
                                        //       Text("Leave", style: TextStyle(fontSize: 10, color: ColorConstant.black900, fontWeight: FontWeight.bold)),
                                        //       Checkbox(
                                        //         value: _filteredStudents[index]['status'] == 'Leave',
                                        //         onChanged: (bool? value) {
                                        //           if (value != null && value) {
                                        //             _updateAttendanceStatus(index, 'Leave');
                                        //           }
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      );
    } else if (AllStudentList.isEmpty && dealy == true) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "List Of Student",
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
            "Currently No Attendance List Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "List Of Student",
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
  void _showZoomableImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 400.0, // Set the height as needed
            child: ZoomableWidget(
              maxScale: 5.0,
              minScale: 0.5,
              multiFingersPan: false,
              autoCenter: true,
              child: Image(image: AssetImage(image)),
              // child: Image(image: NetworkImage(widget.Memeberdetails.photo)),
            ),
          ),
        );
      },
    );
  }

  void _showZoomableImagereal(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 400.0, // Set the height as needed
            child: ZoomableWidget(
              maxScale: 5.0,
              minScale: 0.5,
              multiFingersPan: false,
              autoCenter: true,
              child: Image(image: NetworkImage(image)),
              // child: Image(image: NetworkImage(widget.Memeberdetails.photo)),
            ),
          ),
        );
      },
    );
  }

  String Extaended = '';
  //update time for current class
  Future<void> updadateclasstimme(String updatetime) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_OtpTimeUpdate') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}OtpTimeUpdate'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}OtpTimeUpdate');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // for (var student in StudentList) {
      try {
        final Map<String, dynamic> body = {
          "session": session,
          "sessionyear": sessionyear,
          "sub_offered_id": widget.sub_offered_id,
          'otp_time': updatetime.toString(),
          'date': widget.date,
          // Assuming status is a field in StudentDataList
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == true) {
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
      // }
      // attendancepostAlrt(context);
    } catch (err) {
      print('An error occurred: $err');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime? classotpvalied;
  String addMinutesToCurrentTime(int minutes) {
    DateTime currentTime = DateTime.now();
    DateTime newTime = currentTime.add(Duration(minutes: minutes));
    setState(() {
      classotpvalied = newTime;
    });
    print("new class $classotpvalied");
    return DateFormat('HH:mm').format(newTime); // Format the time as HH:mm
  }

  String? newtime;
  void _onTextChanged(String text) {
    if (text.isNotEmpty) {
      int minutes = int.tryParse(text) ?? 0;
      final newTime = addMinutesToCurrentTime(minutes);

      print('New Time: $newTime');
    }
  }

  void AttendanceTimeExtand(BuildContext context) {
    final TextEditingController _classextand = TextEditingController();
    int counter = 0;

    void _incrementCounter() {
      counter++;
      addMinutesToCurrentTime(counter);
    }

    void _decrementCounter() {
      if (counter > 0) counter--;
      addMinutesToCurrentTime(counter);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Attendance Time Extend'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(50),
                            color: ColorConstant.redA700),
                        child: IconButton(
                          icon: Icon(Icons.remove,
                              color: ColorConstant.whiteA700),
                          onPressed: () {
                            setState(_decrementCounter);
                          },
                        ),
                      ),
                      Text(
                        '$counter',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(50),
                            color: ColorConstant.green900),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: ColorConstant.whiteA700,
                          ),
                          onPressed: () {
                            setState(_incrementCounter);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    updadateclasstimme(classotpvalied.toString());
                    print('Text: ${_classextand.text}');
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //make time extand
  /* void AttendanceTimeExtand(BuildContext context) {
    final TextEditingController _classextand = TextEditingController();
    int counter = 0;

    void _incrementCounter() {
      setState(() {
        counter++;
      });
    }

    void _decrementCounter() {
      setState(() {
        if (counter > 0) counter--;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Last Time'),
          content: Column(
            children: [
              TextField(
                controller: _classextand,
                decoration: InputDecoration(
                    hintText: 'Enter New Time', suffix: Text('Min')),
                onChanged: _onTextChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(_decrementCounter);
                    },
                  ),
                  Text(
                    '$counter',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(_incrementCounter);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updadateclasstimme(classotpvalied.toString());
                print('Text: ${_classextand.text}');
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
*/
}

void pagereload(BuildContext context) {
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
          decoration: BoxDecoration(
            color: Color(0xFF00BCD4),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Please reload Page Then Submit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstant.redA700,
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
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void attendancepostAlrt(BuildContext context) {
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
          decoration: BoxDecoration(
            color: Color(0xFF00BCD4),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Are you sure you want to submit Attendance ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                        (Route<dynamic> route) => true,
                      );
                      // Fluttertoast.showToast(
                      //   msg: "Data Submitted Successfully",
                      //   toastLength: Toast.LENGTH_SHORT,
                      //   gravity: ToastGravity.BOTTOM,
                      //   timeInSecForIosWeb: 1,
                      //   backgroundColor: Colors.black,
                      //   textColor: Colors.white,
                      //   fontSize: 16.0,
                      // );
                      // Navigator.of(context).pop();
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
