import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/services/auth.dart';

enum Language { en, ar }

/// App-level settings: locale, theme, etc.
class AppProvider extends ChangeNotifier {
  Language _language = Language.en;

  Locale get locale => Locale(_language.name);

  Future<bool> hasSelectedLanguage() async {
    final lang = await AuthService.loadLanguage();
    return lang != null;
  }

  Future<void> loadLanguageOnStart() async {
    final language = await AuthService.loadLanguage();
    if (language != null && language == Language.ar.name) {
      _language = Language.ar;
    } else {
      _language = Language.en;
    }
    notifyListeners();
  }

  Future<void> changeLanguage(Language language) async {
    await AuthService.saveLanguage(language.name);
    _language = language;
    notifyListeners();
  }
}
