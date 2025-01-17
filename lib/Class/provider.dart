// theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData? _themeData;

  ThemeProvider() {
    _themeData = ThemeData.light();
    _loadTheme();
  }

  ThemeData getTheme(
          {required MaterialColor primarySwatch, required Color accentColor}) =>
      _themeData!;

  void toggleTheme() {
    if (_themeData!.brightness == Brightness.dark) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark();
    }
    _saveTheme();
    notifyListeners();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkMode') ?? false;
    if (darkMode) {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }
    notifyListeners();
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _themeData!.brightness == Brightness.dark);
  }
}
