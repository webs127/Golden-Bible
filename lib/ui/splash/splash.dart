import 'dart:async';
import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/core/managers/image_manager.dart';
import 'package:bible/core/router/route_names.dart';
import 'package:bible/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  start() {
    Future.delayed(Duration(seconds: 3), nextPage);
  }

  Future<void> nextPage() async {
    await NotificationService.instance.ready;
    if (!mounted) return;
    final fromNotification =
        NotificationService.instance.wasLaunchedFromNotification;
    context.go(fromNotification ? RouteNames.landing : RouteNames.bibleHome);
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(image: AssetImage(ImageManager.logo))
              ),
            ),
            Text(
              "Golden Bible",
              style: theme.textTheme.headlineLarge?.copyWith(
                color: ColorManager.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
