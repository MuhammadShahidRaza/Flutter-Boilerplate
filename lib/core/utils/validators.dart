import 'package:flutter/widgets.dart';
import 'package:sanam_laundry/core/constants/strings.dart';
import 'package:sanam_laundry/core/extensions/localization.dart';
import 'package:sanam_laundry/core/utils/regex.dart';

class AppValidators {
  /// Helper: always use unicode-aware regex
  static bool _match(String pattern, String value) {
    return RegExp(pattern, unicode: true).hasMatch(value);
  }

  /// Required field
  static String? requiredField(
    BuildContext context,
    String? value, {
    String fieldName = Common.feild,
  }) {
    if (value == null || value.trim().isEmpty) {
      return context.tr(
        ValidationMessages.isRequired,
        params: {"name": fieldName},
      );
    }
    return null;
  }

  /// Email
  static String? email(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr(
        ValidationMessages.isRequired,
        params: {"name": Common.email},
      );
    }
    if (!_match(AppRegex.email, value.trim())) {
      return context.tr(ValidationMessages.invalidEmailFormat);
    }
    return null;
  }

  /// Password
  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.tr(
        ValidationMessages.isRequired,
        params: {"name": Common.password},
      );
    }
    if (!_match(AppRegex.password, value)) {
      return context.tr(ValidationMessages.passwordMustContain);
    }
    return null;
  }

  /// Confirm Password
  static String? confirmPassword(
    BuildContext context,
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return requiredField(
        context,
        value,
        fieldName: context.tr(Common.confirmPassword),
      );
    }
    if (value != originalPassword) {
      return context.tr(ValidationMessages.passwordsNotMatch);
    }
    return null;
  }

  /// Name (first/last/general)
  static String? name(
    BuildContext context,
    String? value, {
    String fieldName = Common.name,
  }) {
    if (value == null || value.isEmpty) {
      return context.tr(
        ValidationMessages.isRequired,
        params: {"name": fieldName},
      );
    }
    if (!_match(AppRegex.firstName, value)) {
      return context.tr(
        ValidationMessages.invalidNameWithHyphen,
        params: {"name": fieldName},
      );
    }
    return null;
  }

  /// Phone
  static String? phone(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.tr(
        ValidationMessages.isRequired,
        params: {"name": Common.phoneNumber},
      );
    }
    // if (!_match(AppRegex.phoneNumber, value)) {
    //   return context.tr(ValidationMessages.invalidPhoneNumber);
    // }
    return null;
  }

  /// Minimum length
  static String? minLength(
    BuildContext context,
    String? value, {
    required int min,
  }) {
    if (value != null && value.length < min) {
      return context.tr(
        ValidationMessages.minLength,
        params: {"minLength": "$min"},
      );
    }
    return null;
  }

  /// Maximum length
  static String? maxLength(
    BuildContext context,
    String? value, {
    required int max,
  }) {
    if (value != null && value.length > max) {
      return context.tr(
        ValidationMessages.maxLength,
        params: {"maxLength": "$max"},
      );
    }
    return null;
  }
}
