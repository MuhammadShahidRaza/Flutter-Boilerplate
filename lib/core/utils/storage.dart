import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  // ✅ Android ke liye encryptedSharedPreferences enable
  // ✅ Storage instance
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

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
