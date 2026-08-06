import 'package:bible/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  static const String _enabledKey = 'notifications_enabled';
  static const String _hourKey = 'notification_hour';
  static const String _minuteKey = 'notification_minute';

  final SharedPreferences _prefs;

  bool _enabled;
  int _hour;
  int _minute;

  bool get enabled => _enabled;
  int get hour => _hour;
  int get minute => _minute;
  TimeOfDay get time => TimeOfDay(hour: _hour, minute: _minute);

  NotificationProvider(this._prefs)
    : _enabled = _prefs.getBool(_enabledKey) ?? true,
      _hour = _prefs.getInt(_hourKey) ?? 7,
      _minute = _prefs.getInt(_minuteKey) ?? 0;

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await _prefs.setBool(_enabledKey, value);
    if (value) {
      await NotificationService.instance.scheduleDailyDevotionals(
        hour: _hour,
        minute: _minute,
      );
    } else {
      await NotificationService.instance.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setTime(TimeOfDay value) async {
    _hour = value.hour;
    _minute = value.minute;
    await _prefs.setInt(_hourKey, _hour);
    await _prefs.setInt(_minuteKey, _minute);
    if (_enabled) {
      await NotificationService.instance.scheduleDailyDevotionals(
        hour: _hour,
        minute: _minute,
      );
    }
    notifyListeners();
  }
}
