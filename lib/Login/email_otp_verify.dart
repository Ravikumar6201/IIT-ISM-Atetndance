// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_catch_stack, unused_field, avoid_unnecessary_containers, avoid_print, non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors, unused_local_variable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegistationVarification extends StatefulWidget {
  String email, otp, phone, name, deviceId;
  @override
  RegistationVarification(
      {required this.email,
      required this.otp,
      required this.phone,
      required this.name,
      required this.deviceId});
  @override
  _RegistationVarificationState createState() =>
      _RegistationVarificationState();
}

class _RegistationVarificationState extends State<RegistationVarification> {
  String enteredOTP = '';
  final _formKey = GlobalKey<FormState>();
  var OTPController = TextEditingController();
  bool ischeck = true;
  Duration? remaining;
  bool timeout = false;

  String email = '';
  String otp = '';
  String name = '';
  String phone = '';

  @override
  void initState() {
    setState(() {
      email = widget.email;
      otp = widget.otp;
      name = widget.name;
      phone = widget.phone;
    });

    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double fontSizeTitle =
        screenWidth * 0.07; // Adjust title font size based on screen width
    double fontSizeBody =
        screenWidth * 0.045; // Adjust body font size based on screen width
    double buttonPadding = screenWidth * 0.04;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OTP Validation'),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 150, // Set the desired height
                        width: 150, // Set the desired width
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/login.png"),
                              alignment: Alignment
                                  .topRight, // Position the image in the top-right corner
                              fit: BoxFit.fill, // Adjust the image fit
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: Row(
                      children: [
                        Text(
                          'Check your Email',
                          style: TextStyle(
                              fontSize: 24,
                              color: ColorConstant.black900,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Please type the verification code sent to your given Email',
                            style: TextStyle(
                                fontSize: 16, color: ColorConstant.black900),
                            softWrap:
                                true, // Ensures text wraps when reaching width limit
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Container(
                      height: 72,
                      child: PinCodeTextField(
                        controller: OTPController,
                        length: 4,
                        keyboardType: TextInputType.number,
                        cursorColor: ColorConstant.ismcolor, // Cursor color
                        onChanged: (value) {
                          print(value); // Print OTP value on change
                        },
                        onCompleted: (value) {
                          print("Completed OTP: $value"); // OTP completed
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,

                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 56,
                          activeFillColor:
                              Colors.black, // Fill color for active fields
                          inactiveFillColor:
                              Colors.black, // Fill color for inactive fields
                          selectedFillColor: ColorConstant
                              .black900, // Selected field background color
                          inactiveColor: ColorConstant
                              .black900, // Border color when inactive (light gray)
                          activeColor: ColorConstant
                              .black900, // Border color when active
                          selectedColor: ColorConstant
                              .black900, // Border color when selected
                        ),
                        appContext: context,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // userProvider.isLoading
                  //     ? Center(
                  //         child: CircularProgressIndicator(
                  //         color: ColorConstant.botton,
                  //       ))
                  //     :
                  Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: ElevatedButton(
                      onPressed: () async {
                        Fluttertoast.showToast(
                          msg: 'Button clicked',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP, // Show toast at the top
                          timeInSecForIosWeb: 1,
                          backgroundColor: ColorConstant.redA700,
                          textColor: ColorConstant.whiteA700,
                          fontSize: 16.0,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            // vertical: buttonPadding,
                            ),
                        backgroundColor: ColorConstant
                            .ismcolor, // Responsive vertical padding for button
                        minimumSize: Size(
                            double.infinity, 56), // Responsive button height
                      ),
                      child: Text(
                        'Countnue',
                        style: TextStyle(
                            color: ColorConstant.whiteA700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.only(right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send code again ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${remaining!.inMinutes}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: 18, color: ColorConstant.black900),
                        ),
                        if (timeout == true)
                          InkWell(
                              onTap: () async {
                                if (email != null) {
                                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Button Clicked")),
                                  );
                                }
                              },
                              child: Text(
                                "   Resend OTP",
                                style: TextStyle(
                                    fontSize: 16, color: ColorConstant.ismcolor),
                              ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
