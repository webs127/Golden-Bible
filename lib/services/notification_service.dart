import 'dart:async';

import 'package:bible/core/router/app_router.dart';
import 'package:bible/core/router/route_names.dart';
import 'package:bible/services/devotional_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'daily_devotional';
  static const String _channelName = 'Daily Devotional';
  static const String _channelDescription = 'Daily devotional reminders';
  static const int _daysAhead = 365;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final DevotionalService _devotionalService = DevotionalService();
  final Completer<void> _initCompleter = Completer<void>();

  bool _launchedFromNotification = false;

  bool get wasLaunchedFromNotification => _launchedFromNotification;
  Future<void> get ready => _initCompleter.future;

  Future<void> initialize() async {
    try {
      await _devotionalService.preloadData('assets/json/devotional.json');

      tz.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (e) {
        debugPrint('Failed to resolve local timezone: $e');
      }

      const android = AndroidInitializationSettings('ic_notification');
      const settings = InitializationSettings(android: android);

      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          _navigateFromNotification();
        },
      );

      final launchDetails = await _plugin.getNotificationAppLaunchDetails();
      _launchedFromNotification =
          launchDetails?.didNotificationLaunchApp ?? false;

      final androidImpl =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<void> ensureScheduled({
    required int hour,
    required int minute,
  }) async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      if (pending.length >= 30) return;
    } catch (e) {
      debugPrint('Could not inspect pending notifications: $e');
    }
    await scheduleDailyDevotionals(hour: hour, minute: minute);
  }

  Future<void> scheduleDailyDevotionals({
    required int hour,
    required int minute,
  }) async {
    await _plugin.cancelAll();
    if (_devotionalService.devotionalList == null) return;

    final now = tz.TZDateTime.now(tz.local);
    final futures = <Future<void>>[];
    for (var i = 0; i < _daysAhead; i++) {
      futures.add(_scheduleOne(now, i, hour, minute));
      if (futures.length >= 20) {
        await Future.wait(futures);
        futures.clear();
      }
    }
    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }
  }

  Future<void> _scheduleOne(
    DateTime now,
    int index,
    int hour,
    int minute,
  ) async {
    final scheduled = now.add(Duration(days: index + 1));
    final date = tz.TZDateTime(
      tz.local,
      scheduled.year,
      scheduled.month,
      scheduled.day,
      hour,
      minute,
    );
    final devotion = _devotionalService.verseForDate(scheduled);
    final body = '${devotion.verse.text} - ${devotion.verse.ref}';
    await _plugin.zonedSchedule(
      id: index,
      title: 'Daily Devotional',
      body: _truncate(body, 140),
      scheduledDate: date,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: RouteNames.landing,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> sendTestNotification() async {
    final devotion = _devotionalService.verseForDate(DateTime.now());
    await _plugin.show(
      id: 999,
      title: 'Daily Devotional',
      body: _truncate('${devotion.verse.text} - ${devotion.verse.ref}', 140),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: RouteNames.landing,
    );
  }

  void _navigateFromNotification() {
    router.go(RouteNames.landing);
  }

  String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength - 1)}...';
  }
}
