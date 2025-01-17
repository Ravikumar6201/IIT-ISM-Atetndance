// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_keyColor_in_widget_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_element, file_names, use_build_context_synchronously, avoid_print, non_constant_identifier_names, unnecessary_new, unused_catch_stack, unused_local_variable, sort_child_properties_last, use_key_in_widget_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Login/forget_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
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
                Positioned(
                  child: Text('data'),
                ),
                Container(
                    height: MediaQuery.of(context).size.height, // 0.40,
                    width: double.infinity,
                    color: ColorConstant.whiteA700
                    // decoration:
                    //     BoxDecoration(gradient: ColorConstant.appBarGradient),
                    ),
                Positioned(
                  top: 50,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 35,
                        color: ColorConstant.black900,
                      )),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150, // Responsive logo size
                              child: Image.asset("assets/images/logo.png"),
                            ),
                            // Image(
                            //     image: AssetImage("assets/images/forget.png"),
                            //     height: 200,
                            //     width: double.infinity),
                          ],
                        ))),
                Center(child: LoginFormWidget())
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
  var EmailController = TextEditingController();
  var passwordController = TextEditingController();
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = true;
  bool _autoValidate = false;

  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPhoneField(context),
            _buildLogInButton(context),
            // _buildLogInButton1(context),
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

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: TextFormField(
          controller: EmailController,
          cursorColor: ColorConstant.accentColor, // Set cursor color
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value!.isEmpty) {
              return "Email is required";
            } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                .hasMatch(value)) {
              return "Enter a valid email address";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true, // Makes the field background filled with a color
            fillColor: Color(0xFFF2F2F2), // Customize the fill color
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xFFCCCCCC)), // Default border color
              borderRadius:
                  BorderRadius.circular(8.0), // Customize border radius
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFFCCCCCC), width: 1.0), // Enabled border color
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ColorConstant.gray400,
                  width: 2.0), // Focused border color
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ColorConstant.gray400,
                  width: 1.0), // Error border color
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ColorConstant.gray400,
                  width: 2.0), // Focused error border color
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: ColorConstant.black900, // Icon color
            ),
            labelText: 'Email',
            labelStyle: TextStyle(
              color: ColorConstant.black900, // Customize label color
            ),
          ),
        ));
  }

  String phoneValidation(String value) {
    // Replace this regular expression with the one that matches your phone number format.
    // This example assumes a simple format with digits and optional dashes or spaces.
    RegExp phoneRegExp = RegExp(r'^[0-9\- ]+$');

    if (!phoneRegExp.hasMatch(value)) {
      return "Enter a valid phone number";
    } else {
      return "";
    }
  }

  Widget _buildLogInButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF0158FF)), // Change the background color
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Change the button border radius
                ),
              ),
            ),
            child: Center(
                child: Text(
              "Reset Poaaword",
              style: TextStyle(color: Colors.white),
            )),
            // style: ElevatedButton.styleFrom(
            //   // backgroundColor: Colors.teal,
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10.0)),
            //   padding: EdgeInsets.all(20),
            // ),

            onPressed: () async {
              _signUpProcess(context);
            }));
  }

  void _signUpProcess(BuildContext context) async {
    var validate = _formKey.currentState!.validate();
    try {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Forget_Page()));
      // print(EmailController.text);
      // MobileVarify? data = await Varify(EmailController.text.toString()
      //     // passwordController.text.toString(),
      //     );
      // if (data != null) {
      //   print(data.timestamp);
      //   print(data.sessionId);
      //   if ("success" == data.status) {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // await preferences.clear();
      // preferences.setString('mobileno', EmailController.text);
      // // preferences.setString('password', passwordController.text);
      // preferences.setString('timestamp', data.timestamp.toString());
      // preferences.setString('sessionId', data.sessionId.toString());
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreeen()),
      //   (Route<dynamic> route) => false,
      // );
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
      //           "Mobile Number Not Matched ",
      //           textScaleFactor: 1,
      //         ),
      //       ],
      //     )),
      //   );
      // }
    } catch (_, ex) {}
  }
}
