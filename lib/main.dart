// ignore_for_file: prefer_const_constructors, prefer_is_empty, non_constant_identifier_names, unused_local_variable, empty_catches, avoid_types_as_parameter_names, depend_on_referenced_packages

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ism/Class/provider.dart';
import 'package:ism/Core/provider.dart';
import 'package:ism/Login/Login.dart';
import 'package:ism/Common_Screen/Dashboard.dart';
import 'package:ism/Login/flash.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  FlutterLocalNotificationsPlugin();
  tz.initializeTimeZones();
  runApp(MyApp());
}

late Widget? showFirstScreen;

class MyApp extends StatefulWidget {
  static String? mobilenumber = '';

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    getInitialScreen();

    setState(() {
      isFirstLoad = false;
    });
    // checkLocationPermission();
  }

  Future<void> getInitialScreen() async {
    String mobileno = '';
    String password = '';
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileno = preferences.getString('mobileno') ?? '';
      password = preferences.getString('password') ?? '';
    } catch (e) {
      print('Error while getting initial screen: $e');
    }

    setState(() {
      showFirstScreen = mobileno.isNotEmpty && password.isNotEmpty
          ? Dashboard()
          : LoginPage();
    });
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeProvider.getTheme(
                  accentColor: Colors.white, primarySwatch: Colors.blue),
              title: 'IIT (ISM) Dhanbad',
              home: isFirstLoad ? SplashScreen() : showFirstScreen,
            ),
          );
        },
      ),
    );
  }
}
