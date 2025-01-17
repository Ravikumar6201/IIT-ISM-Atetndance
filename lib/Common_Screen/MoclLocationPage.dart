// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ism/Class/Colorconstat.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Login/mocklocation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationPage extends StatefulWidget {
  const MockLocationPage({super.key});

  @override
  State<MockLocationPage> createState() => _MockLocationPageState();
}

class _MockLocationPageState extends State<MockLocationPage> {
  Future<void> _checkMockLocation() async {
    bool isMock = await LocationService.isMockLocation();
    if (isMock) {
      _showMockLocationAlert();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
      (Route<dynamic> route) => false,
    );
    // await _initMobile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Access Denied',
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
              'Access to the app is blocked due to detected mock location.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ColorConstant.accentColor),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {},
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
                "Go To Dashboard",
                style: TextStyle(fontSize: 16, color: ColorConstant.whiteA700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
