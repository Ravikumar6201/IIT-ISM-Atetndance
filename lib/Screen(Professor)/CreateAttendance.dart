// ignore_for_file: camel_case_types, prefer_final_fields, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_element, unused_field, use_build_context_synchronously, must_be_immutable, unused_import, depend_on_referenced_packages, await_only_futures, unnecessary_null_comparison, unused_local_variable
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/MoclLocationPage.dart';
import 'package:ism/Core/SQLite/LocationChecker.dart';
import 'package:ism/Login/Login.dart';
import 'package:ism/Login/mocklocation.dart';
import 'package:ism/Model/Cbcs_StudentModel.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Professor)/AttendancePending/ListOfPending.dart';
import 'package:ism/Screen(Professor)/DrawerProfessor.dart';
import 'package:ism/Screen(Professor)/ProLiveClass.dart';
import 'package:ism/Screen(Professor)/TodayAttendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateAttendance extends StatefulWidget {
  String? sub_offered_id, subjectName, session, sessionyear, sub_id;

  @override
  CreateAttendance(
      {required this.sub_offered_id,
      required this.subjectName,
      required this.session,
      required this.sessionyear,
      required this.sub_id});

  @override
  _CreateAttendanceState createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  TextEditingController _searchController = TextEditingController();
  List<StudentDataList> StudentList = [];
  List<PendingListModel> DateList = [];
  String? classtime;
  String? latitude;
  String? logitude;
  String? rediusshare;
  String? classshare;
  bool lalog = false;
  bool locationButton = false;
  final List<int> options = [5, 10, 15, 20, 50, 100];
  final List<int> Time = [2, 4, 5, 10, 15];
  int? selectedOption;
  int? selectclass;
  String? otp;
  String? redius;
  String? currentDate;
  bool isMocklocation = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    LocationVerify();
    _LoadAssignClass();
    _generateRandomCode();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void LocationVerify() async {
    try {
      bool isMock = await LocationService.isMockLocation();
      if (isMock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Not Allow to Use Mock Location for this App')),
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MockLocationPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          lalog = false;
        });
        Position position = await _determinePosition();
        setState(() {
          latitude = position.latitude.toString();
          logitude = position.longitude.toString();
          lalog = true;
        });
      }
    } catch (error) {
      print("Error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  bool isLoading = false;
  bool ischeck = true;
  Future<void> _LoadAssignClass() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      setState(() {
        rediusshare = preferences.getString('redius');
        redius = rediusshare;
        classshare = preferences.getString('time');
        classtime = rediusshare;
        _onTextChanged(classtime.toString());
      });
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_AsignCourseStudent') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}AsignCourseStudent'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}AsignCourseStudent');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'sub_offered_id': widget.sub_offered_id,
        'session': widget.session,
        'sessionyear': widget.sessionyear,
      };

      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData is Map) {
            final courseData = jsonData['Student_Data'];

            if (courseData is List) {
              List<StudentDataList> sessionList = [];

              for (var item in courseData) {
                sessionList.add(StudentDataList.fromJson(item));
              }

              setState(() {
                StudentList = sessionList.reversed.toList();
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void _generateRandomCode() async {
    final random = Random();
    setState(() {
      otp = (random.nextInt(9000) + 1000)
          .toString(); // Generates a random number between 1000 and 9999
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('otpnew');
    preferences.setString('otpnew', otp.toString());
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawerProfessor(),
      appBar: AppBar(
        title: Text(
          "Create Attendance",
          style: TextStyle(color: ColorConstant.whiteA700),
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
                setState(() {
                  LocationVerify();
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
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Column(
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      Text(
                        "Please Wait",
                        style: TextStyle(color: ColorConstant.lightBlue701),
                      )
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 80,
                            offset: Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Log : '),
                              lalog
                                  ? Text('$logitude')
                                  : CircularProgressIndicator(),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Lat : '),
                              lalog
                                  ? Text('$latitude')
                                  : CircularProgressIndicator(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 80,
                            offset: Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Attendance duration'),
                          DropdownButton<int>(
                            value: selectclass,
                            hint: Text(classshare ?? "Select Time"),
                            onChanged: (int? newValue) async {
                              setState(() {
                                selectclass = newValue;
                                classtime = newValue.toString();
                                _onTextChanged(
                                    classtime ?? classshare.toString());
                              });
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove('time');
                              await preferences.setString(
                                  'time', classtime.toString());
                            },
                            items: Time.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString() + " Min"),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 80,
                            offset: Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Coverage area(Radius)'),
                          DropdownButton<int>(
                            value: selectedOption,
                            hint: Text(rediusshare ?? "Select Radius"),
                            onChanged: (int? newValue) async {
                              setState(() {
                                selectedOption = newValue;
                                redius = newValue.toString();
                              });
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.remove('redius');
                              await preferences.setString(
                                  'redius', redius.toString());
                            },
                            items:
                                options.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString() + " M"),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 120,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 60,
                            offset: Offset(0, 15),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Students : ",
                                style: TextStyle(),
                              ),
                              Text(
                                StudentList.length.toString(),
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subject Code : ",
                                style: TextStyle(),
                              ),
                              Text(
                                widget.subjectName.toString(),
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Generated OTP is : ",
                                style: TextStyle(),
                              ),
                              Text(
                                otp ?? "",
                                style: TextStyle(
                                    color: ColorConstant.lightBlue701,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? SpinKitWave(
                      color: ColorConstant.ismcolor,
                      size: 50.0,
                      type: SpinKitWaveType.center,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (otp != null && redius != null) {
                          await _Post_Attendance_Student();
                        } else {
                          attendancepostAlrt(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        backgroundColor: ColorConstant.ismcolor,
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
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
      setState(() {
        newtime = newTime;
      });
      print('New Time: $newTime');
    }
  }

  List<StudentAttendance> AllStudentList = [];
  Future<void> _Post_Attendance_Student() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String? sessoion = preferences.getString('session');
      String? sessionyear = preferences.getString('sessionyear');

      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_CreateAttendanceList') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}CreateAttendanceList'); // If isNEP is false

      // final Uri uri = Uri.parse('${ApiConstants.baseUrl}CreateAttendanceList');
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      try {
        final Map<String, dynamic> body = {
          "session": sessoion.toString(),
          "sessionyear": sessionyear.toString(),
          "sub_offered_id": widget.sub_offered_id,
          'class_redius': redius!,
          'class_otp': otp!,
          'latitude': latitude.toString(),
          'logitude': logitude.toString(),
          'sub_id': widget.sub_id,
          'otp_time': classotpvalied.toString(),
          'auth_id': userid
          // Assuming status is a field in StudentDataList
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

          if (jsonData['status'] == true) {
            if (jsonData['class_periods'] != null) {
              String priodid = jsonData['class_periods'];
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Current_AttendanceScreen(
                          sub_offered_id: widget.sub_offered_id,
                          session: sessoion.toString(),
                          sessionyear: sessionyear.toString(),
                          otp: otp,
                          priod: priodid,
                          sub_id: widget.sub_id,
                          proid: widget.session,
                          date: currentDate,
                        )
                    // Attendance_Subjectlist()
                    ),
              );
            } else {
              print("id not found");
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${jsonData['message']}')),
            );
            if (jsonData['message'] == "privious_pending") {
              // PriviousClassPendin(
              //     context,
              //     widget.sub_offered_id.toString(),
              //     widget.session.toString(),
              //     widget.sessionyear,
              //     currentDate,
              //     otp);
            }
            // Handle success scenario for this student
            print('Attendance record for  inserted successfully');
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${jsonData['message']}')),
            );
            // Handle error scenario for this student
            print(
                'Failed to insert attendance record for ${jsonData['message']}');
            if (jsonData.containsKey('error')) {
              setState(() {
                isLoading = false;
              });
              print('Error message: ${jsonData['error']}');
            }
          }
        } else {
          setState(() {
            isLoading = false;
          });
          checklistAttendance(context);
          print('HTTP request failed with status: ${response.statusCode}');
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
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
    // } else {

    // }
  }
}

/*void PriviousClassPendin(BuildContext context, String sub_offered_id,
    String session, sessionyear, date, otps) {
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
                'Already Created This subject Attendance To Change Class Priode',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Current_AttendanceScreen(
                                  sub_offered_id: sub_offered_id.toString(),
                                  session: session.toString(),
                                  sessionyear: sessionyear.toString(),
                                  date: date.toString(),
                                  otp: otps.toString(),
                                )),
                      );
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
*/
void checklistAttendance(BuildContext context) {
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
                'Your current course is pending submission. After You submit the pending class, You will create a new class.',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DatewisePendingScreen()),
                      );
                      // Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
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
                'Please Fill Radius & Latitude, Lognitude Are Required',
                textAlign: TextAlign.center,
                style: TextStyle(
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
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     Fluttertoast.showToast(
                  //       msg: "Data Submitted Successfully",
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //       timeInSecForIosWeb: 1,
                  //       backgroundColor: Colors.black,
                  //       textColor: Colors.white,
                  //       .0,
                  //     );
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text('OK'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
