// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_keyColor_in_widget_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, unused_element, file_names, use_build_context_synchronously, avoid_print, non_constant_identifier_names, unnecessary_new, unused_catch_stack, unused_local_variable, sort_child_properties_last, use_key_in_widget_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Login/reset_pasword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
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
                  height: MediaQuery.of(context)
                      .size
                      .height, // or specify a fraction like 0.40
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/images/loginimage.png"), // Replace with your image path
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ),
                Center(child: LoginFormWidget()),
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
                            Text(
                              "ISM Attendance System",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: blueColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ))),
                // Positioned(
                //   bottom: 0.1,
                //   left: 0.1,
                //   right: 0.1,
                //   child:
                // ),
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
  var sizedbox = SizedBox(
    height: 40,
  );
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(20), topRight: Radius.circular(20)
            //     )
            ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              // _buildLoging(context),
              // sizedbox,
              // sizedbox,

              _buildEmailField(context),
              _buildPasswordField(context),
              _buildForgotPassword(context),
              _buildLogInButton(context),
              // _buildLogInButton1(context),

              // sizedbox,
            ],
          ),
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

  Widget _buildLoging(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildEmailField(BuildContext context) {
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

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) => _passwordValidation(value.toString()),
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          filled: true, // Makes the field background filled with a color
          fillColor: Color(0xFFF2F2F2), // Customize the fill color
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color(0xFFCCCCCC)), // Default border color
            borderRadius: BorderRadius.circular(8.0), // Customize border radius
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
                color: ColorConstant.gray400, width: 1.0), // Error border color
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorConstant.gray400,
                width: 2.0), // Focused error border color
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: ColorConstant.black900, // Icon color
          ),
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
          labelText: 'Password',
          labelStyle: TextStyle(
            color: ColorConstant.black900, // Customize label color
          ),
        ),
      ),
    );
  }

  Widget _buildLogInButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
              "LogIn",
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
              // _signUpProcess(context);
            }));
  }

  // Widget _buildLogInButton1(BuildContext context) {
  //   return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
  //       child: ElevatedButton(
  //           child: Center(child: Text("OTP")),
  //           style: ElevatedButton.styleFrom(
  //             // backgroundColor: Colors.teal,
  //             elevation: 3,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10.0)),
  //             padding: EdgeInsets.all(20),
  //           ),
  //           onPressed: () async {
  //             Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => OTPScreen(),
  //             ));
  //           }));
  // }

  Widget _buildForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(
          //   child: InkWell(
          //       onTap: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => SignUpScreen()));
          //         // Navigator.pushAndRemoveUntil(
          //         //   context,
          //         //   MaterialPageRoute(builder: (context) => SignUpScreen()),
          //         //   (Route<dynamic> route) => false,
          //         // );
          //       },
          //       child: Text(
          //         "Sign Up",
          //         style: TextStyle(
          //           decoration: TextDecoration.underline,
          //           decorationColor:
          //               Colors.blue, // Optional: set the underline color
          //           decorationStyle: TextDecorationStyle
          //               .wavy, // Optional: set the underline style
          //         ),
          //       )),
          // ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgetPasswordScreen()));
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Color(0xFF0158FF),
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  decorationStyle: TextDecorationStyle.wavy,
                  decorationThickness: 2.0,
                ),
              ))
        ],
      ),
    );
  }

  // void _signUpProcess(BuildContext context) async {
  //   var validate = _formKey.currentState!.validate();
  //   try {
  //     print(EmailController.text);
  //     Verify_User? data = await VerifyUser(
  //       EmailController.text.toString(),
  //       passwordController.text.toString(),
  //     );
  //     if (data != null) {
  //       print(data.message);
  //       print(data.token);
  //       if ("success" == data.status) {
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         await preferences.clear();
  //         preferences.setString('email', EmailController.text);
  //         preferences.setString('password', passwordController.text);
  //         preferences.setString('token', data.token.toString());
  //         preferences.setString('userid', data.userId.toString());
  //         // Navigator.pushAndRemoveUntil(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => HomeScreeen()),
  //         //   (Route<dynamic> route) => false,
  //         // );
  //         // getpop(context, data);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Wrong Cradentials ",
  //                 textScaleFactor: 1,
  //               ),
  //             ],
  //           )),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Email Id And Password Not Matched ",
  //               textScaleFactor: 1,
  //             ),
  //           ],
  //         )),
  //       );
  //     }
  //   } catch (_, ex) {}
  // }
}
