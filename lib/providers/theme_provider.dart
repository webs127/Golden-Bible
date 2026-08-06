import 'package:bible/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const _lightKey = 'light_theme';

  final SharedPreferences _prefs;
  bool light;

  ThemeProvider(this._prefs) : light = _prefs.getBool(_lightKey) ?? true;

  void onThemeChanged() {
    light = !light;
    _prefs.setBool(_lightKey, light);
    notifyListeners();
  }

  ThemeData get theme => light ? AppTheme.light() : AppTheme.dark();
}
