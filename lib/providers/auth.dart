import 'package:flutter/material.dart';
import 'package:sanam_laundry/services/auth.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final token = await AuthService.loadToken();
    _isLoggedIn = token != null && token.isNotEmpty;
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
