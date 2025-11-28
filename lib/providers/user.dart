import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  UserModel? _user;

  UserModel? get user => _user;
  bool get hasUser => _user != null;

  /// Load user data only once
  Future<void> loadUserData() async {
    if (_user == null) {
      final storedUser = await _repo.getProfile();
      _user = storedUser;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    await UserService.saveUser(user);
    _user = user;
    notifyListeners();
  }

  /// Clear user-related state (use on logout)
  void clear() async {
    _user = null;
    notifyListeners();
    await UserService.removeUserData();
  }

  /// ✅ Automatically capitalized full name
  String get fullName {
    final f = Utils.capitalize(_user?.firstName);
    final l = Utils.capitalize(_user?.lastName);
    return [f, l].where((e) => e.isNotEmpty).join(' ');
  }
}
