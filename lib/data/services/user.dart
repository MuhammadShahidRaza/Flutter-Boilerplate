import 'dart:convert';

import 'package:sanam_laundry/core/constants/variables.dart';
import 'package:sanam_laundry/core/utils/storage.dart';
import 'package:sanam_laundry/data/index.dart';

class UserService {
  static Future<void> removeUserData() async {
    await Storage.deleteDataFromStorage(Variables.userData);
  }

  static Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await Storage.addDataToStorage(Variables.userData, userJson);
  }

  static Future<UserModel?> loadUser() async {
    final userData = await Storage.getDataFromStorage(Variables.userData);
    if (userData == null || userData.isEmpty) return null;
    final jsonData = jsonDecode(userData);
    return UserModel.fromJson(jsonData);
  }
}
