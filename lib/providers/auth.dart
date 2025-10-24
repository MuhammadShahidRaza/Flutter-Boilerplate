import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/index.dart';

enum Language { en, ar }

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _hasVisitedApp = false;
  UserModel? _user;
  Language _language = Language.en;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get hasVisitedApp => _hasVisitedApp;
  Locale get locale => Locale(_language.name);

  Future<void> loadLoginStatus() async {
    final isVisted = await AuthService.hasVisitedApp();
    final token = await AuthService.loadToken();
    final language = await AuthService.loadLanguage();
    final storedUser = await AuthService.loadUser();

    _isLoggedIn = token != null && token.isNotEmpty;
    _hasVisitedApp = isVisted != null && isVisted.isNotEmpty;
    _user = storedUser;
    if (language != null && language == Language.ar.name) {
      _language = Language.ar;
    } else {
      _language = Language.en;
    }

    notifyListeners();
  }

  Future<void> login(UserModel user) async {
    await AuthService.saveToken(user.token!);
    await AuthService.saveUser(user);

    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await AuthService.saveUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> changeLanguage(Language language) async {
    await AuthService.saveLanguage(language.name);
    _language = language;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.removeToken();
    await AuthService.removeUserData();
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  /// ✅ Automatically capitalized full name
  String get fullName {
    final f = _capitalize(_user?.firstName);
    final l = _capitalize(_user?.lastName);
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }

  /// Helper method to capitalize first letter safely
  String _capitalize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final v = value.trim();
    return v[0].toUpperCase() + v.substring(1).toLowerCase();
  }
}
