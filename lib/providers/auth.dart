import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/services/auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _hasVisitedApp = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasVisitedApp => _hasVisitedApp;

  AuthProvider() {
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final token = await AuthService.loadToken();
    final isVisted = await AuthService.loadToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    _hasVisitedApp = isVisted != null && isVisted.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await AuthService.saveToken(token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.removeToken();
    _isLoggedIn = false;
    notifyListeners();
  }
}
