import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/index.dart';
import 'package:sanam_laundry/presentation/theme/index.dart';

class LightTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      surface: AppColors.scaffoldBackground,
      onSurface: AppColors.text,
      error: AppColors.error,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    textTheme: CustomTextTheme.getTextTheme(
      AppColors.text,
      AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
    iconTheme: const IconThemeData(color: AppColors.icons, size: Dimens.iconM),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          const Size.fromHeight(Dimens.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.buttonRadius),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          const Size.fromHeight(Dimens.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.buttonRadius),
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(
          AppColors.primary,
        ), // text + icon
        side: WidgetStatePropertyAll(BorderSide(color: AppColors.primary)),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.primary),
      ),
    ),

    //input
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.inputRadius),
        borderSide: BorderSide(color: AppColors.border),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.inputRadius),
      ),
      // filled: true,
      // fillColor: Colors.grey.shade100,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      hintStyle: TextStyle(color: Colors.grey.shade500),
    ),
  );
}
