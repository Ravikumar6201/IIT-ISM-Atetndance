// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/AttendancePending/DetailsPending.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DatewisePendingScreen extends StatefulWidget {
  @override
  _DatewisePendingScreenState createState() => _DatewisePendingScreenState();
}

class _DatewisePendingScreenState extends State<DatewisePendingScreen> {
  TextEditingController _searchController = TextEditingController();

  List<PendingListModel> DateList = [];

  String? sessionname;
  String? sessionyearname;
  @override
  void initState() {
    super.initState();
    _LoadAssignClass();
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

  String? userid;

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
      setState(() {
        userid = preferences.getString('userids');
      });
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_PendingAttendanceList_get') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}PendingAttendanceList_get'); // If isNEP is false

      // final Uri uri =
      // Uri.parse('${ApiConstants.baseUrl}PendingAttendanceList_get');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
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
                DateList = sessionList.reversed.toList();
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
          DateList = [];
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

  Ssesion? selectedSession;
  SessionYear? selectedSessionYear;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Total Pending Course",
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: Row(
          children: [
            if (DateList.isNotEmpty)
              InkWell(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(Icons.menu, color: ColorConstant.whiteA700),
              ),
            if (DateList.isEmpty)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new,
                    color: ColorConstant.whiteA700),
              ),
          ],
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      drawer: CustomDrawerProfessor(),
      body: DateList.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: DateList.length,
                    itemBuilder: (context, index) {
                      int id = index + 1;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 5.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Pending_ScreenSubmit(
                                  sub_offered_id:
                                      DateList[index].subOfferedId.toString(),
                                  session: DateList[index].session,
                                  sessionyear: DateList[index].sessionYear,
                                  date: DateList[index].date,
                                  priod: DateList[index].classPeriods,
                                  sub_id: DateList[index].courseCode,
                                  proid: userid.toString(),
                                ),
                              ),
                            ).then((value) => _LoadAssignClass());
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    padding: EdgeInsets.all(5.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateList[index].date,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            DateList[index].courseCode,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          // if (DateList[index].section != '')
                                          Text(
                                              'Class Period : ' +
                                                  DateList[index].classPeriods,
                                              style: TextStyle(fontSize: 16)),
                                          Text(
                                              'Course : ' +
                                                  DateList[index].sub_name,
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    padding: EdgeInsets.only(right: 0.0),
                                    child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Are you sure you want to discard attendance?',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors
                                                                      .red, // text color
                                                            ),
                                                            child: Text('NO'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              await Discart(
                                                                  DateList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors
                                                                      .green, // text color
                                                            ),
                                                            child: Text('YES'),
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
                                          Icons.delete,
                                          color: ColorConstant.redA700,
                                          size: 40,
                                        )),
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
                if (DateList.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 250.0),
                      child: Text(
                        "Please Select Session and Session Year",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
              ],
            )
          : dealy
              ? Center(
                  child: Text(
                    "No Class Pending",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Center(
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

  Future Discart(dynamic idpass) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // int idpass = int.parse(id);
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String? session = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_deleteAttendance') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}deleteAttendance'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}deleteAttendance');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {'id': idpass};

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _LoadAssignClass();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete Attendance Secussfully')),
        );
      } else {
        _LoadAssignClass();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Not Found')),
        );

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

/*  @override
  Widget build(BuildContext context) {
    if (DateList.isNotEmpty) {
      // if(sessionlist.isNotEmpty &&sessionyearlist.isNotEmpty){
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
        body: Column(
          children: [
            if (DateList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: DateList.length,
                  itemBuilder: (context, index) {
                    int id = index + 1; // Generates an ID starting from 1
                    String length = DateList[index].toString();
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 5, top: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pending_ScreenSubmit(
                                      sub_offered_id: DateList[index]
                                          .subOfferedId
                                          .toString(),
                                      session: DateList[index].session,
                                      sessionyear: DateList[index].sessionYear,
                                      date: DateList[index].date,
                                    )),
                          ).then((value) => _LoadAssignClass());
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
                                            Text(DateList[index].date,
                                                style: TextStyle(fontSize: 16)),
                                            Text(DateList[index].courseCode,
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
                                          children: [Icon(Icons.arrow_forward)],
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
            if (DateList.isEmpty)
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
      );
    } else if (DateList.isEmpty && dealy == true) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            children: [
              // if(sessionname =='')
              Text(
                "Session",
                style: TextStyle(color: ColorConstant.whiteA700),
              ),
              // if(sessionyearname =='')

              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  'session year',
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
                "No Class Pendinng",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => Session_SetScreen()),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: ColorConstant.ismcolor,
              //       // elevation: 3,
              //     ),
              //     child: Text(
              //       "Set Session And Session year",
              //       style: TextStyle(color: ColorConstant.whiteA700),
              //     )),
            ],
          ),
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
}*/
