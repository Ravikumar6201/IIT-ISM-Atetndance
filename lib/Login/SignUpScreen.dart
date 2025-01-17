// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, unused_field, unused_local_variable, non_constant_identifier_names, unnecessary_new, prefer_collection_literals, sized_box_for_whitespace, unused_element, avoid_print, duplicate_ignore

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Core/SQLite/DbHelpher.dart';
import 'package:ism/Model/Profile(local).dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  Color yellowColor = Color(0xFFFFA84B);
  Color blueColor = Color(0xFF053148);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign Up"),
      //   backgroundColor: yellowColor,
      // ),
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
                  decoration: BoxDecoration(color: ColorConstant.ismcolor
                      // gradient: ColorConstant.appBarGradient
                      ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome ,",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorConstant.whiteA700,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500),
                            ),
                            Column(
                              children: [
                                // Image(
                                //   image: AssetImage("assets/images/jis.png"),
                                //   height: 150,
                                //   // width: 400,
                                // ),
                                Text(
                                  "Sign Up",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorConstant.whiteA700,
                                      fontSize: 55,
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
  final _proidController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  List<Profile> addprofile = [];
  var sizedbox = SizedBox(
    height: 60,
  );
  bool valuefirst = false;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  //Uint8List? imagebytearray;

  Future getImage(
    ImageSource media,
  ) async {
    var img = await picker.pickImage(source: media, imageQuality: 30);
    var byte = await img!.readAsBytes();

    setState(() {
      // image = img;
      image = img;
      // imagebytearray = byte;
      // hasData = false;
    });
  }

  String? _selectedRole;

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
            _buildDropdownField(context),
            if (_selectedRole == "Student" ||
                _selectedRole == "Professor" ||
                _selectedRole == "TA")
              _buildImageField(context),
            if (_selectedRole == "Student" ||
                _selectedRole == "Professor" ||
                _selectedRole == "TA")
              _buildPhoneField(context),
            if (_selectedRole == "Student") _buildRollField(context),
            if (_selectedRole == "Student" ||
                _selectedRole == "Professor" ||
                _selectedRole == "TA")
              _buildNameField(context),
            if (_selectedRole == "Student") _buildEmailField(context),
            _buildsignUpButton(context),
            _buildlogin(context)
            // sizedbox,
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

  Widget _buildRollField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _proidController,
        decoration: InputDecoration(
          labelText: 'Roll No *',
          prefixIcon: Icon(Icons.person_2_outlined),
        ),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Roll No. is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: 'Name *',
          prefixIcon: Icon(Icons.person_2_outlined),
        ),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _numberController,
        decoration: InputDecoration(
          labelText: '10 digit Mobile number*',
          prefixIcon: Icon(Icons.numbers_outlined),
        ),
        keyboardType: TextInputType.phone,
        maxLength: 10,
        validator: (value) {
          if (value!.isEmpty && value.length == 10) {
            return 'Phone number cannot be empty';
          }
          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return 'Enter a valid 10-digit Phone number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImageField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //image != null
                //? Image.memory(
                // imagebytearray!,
                //  width: 100,
                //  height: 100,
                // )
                //   : Text('No image selected'),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                        // pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        backgroundColor: Colors.purple,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Gallery',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 05,
                          ),
                          Icon(
                            Icons.image,
                            color: ColorConstant.whiteA700,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                        // pickImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        backgroundColor: Colors.purple,
                      ),
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: ColorConstant.lightBlue701,
                      //   elevation: 3,
                      // ),
                      child: Row(
                        children: [
                          Text(
                            'Camara',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email *',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
              .hasMatch(value)) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _passwordController,
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
          labelText: "Password",
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

  Widget _buildDropdownField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: DropdownButtonFormField<String>(
        value: _selectedRole,
        items: [
          DropdownMenuItem(
            value: 'Professor',
            child: Text('Professor'),
          ),
          DropdownMenuItem(
            value: 'TA',
            child: Text('TA'),
          ),
          DropdownMenuItem(
            value: 'Student',
            child: Text('Student'),
          ),
        ],
        onChanged: (String? newValue) {
          setState(() {
            _selectedRole = newValue;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline),
          labelText: "Select Role",
          labelStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Role is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: TextFormField(
        controller: _confirmPasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        // validator: (value) => _passwordValidation(value.toString()),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Confirm Password is required';
          } else if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        obscureText: isPasswordVisible,
        decoration: InputDecoration(
          // border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock_outline),
          labelText: "Password",
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

  Widget _buildlogin(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "You have already account",
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, left: 8),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "LogIn",
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorConstant.ismcolor,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ));
  }

  String issaved = "True";
  Widget _buildsignUpButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: ColorConstant.ismcolor,
            ),
            child: Center(
                child: Text(
              "Sign Up",
              style: TextStyle(color: Colors.white),
            )),
            onPressed: () async {
              addlist(
                  // imagebytearray!,
                  image,
                  _proidController.text,
                  _nameController.text,
                  _emailController.text,
                  _passwordController.text,
                  issaved,
                  _numberController.text,
                  _selectedRole.toString());
            }));
  }

  addlist(
      //Uint8List
      //imagebytearra
      XFile? images,
      String proids,
      String Name,
      String email,
      String password,
      String issaved,
      String mobileno,
      String selectedRole) async {
    // Create a new profile instance and add it to the addprofile list
    Profile newProfile = Profile(
        // imageByteArray: imagebytearra,
        // image: images,
        proId: proids,
        proname: Name,
        proemail: email,
        propassword: password,
        issaved: issaved,
        promobileno: mobileno,
        role: selectedRole);
    addprofile.add(newProfile);
    // Iterate over the addprofile list and insert each profile into the database
    for (var profile in addprofile) {
      print(profile);
      DBSQL.instance.insert(profile.toJson());
    }
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Data Added Secussfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
