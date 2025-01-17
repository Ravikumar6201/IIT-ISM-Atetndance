// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/Edit/HistoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceByDay extends StatefulWidget {
  const AttendanceByDay({super.key});

  @override
  _AttendanceByDayState createState() => _AttendanceByDayState();
}

class _AttendanceByDayState extends State<AttendanceByDay> {
  late final Map<DateTime, List> _events;
  late final ValueNotifier<List> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isLoading = false;
  String? sessionname;
  String? sessionyearname;
  List<AttendanceList> CourseList = [];

  @override
  void initState() {
    super.initState();

    // Define absent dates
    DateTime absentDate1 = DateTime(2024, 6, 1);
    DateTime absentDate3 = DateTime(2024, 6, 3);

    // Initialize _events with absent dates
    _events = {
      absentDate1: ['Absent'],
      absentDate3: ['Absent'],
    };

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_events[_selectedDay] ?? []);
  }

  Future<void> _LoadAssignClass(DateTime date) async {
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
      String currentDate = DateFormat('yyyy-MM-dd').format(date);

      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_Total_class_date_Emp') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}Total_class_date_Emp'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}Total_class_date_Emp');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        // 'userid': userid,
        'session': session,
        'sessionyear': sessionyear,
        'date': currentDate
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          if (jsonData is Map) {
            final courseData = jsonData['attendance_list'];

            if (courseData is List) {
              List<AttendanceList> sessionList = [];

              for (var item in courseData) {
                sessionList.add(AttendanceList.fromJson(item));
              }

              setState(() {
                CourseList = sessionList.reversed.toList();
              });
              showPopup(context, date, currentDate);
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
        showPopupempty(context, currentDate);
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

  void showPopup(
      BuildContext context, DateTime? selectedDay, String currentdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(currentdate),
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
              itemCount: CourseList.length,
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
                                Text(CourseList[index].courseCode,
                                    style: TextStyle(
                                        color: ColorConstant.whiteA700)),
                                Text(
                                    "Class Period : " +
                                        CourseList[index].classPeriods,
                                    style: TextStyle(
                                        color: ColorConstant.whiteA700)),
                                if (CourseList[index].section.isNotEmpty &&
                                    CourseList[index].section != null)
                                  Text("Section : " + CourseList[index].section,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dealy_AttendanceScreen(
                              sub_offered_id:
                                  CourseList[index].subOfferedId.toString(),
                              date: selectedDay!,
                              priods: CourseList[index].classPeriods.toString(),
                              dates: currentdate)),
                    );
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

  void showPopupempty(BuildContext context, String selectedDay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(selectedDay),
              // Padding(
              //   padding: const EdgeInsets.only(left: 5.0),
              //   child: Text(sessionyearname ?? 'Session Year'),
              // ),
            ],
          ),
          content: Container(
            width: double.maxFinite * 0.1,
            height: 200,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
                color: ColorConstant.ismcolor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Available Class ",
                      style: TextStyle(color: ColorConstant.whiteA700),
                    ),
                    Text(
                      selectedDay,
                      style: TextStyle(color: ColorConstant.whiteA700),
                    )
                  ],
                ),
              ),
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

  List _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      print(selectedDay);

      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      _LoadAssignClass(selectedDay);
    } else {
      _LoadAssignClass(selectedDay);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'en_US', // Ensure the locale is set to English (US)
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2090, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.sunday, // Start the week on Sunday
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: _getEventsForDay,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          bool isWeekend = date.weekday == DateTime.saturday ||
              date.weekday == DateTime.sunday;
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
                  _events.containsKey(date) ? Colors.red : Colors.transparent,
            ),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isWeekend ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          );
        },
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle()
            .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        weekdayStyle: TextStyle()
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  // Widget _buildTableCalendar() {
  //   return TableCalendar(
  //     firstDay: DateTime.utc(2010, 10, 16),
  //     lastDay: DateTime.utc(2030, 3, 14),
  //     focusedDay: _focusedDay,
  //     calendarFormat: _calendarFormat,
  //     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  //     onDaySelected: _onDaySelected,
  //     onFormatChanged: (format) {
  //       if (_calendarFormat != format) {
  //         setState(() {
  //           _calendarFormat = format;
  //         });
  //       }
  //     },
  //     onPageChanged: (focusedDay) {
  //       _focusedDay = focusedDay;
  //     },
  //     eventLoader: _getEventsForDay,
  //     calendarBuilders: CalendarBuilders(
  //       defaultBuilder: (context, date, _) {
  //         bool isWeekend = date.weekday == DateTime.saturday ||
  //             date.weekday == DateTime.sunday;
  //         return Container(
  //           margin: const EdgeInsets.all(4.0),
  //           alignment: Alignment.center,
  //           width: 50,
  //           height: 50,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10.0),
  //             color:
  //                 _events.containsKey(date) ? Colors.red : Colors.transparent,
  //           ),
  //           child: Container(
  //             width: 40,
  //             height: 40,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //               color: isWeekend ? Colors.red : Colors.yellow,
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             child: Text(
  //               '${date.day}',
  //               style: const TextStyle(fontSize: 16.0),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Calendar',
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteA700,
          ),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
          ],
        ),
      ),
    );
  }
}
