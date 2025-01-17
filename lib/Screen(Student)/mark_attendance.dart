// // // ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, unused_field, prefer_final_fields, unused_import, unused_local_variable, must_call_super, must_be_immutable, unused_element, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables

// ignore_for_file: depend_on_referenced_packages, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

// Make Attendance Page
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ism/Class/Api_URL.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Common_Screen/MoclLocationPage.dart';
import 'package:ism/Core/SQLite/LocationChecker.dart';
import 'package:ism/Login/mocklocation.dart';
import 'package:ism/Model/Today_AttendanceModel.dart';
import 'package:ism/Screen(Student)/Drawer.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MakeAttendance extends StatefulWidget {
  String? subjectCode,
      session,
      sessionyear,
      redius,
      lattitude,
      lognitude,
      otp,
      sub_id,
      classpriods,
      otptime,
      date;

  MakeAttendance(
      {required this.subjectCode,
      required this.session,
      required this.sessionyear,
      required this.lattitude,
      required this.lognitude,
      required this.otp,
      required this.redius,
      required this.sub_id,
      required this.otptime,
      required this.classpriods,
      required this.date});

  @override
  _MakeAttendanceState createState() => _MakeAttendanceState();
}

class _MakeAttendanceState extends State<MakeAttendance> {
  List<AllStudentAttendanceList> AllStudentList = [];
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // LocationVerify();
    Location();
    _otpController;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> locationgetcheck() async {
    try {
      // Get latitude and longitude
      await getLatLong().then((value) {});
      await Future.delayed(Duration(seconds: 4));
      // LocationVerify();
    } catch (e) {
      // Handle errors
      print("An error occurred: $e");
    }
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;
  Uint8List? imagebytearray;
  Future<void> getImage(ImageSource media) async {
    try {
      var img = await picker.pickImage(
        source: media,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front, // Use the front camera
      );
      if (img != null) {
        var byte = await img.readAsBytes();

        setState(() {
          image = img;
          imagebytearray = byte;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Future getImage(
  //   ImageSource media,
  // ) async {
  //   var img = await picker.pickImage(source: media, imageQuality: 30);
  //   var byte = await img!.readAsBytes();

  //   setState(() {
  //     // image = img;
  //     image = img;
  //     imagebytearray = byte;
  //     // hasData = false;
  //   });
  // }

  bool datatime = false;
// List<AllStudentAttendanceList> AllStudentList=[];
  Future<void> _Post_Attendance_Student(String dateTimeString) async {
    // setState(() {
    //   Completeload = false;
    // });
    print(dateTimeString);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      String? userid = preferences.getString('userids');
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String class_check = "false";
      // Uint8List imageBytes = await image!.readAsBytes();
      // // Convert bytes to base64
      // String base64Image = base64Encode(imageBytes);
      bool isNEP = false;

      setState(() {
        isNEP = preferences.getBool('isNEP') ?? false;
      });

      // Conditionally set the URL based on isNEP value
      final Uri uri = isNEP
          ? Uri.parse(
              '${ApiConstants.baseUrl}nep_markAttendancebystudent') // If isNEP is true
          : Uri.parse(
              '${ApiConstants.baseUrl}markAttendancebystudent'); // If isNEP is false

      // final Uri uri =
      //     Uri.parse('${ApiConstants.baseUrl}markAttendancebystudent');
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
          "admn_no": userid,
          "date": widget.date,
          "sub_offered_id": widget.sub_id,
          "class_periods": widget.classpriods,
          "sub_code": widget.subjectCode,
          // "image": base64Image
        };

        final response =
            await http.post(uri, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(jsonData['message'],
                      style: TextStyle(color: ColorConstant.green900))),
            );

            _AttendanceCompletedDialog(context);
            print('Attendance Marked successfully');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
            setState(() {
              Completeload = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Already mark attendance')),
            );
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

  bool isLoading = false;
  final LocalAuthentication auth = LocalAuthentication();

  final bool _canCheckBiometrics = true;
  bool location = false;
  bool otptime = false;

  bool otpTimeCheck(String dateTimeString) {
    try {
      // Define the date format to include hours and minutes
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

      // Print the input date string for debugging
      print('Input date string: $dateTimeString');

      // Parse the input date and time string
      final DateTime inputDateTime = dateFormat.parse(dateTimeString);

      // Print the parsed date for debugging
      print('Parsed date: $inputDateTime');

      // Get the current date and time
      final DateTime currentDateTime = DateTime.now();

      // Print the current date and time for debugging
      print('Current date and time: $currentDateTime');

      // Compare only hours and minutes of the current date and time with the input date and time
      if (currentDateTime.hour < inputDateTime.hour ||
          (currentDateTime.hour <= inputDateTime.hour &&
              currentDateTime.minute < inputDateTime.minute)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error parsing date: $e');
      return false;
    }
  }

  // Future _registerFingerprint() async {
  //   bool authenticated = false;
  //   try {
  //     authenticated = await auth.authenticate(
  //       localizedReason: 'Enter your fingerprint',
  //       options: const AuthenticationOptions(biometricOnly: true),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (authenticated) {
  //     //   String fingerprintId = DateTime.now().millisecondsSinceEpoch.toString();
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Fingure Matched successfully')),);
  //     // postData(authenticated);
  //   } else {
  //     // postData(authenticated);
  //   }
  // }

  void postData() async {
    // if (value == true) {
    // if (otptime == true) {
    if (_otpController.text == widget.otp) {
      // if (imagebytearray != null) {
      setState(() {
        Completeload = false;
      });
      if (location == true) {
        _showFinalverifyDialog(context);
      } else {
        _showimageDialog(context);
      }

      // LocationVerify();
      // } else {
      //   _showimageDialog(context);
      // }
    } else {
      _showotpDialog(context);
    }
    // } else {
    //   _showOTPTimeDialog(context);
    // }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Fingure Not Matched')),
    //   );
    // }
  }

  Future<void> _refresh() async {
    LocationVerify();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool Completeload = true;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'Mark Attendance',
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: ColorConstant.whiteA700),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: Completeload
          ? RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // _buildlatitudeInfo(),
                          // _buildLognitudeInfo(),
                          _buildSessionInfo(),
                          _buildSessionYearInfo(),
                          _buildSubjectCodeInfo(),
                          // _buildImageInfo(),
                          _buildOtpInput(screenWidth),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Please Wait loading Data...')
              ],
            )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: _isload
              ? ElevatedButton(
                  onPressed: () async {
                    if (otpTimeCheck(widget.otptime.toString())) {
                      postData();
                      // _checkMockLocation();
                    } else {
                      _showOTPTimeDialog(context);
                    }
                    // otptimecheck(widget.otptime.toString()) ? postData() : null;
                    // _registerFingerprint();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    backgroundColor: ColorConstant.ismcolor,
                  ),
                  child: Text(
                    "Verify",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                )
              : SpinKitWave(
                  color: ColorConstant.ismcolor,
                  size: 50.0,
                  type: SpinKitWaveType.center,
                ),
        ),
      ),
    );
  }

  Future<void> _checkMockLocation() async {
    // bool isMock = await LocationService.isMockLocation();
    // if (isMock) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Not Allow to Use Mock Location for this App')),
    //   );
    //   SharedPreferences preferences = await SharedPreferences.getInstance();
    //   await preferences.clear();
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //     (Route<dynamic> route) => false,
    //   );
    //   // _showMockLocationAlert();
    // } else {
    postData();
    // }
  }

  // Widget _buildlatitudeInfo() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Latitude: ",
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       Text(
  //         lati ?? "Required",
  //         style: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLognitudeInfo() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Lognitude: ",
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //       Text(
  //         longi ?? "Required",
  //         style: TextStyle(
  //             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSessionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Session: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.session ?? "",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildSessionYearInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Session Year: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.sessionyear ?? "",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildSubjectCodeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Subject Code: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.subjectCode ?? "",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildImageInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image != null
            ? Image.memory(
                imagebytearray!,
                width: 100,
                height: 100,
              )
            : Text('Take a picture *'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     getImage(ImageSource.gallery);
            //     // pickImage(ImageSource.gallery);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: ColorConstant.lightBlue701,
            //     elevation: 3,
            //   ),
            //   child: Row(
            //     children: [
            //       Text(
            //         'Gallery',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       SizedBox(
            //         width: 05,
            //       ),
            //       Icon(
            //         Icons.image,
            //         color: ColorConstant.whiteA700,
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.camera);
                // pickImage(ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.lightBlue701,
                elevation: 3,
              ),
              child: Row(
                children: [
                  Text(
                    'Take a Picture',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 05,
                  ),
                  Icon(
                    Icons.camera_enhance,
                    color: ColorConstant.whiteA700,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpInput(double screenWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Enter Professor OTP:',
            style: TextStyle(fontSize: 16),
          ),
        ),
        PinCodeTextField(
          appContext: context,
          controller: _otpController,
          length: 4,
          cursorColor: Colors.lightBlue[700],
          onChanged: (value) {
            // Handle OTP input changes
            print(value);
          },
          onCompleted: (value) {
            // Handle OTP input completion
            print("Completed: $value");
          },
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 80,
            activeFillColor: Colors.lightBlue[700],
            inactiveFillColor: Colors.lightBlue[700],
            selectedFillColor: Colors.grey,
          ),
        ),
      ],
    );
  }

//location   //Get Location
  double lat = 0.0;
  double logi = 0.0;

  bool _isload = true;

  void Location() async {
    bool isMock = await LocationService.isMockLocation();
    if (isMock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not Allow to Use Mock Location for this App')),
      );
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MockLocationPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      LocationVerify();
    }
  }

  void LocationVerify() async {
    setState(() {
      _isload = false;
    });

    try {
      Position value = await _determinePosition();
      print("Position: $value");

      double lat = value.latitude;
      double logi = value.longitude;

      double currentLatitude = formatToFourDecimalPlaces(lat);
      double currentLongitude = formatToFourDecimalPlaces(logi);

      double targetLatitude =
          formatToFourDecimalPlaces(double.parse(widget.lattitude!));
      double targetLongitude =
          formatToFourDecimalPlaces(double.parse(widget.lognitude!));
      double radius = double.parse(widget.redius!);

      LocationHelper locationHelper = LocationHelper();
      bool isWithinRadius = locationHelper.isWithinRadius(
        currentLatitude,
        currentLongitude,
        targetLatitude,
        targetLongitude,
        radius,
      );

      setState(() {
        location = isWithinRadius;
        _isload = true;
        Completeload = isWithinRadius;
      });

      if (isWithinRadius) {
        print("The current location is inside the target location.");
      } else {
        Navigator.pop(context);
        _showSimpleDialog(context, isWithinRadius);
        print("The current location is NOT within the target location.");
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      setState(() {
        _isload = true;
      });
    }
  }

  double formatToFourDecimalPlaces(double number) {
    return double.parse(number.toStringAsFixed(5));
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
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // void LocationVerify() async {
  //   setState(() {
  //     _isload = false;
  //   });
  //   Future<Position> data = _determinePosition();
  //   data.then((value) {
  //     print("value $value");
  //     setState(() {
  //       lat = value.latitude;
  //       logi = value.longitude;
  //     });

  //     // Future.delayed(Duration(seconds: 2));

  //     double currentLatitude = formatToFourDecimalPlaces(lat);

  //     double currentLongitude = formatToFourDecimalPlaces(logi);

  //     // locationdata = await DbLocationHelper.instance.fatchdatalocation();

  //     // Target location
  //     double targetLatitude = double.parse(widget.lattitude!);
  //     targetLatitude = formatToFourDecimalPlaces(targetLatitude);
  //     double targetLongitude = double.parse(widget.lognitude!);
  //     targetLongitude = formatToFourDecimalPlaces(targetLongitude);
  //     double redius = double.parse(widget.redius!);
  //     redius = redius;

  //      Future.delayed(Duration(seconds: 2));

  //     LocationHelper locationHelper = LocationHelper();
  //     bool isWithin100Meters = locationHelper.isWithinRadius(currentLatitude,
  //         currentLongitude, targetLatitude, targetLongitude, redius);
  //     if (isWithin100Meters) {
  //       setState(() {
  //         location = isWithin100Meters;
  //         _isload = true;
  //         Completeload = true;
  //       });

  //       print("The current location is inside target location.");
  //     } else {
  //       Navigator.pop(context);
  //       setState(() {
  //         _isload = true;
  //         location = isWithin100Meters;
  //         Completeload = false;
  //       });
  //       setState(() {
  //         Completeload = false;
  //       });

  //       _showSimpleDialog(context, isWithin100Meters);

  //       print(
  //           "The current location is NOT within 100 meters of the target location.");
  //     }
  //   }).catchError((error) {
  //     print("Error $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: $error')),
  //     );
  //   });
  //   // } else {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text('Location services are required')),
  //   //   );
  //   // }
  // }

  // double formatToFourDecimalPlaces(double number) {
  //   return double.parse(number.toStringAsFixed(5));
  // }

  // Future<Position> _determinePosition() async {
  //   // bool serviceEnabled;
  //   LocationPermission permission;

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Location permissions are denied')),
  //       );
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.'),
  //       ),
  //     );
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  Future getLatLong() async {
    Future<Position> data = _determinePosition();
    data.then((value) async {
      print("value $value");
      setState(() {
        lat = value.latitude;
        logi = value.longitude;
      });
    }).catchError((error) {
      print("Error $error");
    });
  }

  void _showSimpleDialog(BuildContext context, bool check) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You are outside the radius set by professor",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.of(context).pop();
                        // Handle OK action here
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

  void _showFinalverifyDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You are verfied ",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Click on mark attendance",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        _Post_Attendance_Student(widget.otptime!);
                        Navigator.of(context).pop();
                        // Handle OK action here
                      },
                      child: Text('Mark Attendance'),
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

//location matcher
  void _AttendanceCompletedDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Great your attendance is marked",
                  style: TextStyle(color: ColorConstant.green900),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
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

//location matcher
  void _showOTPTimeDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Attendance OTP Time Out",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.of(context).pop();
                        // Handle OK action here
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

//otp match
  void _showotpDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "OTP mismatch",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.of(context).pop();
                        // Handle OK action here
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

  void _showimageDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You are outside class radius.",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.of(context).pop();
                        // Handle OK action here
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

//face match

  void _showFingureDialog(BuildContext context) {
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
            decoration: BoxDecoration(color: ColorConstant.cyan300),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Fingure not matched",
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        print('button pressed');
                        Navigator.of(context).pop();
                        // Handle OK action here
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
}
