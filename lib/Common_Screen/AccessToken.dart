// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenScreen extends StatefulWidget {
  const AccessTokenScreen({super.key});

  @override
  State<AccessTokenScreen> createState() => _AccessTokenScreenState();
}

class _AccessTokenScreenState extends State<AccessTokenScreen> {
  String? token;
  String? Simno;
  @override
  void initState() {
    GetToken();
  }

  GetToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    Simno = preferences.getString('Simno');
    setState(() {
      token;
      Simno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Access Token',
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteA700,
          ),
        ),
        backgroundColor: ColorConstant.ismcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              token.toString(),
              style: TextStyle(fontSize: 16, color: ColorConstant.accentColor),
            ),
            Text(
              Simno.toString(),
              style: TextStyle(fontSize: 16, color: ColorConstant.ismcolor),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Copied Token!")),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    // vertical: screenHeight * 0.02,
                    ),
                backgroundColor: ColorConstant
                    .ismcolor, // Responsive vertical padding for button
                minimumSize:
                    Size(double.infinity, 56), // Responsive button height
              ),
              child: Text(
                "Copy",
                style: TextStyle(fontSize: 16, color: ColorConstant.whiteA700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
