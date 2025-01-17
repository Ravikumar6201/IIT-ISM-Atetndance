// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, must_be_immutable

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/ProfessorReport.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NEwListOfDAte extends StatefulWidget {
  String sub_id;
  DateTime date;
  NEwListOfDAte({required this.sub_id, required this.date});
  @override
  _NEwListOfDAteState createState() => _NEwListOfDAteState();
}

class _NEwListOfDAteState extends State<NEwListOfDAte> {
  TextEditingController _searchController = TextEditingController();

  List<DatewiseReport> DateList = [];

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
      String? sessionnew = preferences.getString('session');
      String? sessionyearnew = preferences.getString('sessionyear');
      String currentDate = DateFormat('yyyy-MM-dd').format(widget.date);
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
              '${ApiConstants.baseUrl}nep_Total_classByDate') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}Total_classByDate'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}Total_classByDate');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'sub_offered_id': widget.sub_id,
        'session': sessionnew,
        'sessionyear': sessionyearnew,
        'date': currentDate
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          if (jsonData is Map) {
            final courseData = jsonData['Stu_Course_Data'];

            if (courseData is List) {
              List<DatewiseReport> sessionList = [];

              for (var item in courseData) {
                sessionList.add(DatewiseReport.fromJson(item));
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
          "Total Class List",
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
      body: DateList.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: DateList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5),
                        child: InkWell(
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Dealy_AttendanceScreen(
                          //             sub_offered_id: DateList[index]
                          //                 .subOfferedId
                          //                 .toString(),
                          //             date: widget.date,
                          //             priods: DateList[index]
                          //                 .classPeriods
                          //                 .toString(),
                          //                 dates: currentdate,)),
                          //   );
                          // },
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
                                Expanded(
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
                                        '${index + 1}',
                                        style: TextStyle(
                                            color: ColorConstant.whiteA700),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
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
                                          "Number Of Class : ${DateList[index].classPeriods}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.arrow_forward),
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
            )
          : dealy
              ? Center(
                  child: Text(
                    "Please Select Session and Session Year",
                    style: TextStyle(fontSize: 18),
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
}
/* @override
  Widget build(BuildContext context) {
    if (DateList.isNotEmpty) {
      // if(sessionlist.isNotEmpty &&sessionyearlist.isNotEmpty){
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Total Class List",
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
                                builder: (context) => Dealy_AttendanceScreen(
                                    sub_offered_id:
                                        DateList[index].subOfferedId.toString(),
                                    date: widget.date,
                                    priods: DateList[index]
                                        .classPeriods
                                        .toString())),
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
                                            Text(
                                                "Number Of Class : " +
                                                    DateList[index]
                                                        .classPeriods,
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
                "No Course",
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
