import 'package:bible/core/managers/color_manager.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() => ThemeData(
    scaffoldBackgroundColor: ColorManager.black,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorManager.black,
      selectedItemColor: ColorManager.primary,
      unselectedItemColor: ColorManager.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.grey,
      ),
    ),
    cardTheme: CardThemeData(color: ColorManager.white),
    appBarTheme: AppBarThemeData(
      backgroundColor: ColorManager.black,
      titleTextStyle: TextStyle(color: ColorManager.white),
    ),
    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: ColorManager.grey,
      labelColor: ColorManager.primary,
      indicatorColor: ColorManager.primary,
      dividerColor: Colors.transparent,
      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.white,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.white,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.white,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.white,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.white,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.white,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(iconColor: ColorManager.white),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(ColorManager.white)),
    ),
  );

  static ThemeData light() => ThemeData(
    scaffoldBackgroundColor: ColorManager.background1,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorManager.white,
      selectedItemColor: ColorManager.primary,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: ColorManager.background1,
      titleTextStyle: TextStyle(color: ColorManager.black),
    ),
    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: ColorManager.grey,
      labelColor: ColorManager.primary,
      indicatorColor: ColorManager.primary,
      dividerColor: Colors.transparent,
      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
    cardTheme: CardThemeData(color: ColorManager.white),
    popupMenuTheme: PopupMenuThemeData(iconColor: ColorManager.black),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorManager.black,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.black,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.black,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w600,
        color: ColorManager.black,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(iconColor: WidgetStatePropertyAll(ColorManager.black)),
    ),
  );
}
