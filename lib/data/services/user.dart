import 'dart:convert';

import 'package:sanam_laundry/core/constants/variables.dart';
import 'package:sanam_laundry/core/utils/storage.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/providers/index.dart';

class UserService {
  static Future<void> removeUserData() async {
    await Storage.deleteDataFromStorage(Variables.userData);
  }

  static Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await Storage.addDataToStorage(Variables.userData, userJson);
  }

  static Future<void> saveRole(UserRole role) async {
    await Storage.addDataToStorage(Variables.userRole, role.name);
  }

  static Future<UserModel?> loadUser() async {
    final userData = await Storage.getDataFromStorage(Variables.userData);
    if (userData == null || userData.isEmpty) return null;
    final jsonData = jsonDecode(userData);
    return UserModel.fromJson(jsonData);
  }

  static Future<UserRole?> getRole() async {
    final roleData = await Storage.getDataFromStorage(Variables.userRole);
    if (roleData == null || roleData.isEmpty) return null;
    return roleData == 'rider' ? UserRole.rider : UserRole.user;
  }
}
