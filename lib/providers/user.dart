import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sanam_laundry/core/utils/helper.dart';
import 'package:sanam_laundry/data/index.dart';

enum UserRole { user, rider }

class UserProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  UserModel? _user;
  UserRole? _role;
  UserRole? get role => _role;
  LatLng _currentLocation = LatLng(0, 0);
  LatLng get currentLocation => _currentLocation;

  bool get isRider => _role == UserRole.rider;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void updateCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }

  UserModel? get user => _user;
  bool get hasUser => _user != null;

  /// Load user data only once
  Future<void> loadUserData() async {
    if (_user == null) {
      _role = await UserService.getRole();

      final storedUser = await _repo.getProfile(
        isRider: _role == UserRole.rider,
      );
      _role = storedUser?.userRole == 'rider' ? UserRole.rider : UserRole.user;
      _user = storedUser;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    await UserService.saveUser(user);
    await UserService.saveRole(
      user.userRole == 'rider' ? UserRole.rider : UserRole.user,
    );
    _role = user.userRole == 'rider' ? UserRole.rider : UserRole.user;
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
