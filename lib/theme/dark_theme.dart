import 'package:flutter/material.dart';
import 'package:sanam_laundry/theme/colors.dart';
import 'package:sanam_laundry/theme/text.dart';

class DarkTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.white,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      surface: AppColors.darkScaffoldBackground,
      onSurface: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
    textTheme: CustomTextTheme.getTextTheme(Colors.white, AppColors.secondary),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: AppColors.icons),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(const Size.fromHeight(48)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(const Size.fromHeight(48)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        foregroundColor: WidgetStatePropertyAll(Colors.white), // text + icon
        side: WidgetStatePropertyAll(BorderSide(color: Colors.white)),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white)),
    ),
  );
}
