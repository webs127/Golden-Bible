import 'dart:async';

import 'package:bible/core/router/app_router.dart';
import 'package:bible/providers/bible_provider.dart';
import 'package:bible/providers/devotional_provider.dart';
import 'package:bible/providers/notification_provider.dart';
import 'package:bible/providers/saved_provider.dart';
import 'package:bible/providers/theme_provider.dart';
import 'package:bible/providers/tts_provider.dart';
import 'package:bible/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final notifications = NotificationProvider(prefs);
  final tts = TtsProvider();
  await tts.init();
  runApp(MyApp(prefs: prefs, notifications: notifications, tts: tts));
  unawaited(_setupNotifications(notifications));
}

Future<void> _setupNotifications(NotificationProvider notifications) async {
  try {
    await NotificationService.instance.initialize();
    if (notifications.enabled) {
      await NotificationService.instance.ensureScheduled(
        hour: notifications.hour,
        minute: notifications.minute,
      );
    }
  } catch (e) {
    debugPrint('Notification setup failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.prefs,
    required this.notifications,
    required this.tts,
  });

  final SharedPreferences prefs;
  final NotificationProvider notifications;
  final TtsProvider tts;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BibleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => DevotionalProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => SavedProvider(prefs)),
        ChangeNotifierProvider(create: (_) => notifications),
        ChangeNotifierProvider.value(value: tts),
        ],
      child: Consumer<ThemeProvider>(
        builder: (context, state, __) {
          return MaterialApp.router(
            title: "Golden Bible",
            debugShowCheckedModeBanner: false,
            theme: context.read<ThemeProvider>().theme,
            themeAnimationDuration: const Duration(milliseconds: 600),
            themeAnimationCurve: Curves.easeInOut,
            routerConfig: router);
        }
      ),
    );
  }
}
