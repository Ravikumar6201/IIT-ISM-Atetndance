// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/Cbcs_CourceModel.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Session_SetScreen extends StatefulWidget {
  @override
  _Session_SetScreenState createState() => _Session_SetScreenState();
}

class _Session_SetScreenState extends State<Session_SetScreen> {
  TextEditingController _searchController = TextEditingController();

  List<Ssesion> sessionlist = [];
  List<SessionYear> sessionyearlist = [];
  List<SessionYear> TotalAssignClass = [];
  List<StudentData> CourseList = [];

  String sessionname = '';
  String sessionyearname = '';
  @override
  void initState() {
    super.initState();
    _LoadSession();
    // _LoadAssignClass("","");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  String? session;
  String? sessionyear;

  Future<void> _LoadSession() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the shared preferences instance
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // Retrieve token, isNEP, session, and sessionyear from shared preferences
      String? token = preferences.getString('token');
      bool isNEP = false;

      setState(() {
        isNEP =
            preferences.getBool('isNEP') ?? false; // Default is "CBSE" (false)
        session = preferences.getString("session") ?? "";
        sessionyear = preferences.getString("sessionyear") ?? '';
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse('${ApiConstants.baseUrl}sessionyear') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}sessionyear'); // If isNEP is false
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
                content: Text('$err',
                    style: TextStyle(color: ColorConstant.redA700))),
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
      preferences.remove('session');
      preferences.remove('sessionyear');
      await preferences.setString('session', session);
      await preferences.setString('sessionyear', sessionyear);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session And Session Year Set Secussfully')),
      );
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
    if (sessionlist.isNotEmpty && sessionyearlist.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Session And Session Year",
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
            Container(
              width: double.infinity,
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
                  color: ColorConstant.ismcolor,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<Ssesion>(
                      value: selectedSession,
                      hint: Text('Session'),
                      onChanged: (Ssesion? newValue) {
                        setState(() {
                          selectedSession = newValue;
                          sessionname = selectedSession!.session;
                        });
                      },
                      items: sessionlist
                          .map<DropdownMenuItem<Ssesion>>((Ssesion value) {
                        return DropdownMenuItem<Ssesion>(
                          value: value,
                          child: Text(
                            value.session,
                            style: TextStyle(color: ColorConstant.ismcolor),
                          ),
                        );
                      }).toList(),
                      dropdownColor: ColorConstant.whiteA700,
                      style: TextStyle(
                          color: ColorConstant.ismcolor, fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down,
                          color: ColorConstant.ismcolor),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<SessionYear>(
                      value: selectedSessionYear,
                      hint: Text('Session Year',
                          style: TextStyle(color: Colors.grey[600])),
                      onChanged: (SessionYear? newValue) {
                        setState(() {
                          selectedSessionYear = newValue;
                          sessionyearname = selectedSessionYear?.sessionYear;
                        });
                      },
                      items: sessionyearlist.map<DropdownMenuItem<SessionYear>>(
                          (SessionYear value) {
                        return DropdownMenuItem<SessionYear>(
                          value: value,
                          child: Text(
                            value.sessionYear,
                            style: TextStyle(color: ColorConstant.ismcolor),
                          ),
                        );
                      }).toList(),
                      dropdownColor: ColorConstant.whiteA700,
                      style: TextStyle(
                          color: ColorConstant.ismcolor, fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down,
                          color: ColorConstant.ismcolor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _LoadAssignClass(sessionname, sessionyearname);
                      // Handle submit action
                      print(
                          'Selected Session: $sessionname, Selected Year: $sessionyearname');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.ismcolor,
                      // elevation: 3,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: ColorConstant.whiteA700),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selected Session : ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  session ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selected Session Year : ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  sessionyear ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
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
}
