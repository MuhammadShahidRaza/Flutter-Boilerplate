import 'package:flutter/material.dart';
import 'package:sanam_laundry/data/index.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get hasUser => _user != null;

  Future<void> loadUserData() async {
    final storedUser = await UserService.loadUser();
    _user = storedUser;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await UserService.saveUser(user);
    _user = user;
    notifyListeners();
  }

  /// Clear user-related state (use on logout)
  void clear() {
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
