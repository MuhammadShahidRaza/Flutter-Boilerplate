import 'dart:convert';

import 'package:sanam_laundry/core/constants/variables.dart';
import 'package:sanam_laundry/core/utils/storage.dart';
import 'package:sanam_laundry/data/index.dart';

class AuthService {
  static Future<String?> loadToken() async {
    return await Storage.getDataFromStorage(Variables.userToken);
  }

  static Future<String?> loadLanguage() async {
    return await Storage.getDataFromStorage(Variables.languageCode);
  }

  static Future<String?> hasVisitedApp() async {
    return await Storage.getDataFromStorage(Variables.hasVisitedApp);
  }

  static Future<void> saveHasVisitedApp(String isVisited) async {
    await Storage.addDataToStorage(Variables.hasVisitedApp, isVisited);
  }

  static Future<void> saveToken(String token) async {
    await Storage.addDataToStorage(Variables.userToken, token);
  }

  static Future<void> saveLanguage(String language) async {
    await Storage.addDataToStorage(Variables.languageCode, language);
  }

  static Future<void> removeToken() async {
    await Storage.deleteDataFromStorage(Variables.userToken);
  }

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
