// ignore_for_file: prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names, unused_element, unused_local_variable, camel_case_types, must_be_immutable, depend_on_referenced_packages, unused_field, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_advanced_networkimage_2/zoomable.dart';

class Current_AttendanceScreen extends StatefulWidget {
  String? sub_offered_id, session, sessionyear, date, otp, priod, sub_id, proid;

  Current_AttendanceScreen(
      {required this.sub_offered_id,
      required this.session,
      required this.sessionyear,
      required this.date,
      required this.otp,
      required this.priod,
      required this.sub_id,
      required this.proid});

  @override
  _Current_AttendanceScreenState createState() =>
      _Current_AttendanceScreenState();
}

class _Current_AttendanceScreenState extends State<Current_AttendanceScreen> {
  String totalStudent = '';
  String _search = '';
  String? _classtime;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _LoadAssignClass('');
    _performSearch();
    _absentOption();
    _searchController.addListener(_onSearchChanged);
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<AllOptions> allOptions = [];
  List<StudentAttendance> AllStudentList = [];
  List<StudentAttendance> UpdateStudentList = [];
  List<StudentAttendance> AbsentStudentList = [];
  List<StudentAttendance> PresentStudentList = [];
  bool isLoading = false;
  bool ischeck = true;
  bool pagerload = false;
  int presentStudent = 0;
  int? absentStudent;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _LoadAssignClass(_searchController.text);
    });
  }

  Future<void> _LoadAssignClass(String _search) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      setState(() {
        _classtime = preferences.getString('classtime');
      });
      String? currentDate;
      if (widget.date == 'null') {
        setState(() {
          currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      } else {
        setState(() {
          currentDate = widget.date;
        });
      }
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList_get') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList_get'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList_get');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': widget.session,
        'sessionyear': widget.sessionyear,
        'sub_offered_id': widget.sub_offered_id,
        'date': currentDate,
        'admn_no': _search,
        'class_periods': widget.priod,
        'auth_id': userid,
        'sub_code': widget.sub_id,
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
            List<StudentAttendance> statusOneList = [];

            for (var item in studentAttendanceMap) {
              StudentAttendance student =
                  StudentAttendance.fromJson(item as Map<String, dynamic>);
              sessionList.add(student);

              if (student.status == '0') {
                statusZeroList.add(student);
              } else {
                statusOneList.add(student);
              }
              // if (student.status == '1') {
              //   statusOneList.add(student);
              // }
            }

            setState(() {
              AllStudentList = sessionList;
              PresentStudentList = statusOneList;
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

//present
  Future<void> PresentStudent(String _search) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      setState(() {
        _classtime = preferences.getString('classtime');
      });
      String? currentDate;
      if (widget.date == 'null') {
        setState(() {
          currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      } else {
        setState(() {
          currentDate = widget.date;
        });
      }
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList_get') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList_get'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList_get');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': widget.session,
        'sessionyear': widget.sessionyear,
        'sub_offered_id': widget.sub_offered_id,
        'date': currentDate,
        'admn_no': _search,
        'class_periods': widget.priod,
        'auth_id': userid,
        'sub_code': widget.sub_id,
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
            List<StudentAttendance> statusOneList = [];

            for (var item in studentAttendanceMap) {
              StudentAttendance student =
                  StudentAttendance.fromJson(item as Map<String, dynamic>);
              sessionList.add(student);

              if (student.status == '0') {
                statusZeroList.add(student);
              } else {
                statusOneList.add(student);
              }
            }

            setState(() {
              AllStudentList = statusOneList;
              PresentStudentList = statusOneList;
              AbsentStudentList = statusZeroList;
              // absentStudent = AbsentStudentList.length;
              // totalStudent = AllStudentList.length.toString();
              // presentStudent = AllStudentList.length - AbsentStudentList.length;
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

//absent
  Future<void> AbsentStudent(String _search) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      setState(() {
        _classtime = preferences.getString('classtime');
      });
      String? currentDate;
      if (widget.date == 'null') {
        setState(() {
          currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        });
      } else {
        setState(() {
          currentDate = widget.date;
        });
      }
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList_get') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList_get'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList_get');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': widget.session,
        'sessionyear': widget.sessionyear,
        'sub_offered_id': widget.sub_offered_id,
        'date': currentDate,
        'admn_no': _search,
        'class_periods': widget.priod,
        'auth_id': userid,
        'sub_code': widget.sub_id,
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
            List<StudentAttendance> statusOneList = [];

            for (var item in studentAttendanceMap) {
              StudentAttendance student =
                  StudentAttendance.fromJson(item as Map<String, dynamic>);
              sessionList.add(student);

              if (student.status == '0') {
                statusZeroList.add(student);
              } else {
                statusOneList.add(student);
              }
            }

            setState(() {
              AllStudentList = statusZeroList;
              PresentStudentList = statusOneList;
              AbsentStudentList = statusZeroList;
              // absentStudent = AbsentStudentList.length;
              // totalStudent = AllStudentList.length.toString();
              // presentStudent = AllStudentList.length - AbsentStudentList.length;
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

  Future<void> _absentOption() async {
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
          ? Uri.parse(
              '${ApiConstants.baseUrl}getAbsentOption') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}getAbsentOption'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}getAbsentOption');
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
            final courseData = jsonData['allAbsentOption_list'];

            if (courseData is List) {
              List<AllOptions> sessionList = [];

              for (var item in courseData) {
                sessionList.add(AllOptions.fromJson(item));
              }
              setState(() {
                allOptions = sessionList.reversed.toList();
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
      }
    } catch (err) {
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

  Future<void> _AbsentAttendanceUpdate(String classpriod) async {
    setState(() {
      isLoading = true;
      ischeck = false;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? auth_id = preferences.getString('userids');
      // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_AbsentAttendanceUpdate') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}AbsentAttendanceUpdate'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}AbsentAttendanceUpdate');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // for (var student in StudentList) {
      try {
        final Map<String, dynamic> body = {
          "session": widget.session,
          "sessionyear": widget.sessionyear,
          "sub_offered_id": widget.sub_offered_id,
          'date': widget.date,
          "class_periods": classpriod,
          'sub_id': widget.sub_id,
          'auth_id': auth_id,
          'pro_id': auth_id

          // Assuming status is a field in StudentDataList
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'success') {
            if (jsonData['status'] == 'success') {
              attendancepostAlrt(context);
              Fluttertoast.showToast(
                msg: "Attendance record for  inserted successfully",
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
        print('An error occurred while processing : $err');
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
        ischeck = true;
      });
    }
  }

  Future<void> _Post_Attendance_Student_update() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList_update') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList_update'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList_update');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // for (var student in StudentList) {
      try {
        final Map<String, dynamic> body = {
          "session": widget.session,
          "sessionyear": widget.sessionyear,
          "sub_offered_id": widget.sub_offered_id,
          'date': widget.date,

          // Assuming status is a field in StudentDataList
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          // if (jsonData['status'] == 'success') {

          if (jsonData['status'] == true) {
            // Handle success scenario for this student
            print('Attendance record for  inserted successfully');
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
        print('An error occurred while processing : $err');
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

  Future<void> UpdateStatus(
      String adminNo, String classpriods, String Status, String remark) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String? remarkss;
      if (remark == '') {
        setState(() {
          remarkss = "Present";
        });
      } else {
        remarkss = remark.toString();
      }
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_UpdateAttendanceStatus') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}UpdateAttendanceStatus'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}UpdateAttendanceStatus');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'admn_no': adminNo,
        'status': Status,
        'date': widget.date,
        'sub_offered_id': widget.sub_offered_id,
        'class_periods': classpriods,
        'attendance_remark': remarkss,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance Update')),
          );
          _LoadAssignClass('');
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
      _LoadAssignClass('');
    }
  }

  void _updateAttendanceStatus(int index, String status) {
    setState(() {
      AllStudentList[index].status == status;
      int originalIndex = AbsentStudentList.indexWhere(
          (student) => student == AllStudentList[index].admnNo);
      if (originalIndex != -1) {
        AbsentStudentList[originalIndex].status = AllStudentList[index].status;
        // AbsentStudentList.add(AbsentStudentList[originalIndex].status);
      }
      // _filteredStudents = _students.where((student) => (widget.isPresent && student['status'] == 'Present') || (!widget.isPresent && student['status'] == 'Absent')).toList();
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawerProfessor(),
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    totalStudent,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                    flex: 1,
                    // ignore: sort_child_properties_last
                    child: Row(children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _search = value;
                            });
                          },
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            iconColor: Colors.white,
                            hoverColor: Colors.white,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              AbsentStudentList = <StudentAttendance>[];
                            });
                            _LoadAssignClass(_search.toString());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorConstant.ismcolor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      /*   Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _search = value;
                            });
                          },
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            iconColor: Colors.white,
                            hoverColor: Colors.white,
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              AllStudentList = <StudentAttendance>[];
                            });
                            _LoadAssignClass(_search.toString());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorConstant.ismcolor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
             */
                    ]))
              ],
            ),
            leading: InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Icon(Icons.menu, color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: InkWell(
                  onTap: () {
                    _LoadAssignClass('');
                    setState(() {
                      pagerload = true;
                    });
                  },
                  child: Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
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
              : Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      //button tab
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _LoadAssignClass(_search);
                                setState(() {
                                  _currentIndex = 0;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _currentIndex == 0
                                    ? ColorConstant.ismcolor
                                    : Colors.grey,
                              ),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  color: _currentIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                PresentStudent(_search);
                                setState(() {
                                  _currentIndex = 1;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _currentIndex == 1
                                    ? ColorConstant.ismcolor
                                    : Colors.grey,
                              ),
                              child: Text(
                                'Present',
                                style: TextStyle(
                                  color: _currentIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  AbsentStudent(_search);
                                  _currentIndex = 2;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _currentIndex == 2
                                    ? ColorConstant.ismcolor
                                    : Colors.grey,
                              ),
                              child: Text(
                                'Absent',
                                style: TextStyle(
                                  color: _currentIndex == 2
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Text(
                                    "Present: $presentStudent",
                                    // style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Absent: $absentStudent",
                                    // style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: Text(
                                    "Attendance OTP: " + widget.otp.toString(),
                                    // style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      AttendanceTimeExtand(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorConstant.ismcolor,
                                    ),
                                    child: Text(
                                      'Extend Time',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
                            int id =
                                index + 1; // Generates an ID starting from 1
                            String length = AllStudentList[index].toString();
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
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
                                    /* Flexible(
                                      flex: 2,
                                      child: Container(
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                            topStart: Radius.circular(10),
                                            bottomStart: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              if (AllStudentList[index].image !=
                                                  null)
                                                InkWell(
                                                  onTap: () {
                                                    _showZoomableImagereal(
                                                      context,
                                                      AllStudentList[index]
                                                          .image
                                                          .toString(),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 65,
                                                    child: Image.network(
                                                      AllStudentList[index]
                                                          .image
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (AllStudentList[index].image ==
                                                  null)
                                                InkWell(
                                                  onTap: () {
                                                    _showZoomableImage(context,
                                                        "assets/images/image1.jpg");
                                                  },
                                                  child: Container(
                                                    height: 65,
                                                    child: Image.asset(
                                                      "assets/images/image1.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                   */
                                    Flexible(
                                      flex: 5,
                                      child: Container(
                                        width: constraints.maxWidth * 0.5,
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
                                                  Text(
                                                      'Physically Not Verified',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.red)),
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
                                              width: 65,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("Present",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Checkbox(
                                                    value: AllStudentList[index]
                                                            .status ==
                                                        '1',
                                                    onChanged: (bool? value) {
                                                      if (value != null &&
                                                          value) {
                                                        _updateAttendanceStatus(
                                                            index, '1');
                                                        UpdateStatus(
                                                            AllStudentList[
                                                                    index]
                                                                .admnNo,
                                                            AllStudentList[
                                                                    index]
                                                                .classPeriods,
                                                            '1',
                                                            "");
                                                      }
                                                    },
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
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Checkbox(
                                                    value: AllStudentList[index]
                                                            .status ==
                                                        '0',
                                                    onChanged: (bool? value) {
                                                      if (value != null &&
                                                          value) {
                                                        AbsentAlert(
                                                          context,
                                                          index,
                                                          AllStudentList[index]
                                                              .admnNo,
                                                          AllStudentList[index]
                                                              .classPeriods,
                                                        );
                                                      }
                                                    },
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
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            child: Column(
              children: [
                ischeck
                    ? ElevatedButton(
                        onPressed: () async {
                          if (pagerload == true) {
                            _AbsentAttendanceUpdate(
                                AllStudentList.first.classPeriods);
                            // attendancepostAlrt(context);
                          } else {
                            pagereload(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          backgroundColor: ColorConstant.ismcolor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  /* @override
  Widget build(BuildContext context) {
    if (AllStudentList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawerProfessor(),
        appBar: AppBar(
          // title: Text(
          //   totalStudent,
          //   style: TextStyle(color: ColorConstant.whiteA700),
          // ),
          title: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    totalStudent
                    // + " (OTP :" + otp + ")"
                    ,
                    style: TextStyle(color: ColorConstant.whiteA700),
                  )),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _search = value;
                          });
                        },
                        cursorColor: ColorConstant.whiteA700,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          focusColor: ColorConstant.whiteA700,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search",
                          hintStyle: TextStyle(color: ColorConstant.whiteA700),
                          fillColor: ColorConstant.whiteA700,
                          // filled: true,
                          iconColor: ColorConstant.whiteA700,
                          hoverColor: ColorConstant.whiteA700,
                        ),
                        style: TextStyle(color: ColorConstant.whiteA700),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            AllStudentList = <StudentAttendance>[];
                          });
                          _LoadAssignClass(_search.toString());
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: ColorConstant.ismcolor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(Icons.menu, color: ColorConstant.whiteA700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () {
                  _LoadAssignClass('');
                  setState(() {
                    pagerload = true;
                  });
                },
                child: Icon(
                  Icons.replay,
                  color: ColorConstant.whiteA700,
                  size: 30,
                ),
              ),
            ),
          ],
          // actions: [
          //   Container(   width: 200,
          //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

          //     child: TextField(
          //             onChanged: (value) async {
          //               setState(() {
          //                 _search = value;
          //                 AllStudentList = <AllStudentAttendanceList>[];
          //               });
          //               // getpop(context);
          //               _LoadAssignClass(_search.toString());
          //             },
          //             cursorColor: ColorConstant.whiteA700,
          //             keyboardType: TextInputType.text,
          //             textInputAction: TextInputAction.go,
          //             decoration: InputDecoration(
          //                 focusColor: ColorConstant.whiteA700,
          //                 border: InputBorder.none,
          //                 contentPadding: EdgeInsets.symmetric(horizontal: 15),
          //                 hintText: "Search",
          //                 // suffixIcon: Icon(Icons.search),
          //                 hoverColor: ColorConstant.whiteA700),
          //           ),
          //   ),
          // ],
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                child: Column(
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                  child: Text(
                                "Present : " + presentStudent.toString(),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                  child: Text(
                                "Attendance OTP : " + otp,
                                style: TextStyle(fontSize: 18),
                              )),
                              Center(
                                  child: ElevatedButton(
                                onPressed: () {
                                  AttendanceTimeExtand(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.ismcolor,
                                  // elevation: 3,
                                ),
                                child: Text(
                                  'Time Extend',
                                  style:
                                      TextStyle(color: ColorConstant.whiteA700),
                                ),
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
                                    flex: 2,
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.only(
                                          topStart: Radius.circular(10),
                                          bottomStart: Radius.circular(10),
                                        ),
                                        // color: ColorConstant.ismcolor,
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            if (AllStudentList[index].image !=
                                                null)
                                              InkWell(
                                                onTap: () {
                                                  _showZoomableImagereal(
                                                    context,
                                                    AllStudentList[index]
                                                        .image
                                                        .toString(),
                                                  );
                                                },
                                                child: Container(
                                                  height: 65,
                                                  child: Image.network(
                                                    AllStudentList[index]
                                                        .image
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            if (AllStudentList[index].image ==
                                                null)
                                              InkWell(
                                                onTap: () {
                                                  _showZoomableImage(context,
                                                      "assets/images/image1.jpg");
                                                },
                                                child: Container(
                                                  height: 65,
                                                  // width: 50,
                                                  child: Image.asset(
                                                    "assets/images/image1.jpg",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                          ],
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
                                                  onChanged: (bool? value) {
                                                    if (value != null &&
                                                        value) {
                                                      _updateAttendanceStatus(
                                                          index, '1');
                                                      UpdateStatus(
                                                          AllStudentList[index]
                                                              .admnNo,
                                                          AllStudentList[index]
                                                              .classPeriods,
                                                          '1',
                                                          "");
                                                    }
                                                  },
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
                                                          value) {
                                                        AbsentAlert(
                                                          context,
                                                          index,
                                                          AllStudentList[index]
                                                              .admnNo,
                                                          AllStudentList[index]
                                                              .classPeriods,
                                                        );
                                                      }
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
              ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
            child: Column(
              children: [
                ischeck
                    ? ElevatedButton(
                        onPressed: () async {
                          if (pagerload == true) {
                            // await _Post_Attendance_Student_update();
                            _AbsentAttendanceUpdate(
                                AllStudentList.first.classPeriods);
                            attendancepostAlrt(context);
                          } else {
                            pagereload(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          backgroundColor: ColorConstant.ismcolor,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      )
                    : SpinKitWave(
                        color: ColorConstant.ismcolor,
                        size: 50.0,
                        type: SpinKitWaveType.center,
                      ),
              ],
            ),
          ),
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

  String? _selectedOption;
  void AbsentAlert(BuildContext context, index, admn, classpriod) {
    final _formKey = GlobalKey<FormState>();
    final _textControllerremark = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 100,
            height: 200,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Remark',
                    ),
                    items: allOptions.map((AllOptions option) {
                      return DropdownMenuItem<String>(
                        value: option.name,
                        child: Text(option.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Remark field is required';
                      }
                      return null;
                    },
                  ),
                  // TextFormField(
                  //   controller: _textControllerremark,
                  //   decoration: InputDecoration(
                  //     labelText: 'Enter Remark',
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'This field is required';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform some action with the input
                        _updateAttendanceStatus(index, '0');
                        UpdateStatus(
                            admn, classpriod, '0', _selectedOption.toString());
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Time Extended ')),
            );
            print('Time Extand ' + widget.date.toString());
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
                'Attendance submission successful.',
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text('Close'),
                  // ),
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
