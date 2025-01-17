// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:ism/Class/Colorconstat.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Student_HistoryScreen extends StatefulWidget {
//   const Student_HistoryScreen({super.key});

//   @override
//   State<Student_HistoryScreen> createState() => _Student_HistoryScreenState();
// }

// class _Student_HistoryScreenState extends State<Student_HistoryScreen> {
//   @override
//   initState() {
//     super.initState();
//     delayedOperation();
//     _handleTabClick(0);
//     _delayedFunction();
//   }

//   Future<void> delayedOperation() async {
//     await Future.delayed(Duration(seconds: 2));
//     // Perform delayed operation
//   }

//   String regularperc = '0';
//   String regulartotal = '0';
//   String powerperc = '0';
//   String powertotal = '0';
//   String otherperc = '0';
//   String othertotal = '0';

//   String extractDateAndTime(String timestamp) {
//     DateTime parsedDateTime = DateTime.parse(timestamp);
//     String formattedTime = "${parsedDateTime.hour}:${parsedDateTime.minute}";
//     String amPm = parsedDateTime.hour < 12 ? 'AM' : 'PM';
//     if (parsedDateTime.hour == 0) {
//       formattedTime = "12:${parsedDateTime.minute}";
//     } else if (parsedDateTime.hour > 12) {
//       formattedTime = "${parsedDateTime.hour - 12}:${parsedDateTime.minute}";
//     }
//     return "${parsedDateTime.day}/${parsedDateTime.month}/${parsedDateTime.year} ";
//   }

//   String calculatePercentage(String value1, String total1) {
//     double value = double.parse(value1.toString());
//     double total = double.parse(total1.toString());
//     double sum = 0.0;

//     if (total == 0) {
//       return sum.toString();
//     }
//     sum = (value / total) * 100;
//     String percentage = sum.toString();
//     return percentage;
//   }

//   int setpercentage = 0;
//   void _handleTabClick(int tabIndex) {
//     setState(() {
//       setpercentage = tabIndex;
//       startDate;
//       endDate;
//     });
//     // Call your function here based on the tabIndex
//     print('Tab $tabIndex clicked');
//   }

//   // date time picker
//   DateTime? startDate;
//   DateTime? endDate;
//   String _formattedDate(DateTime? date) {
//     return date != null ? '${date.day}/${date.month}/${date.year}' : 'None';
//   }

//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   bool timeout = false;
//   Future<void> _delayedFunction() async {
//     // Delay for 10 seconds
//     await Future.delayed(Duration(seconds: 1));

//     setState(() {
//       timeout = true;
//     });

//     // Your code to execute after the delay
//     print('Delayed function executed after 10 seconds');
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     if (timeout == true) {
//       return DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: ColorConstant.whiteA700,
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             title: Text(
//               "Attendance",
//               style: TextStyle(
//                 color: ColorConstant.whiteA700,
//               ),
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: Row(
//                   children: [
//                     if (setpercentage == 0)
//                       Text(
//                         calculatePercentage(powerperc, powertotal) + " %",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: ColorConstant.whiteA700,
//                         ),
//                       ),
//                     if (setpercentage == 1)
//                       Text(
//                         calculatePercentage(regularperc, regulartotal) + " %",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: ColorConstant.whiteA700,
//                         ),
//                       ),
//                     if (setpercentage == 2)
//                       Text(
//                         calculatePercentage(otherperc, othertotal) + " %",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: ColorConstant.whiteA700,
//                         ),
//                       ),
//                   ],
//                 ),
//               )
//             ],
//             backgroundColor: ColorConstant.ismcolor,
//             bottom: TabBar(
//               labelColor: ColorConstant.whiteA700,
//               unselectedLabelColor: ColorConstant.yellowA400,
//               onTap: _handleTabClick,
//               tabs: [
//                 Tab(text: 'Monsoon'),
//                 Tab(text: 'Winter'),
//                 Tab(text: 'Summer'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               _buildChartTab('Monsoon', '10', '20',
//                   'Monsoon'), // Assume 10 days absent in Monsoon
//               _buildChartTab('Winter', regularperc, regulartotal, 'Winter'),
//               _buildChartTab('Summer', otherperc, othertotal, 'Summer'),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: ColorConstant.whiteA700,
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Text(
//             "Attendance",
//             style: TextStyle(
//               color: ColorConstant.whiteA700,
//             ),
//           ),
//           backgroundColor: ColorConstant.ismcolor,
//         ),
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//   }

//   Widget _buildChartTab(String title, String value, String total, String type) {
//     return Column(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(show: true),
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: generateLast20DaysData(type, true),
//                     isCurved: true,
//                     color: ColorConstant.ismcolor,
//                     barWidth: 2,
//                     isStrokeCapRound: true,
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                   LineChartBarData(
//                     spots: generateLast20DaysData(type, false),
//                     isCurved: true,
//                     color: Colors.red,
//                     barWidth: 2,
//                     isStrokeCapRound: true,
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Text(
//           '$title: ${calculatePercentage(value, total)}%',
//           style: TextStyle(fontSize: 18, color: ColorConstant.whiteA700),
//         ),
//       ],
//     );
//   }

//   List<FlSpot> generateLast20DaysData(String type, bool present) {
//     List<FlSpot> spots = [];
//     DateTime today = DateTime.now();

//     for (int i = 0; i < 20; i++) {
//       DateTime date = today.subtract(Duration(days: 20 - i));
//       double value;

//       if (type == 'Monsoon' && !present) {
//         // Simulating 10 days absent in Monsoon period
//         value = (i < 10) ? 1 : 100;
//       } else {
//         // Random value generation, you should replace it with actual data
//         value = (present) ? (i * 5 + 20).toDouble() : 0;
//       }

//       spots.add(FlSpot(i.toDouble(), value));
//     }

//     return spots;
//   }
// }

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:http/http.dart' as http;
import 'package:ism/Model/AllCourseListStudent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student_HistoryScreen extends StatefulWidget {
  String sub_id, course;
  Student_HistoryScreen({required this.sub_id, required this.course});
  @override
  _Student_HistoryScreenState createState() => _Student_HistoryScreenState();
}

class _Student_HistoryScreenState extends State<Student_HistoryScreen> {
  @override
  void initState() {
    _LoadAssignClass();
  }

  List<StuCourseDataReport> CourseAssignList = [];
  List<StuCourseDataReport> CourseAssignListPresent = [];
  List<StuCourseDataReport> CourseAssignListAbsent = [];
  List<Autogenerated> CourseAssignap = [];
  bool isLoading = false;
  String? sessionname;
  String? sessionyearname;
  double? percentage;
  String percentageString = '';

  String formatDateTime(String dateTimess) {
    DateTime dateTime = DateTime.parse(dateTimess);
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    String hour = (dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12)
        .toString()
        .padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return "$day-$month-$year $hour:$minute $period";
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
              '${ApiConstants.baseUrl}nep_AsignCourseStu_AttendanceCount') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}AsignCourseStu_AttendanceCount'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}AsignCourseStu_AttendanceCount');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'session': session,
        'sessionyear': sessionyear,
        'admn_no': userid,
        'sub_offered_id': widget.sub_id,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['Stu_Course_Data'];

            if (courseData is List) {
              List<StuCourseDataReport> sessionList = [];
              List<StuCourseDataReport> sessionListpresnt = [];

              for (var item in courseData) {
                StuCourseDataReport student =
                    StuCourseDataReport.fromJson(item as Map<String, dynamic>);
                sessionListpresnt.add(student);

                if (student.status == '1') {
                  CourseAssignListPresent.add(student);
                }
                if (student.status == '0') {
                  CourseAssignListAbsent.add(student);
                }
              }
              for (var item in courseData) {
                sessionList.add(StuCourseDataReport.fromJson(item));
              }

              setState(() {
                CourseAssignList = sessionList.reversed.toList();
                CourseAssignListPresent;
                CourseAssignListAbsent;
                percentage =
                    (CourseAssignListPresent.length / CourseAssignList.length) *
                        100;
                percentageString = percentage!.toStringAsFixed(2);
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
          CourseAssignList = [];
        });
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

  @override
  Widget build(BuildContext context) {
    if (CourseAssignList.isNotEmpty) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.course ?? '',
            style: TextStyle(color: ColorConstant.whiteA700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                percentageString.toString() + ' %',
                style: TextStyle(color: ColorConstant.whiteA700, fontSize: 18),
              ),
            )
          ],
          leading: InkWell(
            onTap: () {
              // _scaffoldKey.currentState?.openDrawer();
              Navigator.pop(context);
            },
            child:
                Icon(Icons.arrow_back_ios_new, color: ColorConstant.whiteA700),
          ),
          backgroundColor: ColorConstant.ismcolor,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              // Table headers
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: Colors.grey[400],
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Center(
                            child: Text('Date',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Status',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                    Expanded(
                        child: Center(
                            child: Text('Remark',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                ),
              ),
              // Data rows
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: CourseAssignList.length,
                  itemBuilder: (context, index) {
                    final attendance = CourseAssignList[index];
                    bool isAbsent = attendance.status == '0';
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isAbsent ? Colors.red[100] : Colors.green[200],
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(
                                      formatDateTime(attendance.timestamp)))),
                          Expanded(
                            child: Center(
                                child: Text(statuschanger(attendance.status),
                                    style: TextStyle(
                                        color: isAbsent
                                            ? Colors.red
                                            : Colors.black))),
                          ),
                          Expanded(
                              child: Center(
                                  child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(attendance.attendanceRemark ?? ''),
                            ],
                          ))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              widget.course ?? '',
              style: TextStyle(color: ColorConstant.whiteA700),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "0.0%",
                  style:
                      TextStyle(color: ColorConstant.whiteA700, fontSize: 18),
                ),
              )
            ],
            leading: InkWell(
              onTap: () {
                // _scaffoldKey.currentState?.openDrawer();
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new,
                  color: ColorConstant.whiteA700),
            ),
            backgroundColor: ColorConstant.ismcolor,
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Please wait Data loading...')
            ],
          )));
    }
  }

  String statuschanger(String status) {
    if (status == '1') {
      return 'Present';
    } else {
      return 'Absent';
    }
  }
}
