import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/index.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _hasVisitedApp = false;
  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasVisitedApp => _hasVisitedApp;
  Future<void> loadLoginStatus() async {
    final token = await AuthService.loadToken();
    final isVisted = await AuthService.hasVisitedApp();
    final storedUser = await AuthService.loadUser();

    _isLoggedIn = token != null && token.isNotEmpty;
    _hasVisitedApp = isVisted != null && isVisted.isNotEmpty;
    _user = storedUser;

    notifyListeners();
  }

  Future<void> login(UserModel user) async {
    await AuthService.saveToken(user.token!);
    await AuthService.saveUser(user);

    _user = user;
    _isLoggedIn = true;
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
