// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, unused_field, unused_local_variable, non_constant_identifier_names, sized_box_for_whitespace, camel_case_types, unused_import, depend_on_referenced_packages, duplicate_import, duplicate_ignore

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forget_Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Forget_PageState();
  }
}

class _Forget_PageState extends State<Forget_Page> {
  Color yellowColor = Color(0xFFFFA84B);
  Color blueColor = Color(0xFF053148);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height, // 0.40,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(gradient: ColorConstant.appBarGradient),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Please",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       color: blueColor,
                            //       fontSize: 30,
                            //       fontWeight: FontWeight.w500),
                            // ),
                            Column(
                              children: [
                                // Image(
                                //   image: AssetImage("assets/images/jis.png"),
                                //   height: 150,
                                //   // width: 400,
                                // ),
                                Text(
                                  "Enter Email OTP And New Password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: blueColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ],
                        ))),
                Positioned(
                  bottom: 0.1,
                  left: 0.1,
                  right: 0.1,
                  child: LoginFormWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState();
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = true;
  bool isPasswordVisible = true;
  bool _autoValidate = false;
  final OTPController = TextEditingController();
  final _NewpasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  var sizedbox = SizedBox(
    height: 60,
  );
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // sizedbox,
            sizedbox,
            _buildOTPField(context),
            _buildPasswordField(context),
            _buildConfirmPasswordField(context),
            _buildsignUpButton(context),
            sizedbox,
          ],
        ),
      ),
    );
  }

  _passwordValidation(String value) {
    if (value.isEmpty) {
      return "Please enter password";
    } else {
      return null;
    }
  }

  Widget _buildOTPField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Enter valied OTP",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: PinCodeTextField(
              textStyle: TextStyle(fontSize: 30),
              appContext: context,
              controller: OTPController,
              length: 4,
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
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _NewpasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) => _passwordValidation(value.toString()),
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          // border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock_outline),
          labelText: "New Password",
          hintText: "",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _confirmNewPasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        // validator: (value) => _passwordValidation(value.toString()),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Confirm Password is required';
          } else if (value != _NewpasswordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        obscureText: isPasswordVisible,
        decoration: InputDecoration(
          // border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock_outline),
          labelText: "Confirm Password",
          hintText: "",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }

  Widget _buildsignUpButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF053148)), // Change the background color
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Change the button border radius
                ),
              ),
            ),
            child: Center(
                child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            )),
            onPressed: () async {
              _signUpProcess(context);
            }));
  }

  void _signUpProcess(BuildContext context) async {
    var validate = _formKey.currentState!.validate();
    try {
      Navigator.pop(context);
      // print(EmailController.text);
      // Verify_User? data = await VerifyUser(
      //   EmailController.text.toString(),
      //   passwordController.text.toString(),
      // );
      // if (data != null) {
      //   print(data.message);
      //   print(data.token);
      //   if ("success" == data.status) {
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     await preferences.clear();
      //     preferences.setString('email', EmailController.text);
      //     preferences.setString('password', passwordController.text);
      //     preferences.setString('token', data.token.toString());
      //     preferences.setString('userid', data.userId.toString());
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => HomeScreeen()),
      //       (Route<dynamic> route) => false,
      //     );
      // getpop(context, data);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Text(
      //           "Wrong Cradentials ",
      //           textScaleFactor: 1,
      //         ),
      //       ],
      //     )),
      //   );
      // }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Text(
      //           "Email Id And Password Not Matched ",
      //           textScaleFactor: 1,
      //         ),
      //       ],
      //     )),
      //   );
      // }
    } catch (_, ex) {}
  }
}
