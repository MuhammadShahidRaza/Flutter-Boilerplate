import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/index.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _hasVisitedApp = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasVisitedApp => _hasVisitedApp;

  Future<void> loadLoginStatus() async {
    final isVisted = await AuthService.hasVisitedApp();
    final token = await AuthService.loadToken();

    _isLoggedIn = token != null && token.isNotEmpty;
    _hasVisitedApp = isVisted != null && isVisted.isNotEmpty;

    notifyListeners();
  }

  Future<void> login(UserModel user) async {
    await AuthService.saveToken(user.token!);
    await UserService.saveUser(user);

    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.removeToken();
    await UserService.removeUserData();
    _isLoggedIn = false;
    notifyListeners();
  }
}
