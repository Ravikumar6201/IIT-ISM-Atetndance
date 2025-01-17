// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Core/SQLite/DbHelpher.dart';
import 'package:ism/Core/conenction.dart';
import 'package:ism/Login/Login_API.dart';
import 'package:ism/Login/OTP.dart';
import 'package:ism/Login/mocklocation.dart';
import 'package:ism/Model/DashboardModel.dart';
import 'package:ism/Model/Verify.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isMocklocation = false;
  bool isload = true;
  String? mobileNumber;
  String? currentNo;
  String? completeno;
  String? only10digit;
  bool _isPasswordVisible = true;
  var _emailFocusNode = FocusNode();
  _passwordValidation(String value) {
    if (value.isEmpty) {
      return "Please enter password";
    } else {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  var MobileController = TextEditingController();
  var passwordController = TextEditingController();

  bool connection = false;

  Future<void> conenction() async {
    var connectivityResult = await ConnectivityService.checkConnectivity();
    if (connectivityResult.first.name == 'none') {
      setState(() {
        connection = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('No Internet Connection')),
      // );
    } else {
      setState(() {
        connection = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _initMobile();
    conenction();
    getDeviceId();
    fetchDataAndPrint();
    checkLocationPermission();
    _checkMockLocation();

    MobileController = TextEditingController(text: only10digit);
  }

  Future getDeviceId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('userids', );
    String? devideinfo = preferences.getString("devicename");
    if (devideinfo == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print(androidInfo.device);
        String android = androidInfo.id;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('devicename', android);
        // return androidInfo.device;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print(iosInfo.identifierForVendor);
        String android = iosInfo.systemName;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('devicename', android);
        // return iosInfo.identifierForVendor!;
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {}
  }

  Future<void> _checkMockLocation() async {
    bool isMock = await LocationService.isMockLocation();
    if (isMock) {
      _showMockLocationAlert();
    }
    setState(() {
      isMocklocation = isMock;
    });
    // await _initMobile();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    MobileController.dispose();
    super.dispose();
  }

  void _showMockLocationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mock Location Detected'),
        content:
            Text('Access to the app is blocked due to detected mock location.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> checkLocationPermission() async {
    try {
      await _determinePosition();
    } catch (e) {
      exitApp();
    }
  }

/*
  Future<void> _initMobileNumber() async {
    try {
      // Request permission for reading phone state
      if (await Permission.phone.request().isGranted) {
        // Get mobile number and SIM info
        mobileNumber = await MobileNumber.mobileNumber;
        simCards = (await MobileNumber.getSimCards)!;
        // print(mobileNumber);
        if (simCards.first.number.toString().startsWith('+91')) {
          setState(() {
            only10digit = simCards.first.number
                .toString()
                .substring(3); // Removes the first 3 characters (+91)
            print("only 10 $only10digit");
            MobileController = TextEditingController(text: only10digit);
          });
        } else if (simCards.first.number.toString().startsWith('91')) {
          setState(() {
            only10digit = simCards.first.number.toString().substring(2);
            print("only 10 $only10digit");
            MobileController = TextEditingController(text: only10digit);
          });

          // Removes the first 2 characters (91)
        }

        setState(() {
          currentNo = '+' + simCards.first.number.toString();
        });
        print('sim number $currentNo');
      } else {
        print("Permission not granted");
      }
    } catch (e) {
      print("Failed to get mobile number: $e");
    }
  }
*/
  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        exitApp();
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
      exitApp();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void exitApp() {
    SystemNavigator.pop();
  }

  List<UserOtherDetails> profiles = [];

  Future<void> fetchDataAndPrint() async {
    // _initMobile();
    profiles = await DbLocationHelper.instance.getUsersotherdetailsbyList();
    setState(() {
      profiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    conenction();
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                  color: ColorConstant.ismcolor,
                  height: screenSize.height * 0.05),
              Container(
                width: screenSize.width * 0.9, // 90% of the screen width
                constraints: BoxConstraints(
                  maxWidth: 1000, // Maximum width of the container
                ),

                // padding: EdgeInsets.only(
                //     top: screenSize.width * 0.1), // Padding around the container
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenSize.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height:
                              screenSize.height * 0.2, // Responsive logo size
                          child: Image.asset("assets/images/logo.png"),
                        ),
                        SizedBox(
                            height:
                                screenSize.height * 0.02), // Responsive spacing
                        Text(
                          "Log In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                screenSize.width * 0.07, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.ismcolor,
                          ),
                        ),
                        SizedBox(
                            height:
                                screenSize.height * 0.02), // Responsive spacing
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: IntlPhoneField(
                            disableLengthCheck: true,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorConstant.ismcolor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorConstant.ismcolor,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: ColorConstant.ismcolor,
                              ),
                              hintStyle: TextStyle(
                                color: ColorConstant.ismcolor,
                              ),
                              fillColor: Colors.black,
                              iconColor: Colors.black,
                              focusColor: Colors.black,
                              hoverColor: ColorConstant.ismcolor,
                            ),
                            controller: MobileController,
                            keyboardType: TextInputType.phone,
                            // autofillHints: [AutofillHints.telephoneNumber],
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              print("complete no" + phone.completeNumber);
                              setState(() {
                                completeno = phone.completeNumber;
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // Allow only digits
                              LengthLimitingTextInputFormatter(
                                  10), // Limit length to 10 digits
                            ],
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            // obscureText: true,
                            autofillHints: [AutofillHints.password],
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                            validator: (value) =>
                                _passwordValidation(value.toString()),
                            obscureText: _isPasswordVisible,
                            decoration: InputDecoration(
                              filled:
                                  true, // Makes the field background filled with a color
                              fillColor:
                                  Color(0xFFF2F2F2), // Customize the fill color
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorConstant.ismcolor,
                                ), // Default border color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Customize border radius
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstant.ismcolor,
                                    width: 1), // Enabled border color
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstant.ismcolor,
                                    width: 1), // Focused border color
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstant.ismcolor,
                                    width: 1), // Error border color
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstant.ismcolor,
                                    width: 1), // Focused error border color
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: ColorConstant.black900, // Icon color
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  }),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: ColorConstant
                                    .ismcolor, // Customize label color
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenSize.height * 0.02),

                        // Responsive spacing
                        isload
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.02),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!isMocklocation) {
                                      if (connection == true) {
                                        // _initMobileNumber(
                                        //     MobileController.text);
                                        _signUpProcess(context);
                                      } else {
                                        _showSnackBar(context,
                                            'Your device not connected to any internet ');
                                      }
                                    } else {
                                      _showMockLocationAlertlogin();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenSize.height * 0.01),
                                    backgroundColor: ColorConstant.ismcolor,
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: screenSize.width *
                                          0.05, // Responsive font size
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: SpinKitWave(
                                  color: ColorConstant.ismcolor,
                                  size: 50.0,
                                  type: SpinKitWaveType.center,
                                ),
                              ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login With Email & Password: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Click ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorConstant.ismcolor,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login With Email & OTP: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginWithEmailOTP()));
                                },
                                child: Text(
                                  "Click ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorConstant.ismcolor,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          ],
                        ),
                     */
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future VerifyUser(String mobile) async {
    return await DBSQL.instance.login(mobile);
  }

  void _signUpProcess(BuildContext context) async {
    setState(() {
      isload = false;
    });
    if (profiles.isNotEmpty) {
      _showSnackBar(context, 'Reset the App');
      setState(() {
        isload = true;
      });
    } else {
      try {
        String mobileNumber = MobileController.text;
        String password = passwordController.text;

        if (mobileNumber.isEmpty) {
          _showSnackBar(context, 'Please enter a mobile number');
          setState(() {
            isload = true;
          });
          return;
        }
        if (password.isEmpty) {
          _showSnackBar(context, 'Please enter Password');
          setState(() {
            isload = true;
          });
          return;
        }

        if (mobileNumber.length != 10) {
          _showSnackBar(context, 'Mobile number must be 10 digits long');
          setState(() {
            isload = true;
          });
          return;
        }

        if (!RegExp(r'^\d{10}$').hasMatch(mobileNumber)) {
          _showSnackBar(
              context, 'Mobile number must contain only numeric characters');
          setState(() {
            isload = true;
          });
          return;
        }

        // MobileVarify? data = await Varify(mobileNumber, '');
        LoginResponse? data =
            await Loginverification(mobileNumber, password, '');
        if (data != null) {
          isload = true;
          if (data.status == 'success' && data.token != null) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.clear();
            await preferences.setString('mobileno', mobileNumber.toString());
            await preferences.setString('password', password.toString());
            await preferences.setString('token', data.token.toString());
            await preferences.setString('userid', data.userid.toString());
            // Save mobile number and password securely

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (Route<dynamic> route) => false,
            );
            setState(() {
              isload = true;
            });
          } else {
            _showSnackBar(context, data.message);
            // _showSnackBar(context, 'Wrong Credentials');
            setState(() {
              isload = true;
            });
          }
        } else {
          _showSnackBar(context, data!.message);
          setState(() {
            isload = true;
          });
        }
      } catch (e) {
        isload = true;
        _showSnackBar(context, 'An error occurred. Please try again.');
        print('Error: $e');
      }
    }
  }

  void _showMockLocationAlertlogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mock Location Detected'),
        content: Text(
            'Access to the app is blocked due to detected mock location Login Denied.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _signUpProcesslogin() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? mobileno = preferences.getString('mobileno');

      // if (mobileno !=null) {
      // _showSnackBar(context, 'Please enter a valid mobile number');
      //   setState(() {
      //     ischeck = true;
      //   });
      //   return;
      // }

      MobileVarify? data = await Varify(mobileno.toString(), '');

      if (data != null) {
        if (data.status == 'success') {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          await preferences.setString('mobileno', mobileno.toString());
          await preferences.setString('timestamp', data.timestamp.toString());
          await preferences.setString('sessionId', data.sessionId);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OTPValidationPage()),
            (Route<dynamic> route) => false,
          );
          setState(() {
            // ischeck = true;
          });
        } else {
          // _showSnackBar(context, 'Wrong Credentials');
          setState(() {
            // ischeck = true;
          });
        }
      } else {
        // _showSnackBar(context, 'Mobile number not registered');
        setState(() {
          // ischeck = true;
        });
      }
    } catch (e) {
      // _showSnackBar(context, 'An error occurred. Please try again.');
      print('Error: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message + " !",
              style: TextStyle(color: ColorConstant.redA700))),
    );
  }
}
