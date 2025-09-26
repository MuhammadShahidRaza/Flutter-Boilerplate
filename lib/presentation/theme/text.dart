import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanam_laundry/presentation/theme/font.dart';

class CustomTextTheme {
  static TextTheme getTextTheme(Color textColor, Color secondaryColor) {
    TextStyle base({double? size, FontWeight? weight, Color? color}) {
      return GoogleFonts.getFont(
        AppFonts.defaultFont,
        fontSize: size,
        fontWeight: weight,
        color: color,
      );
    }

    return TextTheme(
      displayLarge: base(size: 57, weight: FontWeight.bold, color: textColor),
      displayMedium: base(size: 45, weight: FontWeight.bold, color: textColor),
      displaySmall: base(size: 36, weight: FontWeight.w600, color: textColor),
      headlineLarge: base(size: 32, weight: FontWeight.bold, color: textColor),
      headlineMedium: base(size: 28, weight: FontWeight.bold, color: textColor),
      headlineSmall: base(size: 24, weight: FontWeight.w600, color: textColor),
      titleLarge: base(size: 22, weight: FontWeight.w600, color: textColor),
      titleMedium: base(size: 16, weight: FontWeight.w500, color: textColor),
      titleSmall: base(size: 14, weight: FontWeight.w500, color: textColor),
      bodyLarge: base(size: 16, weight: FontWeight.normal, color: textColor),
      bodyMedium: base(size: 14, weight: FontWeight.normal, color: textColor),
      bodySmall: base(
        size: 12,
        weight: FontWeight.normal,
        color: secondaryColor,
      ),
      labelLarge: base(size: 14, weight: FontWeight.w500, color: textColor),
      labelMedium: base(
        size: 12,
        weight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: base(
        size: 10,
        weight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
