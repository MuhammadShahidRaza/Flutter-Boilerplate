import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<void> load() async {
    String jsonString = await rootBundle.loadString(
      'lib/localization/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = {};
    jsonMap.forEach((key, value) {
      if (value is Map) {
        value.forEach((childKey, childValue) {
          _localizedStrings["$key.$childKey"] = childValue.toString();
        });
      } else {
        _localizedStrings[key] = value.toString();
      }
    });
  }

  String translate(String? key, {Map<String, String>? params}) {
    if (key == null || key.isEmpty) return "";

    String value = _localizedStrings[key] ?? key;

    // Replace placeholders with actual values
    if (params != null) {
      params.forEach((placeholder, replacement) {
        value = value.replaceAll(
          '{$placeholder}',
          _localizedStrings[replacement] ?? replacement,
        );
      });
    }

    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
