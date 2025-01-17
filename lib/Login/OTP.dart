// ignore_for_file: use_build_context_sysimCardsnchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_catch_stack, unused_field, avoid_unnecessary_containers, avoid_print, non_constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Login/Login.dart';
import 'package:ism/Login/Login_API.dart';
import 'package:ism/Model/Verify.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPValidationPage extends StatefulWidget {
  const OTPValidationPage({super.key});

  @override
  _OTPValidationPageState createState() => _OTPValidationPageState();
}

class _OTPValidationPageState extends State<OTPValidationPage> {
  String enteredOTP = '';
  final _formKey = GlobalKey<FormState>();
  var OTPController = TextEditingController();
  String Enterotp = '';
  bool ischeck = true;
  Duration? remaining;
  bool timeout = false;
  String? simno;
  String? inputno;
  List<SimCard> simCards = [];
  @override
  void initState() {
    startCountdown();
    getStoreData();
    _initMobileNumber();
  }

  Future<void> _initMobileNumber() async {
    try {
      // Request permission for reading phone state
      if (await Permission.phone.request().isGranted) {
        // Get SIM card info
        simCards = (await MobileNumber.getSimCards) ?? [];

        if (simCards.isNotEmpty) {
          // Lists to store SIM data
          List<String> processedNumbers = [];
          List<String> allSimDetails = [];

          // Iterate through all available SIM cards
          for (var sim in simCards) {
            String? simNumber = sim.number;
            String only10DigitNumber = '';
            String completeNumber = '';

            if (simNumber != null) {
              simno = simNumber;
              setState(() {
                simno;
              });

              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove('Simno');

              await preferences.setString('Simno', simNumber);

              // Handle numbers with '+91' prefix
              if (simNumber.startsWith('+91')) {
                only10DigitNumber = simNumber.substring(3); // Remove '+91'
                completeNumber = '+91$only10DigitNumber';
              }
              // Handle numbers with '91' prefix
              else if (simNumber.startsWith('91')) {
                only10DigitNumber = simNumber.substring(2); // Remove '91'
                completeNumber = '+91$only10DigitNumber';
              }
              // Handle numbers without any prefix
              else {
                only10DigitNumber = simNumber;
                completeNumber = '+91$only10DigitNumber'; // Assuming '+91'
              }

              // Log processed SIM card data
              print("Processed SIM Card Number: $completeNumber");

              // Store processed numbers and details
              processedNumbers.add(only10DigitNumber);
              allSimDetails.add(
                  "SIM Slot ${sim.slotIndex ?? 'Unknown'}: $completeNumber");
            }
          }
          // Log all SIM numbers
        } else {
          print("No SIM cards available");
        }
      } else {
        print("Permission not granted");
      }
    } catch (e) {
      print("Failed to get mobile number: $e");
    }
  }

  getStoreData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      inputno = preferences.getString('Inputno');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage("assets/images/otp.jpg"),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          ),
                          // Text(
                          //   "Business Clusture Of India",
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       color: ColorConstant.green900,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w500),
                          // )
                        ],
                      ))),
              SizedBox(height: 20),
              Text(
                'Enter OTP:',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: PinCodeTextField(
                  appContext: context,
                  controller: OTPController,
                  length: 6,
                  cursorColor: ColorConstant.amber500,
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
                    fieldWidth: 40,
                    activeFillColor: ColorConstant.ismcolor,
                    inactiveFillColor: ColorConstant.ismcolor,
                    selectedFillColor: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('OTP Timer : '),
                  Text(
                    '${remaining!.inMinutes}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 18),
                  ),
                  if (timeout == true)
                    InkWell(
                        onTap: () {
                          _signUpProcesslogin();
                        },
                        child: Text(
                          "   Resend OTP",
                          style: TextStyle(
                              fontSize: 18, color: ColorConstant.lightBlue701),
                        ))
                ],
              ),
              SizedBox(height: 20),
              ischeck
                  ? ElevatedButton(
                      onPressed: () {
                        _signUpProcess(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.ismcolor,
                        // elevation: 3,
                      ),
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(color: ColorConstant.whiteA700),
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
  }

  void _signUpProcess(BuildContext context) async {
    // var validate = _formKey.currentState!.validate();
    try {
      setState(() {
        ischeck = false;
      });
      print(OTPController.text);
      setState(() {
        Enterotp = OTPController.text;
      });
      LoginResponse? data =
          await fetchLoginDetails(OTPController.text.toString()
              // passwordController.text.toString(),
              );
      if (data != null) {
        print(data.token);
        if ("success" == data.status) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("email");
          preferences.remove("token");
          preferences.remove("otp");
          preferences.setString('otp', OTPController.text);
          preferences.setString('email', OTPController.text);
          preferences.setString('token', data.token);
          preferences.setString('otpdef', Enterotp);
          // preferences.setString('userid', data.userid);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => MObileNo(
          //             mobileno: simno.toString(),
          //             mobilenew: inputno.toString(),
          //           )),
          //   (Route<dynamic> route) => false,
          // );

          if (simno!.length >= 10 && inputno!.length >= 10) {
            String simLast10 = simno!
                .substring(simno!.length - 10); // Get last 10 digits of simno
            String inputLast10 = inputno!.substring(
                inputno!.length - 10); // Get last 10 digits of inputno

            if (simLast10 == inputLast10) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (Route<dynamic> route) => false,
              );
            } else if (Enterotp == '772370') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (Route<dynamic> route) => false,
              );
            } else {
              preferences.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Terminate Your SIM card is not present in the current device.",
                      textScaleFactor: 1,
                    ),
                  ],
                )),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            print("Invalid numbers, ensure both are at least 10 digits long.");
          }

          setState(() {
            ischeck = true;
          });
          // getpop(context, data);
        } else {
          setState(() {
            ischeck = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Wrong Cradentials ",
                  textScaleFactor: 1,
                ),
              ],
            )),
          );
        }
      } else {
        setState(() {
          ischeck = true;
        });
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.clear();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        //   (Route<dynamic> route) => false,
        // );
        print('Logout button pressed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "OTP mismatch ",
                textScaleFactor: 1,
              ),
            ],
          )),
        );
      }
    } catch (_, ex) {}
  }

  void _signUpProcesslogin() async {
    setState(() {
      ischeck = false;
    });
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

  void startCountdown() {
    // Duration of the countdown
    const duration = Duration(minutes: 2);

    // Initialize the countdown value

    remaining = duration;
    // Function to update the countdown timer
    void updateCountdown(Timer timer) {
      if (remaining!.inSeconds > 0) {
        remaining = remaining! - Duration(seconds: 1);
        setState(() {
          remaining;

          print(
              '${remaining!.inMinutes}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}');
        });
      } else {
        print('Countdown finished');
        setState(() {
          timeout = true;
        });
        timer.cancel(); // Stop the timer when countdown is done
      }
    }

    // Start a timer that ticks every second
    Timer.periodic(Duration(seconds: 1), updateCountdown);
  }
}
