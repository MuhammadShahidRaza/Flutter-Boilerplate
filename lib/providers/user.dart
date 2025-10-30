import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/index.dart';

enum Language { en, ar }

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUserData() async {
    final storedUser = await AuthService.loadUser();
    _user = storedUser;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await AuthService.saveUser(user);
    _user = user;
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
