import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // ✅ Android ke liye encryptedSharedPreferences enable
  // ✅ Storage instance
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _firstInstallFlag = '__sanam_laundry_storage_initialized';

  /// Ensure secure storage is wiped the first time the app runs after install.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyInitialized = prefs.getBool(_firstInstallFlag) ?? false;
    if (alreadyInitialized) return;

    try {
      await _storage.deleteAll();
      await prefs.setBool(_firstInstallFlag, true);
    } catch (error) {
      debugPrint('Failed to clear secure storage on first launch: $error');
    }
  }

  // ✅ Set string
  static Future<void> addDataToStorage(String key, String value) =>
      _storage.write(key: key, value: value);

  // ✅ Get string
  static Future<String?> getDataFromStorage(String key) =>
      _storage.read(key: key);

  // ✅ Delete single key
  static Future<void> deleteDataFromStorage(String key) =>
      _storage.delete(key: key);

  // ✅ Clear all keys
  static Future<void> clearAllDataFromStorage() => _storage.deleteAll();
}
