import 'package:flutter/material.dart';
import 'package:mulink/global/theme/dark/dark_theme_colors.dart';
import 'package:mulink/global/theme/dark/dark_theme_shadows.dart';
import 'package:mulink/global/theme/light/light_theme_colors.dart';
import 'package:mulink/global/theme/light/light_theme_shadows.dart';

import 'color/app_colors.dart';
import 'color/base/theme_color_base.dart';
import 'color/base/theme_shadow_base.dart';

enum CustomTheme {
  dark(
    DarkThemeColors(),
    DarkThemeShadows(),
  ),
  light(
    LightThemeColors(),
    LightThemeShadows(),
  );

  const CustomTheme(this.appColors, this.appShadows);

  final ThemeColorBase appColors;
  final ThemeShadowBase appShadows;

  ThemeData get themeData {
    switch (this) {
      case CustomTheme.dark:
        return darkTheme;
      case CustomTheme.light:
        return lightTheme;
    }
  }
}

MaterialColor primarySwatchColor = Colors.lightBlue;

ThemeData lightTheme = ThemeData(
    primarySwatch: primarySwatchColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    // textTheme: GoogleFonts.singleDayTextTheme(
    //   ThemeData(brightness: Brightness.light).textTheme,
    // ),
    colorScheme: const ColorScheme.light(background: Colors.white));

ThemeData darkTheme = ThemeData(
    primarySwatch: primarySwatchColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.veryDarkGrey,
    // textTheme: GoogleFonts.nanumMyeongjoTextTheme(
    //   ThemeData(brightness: Brightness.dark).textTheme,
    // ),
    colorScheme: const ColorScheme.dark(background: AppColors.veryDarkGrey));
