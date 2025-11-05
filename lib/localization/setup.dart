import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanam_laundry/providers/app.dart';
import 'app_localizations.dart';

class AppLocalizationSetup {
  final supportedLocales = [Locale(Language.en.name), Locale(Language.ar.name)];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? resolveLocale(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) return supportedLocales.first;
    return supportedLocales.firstWhere(
      (l) => l.languageCode == locale.languageCode,
      orElse: () => supportedLocales.first,
    );
  }
}
