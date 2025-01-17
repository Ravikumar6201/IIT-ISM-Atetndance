// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, prefer_const_literals_to_create_immutables, use_build_context_synchronously, use_key_in_widget_constructors, unused_import, unused_field, prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/AccessToken.dart';
import 'package:ism/Common_Screen/sessionNsessionyear.dart';
import 'package:ism/Core/SQLite/DbHelpher.dart';
import 'package:ism/Login/Login.dart';
import 'package:ism/Screen(Professor)/AssignClass.dart';
import 'package:ism/Screen(Professor)/ProLiveClass.dart';
import 'package:ism/Screen(Professor)/CreateAttendance.dart';
import 'package:ism/Screen(Professor)/TodayAttendance.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomDrawerProfessor extends StatefulWidget {
  @override
  State<CustomDrawerProfessor> createState() => _CustomDrawerProfessorState();
}

class _CustomDrawerProfessorState extends State<CustomDrawerProfessor> {
  File? _image;
  @override
  void initState() {
    super.initState();
    // _firstLoad();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profileImage');
    if (base64Image != null) {
      final bytes = base64Decode(base64Image);
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/profileImage.png';
      final file = await File(filePath).writeAsBytes(bytes);
      setState(() {
        _image = file;
      });
    }
  }

  bool isDarkMode = false;
  bool _isLocationEnabled = false;

  String name = '';
  String image = '';
  bool _isFirstLoadRunning = false;

  Future _firstLoad() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? names = preferences.getString('username');
      String? images = preferences.getString('image');
      setState(() {
        name = names!;
        image = images!;
      });
    } catch (err) {
      print('An error occurred: $err');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant
              .whiteA700, // Set the background color of the container
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          // image: DecorationImage(
          //   image: AssetImage(
          //       'assets/images/image1.jpg'), // Replace with your image asset path
          //   fit: BoxFit
          //       .cover, // Ensure that the image covers the entire container
          //   alignment:
          //       Alignment.center, // Center the image within the container
          //   repeat:
          //       ImageRepeat.repeat, // Repeat the image to fill the container
          // ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: ColorConstant.ismcolor),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius:
                                            50, // Adjust the radius as needed
                                        backgroundImage: AssetImage(
                                            'assets/images/image1.jpg'), // Replace 'your_image.jpg' with your image asset path
                                      ),
                              ],
                            ),

                            // Column(
                            //   children: [
                            //     if (image != '')
                            //       CircleAvatar(
                            //         radius: 50, // Adjust the radius as needed
                            //         backgroundImage: NetworkImage(image
                            //             .toString()), // Replace 'your_image.jpg' with your image asset path
                            //       ),
                            //     if (image == '')
                            //       CircleAvatar(
                            //         radius: 50, // Adjust the radius as needed
                            //         backgroundImage: AssetImage(
                            //             'assets/images/image1.jpg'), // Replace 'your_image.jpg' with your image asset path
                            //       ),
                            //     // Image.asset(
                            //     //   "assets/images/profile.png",
                            //     //   width: MediaQuery.of(context).size.width,
                            //     //   fit: BoxFit.cover,
                            //     // ),
                            //   ],
                            // ),
                          ),
                        ),
                        if (name != '')
                          Text(name.toString(),
                              style: TextStyle(color: Colors.white)),
                        if (name == '')
                          Text('Professor',
                              style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 05,
                  // ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(237, 242, 242, 0.783)),
                    child: CustomListTile(
                      icon: Icons.home_work_outlined,
                      title: "Dashboard",
                      onTap: () async {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()))
                            .then((_) async {
                          Navigator.pop(context);
                        });

                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Dashboard()),
                        //   (Route<dynamic> route) => true,
                        // );
                        // await navigateToScreen(context, CallListScreen());
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.07),
                        color: ColorConstant.black90026),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(237, 242, 242, 0.783)),
                    child: CustomListTile(
                      icon: Icons.calendar_month_rounded,
                      title: "Session",
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Session_SetScreen(),
                          ),
                        ).then((_) async {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.07),
                        color: ColorConstant.black90026),
                  ),

                  Divider(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(237, 242, 242, 0.783)),
                    child: CustomListTile(
                      icon: Icons.mark_chat_read_rounded,
                      title: "Create Attendance",
                      onTap: () async {
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MakeAttendance()),
                        //   (Route<dynamic> route) => false,
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssignClass_Screen(),
                          ),
                        ).then((_) async {
                          Navigator.pop(context);
                        });
                        // await navigateToScreen(context, MakeAttendance());
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.07),
                        color: ColorConstant.black90026),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(237, 242, 242, 0.783)),
                    child: CustomListTile(
                      icon: Icons.list_alt_sharp,
                      title: "Live Class",
                      onTap: () async {
                        // Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => FollowUp_Screen("")))
                        //     .then((_) async {
                        //   Navigator.pop(context);
                        // });
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => Attendance_History()),
                        //   (Route<dynamic> route) => false,
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Attendance_Subjectlist(),
                          ),
                        ).then((_) async {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5),
                  //       color: Color.fromRGBO(237, 242, 242, 0.783)),
                  //   child: CustomListTile(
                  //     icon: Icons.security_outlined,
                  //     title: "Access Token",
                  //     onTap: () async {
                  //       // Navigator.push(
                  //       //         context,
                  //       //         MaterialPageRoute(
                  //       //             builder: (context) => FollowUp_Screen("")))
                  //       //     .then((_) async {
                  //       //   Navigator.pop(context);
                  //       // });
                  //       // Navigator.pushAndRemoveUntil(
                  //       //   context,
                  //       //   MaterialPageRoute(
                  //       //       builder: (context) => Attendance_History()),
                  //       //   (Route<dynamic> route) => false,
                  //       // );
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => AccessTokenScreen(),
                  //         ),
                  //       ).then((_) async {
                  //         Navigator.pop(context);
                  //       });
                  //     },
                  //   ),
                  // ),
                
                
                ],
              ),
            ),

            //  ListTile(
            //       leading: const Icon(Icons.place_outlined),
            //       title: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Center(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text('Location'),
            //                   Switch(
            //                     value: _isLocationEnabled,
            //                     onChanged: _toggleLocationService,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //     ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: ColorConstant.redA700,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : ColorConstant.redA700,
                ),
              ),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                final dbHelper = DatabaseHelper();
                // Truncate 'user' table
                await dbHelper.truncateTableuser('user');
                print('User table truncated!');

                // Truncate 'UserDetails' table
                await dbHelper.truncateTableuserdetails('UserDetails');
                print('UserDetails table truncated!');

                // Truncate 'userotherdetails' table
                await dbHelper
                    .truncateTableuserotherdetails('userotherdetails');
                print('UserOtherDetails table truncated!');

                // Truncate 'tadetails' table
                await dbHelper.truncateTableta('tadetails');
                print('TADetails table truncated!');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
                print('Logout button pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future navigateToScreen(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    Navigator.pop(context);
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const CustomListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InkWell(
        onTap: onTap as void Function()?,
        child: Row(
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
